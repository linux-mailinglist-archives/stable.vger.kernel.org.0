Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46467401839
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 10:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhIFIsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 04:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240824AbhIFIsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 04:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E588860F92;
        Mon,  6 Sep 2021 08:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630918032;
        bh=DPaOzuxP1WrkbEva/oMrI/njuakPOgO8GQ7zUxsW/uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdSa4/c/c4rKlJjG2Aj/TxcNIzYb6+werRxQ13ZIXXAWWT4TNM61pHRenrq+6zyJn
         8r8zqYcebKQ19SyVUVKOhhdoUtNSxK4Rtrs3YkjmQzjaQN6ZvbDHLuiH30QqTM6o2I
         rkm4FWkFbtRqu8sweuYLaZ/nZYutUXFcon0vjgKw=
Date:   Mon, 6 Sep 2021 10:47:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH for 5.10.y] spi: Switch to signed types for *_native_cs
 SPI controller fields
Message-ID: <YTXVjcc6D2oSZ0LA@kroah.com>
References: <20210906060842.2913612-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906060842.2913612-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 03:08:42PM +0900, Nobuhiro Iwamatsu wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> commit 35f3f8504c3b60a1ae5576e178b27fc0ddd6157d upstream.
> 
> While fixing undefined behaviour the commit f60d7270c8a3 ("spi: Avoid
> undefined behaviour when counting unused native CSs") missed the case
> when all CSs are GPIOs and thus unused_native_cs will be evaluated to
> -1 in unsigned representation. This will falsely trigger a condition
> in the spi_get_gpio_descs().
> 
> Switch to signed types for *_native_cs SPI controller fields to fix above.
> 
> Fixes: f60d7270c8a3 ("spi: Avoid undefined behaviour when counting unused native CSs")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Link: https://lore.kernel.org/r/20210510131242.49455-1-andriy.shevchenko@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  include/linux/spi/spi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index 2d906b9c149929..e1d88630ff2439 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -646,8 +646,8 @@ struct spi_controller {
>  	int			*cs_gpios;
>  	struct gpio_desc	**cs_gpiods;
>  	bool			use_gpio_descriptors;
> -	u8			unused_native_cs;
> -	u8			max_native_cs;
> +	s8			unused_native_cs;
> +	s8			max_native_cs;
>  
>  	/* statistics */
>  	struct spi_statistics	statistics;
> -- 
> 2.33.0
> 
> 

Now queued up, thanks.

greg k-h
