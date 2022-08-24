Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDE59FA2E
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiHXMoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiHXMoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:44:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A787EFD9;
        Wed, 24 Aug 2022 05:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ED39B823EE;
        Wed, 24 Aug 2022 12:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A92C433D6;
        Wed, 24 Aug 2022 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661345049;
        bh=VyOSeotGuBynCWf8xVV1neByhcDavvdhIyVzJYpBTTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZKILxcGZ1yzoQ3CKhg+sqa4gxpeyzquI4CmEXkcU2sI59dGBNd7AbruZCP+VS71w
         7NplD7UX8s9eFmYY1JAD6C7GFVE3gwYjp52vfwuYk+UM9mV+NSCyqBtS0paFBGw8k6
         vp1cdjF+ttL6NF/niJPVKeJI02tbtuJ9ohbLqdGE=
Date:   Wed, 24 Aug 2022 14:44:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     kishon@ti.com, lpieralisi@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mie@igel.co.jp, kw@linux.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] tools: PCI: Fix parsing the return value of IOCTLs
Message-ID: <YwYdFt6sc7lZGRcg@kroah.com>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
 <20220824123010.51763-3-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824123010.51763-3-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 06:00:07PM +0530, Manivannan Sadhasivam wrote:
> "pci_endpoint_test" driver now returns 0 for success and negative error
> code for failure. So adapt to the change by reporting FAILURE if the
> return value is < 0, and SUCCESS otherwise.
> 
> Cc: stable@vger.kernel.org #5.10
> Fixes: 3f2ed8134834 ("tools: PCI: Add a userspace tool to test PCI endpoint")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  tools/pci/pcitest.c | 41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/pci/pcitest.c b/tools/pci/pcitest.c
> index 441b54234635..a4e5b17cc3b5 100644
> --- a/tools/pci/pcitest.c
> +++ b/tools/pci/pcitest.c
> @@ -18,7 +18,6 @@
>  
>  #define BILLION 1E9
>  
> -static char *result[] = { "NOT OKAY", "OKAY" };
>  static char *irq[] = { "LEGACY", "MSI", "MSI-X" };
>  
>  struct pci_test {
> @@ -54,9 +53,9 @@ static int run_test(struct pci_test *test)
>  		ret = ioctl(fd, PCITEST_BAR, test->barnum);
>  		fprintf(stdout, "BAR%d:\t\t", test->barnum);
>  		if (ret < 0)
> -			fprintf(stdout, "TEST FAILED\n");
> +			fprintf(stdout, "FAILED\n");
>  		else
> -			fprintf(stdout, "%s\n", result[ret]);
> +			fprintf(stdout, "SUCCESS\n");

Is this following the kernel TAP output rules?  If not, why not?  If so,
say that you are fixing that issue up in the changelog text.

thanks,

greg k-h
