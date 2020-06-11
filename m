Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167121F6814
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgFKMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 08:45:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:57880 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFKMpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 08:45:07 -0400
IronPort-SDR: 5OPaBHxRrV9kQecOgm8HIK90e/CAm4rOCMp8oBQmv79XAW3L0iaDWsD/gBQpkzap3Wu4ZSPvOF
 tfSySv09txbg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:45:05 -0700
IronPort-SDR: NPR+fUbBO5DWIwkJuW6tu4KPJ78c40SjkolJh2TiCjHVkey4ujGlqxqHIHHEYZWyTsA9lYIbN2
 97nKqX62kkAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="275320085"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2020 05:45:04 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jjMZu-00CM50-Vp; Thu, 11 Jun 2020 15:45:06 +0300
Date:   Thu, 11 Jun 2020 15:45:06 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] pinctrl: baytrail: Fix pin being driven low for a
 while on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200611124506.GW2428291@smile.fi.intel.com>
References: <20200606093150.32882-1-hdegoede@redhat.com>
 <CACRpkdaTJ9hW+GTnTVWK1UxHYxgD_c8G=Eq-3=iEN=YJrYLhKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaTJ9hW+GTnTVWK1UxHYxgD_c8G=Eq-3=iEN=YJrYLhKg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 01:21:37PM +0200, Linus Walleij wrote:
> On Sat, Jun 6, 2020 at 11:31 AM Hans de Goede <hdegoede@redhat.com> wrote:
> 
> > The pins on the Bay Trail SoC have separate input-buffer and output-buffer
> > enable bits and a read of the level bit of the value register will always
> > return the value from the input-buffer.
> >
> > The BIOS of a device may configure a pin in output-only mode, only enabling
> > the output buffer, and write 1 to the level bit to drive the pin high.
> > This 1 written to the level bit will be stored inside the data-latch of the
> > output buffer.
> >
> > But a subsequent read of the value register will return 0 for the level bit
> > because the input-buffer is disabled. This causes a read-modify-write as
> > done by byt_gpio_set_direction() to write 0 to the level bit, driving the
> > pin low!
> >
> > Before this commit byt_gpio_direction_output() relied on
> > pinctrl_gpio_direction_output() to set the direction, followed by a call
> > to byt_gpio_set() to apply the selected value. This causes the pin to
> > go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
> > calls.
> >
> > Change byt_gpio_direction_output() to directly make the register
> > modifications itself instead. Replacing the 2 subsequent writes to the
> > value register with a single write.
> >
> > Note that the pinctrl code does not keep track internally of the direction,
> > so not going through pinctrl_gpio_direction_output() is not an issue.
> >
> > This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
> > already on at boot (no external monitor connected), then the i915 driver
> > does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
> > temporarily going low of that GPIO was causing the panel to reset itself
> > after which it would not show an image until it was turned off and back on
> > again (until a full modeset was done on it). This commit fixes this.
> >
> > This commit also updates the byt_gpio_direction_input() to use direct
> > register accesses instead of going through pinctrl_gpio_direction_input(),
> > to keep it consistent with byt_gpio_direction_output().
> >
> > Note for backporting, this commit depends on:
> > commit e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once
> > when setting direct-irq pin to output")
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > ---
> > Note the factoring out of the direct IRQ mode warning is deliberately not
> > split into a separate patch to make backporting this easier.
> 
> Looks good to me,

Thanks!

> I expect this in a pull request from Andy for
> fixes, alternatively I can apply it directly for fixes if Andy prefers
> this.

Mika or I will send a PR for v5.8-rcX at some point with fixes material.
Though, there are GPIO stuff (PCA953x) which you can handle ;-)

-- 
With Best Regards,
Andy Shevchenko


