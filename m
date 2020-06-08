Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C311F1718
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 12:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgFHK75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 06:59:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:20100 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgFHK75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 06:59:57 -0400
IronPort-SDR: NeZ88um0eO0/VEhkD3jMT8V28wH01xnlD0/sp6P6VWTNyPXW8SWCUNfS6vwozruIA3pnP3K6DB
 oY+XqMoNsCNQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 03:59:56 -0700
IronPort-SDR: 7UeMIu9syk/NjzhM3fO6gHiRjwpyM8+oTUkbPYUlMIrVxsENqpwpxuQFRZfaVnvnAnljy4e6EH
 otaX3jF+vFLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="379387369"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 08 Jun 2020 03:59:54 -0700
Received: by lahna (sSMTP sendmail emulation); Mon, 08 Jun 2020 13:59:53 +0300
Date:   Mon, 8 Jun 2020 13:59:53 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: baytrail: Fix pin being driven low for a
 while on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200608105953.GC247495@lahna.fi.intel.com>
References: <20200606093150.32882-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606093150.32882-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 06, 2020 at 11:31:50AM +0200, Hans de Goede wrote:
> The pins on the Bay Trail SoC have separate input-buffer and output-buffer
> enable bits and a read of the level bit of the value register will always
> return the value from the input-buffer.
> 
> The BIOS of a device may configure a pin in output-only mode, only enabling
> the output buffer, and write 1 to the level bit to drive the pin high.
> This 1 written to the level bit will be stored inside the data-latch of the
> output buffer.
> 
> But a subsequent read of the value register will return 0 for the level bit
> because the input-buffer is disabled. This causes a read-modify-write as
> done by byt_gpio_set_direction() to write 0 to the level bit, driving the
> pin low!
> 
> Before this commit byt_gpio_direction_output() relied on
> pinctrl_gpio_direction_output() to set the direction, followed by a call
> to byt_gpio_set() to apply the selected value. This causes the pin to
> go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
> calls.
> 
> Change byt_gpio_direction_output() to directly make the register
> modifications itself instead. Replacing the 2 subsequent writes to the
> value register with a single write.
> 
> Note that the pinctrl code does not keep track internally of the direction,
> so not going through pinctrl_gpio_direction_output() is not an issue.
> 
> This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
> already on at boot (no external monitor connected), then the i915 driver
> does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
> temporarily going low of that GPIO was causing the panel to reset itself
> after which it would not show an image until it was turned off and back on
> again (until a full modeset was done on it). This commit fixes this.
> 
> This commit also updates the byt_gpio_direction_input() to use direct
> register accesses instead of going through pinctrl_gpio_direction_input(),
> to keep it consistent with byt_gpio_direction_output().
> 
> Note for backporting, this commit depends on:
> commit e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once
> when setting direct-irq pin to output")
> 
> Cc: stable@vger.kernel.org
> Fixes: 86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
