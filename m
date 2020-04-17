Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE241AD96B
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 11:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgDQJFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 05:05:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:27130 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgDQJFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 05:05:06 -0400
IronPort-SDR: 16Tx0uSrbMV34ixbWqLRGR1nMYsgmoFF4zjxesj+pG/gfVkXYEBITYhhEJ+El0nEvi4E6zgaB+
 w7nP8U5ZBE5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 02:05:05 -0700
IronPort-SDR: iImZ98H6UD3xcWqYoNqzdpqoBINcrRfzHDRb1nBDIsxheRoaWWd338Fac35K5WTATRAqRj0z2X
 Pzvhpr0Af3jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,394,1580803200"; 
   d="scan'208";a="364275266"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 17 Apr 2020 02:05:01 -0700
Received: by lahna (sSMTP sendmail emulation); Fri, 17 Apr 2020 12:05:00 +0300
Date:   Fri, 17 Apr 2020 12:05:00 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     =?utf-8?Q?Micha=C5=82?= Stanek <mst@semihalf.com>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stanekm@google.com,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        levinale@chromium.org, andriy.shevchenko@linux.intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com, rafael.j.wysocki@intel.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation
 of ACPI GPIO numbers
Message-ID: <20200417090500.GM2586@lahna.fi.intel.com>
References: <20200205194804.1647-1-mst@semihalf.com>
 <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
 <20200207075654.GB2667@lahna.fi.intel.com>
 <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
 <20200210101414.GN2667@lahna.fi.intel.com>
 <CAMiGqYiYp=aSgW-4ro5ceUEaB7g0XhepFg+HZgfPvtvQL9Z1jA@mail.gmail.com>
 <20200310144913.GY2540@lahna.fi.intel.com>
 <20200417020641.GA145784@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417020641.GA145784@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 07:06:41PM -0700, Brian Norris wrote:
> If you just read the last sentence from Michal, you get the wrong
> picture. There's no hard-coding of gpiochipX numbers going on. We only
> had the pin offsets "hardcoded" (in ACPI), and the kernel driver
> unilaterally changed from a contiguous mapping to a non-contiguous
> mapping.

OK, I now understand the issue. My apologies that I was not able to
figure that out from the previous explanation.

So indeed if relative GPIO numbering inside the gpiochip was changed
then it is kernel regression and needs to be dealt with.

> How do you recommend determining (both pre- and
> post-commit-03c4749dd6c7ff94) whether pin 22 is at offset 22, vs. offset
> 19?

I wonder if we can add back the previous GPIO base like this?

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index 4c74fdde576d..f53de56bb763 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1591,17 +1591,18 @@ static int chv_gpio_add_pin_ranges(struct gpio_chip *chip)
 	struct chv_pinctrl *pctrl = gpiochip_get_data(chip);
 	const struct chv_community *community = pctrl->community;
 	const struct chv_gpio_pinrange *range;
-	int ret, i;
+	int ret, i, offset;
 
-	for (i = 0; i < community->ngpio_ranges; i++) {
+	for (i = 0, offset = 0; i < community->ngpio_ranges; i++) {
 		range = &community->gpio_ranges[i];
-		ret = gpiochip_add_pin_range(chip, dev_name(pctrl->dev),
-					     range->base, range->base,
-					     range->npins);
+		ret = gpiochip_add_pin_range(chip, dev_name(pctrl->dev), offset,
+					     range->base, range->npins);
 		if (ret) {
 			dev_err(pctrl->dev, "failed to add GPIO pin range\n");
 			return ret;
 		}
+
+		offset += range->npins;
 	}
 
 	return 0;
