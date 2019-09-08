Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF7ACDF9
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbfIHMtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbfIHMtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:12 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E1962190F;
        Sun,  8 Sep 2019 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946951;
        bh=uZUdd3IGYUQS/CNgapUdkPFnu06tnrUf79ahH4sF9g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+qf8Bs4xJNTf199EomGm6Y8jwflbmxmvd/UaCNExVI7cInaAtvEBFJYjMld/+gJ8
         dn7d7wYqeBWKi9pI3CkoI+9jnG9qnHaiOcg1rSeUlxgMFQJzqHODnXwhlfrmgjTW89
         A5JevdSVBxGWUg56thABw8uT4f9fLgAR/TLSSCc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/57] HID: cp2112: prevent sleeping function called from invalid context
Date:   Sun,  8 Sep 2019 13:42:03 +0100
Message-Id: <20190908121143.628821353@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 271f31461da42..6f65f52572368 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1160,8 +1160,6 @@ static unsigned int cp2112_gpio_irq_startup(struct irq_data *d)
 
 	INIT_DELAYED_WORK(&dev->gpio_poll_worker, cp2112_gpio_poll_callback);
 
-	cp2112_gpio_direction_input(gc, d->hwirq);
-
 	if (!dev->gpio_poll) {
 		dev->gpio_poll = true;
 		schedule_delayed_work(&dev->gpio_poll_worker, 0);
@@ -1209,6 +1207,12 @@ static int __maybe_unused cp2112_allocate_irq(struct cp2112_device *dev,
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



