Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8521F530B
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgFJLVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbgFJLVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 07:21:50 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DF5C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 04:21:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x18so1996232lji.1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 04:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34s/UudA0g6sy/PuF5ij0UDHJHHlXUeLJ0XZZpZwUj0=;
        b=Zw/UUAncdZrCkVzxyRRfOD0pd964ijRbrOUynobbqQjw8BvJ91e7KKj0W9Lcluz1j6
         nr5OFK6KCmfGtdLyZ2FrVIYIHPeOpvTWfQhhF0nrIcJMQL/NPWALdu81+iA6CYQClraH
         x0A3SZ24rsEHfXtN7dJD4CHfJCoNrNxOoaarWuZeKIyRgk8u4k9Pg0Cux46/usK3J37I
         7F89OLKoyTnHK+j7yoX4YNn2HCByaACA3WDSX4romXYwHWPYJ+oGKiIEG8Gu5x9Vz/OD
         LxSjmAdn4iU6zA4qEHurICrDVvcHKiPSyLjgMowv297XHmuRShhUxFw/1M0etc79yfCB
         cEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34s/UudA0g6sy/PuF5ij0UDHJHHlXUeLJ0XZZpZwUj0=;
        b=RrbcQZQN+FQbH7ftVWOI2sIw4LonbHDp2U04Rv+SnQRftn+DcVey9rzYuhG99DYEjM
         OEAjpbVwQB/KR3qzUIUC6yRB8gyoEZWKHUb4Qz7GrphMuLl+2cP5+GlsCTL8RoIB1nB+
         QTzL4AgM4dACNxHGnlFEJxEAeWq2yubx6ML7WNWs0qA/j0QJgXd/4jK3pwMW+fpD8zc2
         m51/dS5vb/UkPpWGwxx1h/P+xvtX2dxH+aNUTyQOdtGlulFUUtdMT+Ff53RlEy21dnwI
         8HP0bgCjjY0NSWZuEYGRsrDFXAJnq8iLNH7TU8oNfi7d2qDh7rXeh5YD33diAl/LMVEl
         SktQ==
X-Gm-Message-State: AOAM530iIa7u8mJURC33XS5jcM6pxC8trgGCg2aFpm7VCfd9/em41iNd
        BHGDJjy9y4d5aWa/CAvgdEDPOjJA3LVl2aTbtvZIY5xI
X-Google-Smtp-Source: ABdhPJyW5H491HGWKGgiLem4FyZKdKKobr76+yfSy+ZTJl5n3Dav1PkDAFK/SXUuZP3anXqMXmrnBOWiguThBzu7Gd8=
X-Received: by 2002:a2e:351a:: with SMTP id z26mr1502554ljz.144.1591788108186;
 Wed, 10 Jun 2020 04:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200606093150.32882-1-hdegoede@redhat.com>
In-Reply-To: <20200606093150.32882-1-hdegoede@redhat.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 10 Jun 2020 13:21:37 +0200
Message-ID: <CACRpkdaTJ9hW+GTnTVWK1UxHYxgD_c8G=Eq-3=iEN=YJrYLhKg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: baytrail: Fix pin being driven low for a
 while on gpiod_get(..., GPIOD_OUT_HIGH)
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 6, 2020 at 11:31 AM Hans de Goede <hdegoede@redhat.com> wrote:

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
> ---
> Note the factoring out of the direct IRQ mode warning is deliberately not
> split into a separate patch to make backporting this easier.

Looks good to me, I expect this in a pull request from Andy for
fixes, alternatively I can apply it directly for fixes if Andy prefers
this.

Yours,
Linus Walleij
