Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0863915F910
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388076AbgBNVyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387933AbgBNVyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:37 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF6562187F;
        Fri, 14 Feb 2020 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717277;
        bh=lpm37VSiCvyvzrUMxYL85tfQ1o8pXGNkVe47bNaYcF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ULfvwwWOt3qiaqFnSb2CeRBlcOASfI4qn7jTbfgo9Ba9Vs7B6ctpaUt2e07Uv1s1l
         E5GGL3/zKXag1vzuXQ9zTTwEzpl8aDWccyiWCJzNlPBAO9nWCChsa0nPL3kpbOedVb
         UdUpLz+SeFhAx6BigOC+kSTY9sAF7XoGIjh4PYfc=
Date:   Fri, 14 Feb 2020 16:49:35 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Simon Schwartz <kern.simon@theschwartz.xyz>
Subject: Re: [PATCH AUTOSEL 5.5 346/542] driver core: platform: Prevent
 resouce overflow from causing infinite loops
Message-ID: <20200214214935.GG4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-346-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-346-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:45:38AM -0500, Sasha Levin wrote:
> From: Simon Schwartz <kern.simon@theschwartz.xyz>
> 
> [ Upstream commit 39cc539f90d035a293240c9443af50be55ee81b8 ]
> 
> num_resources in the platform_device struct is declared as a u32.  The
> for loops that iterate over num_resources use an int as the counter,
> which can cause infinite loops on architectures with smaller ints.
> Change the loop counters to u32.
> 
> Signed-off-by: Simon Schwartz <kern.simon@theschwartz.xyz>
> Link: https://lore.kernel.org/r/2201ce63a2a171ffd2ed14e867875316efcf71db.camel@theschwartz.xyz
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/base/platform.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index cf6b6b722e5c9..864b53b3d5980 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -27,6 +27,7 @@
>  #include <linux/limits.h>
>  #include <linux/property.h>
>  #include <linux/kmemleak.h>
> +#include <linux/types.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -48,7 +49,7 @@ EXPORT_SYMBOL_GPL(platform_bus);
>  struct resource *platform_get_resource(struct platform_device *dev,
>  				       unsigned int type, unsigned int num)
>  {
> -	int i;
> +	u32 i;
>  
>  	for (i = 0; i < dev->num_resources; i++) {
>  		struct resource *r = &dev->resource[i];
> @@ -255,7 +256,7 @@ struct resource *platform_get_resource_byname(struct platform_device *dev,
>  					      unsigned int type,
>  					      const char *name)
>  {
> -	int i;
> +	u32 i;
>  
>  	for (i = 0; i < dev->num_resources; i++) {
>  		struct resource *r = &dev->resource[i];
> @@ -501,7 +502,8 @@ EXPORT_SYMBOL_GPL(platform_device_add_properties);
>   */
>  int platform_device_add(struct platform_device *pdev)
>  {
> -	int i, ret;
> +	u32 i;
> +	int ret;
>  
>  	if (!pdev)
>  		return -EINVAL;
> @@ -590,7 +592,7 @@ EXPORT_SYMBOL_GPL(platform_device_add);
>   */
>  void platform_device_del(struct platform_device *pdev)
>  {
> -	int i;
> +	u32 i;
>  
>  	if (!IS_ERR_OR_NULL(pdev)) {
>  		device_del(&pdev->dev);
> -- 
> 2.20.1
> 

This doesn't solve a real issue, so please drop from everywhere.

thanks,

greg k-h
