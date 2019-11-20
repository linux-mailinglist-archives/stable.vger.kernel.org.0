Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB1B10423D
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 18:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfKTRiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 12:38:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:33364 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfKTRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 12:38:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 09:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="381441510"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 20 Nov 2019 09:37:59 -0800
Received: from andy by smile with local (Exim 4.93-RC1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iXTvS-0000MK-On; Wed, 20 Nov 2019 19:37:58 +0200
Date:   Wed, 20 Nov 2019 19:37:58 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: baytrail: Really serialize all register
 accesses
Message-ID: <20191120173758.GR32742@smile.fi.intel.com>
References: <20191119154641.202139-1-hdegoede@redhat.com>
 <20191119160917.GM11621@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119160917.GM11621@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:09:17PM +0200, Mika Westerberg wrote:
> On Tue, Nov 19, 2019 at 04:46:41PM +0100, Hans de Goede wrote:
> > Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
> > added a spinlock around all register accesses because:
> > 
> > "There is a hardware issue in Intel Baytrail where concurrent GPIO register
> >  access might result reads of 0xffffffff and writes might get dropped
> >  completely."
> > 
> > Testing has shown that this does not catch all cases, there are still
> > 2 problems remaining
> > 
> > 1) The original fix uses a spinlock per byt_gpio device / struct,
> > additional testing has shown that this is not sufficient concurent
> > accesses to 2 different GPIO banks also suffer from the same problem.
> > 
> > This commit fixes this by moving to a single global lock.
> > 
> > 2) The original fix did not add a lock around the register accesses in
> > the suspend/resume handling.
> > 
> > Since pinctrl-baytrail.c is using normal suspend/resume handlers,
> > interrupts are still enabled during suspend/resume handling. Nothing
> > should be using the GPIOs when they are being taken down, _but_ the
> > GPIOs themselves may still cause interrupts, which are likely to
> > use (read) the triggering GPIO. So we need to protect against
> > concurrent GPIO register accesses in the suspend/resume handlers too.
> > 
> > This commit fixes this by adding the missing spin_lock / unlock calls.
> > 
> > The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
> > confused after a suspend resume. The DSDT for this device has a bug
> > in its _LID method which reprograms the home and power button trigger-
> > flags requesting both high and low _level_ interrupts so the IRQs for
> > these 2 GPIOs continuously fire. This combined with the saving of
> > registers during suspend, triggers concurrent GPIO register accesses
> > resulting in saving 0xffffffff as pconf0 value during suspend and then
> > when restoring this on resume the pinmux settings get all messed up,
> > resulting in various I2C busses being stuck, the wifi no longer working
> > and often the tablet simply not coming out of suspend at all.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Pushed to my review and testing queue, thanks!

-- 
With Best Regards,
Andy Shevchenko


