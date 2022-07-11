Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2D570DA3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 00:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiGKWyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 18:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiGKWyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 18:54:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A517A643E3;
        Mon, 11 Jul 2022 15:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40E01612D7;
        Mon, 11 Jul 2022 22:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA47C34115;
        Mon, 11 Jul 2022 22:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657580079;
        bh=xG4WYnt2pDWcAgSjzTQqgeaw1HV6zEbIP5TmSZQv9V4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RO7PsVoXA2lACTlYaApR1PY+FprRwxwn3Z1jOocown9d/2WeRqXQXyiuNCJ7YA6SL
         HgZ7N4arbFKjmQkBdue4doz2FDjQhT3tzZmZ0VNudGvZbAjMVHgIXRXh2rKnlwRH81
         Q3YWaGMm3ZTX85M91QhtsbxE9/Z+8pk7gEeVW+GQmzYVGTuJikGn+gn2npZirHQBg5
         qvX5ZJ2DrXcT+HH3S2lTYOOg+m163cM7KOX2XLzmlQjSLluBOiz69xKGVNKAEhKEzn
         JhHkM+xszcqy0PlwilpnBmdIQ81Ngl6NvOVWsK6NkoJgBIPqo19Zjia47d96dY/M5Q
         xmqu/i5M81GOA==
Date:   Mon, 11 Jul 2022 17:54:37 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mohamed Khalfella <mkhalfella@purestorage.com>
Cc:     stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Eric Badger <ebadger@purestorage.com>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "open list:PCI ENHANCED ERROR HANDLING (EEH) FOR POWERPC" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI/AER: Iterate over error counters instead of error
 strings
Message-ID: <20220711225437.GA703490@bhelgaas>
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

On Mon, May 09, 2022 at 06:14:41PM +0000, Mohamed Khalfella wrote:
> PCI AER stats counters sysfs attributes need to iterate over
> stats counters instead of stats names. Also, added a build
> time check to make sure all counters have entries in strings
> array.
> 
> Fixes: 0678e3109a3c ("PCI/AER: Simplify __aer_print_error()")
> Cc: stable@vger.kernel.org
> Reported-by: Meeta Saggi <msaggi@purestorage.com>
> Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
> Reviewed-by: Meeta Saggi <msaggi@purestorage.com>
> Reviewed-by: Eric Badger <ebadger@purestorage.com>

I added some info about why we need this to the commit log and applied
to pci/err for v5.20.  Thank you!

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
> @@ -1342,6 +1342,11 @@ static int aer_probe(struct pcie_device *dev)
>  	struct device *device = &dev->device;
>  	struct pci_dev *port = dev->port;
>  
> +	BUILD_BUG_ON(ARRAY_SIZE(aer_correctable_error_string) <
> +		     AER_MAX_TYPEOF_COR_ERRS);
> +	BUILD_BUG_ON(ARRAY_SIZE(aer_uncorrectable_error_string) <
> +		     AER_MAX_TYPEOF_UNCOR_ERRS);
> +
>  	/* Limit to Root Ports or Root Complex Event Collectors */
>  	if ((pci_pcie_type(port) != PCI_EXP_TYPE_RC_EC) &&
>  	    (pci_pcie_type(port) != PCI_EXP_TYPE_ROOT_PORT))
> -- 
> 2.29.0
> 
