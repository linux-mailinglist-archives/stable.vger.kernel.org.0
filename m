Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794CD1AC383
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898209AbgDPNoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506637AbgDPNoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:44:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E9E2076D;
        Thu, 16 Apr 2020 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044651;
        bh=lmDFwSRJINaEuNcm0imgBOH7qPo597f26/3MDbu0cUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fU5fuDIMfQvRoK8iecAuMtlHKEwisGbkn4D63QqbnaH7I1ly35Xi+ao8JSE+kJYK5
         Z9wQcqtYIhmW6BDEgu2Yj7l0dXWAIUeFhVnf8A5kgzdzMThvnFfnyC4J5i6RolhE14
         ji5gplDcNgxmTSqF5WxinK5hq4WDNiRt74HaLqbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Reitemeyer <nick.reitemeyer@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/232] Input: tm2-touchkey - add support for Coreriver TC360 variant
Date:   Thu, 16 Apr 2020 15:21:40 +0200
Message-Id: <20200416131317.331398711@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



