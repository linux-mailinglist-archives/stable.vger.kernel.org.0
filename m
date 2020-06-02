Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E41EBEFD
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 17:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFBPZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 11:25:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:37323 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBPZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 11:25:56 -0400
IronPort-SDR: B1wyM2ReYPEAwfDFoGn8JOw4mtorvI1muWT/bmHwsbBzUSb4uPzK44Tj2yoai2fyDQazRHDZBT
 SS6aRy1kQBvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 08:25:55 -0700
IronPort-SDR: 8G2Kl3wxqUb5fneDULn0yy2Ec9PNwlhKwRY7Yj0XjpyLnhQXYPhEmcmcQh29omLpiG8Q4dVFbU
 D6e9LRPKEsBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,464,1583222400"; 
   d="scan'208";a="293615478"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004.fm.intel.com with ESMTP; 02 Jun 2020 08:25:53 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jg8nb-00ARtx-Vf; Tue, 02 Jun 2020 18:25:55 +0300
Date:   Tue, 2 Jun 2020 18:25:55 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200602152555.GJ2428291@smile.fi.intel.com>
References: <20200602122130.45630-1-hdegoede@redhat.com>
 <20200602152317.GI2428291@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602152317.GI2428291@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 06:23:17PM +0300, Andy Shevchenko wrote:
> On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:

...

> Wouldn't be simple below fix the issue?
> 
> @@ -1171,14 +1171,10 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
>  static int byt_gpio_direction_output(struct gpio_chip *chip,
>                                      unsigned int offset, int value)
>  {
> -       int ret = pinctrl_gpio_direction_output(chip->base + offset);
> -
> -       if (ret)
> -               return ret;
> -
> +       /* Set value first to avoid a glitch */
>         byt_gpio_set(chip, offset, value);
>  
> -       return 0;
> +       return pinctrl_gpio_direction_output(chip->base + offset);
>  }
>  
> 
> P.S. It's mangled, sorry.

Cherrytrail does this way, btw, 549e783f6a1.

-- 
With Best Regards,
Andy Shevchenko


