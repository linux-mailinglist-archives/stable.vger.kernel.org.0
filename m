Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED98826124B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIHOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 10:02:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:12657 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgIHN6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 09:58:36 -0400
IronPort-SDR: XKwwhD+FXuOQkBN/paSmOFeWfPxkx6SHIjyNHHgqR30LVerybp3K/9s+s1teeKdSx3smZOBEEp
 9qmXF4kucdhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="219688132"
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="219688132"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 06:45:25 -0700
IronPort-SDR: bjY/o98d8EepQt7h8nZWe0WdED9G0VcFr6vdeMg5RIll0WD6OZt6R9YMnT6KCnIbqCn6xPlap7
 6pBxoEdWtS/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="333477551"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 08 Sep 2020 06:45:23 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kFdw0-00FDYM-Me; Tue, 08 Sep 2020 16:45:20 +0300
Date:   Tue, 8 Sep 2020 16:45:20 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Kent Gibson <warthog618@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] gpio: mockup: fix resource leak in error path
Message-ID: <20200908134520.GY1891694@smile.fi.intel.com>
References: <20200908130749.9948-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908130749.9948-1-brgl@bgdev.pl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 03:07:49PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> If the module init function fails after creating the debugs directory,
> it's never removed. Add proper cleanup calls to avoid this resource
> leak.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/gpio/gpio-mockup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
> index bc345185db26..1652897fdf90 100644
> --- a/drivers/gpio/gpio-mockup.c
> +++ b/drivers/gpio/gpio-mockup.c
> @@ -552,6 +552,7 @@ static int __init gpio_mockup_init(void)
>  	err = platform_driver_register(&gpio_mockup_driver);
>  	if (err) {
>  		gpio_mockup_err("error registering platform driver\n");
> +		debugfs_remove_recursive(gpio_mockup_dbg_dir);
>  		return err;
>  	}
>  
> @@ -582,6 +583,7 @@ static int __init gpio_mockup_init(void)
>  			gpio_mockup_err("error registering device");
>  			platform_driver_unregister(&gpio_mockup_driver);
>  			gpio_mockup_unregister_pdevs();
> +			debugfs_remove_recursive(gpio_mockup_dbg_dir);
>  			return PTR_ERR(pdev);
>  		}
>  
> -- 
> 2.26.1
> 

-- 
With Best Regards,
Andy Shevchenko


