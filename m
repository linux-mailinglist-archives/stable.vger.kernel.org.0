Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF8E1A035E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgDGAJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbgDGABN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 792E120768;
        Tue,  7 Apr 2020 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217673;
        bh=lmDFwSRJINaEuNcm0imgBOH7qPo597f26/3MDbu0cUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7vjnn88a06IFpTQDiNr8n6aYbqBBUfvK0etQFjsST2RGyB2KANGk1F3svjoENEp+
         og+fNLumAtQs9y6DcEpygtWpEF8ighP3mUwYseKcjeUb4NcOMVZZ1eviYyZ16pxr5C
         soNYNVyqV7vzAmZU/0Xgq4sBOW0C6bw869AZGXXY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Reitemeyer <nick.reitemeyer@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 11/35] Input: tm2-touchkey - add support for Coreriver TC360 variant
Date:   Mon,  6 Apr 2020 20:00:33 -0400
Message-Id: <20200407000058.16423-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Reitemeyer <nick.reitemeyer@web.de>

[ Upstream commit da3289044833769188c0da945d2cec90af35e87e ]

The Coreriver TouchCore 360 is like the midas board touchkey, but it is
using a fixed regulator.

Signed-off-by: Nick Reitemeyer <nick.reitemeyer@web.de>
Link: https://lore.kernel.org/r/20200121141525.3404-3-nick.reitemeyer@web.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/tm2-touchkey.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/input/keyboard/tm2-touchkey.c b/drivers/input/keyboard/tm2-touchkey.c
index 14b55bacdd0f1..fb078e049413f 100644
--- a/drivers/input/keyboard/tm2-touchkey.c
+++ b/drivers/input/keyboard/tm2-touchkey.c
@@ -75,6 +75,14 @@ static struct touchkey_variant aries_touchkey_variant = {
 	.cmd_led_off = ARIES_TOUCHKEY_CMD_LED_OFF,
 };
 
+static const struct touchkey_variant tc360_touchkey_variant = {
+	.keycode_reg = 0x00,
+	.base_reg = 0x00,
+	.fixed_regulator = true,
+	.cmd_led_on = TM2_TOUCHKEY_CMD_LED_ON,
+	.cmd_led_off = TM2_TOUCHKEY_CMD_LED_OFF,
+};
+
 static int tm2_touchkey_led_brightness_set(struct led_classdev *led_dev,
 					    enum led_brightness brightness)
 {
@@ -327,6 +335,9 @@ static const struct of_device_id tm2_touchkey_of_match[] = {
 	}, {
 		.compatible = "cypress,aries-touchkey",
 		.data = &aries_touchkey_variant,
+	}, {
+		.compatible = "coreriver,tc360-touchkey",
+		.data = &tc360_touchkey_variant,
 	},
 	{ },
 };
-- 
2.20.1

