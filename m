Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA191EFE8A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgFERJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 13:09:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:24813 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgFERJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 13:09:31 -0400
IronPort-SDR: JwmNp8b9Yr4qL8P78n+TuNCQR1xYd2PYy6GT8I6BOFAuH2GvYajawejcufcAGr4zW+tz9B3ifn
 8r1y9btTvTHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 10:09:30 -0700
IronPort-SDR: ejD2iB+0Y/PIY6NUm6qMALZslYTaBiAheR1m3mbD0+dYitoSyHA0rPS0jANDAeWq8XRlUCM/yB
 V5ypg5o/Rbnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="348494979"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001.jf.intel.com with ESMTP; 05 Jun 2020 10:09:28 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jhFqV-00B4hT-DR; Fri, 05 Jun 2020 20:09:31 +0300
Date:   Fri, 5 Jun 2020 20:09:31 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200605170931.GR2428291@smile.fi.intel.com>
References: <20200602122130.45630-1-hdegoede@redhat.com>
 <20200602152317.GI2428291@smile.fi.intel.com>
 <ba931618-9259-aca0-142c-c1dfb67e737e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba931618-9259-aca0-142c-c1dfb67e737e@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 04:33:47PM +0200, Hans de Goede wrote:
> On 6/2/20 5:23 PM, Andy Shevchenko wrote:
> > On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:
> > > The pins on the Bay Trail SoC have separate input-buffer and output-buffer
> > > enable bits and a read of the level bit of the value register will always
> > > return the value from the input-buffer.
> > > 
> > > The BIOS of a device may configure a pin in output-only mode, only enabling
> > > the output buffer, and write 1 to the level bit to drive the pin high.
> > > This 1 written to the level bit will be stored inside the data-latch of the
> > > output buffer.
> > > 
> > > But a subsequent read of the value register will return 0 for the level bit
> > > because the input-buffer is disabled. This causes a read-modify-write as
> > > done by byt_gpio_set_direction() to write 0 to the level bit, driving the
> > > pin low!
> > > 
> > > Before this commit byt_gpio_direction_output() relied on
> > > pinctrl_gpio_direction_output() to set the direction, followed by a call
> > > to byt_gpio_set() to apply the selected value. This causes the pin to
> > > go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
> > > calls.
> > > 
> > > Change byt_gpio_direction_output() to directly make the register
> > > modifications itself instead. Replacing the 2 subsequent writes to the
> > > value register with a single write.
> > > 
> > > Note that the pinctrl code does not keep track internally of the direction,
> > > so not going through pinctrl_gpio_direction_output() is not an issue.
> > > 
> > > This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
> > > already on at boot (no external monitor connected), then the i915 driver
> > > does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
> > > temporarily going low of that GPIO was causing the panel to reset itself
> > > after which it would not show an image until it was turned off and back on
> > > again (until a full modeset was done on it). This commit fixes this.
> > 
> > No Fixes tag?
> 
> It is sort of hard to pin the introduction of this down to a single
> commit. If I were to guess, I guess the commit introducing the driver?

Why not? Good guess to me (but I think rather the one which converts GPIO
driver to pin control).

...

> > > +	/*
> > > +	 * Before making any direction modifications, do a check if gpio is set
> > 
> > > +	 * for direct IRQ.  On baytrail, setting GPIO to output does not make
> > 
> > Since we change this, perhaps
> > 
> > 'IRQ.  On baytrail' -> 'IRQ. On Baytrail' (one space and capital 'B').
> 
> Sure, not sure if that is worth respinning the patch for though,
> either way let me know.

I think makes sense to respin. We still have time.

> > > +	 * sense, so let's at least inform the caller before they shoot
> > > +	 * themselves in the foot.
> > > +	 */

...

> > Wouldn't be simple below fix the issue?

> No that will not help the pin is already high, but any reads
> of the register will return the BYT_LEVEL bit as being low, so
> the read-write-modify done when setting the direction reads BYT_LEVEL
> as 0 and writes it back as such.

So, if I read documentation correctly, there is no means to read back current
output value if input is disabled. Alas, quite a bad design of hardware.
And on top of that likely nobody has tested that on non-Windows platform.

> So your proposal would actually make the problem much worse (and more
> obvious) if we do the byt_gpio_set() first then for pins which have
> there input-buffer initially disabled, the value passed to
> byt_gpio_direction_output will be completely ignored and they will
> always end up as being driven low.

What I proposed is not gonna work AFAIU documentation.

Btw, can we for sake of consistency update direction_input() as well?

-- 
With Best Regards,
Andy Shevchenko


