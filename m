Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A925413F378
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgAPRL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:11:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389964AbgAPRL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321B42468B;
        Thu, 16 Jan 2020 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194688;
        bh=uiasfpaw3t7cNNMG2O+qQHIqHKAg3oUJaJRg0Vu++lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8IzHwxo0HD0xqFeJjJQSjE9jWBDlrUlZ8xtY1OOoYpTP+ZsOF1sRASr++1lo6gn7
         hEjz7DQ6eCF+k7v+nVGgET/J5bkm1wHPNtPRxCh9rowGKD7kOihnoqu12V6scXafsG
         LBcHzUV/M018bSFez1VliUJOCJtRxIcoMV6ncuUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleh Kravchenko <oleg@kaa.org.ua>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 531/671] led: triggers: Fix dereferencing of null pointer
Date:   Thu, 16 Jan 2020 12:02:49 -0500
Message-Id: <20200116170509.12787-268-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleh Kravchenko <oleg@kaa.org.ua>

[ Upstream commit 4016ba85880b252365d11bc7dc899450f2c73ad7 ]

Error was detected by PVS-Studio:
V522 Dereferencing of the null pointer 'led_cdev->trigger' might take place.

Fixes: 2282e125a406 ("leds: triggers: let struct led_trigger::activate() return an error code")
Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index e4cb3811e82a..005b839f6eb9 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -171,11 +171,11 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		trig->deactivate(led_cdev);
 err_activate:
 
-	led_cdev->trigger = NULL;
-	led_cdev->trigger_data = NULL;
 	write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
 	list_del(&led_cdev->trig_list);
 	write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock, flags);
+	led_cdev->trigger = NULL;
+	led_cdev->trigger_data = NULL;
 	led_set_brightness(led_cdev, LED_OFF);
 	kfree(event);
 
-- 
2.20.1

