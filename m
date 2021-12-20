Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCCD47A820
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhLTLBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhLTLBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:01:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAE8C061574;
        Mon, 20 Dec 2021 03:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF31A60F7D;
        Mon, 20 Dec 2021 11:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB828C36AE8;
        Mon, 20 Dec 2021 11:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639998083;
        bh=mbYZpWkOpBpdkdwTg12if6HElD5q2Vqht+vy/9jDAwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtmlcauAAglMXUHRrvG+kdWk3FNldRIFxjvE87jPdneXrTq0XdwVO2Y0BVJiS929G
         9r5EhjX9ZyBZ8f+tqYWSkoP2NcFS5rXv9/IRpU9sEi7ba2dEyUbGAwFN2Vu7pyMqx3
         xX1VoS14lKnWZKlbSAPqkzukUZ6PfOpHTL5ufwvk=
Date:   Mon, 20 Dec 2021 12:01:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pedro Batista <pedbap.g@gmail.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [BACKPORT v4.9 - v4.19] firmware: arm_scpi: Fix string
 overflow in SCPI genpd driver
Message-ID: <YcBigHusYbH/CY7I@kroah.com>
References: <20211217142056.866487-1-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217142056.866487-1-sudeep.holla@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 02:20:56PM +0000, Sudeep Holla wrote:
> commit 865ed67ab955428b9aa771d8b4f1e4fb7fd08945 upstream.
> 
> Without the bound checks for scpi_pd->name, it could result in the buffer
> overflow when copying the SCPI device name from the corresponding device
> tree node as the name string is set at maximum size of 30.
> 
> Let us fix it by using devm_kasprintf so that the string buffer is
> allocated dynamically.
> 
> Fixes: 8bec4337ad40 ("firmware: scpi: add device power domain support using genpd")
> Reported-by: Pedro Batista <pedbap.g@gmail.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: stable@vger.kernel.org #v4.9, v4.14, v4.19
> Cc: Cristian Marussi <cristian.marussi@arm.com>
> Link: https://lore.kernel.org/r/20211209120456.696879-1-sudeep.holla@arm.com
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/firmware/scpi_pm_domain.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/scpi_pm_domain.c b/drivers/firmware/scpi_pm_domain.c
> index f395dec27113..a6e62a793fbe 100644
> --- a/drivers/firmware/scpi_pm_domain.c
> +++ b/drivers/firmware/scpi_pm_domain.c
> @@ -27,7 +27,6 @@ struct scpi_pm_domain {
>  	struct generic_pm_domain genpd;
>  	struct scpi_ops *ops;
>  	u32 domain;
> -	char name[30];
>  };
>  
>  /*
> @@ -121,8 +120,13 @@ static int scpi_pm_domain_probe(struct platform_device *pdev)
>  
>  		scpi_pd->domain = i;
>  		scpi_pd->ops = scpi_ops;
> -		sprintf(scpi_pd->name, "%s.%d", np->name, i);
> -		scpi_pd->genpd.name = scpi_pd->name;
> +		scpi_pd->genpd.name = devm_kasprintf(dev, GFP_KERNEL,
> +						     "%s.%d", np->name, i);
> +		if (!scpi_pd->genpd.name) {
> +			dev_err(dev, "Failed to allocate genpd name:%s.%d\n",
> +				np->name, i);
> +			continue;
> +		}
>  		scpi_pd->genpd.power_off = scpi_pd_power_off;
>  		scpi_pd->genpd.power_on = scpi_pd_power_on;
>  
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
