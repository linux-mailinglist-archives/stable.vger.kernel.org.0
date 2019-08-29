Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B42A253E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfH2SPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbfH2SO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E534823405;
        Thu, 29 Aug 2019 18:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102497;
        bh=cIBmie2SDl6fWDIBpvZGPqToFNOLY9z40Csdp2T6Pt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySz//tuwyBcxQVLhVK74jU6TYVKKyjYKBBAAYi7OxLYyA0r8eM/sDnEqoH5jhZgpG
         0Y1DPR/b8UbQKH6dp7s5DYeeX+stdjH/+C6S5AJuPW9zpybqM2xYhCu/BksKBw/jsc
         Rnp3GR7pa0aWL0klT1w0k65ykK+wg9819r6KRDeY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 50/76] HID: cp2112: prevent sleeping function called from invalid context
Date:   Thu, 29 Aug 2019 14:12:45 -0400
Message-Id: <20190829181311.7562-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[ Upstream commit 2d05dba2b25ecb0f8fc3a0b4eb2232da6454a47b ]

When calling request_threaded_irq() with a CP2112, the function
cp2112_gpio_irq_startup() is called in a IRQ context.

Therefore we can not sleep, and we can not call
cp2112_gpio_direction_input() there.

Move the call to cp2112_gpio_direction_input() earlier to have a working
driver.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 8bbe3d0cbe5d9..8fd44407a0df7 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1152,8 +1152,6 @@ static unsigned int cp2112_gpio_irq_startup(struct irq_data *d)
 
 	INIT_DELAYED_WORK(&dev->gpio_poll_worker, cp2112_gpio_poll_callback);
 
-	cp2112_gpio_direction_input(gc, d->hwirq);
-
 	if (!dev->gpio_poll) {
 		dev->gpio_poll = true;
 		schedule_delayed_work(&dev->gpio_poll_worker, 0);
@@ -1201,6 +1199,12 @@ static int __maybe_unused cp2112_allocate_irq(struct cp2112_device *dev,
 		return PTR_ERR(dev->desc[pin]);
 	}
 
+	ret = cp2112_gpio_direction_input(&dev->gc, pin);
+	if (ret < 0) {
+		dev_err(dev->gc.parent, "Failed to set GPIO to input dir\n");
+		goto err_desc;
+	}
+
 	ret = gpiochip_lock_as_irq(&dev->gc, pin);
 	if (ret) {
 		dev_err(dev->gc.parent, "Failed to lock GPIO as interrupt\n");
-- 
2.20.1

