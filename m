Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA2E1483A5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403794AbgAXLbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388657AbgAXLbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:40 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68D72077C;
        Fri, 24 Jan 2020 11:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865499;
        bh=Wk+ZmpSEN5g7qxeVyMdC8je/0aEgQIF8oHS9ao4XKtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvHPsLR4n64Db6/Q0lV2I/KC0lq4UByaOp9ajUBFKA5nS2KnHZPC3izrBu7Y0Uut1
         ilLqsvCmfGxWi6jpkub/W3IRrbNoNq21ZgiYRa2KvkzjHNoBNUSDnxzALf0LZI8pCB
         tWzBz0ZAjUxig7dlspPlCyNZzbEIdeosqGNN39ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleh Kravchenko <oleg@kaa.org.ua>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 545/639] led: triggers: Fix dereferencing of null pointer
Date:   Fri, 24 Jan 2020 10:31:55 +0100
Message-Id: <20200124093157.383168919@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e4cb3811e82a3..005b839f6eb9e 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -171,11 +171,11 @@ err_add_groups:
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



