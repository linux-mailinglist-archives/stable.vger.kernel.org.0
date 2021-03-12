Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFA3387D8
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 09:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhCLIrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 03:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232461AbhCLIrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 03:47:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF6964FC9;
        Fri, 12 Mar 2021 08:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615538833;
        bh=bkDYBXVl8wBrMSFnk3bEbSis33pUn2mhlKCq8oD0o0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iHTjMbJngH+2cSeA9MNEtuBxBfUJ7eFGSgqnVODi76KrkhrRsEmlS3s3SOK/XmeQH
         vXLCoIwml+TBiCOao0eEw6X1/EtMsmHa43tOjbbzS94vsuqZrWgwuImw5x1c8OJLBd
         oSTMqGzIz6oRUSaAkntjAYbJ6JUYyodEP+aQ07Qumc73eM9YE4GBQpTBKWlkjxu5zH
         O4w6prUj0nnzbmQ6n+zUsxT7obNBZ/9X9Nt+t0ZLiDRydRNE0or6IykVY5cTiaBt3g
         vhux3hp9ne1SVLbrS/mcfA/M1NfcfhC/JoPCIdswRynylIMSBGS9eDEG9LAuYQTmYV
         8nQf6FJ7R251A==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lKdS8-00039J-IL; Fri, 12 Mar 2021 09:47:25 +0100
Date:   Fri, 12 Mar 2021 09:47:24 +0100
From:   Johan Hovold <johan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     bgolaszewski@baylibre.com, saravanak@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption"
 failed to apply to 5.11-stable tree
Message-ID: <YEsqnDY7nGWuh9h5@hovoldconsulting.com>
References: <16154845012114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16154845012114@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 06:41:41PM +0100, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.11-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

> ------------------ original commit in Linus's tree ------------------
> 
> From cf25ef6b631c6fc6c0435fc91eba8734cca20511 Mon Sep 17 00:00:00 2001
> From: Johan Hovold <johan@kernel.org>
> Date: Mon, 1 Mar 2021 10:05:19 +0100
> Subject: [PATCH] gpio: fix gpio-device list corruption
> 
> Make sure to hold the gpio_lock when removing the gpio device from the
> gpio_devices list (when dropping the last reference) to avoid corrupting
> the list when there are concurrent accesses.
> 
> Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
> Cc: stable@vger.kernel.org      # 4.6
> Reviewed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 6e0572515d02..4253837f870b 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
>  static void gpiodevice_release(struct device *dev)
>  {
>  	struct gpio_device *gdev = container_of(dev, struct gpio_device, dev);
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&gpio_lock, flags);
>  	list_del(&gdev->list);
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
>  	ida_free(&gpio_ida, gdev->id);
>  	kfree_const(gdev->label);
>  	kfree(gdev->descs);
> 

Bah, that's because of a6112998ee45 ("gpio: fix
NULL-deref-on-deregistration regression") which is strictly only needed
in 5.12 even if it could be backported (the commit message might be a
bit confusing though).

I should have reversed the order of these two.

Below is a backport to 5.11.

Johan


From 7599320f36bb5273844dfb749861a5361d8aa5b7 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 1 Mar 2021 10:05:19 +0100
Subject: [PATCH] gpio: fix gpio-device list corruption

Make sure to hold the gpio_lock when removing the gpio device from the
gpio_devices list (when dropping the last reference) to avoid corrupting
the list when there are concurrent accesses.

Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
Cc: stable@vger.kernel.org      # 4.6
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[ johan: adjust context to 5.11 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index adf55db080d8..0069b115928c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
 static void gpiodevice_release(struct device *dev)
 {
 	struct gpio_device *gdev = dev_get_drvdata(dev);
+	unsigned long flags;
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
 	ida_free(&gpio_ida, gdev->id);
 	kfree_const(gdev->label);
 	kfree(gdev->descs);
-- 
2.26.2

