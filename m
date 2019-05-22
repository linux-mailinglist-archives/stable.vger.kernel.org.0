Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8326D5A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbfEVTlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732721AbfEVT3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:29:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA0F21841;
        Wed, 22 May 2019 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553341;
        bh=nbohXr6h3h8OSKBnDnEzE/1GdOue9o7EuLF85wUA6qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/m1zPYc4xxNrkcnuURCwLM2hm5oqLHsCsMQS6+xid6216JcIs5BbONt/t4hlg6ra
         dGPO5u8fq0Mw7DD9oUg4g3t3W0IfYYGeA4LC84iCmrDhdx/lEAGHOsTwsQqAziY1q5
         e7iWt27NfZv+X5Pr/PAGG3Q/lG7XPD3B3j7ZPOFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 013/167] leds: avoid races with workqueue
Date:   Wed, 22 May 2019 15:26:08 -0400
Message-Id: <20190522192842.25858-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

[ Upstream commit 0db37915d912e8dc6588f25da76d3ed36718d92f ]

There are races between "main" thread and workqueue. They manifest
themselves on Thinkpad X60:

This should result in LED blinking, but it turns it off instead:

    root@amd:/data/pavel# cd /sys/class/leds/tpacpi\:\:power
    root@amd:/sys/class/leds/tpacpi::power# echo timer > trigger
    root@amd:/sys/class/leds/tpacpi::power# echo timer > trigger

It should be possible to transition from blinking to solid on by echo
0 > brightness; echo 1 > brightness... but that does not work, either,
if done too quickly.

Synchronization of the workqueue fixes both.

Fixes: 1afcadfcd184 ("leds: core: Use set_brightness_work for the blocking op")
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 1 +
 drivers/leds/led-core.c  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index b0e2d55acbd6f..80374c6c943ad 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -57,6 +57,7 @@ static ssize_t brightness_store(struct device *dev,
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
 	led_set_brightness(led_cdev, state);
+	flush_work(&led_cdev->set_brightness_work);
 
 	ret = size;
 unlock:
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 9ce6b32f52a19..cb84c35d64f97 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -162,6 +162,11 @@ static void led_blink_setup(struct led_classdev *led_cdev,
 		     unsigned long *delay_on,
 		     unsigned long *delay_off)
 {
+	/*
+	 * If "set brightness to 0" is pending in workqueue, we don't
+	 * want that to be reordered after blink_set()
+	 */
+	flush_work(&led_cdev->set_brightness_work);
 	if (!test_bit(LED_BLINK_ONESHOT, &led_cdev->work_flags) &&
 	    led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
-- 
2.20.1

