Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6368862373A
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiKIXHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 18:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKIXHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 18:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1E9647D;
        Wed,  9 Nov 2022 15:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 586F961D10;
        Wed,  9 Nov 2022 23:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0FFC433B5;
        Wed,  9 Nov 2022 23:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668035234;
        bh=QVbJuuASX3h4Jz3Lm8MMNfZQd7k5AEXGegUih81XkzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=YJb7PdweWdzkXJcJkksW1F8gyz9CusdJzwyYMz7FHgIwSm9SupYfjWQgP1ZxtKhmF
         yJVXjaGqat52C5i7+HlzwOGUOL5dyZ1vlqQfOsbzraviagtWZISTkW7fEgLA3jl4f3
         XhSbLsSZh033TT+FTt03SukODY10xfemUPiFkd5bxMbHH9pVC43HlA3cpkddBqGYLZ
         OriGhzJZnvFhfPwrZUSvEVuIeG5fo3pQgbjWmWUsX/blv1G5XVdiX0mPKQadOdrTeQ
         vT2BguG3AkcjC3oYq2OqQWmS5LLhjrjT1fGVoZZ5RbGQ1zMExsP2yIy8ux0k9CSyp+
         fjdvPolcqwmqg==
Date:   Wed, 9 Nov 2022 17:07:12 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH] PCI/sysfs: Fix double free in error path
Message-ID: <20221109230712.GA580188@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007070735.GX986@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Sergey, Alex, Krzysztof since you all posted similar patches in
the past]

On Fri, Oct 07, 2022 at 09:07:35AM +0200, Sascha Hauer wrote:
> On Fri, Oct 07, 2022 at 08:56:18AM +0200, Sascha Hauer wrote:
> > When pci_create_attr() fails then pci_remove_resource_files() is called
> > which will iterate over the res_attr[_wc] arrays and frees every non
> > NULL entry. To avoid a double free here we have to set the failed entry
> > to NULL in pci_create_attr() when freeing it.
> > 
> 
> You might consider applying this alternative version instead which IMO
> looks a bit better.

Thanks, I agree, I like how this one doesn't set res_attr[] until we
know we're going to return success.

Applied to pci/sysfs for v6.2, thanks!

> -------------------------------8<-----------------------------
> 
> From fe8e0e6f914c14395c751b7dc165967b12427995 Mon Sep 17 00:00:00 2001
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Date: Fri, 7 Oct 2022 07:35:35 +0200
> Subject: [PATCH] PCI/sysfs: Fix double free in error path
> 
> When pci_create_attr() fails then pci_remove_resource_files() is called
> which will iterate over the res_attr[_wc] arrays and frees every non
> NULL entry. To avoid a double free here set the array entry only after
> it's clear we successfully initialized it.
> 
> Fixes: b562ec8f74e4 ("PCI: Don't leak memory if sysfs_create_bin_file() fails")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/pci/pci-sysfs.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fc804e08e3cb5..6dd4050c9f2ed 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1174,11 +1174,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
>  
>  	sysfs_bin_attr_init(res_attr);
>  	if (write_combine) {
> -		pdev->res_attr_wc[num] = res_attr;
>  		sprintf(res_attr_name, "resource%d_wc", num);
>  		res_attr->mmap = pci_mmap_resource_wc;
>  	} else {
> -		pdev->res_attr[num] = res_attr;
>  		sprintf(res_attr_name, "resource%d", num);
>  		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
>  			res_attr->read = pci_read_resource_io;
> @@ -1196,10 +1194,17 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
>  	res_attr->size = pci_resource_len(pdev, num);
>  	res_attr->private = (void *)(unsigned long)num;
>  	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
> -	if (retval)
> +	if (retval) {
>  		kfree(res_attr);
> +		return retval;
> +	}
> +
> +	if (write_combine)
> +		pdev->res_attr_wc[num] = res_attr;
> +	else
> +		pdev->res_attr[num] = res_attr;
>  
> -	return retval;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.30.2
> 
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
