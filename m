Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC62101C6E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 09:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKSITQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 03:19:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:39243 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfKSITP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 03:19:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 00:19:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,322,1569308400"; 
   d="scan'208";a="215487844"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 19 Nov 2019 00:19:10 -0800
Received: by lahna (sSMTP sendmail emulation); Tue, 19 Nov 2019 10:19:09 +0200
Date:   Tue, 19 Nov 2019 10:19:09 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Really serialize all register accesses
Message-ID: <20191119081909.GE11621@lahna.fi.intel.com>
References: <20191118142020.22256-1-hdegoede@redhat.com>
 <20191118142020.22256-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118142020.22256-2-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 03:20:20PM +0100, Hans de Goede wrote:
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
> ---
>  drivers/pinctrl/intel/pinctrl-baytrail.c | 81 +++++++++++++-----------
>  1 file changed, 44 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
> index b18336d42252..1b289f64c3a2 100644
> --- a/drivers/pinctrl/intel/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
> @@ -111,7 +111,6 @@ struct byt_gpio {
>  	struct platform_device *pdev;
>  	struct pinctrl_dev *pctl_dev;
>  	struct pinctrl_desc pctl_desc;
> -	raw_spinlock_t lock;
>  	const struct intel_pinctrl_soc_data *soc_data;
>  	struct intel_community *communities_copy;
>  	struct byt_gpio_pin_context *saved_context;
> @@ -550,6 +549,8 @@ static const struct intel_pinctrl_soc_data *byt_soc_data[] = {
>  	NULL
>  };
>  
> +static DEFINE_RAW_SPINLOCK(byt_gpio_lock);

Can we call it byt_lock instead? Following same convention we use in
chv.

Other than that looks good and definitely right thing to do. Thanks for
doing this Hans!
