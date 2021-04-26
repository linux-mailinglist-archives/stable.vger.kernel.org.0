Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B59436AEAF
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhDZHqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234213AbhDZHpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67CC761166;
        Mon, 26 Apr 2021 07:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422914;
        bh=oBHJLs4kHIy0N6NBAmjtqZO0DXqcU4GPNhTLHYX1rWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoo8HfD3ecjdQm00un0eZY5ga45H8W1quJYBEnT0IFlOd4mQjtgQp+IAY904rVAtF
         agAnWw/7TqrLdFvOkR8CvZs+zAfLFSp2x6or14ruTUdshVmFJVeWaR2ierfAyjfWsQ
         RQulcPxGX5EmXVJOFv5LVTtFQdxkl9NJrfCcn0G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 25/41] HID cp2112: fix support for multiple gpiochips
Date:   Mon, 26 Apr 2021 09:30:12 +0200
Message-Id: <20210426072820.538345782@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit 2a2b09c867fdac63f430a45051e7bd0c46edc381 ]

In lk 5.11.0-rc2 connecting a USB based Silicon Labs HID to I2C
bridge evaluation board (CP2112EK) causes this warning:
  gpio gpiochip0: (cp2112_gpio): detected irqchip that is shared
       with multiple gpiochips: please fix the driver

Simply copy what other gpio related drivers do to fix this
particular warning: replicate the struct irq_chip object in each
device instance rather than have a static object which makes that
object (incorrectly) shared by each device.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 21e15627a461..477baa30889c 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -161,6 +161,7 @@ struct cp2112_device {
 	atomic_t read_avail;
 	atomic_t xfer_avail;
 	struct gpio_chip gc;
+	struct irq_chip irq;
 	u8 *in_out_buffer;
 	struct mutex lock;
 
@@ -1175,16 +1176,6 @@ static int cp2112_gpio_irq_type(struct irq_data *d, unsigned int type)
 	return 0;
 }
 
-static struct irq_chip cp2112_gpio_irqchip = {
-	.name = "cp2112-gpio",
-	.irq_startup = cp2112_gpio_irq_startup,
-	.irq_shutdown = cp2112_gpio_irq_shutdown,
-	.irq_ack = cp2112_gpio_irq_ack,
-	.irq_mask = cp2112_gpio_irq_mask,
-	.irq_unmask = cp2112_gpio_irq_unmask,
-	.irq_set_type = cp2112_gpio_irq_type,
-};
-
 static int __maybe_unused cp2112_allocate_irq(struct cp2112_device *dev,
 					      int pin)
 {
@@ -1339,8 +1330,17 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	dev->gc.can_sleep		= 1;
 	dev->gc.parent			= &hdev->dev;
 
+	dev->irq.name = "cp2112-gpio";
+	dev->irq.irq_startup = cp2112_gpio_irq_startup;
+	dev->irq.irq_shutdown = cp2112_gpio_irq_shutdown;
+	dev->irq.irq_ack = cp2112_gpio_irq_ack;
+	dev->irq.irq_mask = cp2112_gpio_irq_mask;
+	dev->irq.irq_unmask = cp2112_gpio_irq_unmask;
+	dev->irq.irq_set_type = cp2112_gpio_irq_type;
+	dev->irq.flags = IRQCHIP_MASK_ON_SUSPEND;
+
 	girq = &dev->gc.irq;
-	girq->chip = &cp2112_gpio_irqchip;
+	girq->chip = &dev->irq;
 	/* The event comes from the outside so no parent handler */
 	girq->parent_handler = NULL;
 	girq->num_parents = 0;
-- 
2.30.2



