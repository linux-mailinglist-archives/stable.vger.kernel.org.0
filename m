Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522BD522186
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347609AbiEJQrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347610AbiEJQrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E45B62CC8;
        Tue, 10 May 2022 09:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDD26183D;
        Tue, 10 May 2022 16:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C14C385A6;
        Tue, 10 May 2022 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652200991;
        bh=Osg1O0gfa6ZkJPjBpOrkM1rXaweWgHooysorOXbKftU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=SG253suakgSw/EN+cXtrkyjj6aWCkxwrbCbP7C0HSUz/KfL9A6Vx4aeAY6gHLL/zK
         Ig/jhuTc7srNJMuXg8I3xGqrmiHxoSwZQiu5XNG+vcxoeaNuD8SwYUmAwdpg2PvtsX
         MpPy2zHkZCbErrHZecpOuX2nCTX41ds2hoJA0idx7X7ROHLRuS93+5p7XfBG9vBJBD
         +vkSNa3ypaT5L6QmF6BfBVCSIK9q3bhncdsZ5Yu4H/cJ+Yulisq7PiKnwg/z/cBrCR
         mVqqxmHRCgXEPo2OqbB+8jN15fPu9j2moaT3HEQDubZBxY0v4EEMpEQZCjIxPT4y4b
         YYOf7ALzDkFLw==
Date:   Tue, 10 May 2022 11:43:05 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mohamed Khalfella <mkhalfella@purestorage.com>
Cc:     stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Eric Badger <ebadger@purestorage.com>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Rajat Jain <rajatja@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "open list:PCI ENHANCED ERROR HANDLING (EEH) FOR POWERPC" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI/AER: Iterate over error counters instead of error
 strings
Message-ID: <20220510164305.GA678149@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509181441.31884-1-mkhalfella@purestorage.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Rajat]

On Mon, May 09, 2022 at 06:14:41PM +0000, Mohamed Khalfella wrote:
> PCI AER stats counters sysfs attributes need to iterate over
> stats counters instead of stats names. 

Thanks for catching this; it definitely looks like a real issue!  I
guess you're probably seeing junk in the sysfs files?

It would be helpful to reviewers if this said *why* we need to iterate
over the counters instead of the names.  I think the problem is that
the current code reads past the end of the stats counters.

There are parallel arrays here:

  #define AER_MAX_TYPEOF_COR_ERRS         16
  #define AER_MAX_TYPEOF_UNCOR_ERRS       27

  aer_correctable_error_string[32]                               # 32
  pdev->aer_stats->dev_cor_errs[AER_MAX_TYPEOF_COR_ERRS]         # 16
  aer_uncorrectable_error_string[32]                             # 32
  pdev->aer_stats->dev_fatal_errs[AER_MAX_TYPEOF_UNCOR_ERRS]     # 27
  pdev->aer_stats->dev_nonfatal_errs[AER_MAX_TYPEOF_UNCOR_ERRS]  # 27

And here's the current use of them:

  #define aer_stats_dev_attr(..., stats_array, strings_array, ...)
    for (i = 0; i < ARRAY_SIZE(strings_array); i++) {
      if (strings_array[i])
	sysfs_emit_at(..., strings_array[i], stats[i]);          (1)
      else if (stats[i])
	sysfs_emit_at(..., stats[i]);                            (2)

  aer_stats_dev_attr(..., dev_cor_errs, aer_correctable_error_string,
  aer_stats_dev_attr(..., dev_fatal_errs, aer_uncorrectable_error_string,
  aer_stats_dev_attr(..., dev_nonfatal_errs, aer_uncorrectable_error_string,

The current loop iterates over 0..31, which is safe at (1) because the
non-NULL strings are at aer_correctable_error_string[0..15] and
aer_uncorrectable_error_string[0..26].

But it is unsafe at (2) because it references dev_cor_errs[16..31],
dev_fatal_errs[27..31], and dev_nonfatal_errs[27..31], which are past
the end of the arrays.

> Also, added a build time check to make sure all counters have
> entries in strings array.
>
> Fixes: 0678e3109a3c ("PCI/AER: Simplify __aer_print_error()")

Yep, I blew it there.  Rajat did it correctly when he added this with
81aa5206f9a7 ("PCI/AER: Add sysfs attributes to provide AER stats and
breakdown"), and I broke it by extending the string arrays to 32
entries.

> Cc: stable@vger.kernel.org
> Reported-by: Meeta Saggi <msaggi@purestorage.com>
> Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
> Reviewed-by: Meeta Saggi <msaggi@purestorage.com>
> Reviewed-by: Eric Badger <ebadger@purestorage.com>
> ---
>  drivers/pci/pcie/aer.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
> index 9fa1f97e5b27..ce99a6d44786 100644
> --- a/drivers/pci/pcie/aer.c
> +++ b/drivers/pci/pcie/aer.c
> @@ -533,7 +533,7 @@ static const char *aer_agent_string[] = {
>  	u64 *stats = pdev->aer_stats->stats_array;			\
>  	size_t len = 0;							\
>  									\
> -	for (i = 0; i < ARRAY_SIZE(strings_array); i++) {		\
> +	for (i = 0; i < ARRAY_SIZE(pdev->aer_stats->stats_array); i++) {\
>  		if (strings_array[i])					\
>  			len += sysfs_emit_at(buf, len, "%s %llu\n",	\
>  					     strings_array[i],		\

I think maybe we should populate the currently NULL entries in the
string[] arrays and simplify the code here, e.g.,

  static const char *aer_correctable_error_string[] = {
        "RxErr",                        /* Bit Position 0       */
        "dev_cor_errs_bit[1]",
	...

  if (stats[i])
    len += sysfs_emit_at(buf, len, "%s %llu\n", strings_array[i], stats[i]);

It's a little more data space, but easier to verify.

> @@ -1342,6 +1342,11 @@ static int aer_probe(struct pcie_device *dev)
>  	struct device *device = &dev->device;
>  	struct pci_dev *port = dev->port;
>  
> +	BUILD_BUG_ON(ARRAY_SIZE(aer_correctable_error_string) <
> +		     AER_MAX_TYPEOF_COR_ERRS);
> +	BUILD_BUG_ON(ARRAY_SIZE(aer_uncorrectable_error_string) <
> +		     AER_MAX_TYPEOF_UNCOR_ERRS);

And make these check for "!=" instead of "<".
