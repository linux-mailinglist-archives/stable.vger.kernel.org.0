Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54761028EE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 17:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfKSQJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 11:09:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:8324 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfKSQJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 11:09:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 08:09:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,218,1571727600"; 
   d="scan'208";a="215567282"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 19 Nov 2019 08:09:18 -0800
Received: by lahna (sSMTP sendmail emulation); Tue, 19 Nov 2019 18:09:17 +0200
Date:   Tue, 19 Nov 2019 18:09:17 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: baytrail: Really serialize all register
 accesses
Message-ID: <20191119160917.GM11621@lahna.fi.intel.com>
References: <20191119154641.202139-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119154641.202139-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 04:46:41PM +0100, Hans de Goede wrote:
> Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
> added a spinlock around all register accesses because:
> 
> "There is a hardware issue in Intel Baytrail where concurrent GPIO register
>  access might result reads of 0xffffffff and writes might get dropped
>  completely."
> 
> Testing has shown that this does not catch all cases, there are still
> 2 problems remaining
> 
> 1) The original fix uses a spinlock per byt_gpio device / struct,
> additional testing has shown that this is not sufficient concurent
> accesses to 2 different GPIO banks also suffer from the same problem.
> 
> This commit fixes this by moving to a single global lock.
> 
> 2) The original fix did not add a lock around the register accesses in
> the suspend/resume handling.
> 
> Since pinctrl-baytrail.c is using normal suspend/resume handlers,
> interrupts are still enabled during suspend/resume handling. Nothing
> should be using the GPIOs when they are being taken down, _but_ the
> GPIOs themselves may still cause interrupts, which are likely to
> use (read) the triggering GPIO. So we need to protect against
> concurrent GPIO register accesses in the suspend/resume handlers too.
> 
> This commit fixes this by adding the missing spin_lock / unlock calls.
> 
> The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
> confused after a suspend resume. The DSDT for this device has a bug
> in its _LID method which reprograms the home and power button trigger-
> flags requesting both high and low _level_ interrupts so the IRQs for
> these 2 GPIOs continuously fire. This combined with the saving of
> registers during suspend, triggers concurrent GPIO register accesses
> resulting in saving 0xffffffff as pconf0 value during suspend and then
> when restoring this on resume the pinmux settings get all messed up,
> resulting in various I2C busses being stuck, the wifi no longer working
> and often the tablet simply not coming out of suspend at all.
> 
> Cc: stable@vger.kernel.org
> Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
