Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E36146F9
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 10:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKAJlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 05:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiKAJkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 05:40:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD9E19004
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 02:40:08 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1opnka-0007Kh-Ma; Tue, 01 Nov 2022 10:40:04 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1opnka-0003Bi-D9; Tue, 01 Nov 2022 10:40:04 +0100
Date:   Tue, 1 Nov 2022 10:40:04 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PCI/sysfs: Fix double free in error path
Message-ID: <20221101094004.GD9130@pengutronix.de>
References: <20221007065618.2169880-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007065618.2169880-1-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On Fri, Oct 07, 2022 at 08:56:18AM +0200, Sascha Hauer wrote:
> When pci_create_attr() fails then pci_remove_resource_files() is called
> which will iterate over the res_attr[_wc] arrays and frees every non
> NULL entry. To avoid a double free here we have to set the failed entry
> to NULL in pci_create_attr() when freeing it.
> 
> Fixes: b562ec8f74e4 ("PCI: Don't leak memory if sysfs_create_bin_file() fails")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/pci/pci-sysfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Any input to this one? There's this long unfixed race condition
described here:

https://patchwork.kernel.org/project/linux-pci/patch/20200716110423.xtfyb3n6tn5ixedh@pali/#23547255

And this patch at least prevents my system from crashing when this race
condition occurs.

Sascha

> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fc804e08e3cb5..a07381d46ddae 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1196,8 +1196,13 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
>  	res_attr->size = pci_resource_len(pdev, num);
>  	res_attr->private = (void *)(unsigned long)num;
>  	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
> -	if (retval)
> +	if (retval) {
> +		if (write_combine)
> +			pdev->res_attr_wc[num] = NULL;
> +		else
> +			pdev->res_attr[num] = NULL;
>  		kfree(res_attr);
> +	}
>  
>  	return retval;
>  }
> -- 
> 2.30.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
