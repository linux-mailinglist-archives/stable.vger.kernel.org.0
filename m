Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF641AA038
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369144AbgDOMXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897229AbgDOLpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51A821582;
        Wed, 15 Apr 2020 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951149;
        bh=yaliotJxvLNaSp02wuihbJu/1ZddBCwFTwSf8FxJC0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNeH36HjSXR9Unl8qY/dZBoYALMzZ0oJn8XRVGYx/Zyl3I5N3O3Fu7tEwGiybKYQ9
         ZPf6efll4U8VxCcOsnS5+rdmxdLbC5jRS1Te8SqbC0DKerf+KwJngUqeXsXWvvB3is
         5ucSH3M3kk6ecXNb+ORdDIcWFICtHz6H+N28EAsU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 56/84] leds: core: Fix warning message when init_data
Date:   Wed, 15 Apr 2020 07:44:13 -0400
Message-Id: <20200415114442.14166-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda Delgado <ribalda@kernel.org>

[ Upstream commit 64ed6588c2ea618d3f9ca9d8b365ae4c19f76225 ]

The warning message when a led is renamed due to name collition can fail
to show proper original name if init_data is used. Eg:

[    9.073996] leds-gpio a0040000.leds_0: Led (null) renamed to red_led_1 due to name collision

Fixes: bb4e9af0348d ("leds: core: Add support for composing LED class device names")
Signed-off-by: Ricardo Ribalda Delgado <ribalda@kernel.org>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 647b1263c5794..d3e83c33783e5 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -281,7 +281,7 @@ int led_classdev_register_ext(struct device *parent,
 
 	if (ret)
 		dev_warn(parent, "Led %s renamed to %s due to name collision",
-				led_cdev->name, dev_name(led_cdev->dev));
+				proposed_name, dev_name(led_cdev->dev));
 
 	if (led_cdev->flags & LED_BRIGHT_HW_CHANGED) {
 		ret = led_add_brightness_hw_changed(led_cdev);
-- 
2.20.1

