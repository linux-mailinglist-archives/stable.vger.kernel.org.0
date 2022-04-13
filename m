Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E114FFBE3
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 18:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiDMQ7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 12:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiDMQ7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 12:59:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129AE6A036;
        Wed, 13 Apr 2022 09:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649869048; x=1681405048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J/06hLI56n+UwECnp0EG6XOIuTP/83n8TeWwphjmSp8=;
  b=kW/LagHcPCJaOI9h28kgoIi2daCBgPqJ7xO7gOfQkYjeKzqZYMplKlbl
   3IIqGn57KVKRWvu7z2hJNNCsdKyiAr/kZ9CrS/b7g78BGy4dowhmHWr/e
   t9x0vIk0rWahtABes9gQxsBZ/38I1r9ODxGfMZBG1PQIseT+iKDAF7v07
   El+oHvIEeYslnIocY6i7DiWMN2FMo/uDQLWwc1AuFU8TtLahU0CwXZxex
   W8egbONnrCXwMO4+i0H4JKi517cydjKPvALSs6Z8Z4/fgusMAIt6PxuyK
   1v3UECtMh8xoy5bJcyiL9Nc+U7+z2ZTPoJb21D79J8Zeq7kMhMjT1gNJA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261566264"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261566264"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 09:57:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="611958900"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 09:57:15 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1negFM-001vxB-Lb;
        Wed, 13 Apr 2022 19:53:36 +0300
Date:   Wed, 13 Apr 2022 19:53:36 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Kent Gibson <warthog618@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] gpio: sim: fix setting and getting multiple lines
Message-ID: <YlcAEPYOBHk+NAD8@smile.fi.intel.com>
References: <20220413140132.286848-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413140132.286848-1-brgl@bgdev.pl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 04:01:32PM +0200, Bartosz Golaszewski wrote:
> We need to take mask into account in the set/get_multiple() callbacks.
> Use bitmap_replace() instead of bitmap_copy().

Good catch!
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: cb8c474e79be ("gpio: sim: new testing module")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> ---
>  drivers/gpio/gpio-sim.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
> index 8e5d87984a48..41c31b10ae84 100644
> --- a/drivers/gpio/gpio-sim.c
> +++ b/drivers/gpio/gpio-sim.c
> @@ -134,7 +134,7 @@ static int gpio_sim_get_multiple(struct gpio_chip *gc,
>  	struct gpio_sim_chip *chip = gpiochip_get_data(gc);
>  
>  	mutex_lock(&chip->lock);
> -	bitmap_copy(bits, chip->value_map, gc->ngpio);
> +	bitmap_replace(bits, bits, chip->value_map, mask, gc->ngpio);
>  	mutex_unlock(&chip->lock);
>  
>  	return 0;
> @@ -146,7 +146,7 @@ static void gpio_sim_set_multiple(struct gpio_chip *gc,
>  	struct gpio_sim_chip *chip = gpiochip_get_data(gc);
>  
>  	mutex_lock(&chip->lock);
> -	bitmap_copy(chip->value_map, bits, gc->ngpio);
> +	bitmap_replace(chip->value_map, chip->value_map, bits, mask, gc->ngpio);
>  	mutex_unlock(&chip->lock);
>  }
>  
> -- 
> 2.32.0
> 

-- 
With Best Regards,
Andy Shevchenko


