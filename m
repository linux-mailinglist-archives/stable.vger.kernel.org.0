Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2C2C429F
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgKYPHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKYPHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:07:31 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0434420679;
        Wed, 25 Nov 2020 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606316850;
        bh=XUXkH2P+Dj+LfdkoHygf4L5x2gUdd3NfXUBkon3pM9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Em17VZvWWVlY5BRMnMYZzW3hq0R6dbkbJqGZlomaIrDWJejvK9KSDxJVZgK03ItrZ
         lms3lto2jKNlaqS9UlSLYVt+gOs2it0Zzbgx5BMKym5lFi8FfGwMvDn3s7+e5Xwc15
         5C1KPBQGN9O0Z8NIrVjf3IYc04YgAgitcpcqYU/4=
Date:   Wed, 25 Nov 2020 16:07:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-input@vger.kernel.org,
        Helmut Stult <helmut.stult@schinfo.de>,
        =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>, stable@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <X75zL12q+FF6KBHi@kroah.com>
References: <20201125141022.321643-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201125141022.321643-1-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 10:10:22PM +0800, Coiby Xu wrote:
> For a broken touchpad, it may take several months or longer to be fixed.
> Polling mode could be a fallback solution for enthusiastic Linux users
> when they have a new laptop. It also acts like a debugging feature. If
> polling mode works for a broken touchpad, we can almost be certain
> the root cause is related to the interrupt or power setting.
> 
> This patch could fix touchpads of Lenovo AMD gaming laptops including
> Legion-5 15ARH05 (R7000), Legion-5P (R7000P) and IdeaPad Gaming 3
> 15ARH05.
> 
> When polling mode is enabled, an I2C device can't wake up the suspended
> system since enable/disable_irq_wake is invalid for polling mode.
> 
> Three module parameters are added to i2c-hid,
>     - polling_mode: by default set to 0, i.e., polling is disabled
>     - polling_interval_idle_ms: the polling internal when the touchpad
>       is idle, default to 10ms
>     - polling_interval_active_us: the polling internal when the touchpad
>       is active, default to 4000us
> 
> User can change the last two runtime polling parameter by writing to
> /sys/module/i2c_hid/parameters/polling_interval_{idle_ms,active_us}.
> 
> Note xf86-input-synaptics doesn't work well with this polling mode
> for the Synaptics touchpad. The Synaptics touchpad would often locks
> into scroll mode when using multitouch gestures [1]. One remedy is to
> decrease the polling interval.
> 
> Thanks to Barnabás's thorough review of this patch and the useful
> feedback!
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190/comments/235
> 
> Cc: <stable@vger.kernel.org>
> Cc: Barnabás Pőcze <pobrn@protonmail.com>
> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid-core.c | 152 +++++++++++++++++++++++++++--
>  1 file changed, 142 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
> index aeff1ffb0c8b..f25503f31ccf 100644
> --- a/drivers/hid/i2c-hid/i2c-hid-core.c
> +++ b/drivers/hid/i2c-hid/i2c-hid-core.c
> @@ -36,6 +36,8 @@
>  #include <linux/hid.h>
>  #include <linux/mutex.h>
>  #include <linux/acpi.h>
> +#include <linux/kthread.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/of.h>
>  #include <linux/regulator/consumer.h>
>  
> @@ -60,6 +62,25 @@
>  #define I2C_HID_PWR_ON		0x00
>  #define I2C_HID_PWR_SLEEP	0x01
>  
> +/* polling mode */
> +#define I2C_HID_POLLING_DISABLED 0
> +#define I2C_HID_POLLING_GPIO_PIN 1
> +#define I2C_HID_POLLING_INTERVAL_ACTIVE_US 4000
> +#define I2C_HID_POLLING_INTERVAL_IDLE_MS 10
> +
> +static u8 polling_mode;
> +module_param(polling_mode, byte, 0444);
> +MODULE_PARM_DESC(polling_mode, "How to poll (default=0) - 0 disabled; 1 based on GPIO pin's status");

Module parameters are for the 1990's, they are global and horrible to
try to work with.  You should provide something on a per-device basis,
as what happens if your system requires different things here for
different devices?  You set this for all devices :(

thanks,

greg k-h
