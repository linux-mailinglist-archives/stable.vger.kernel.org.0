Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95E32E417A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439001AbgL1PHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438798AbgL1OJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0FD9206C3;
        Mon, 28 Dec 2020 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164527;
        bh=iIow4M2IQxaBOiAtvDekYGaZdDt0Zr57yL9ldMSPCSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVOrGUWRLzR+R3qOOUtoYPaSDZDeR03tRAimeM8PosoczqKX0KAVAWBxYcqbBgnP6
         i49OWzh67FZ8F5v+Dq0gjb0OGqx0fSX6rkFsM76gVCGm0UHZr3UxDMydJa+n91tiKq
         T7N9/RYvFNPsIW46pgP8l761jO7fi+UEdD6NNeBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/717] leds: turris-omnia: check for LED_COLOR_ID_RGB instead LED_COLOR_ID_MULTI
Date:   Mon, 28 Dec 2020 13:43:23 +0100
Message-Id: <20201228125030.804307602@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 98650b0874171cc443251f7b369d3b1544db9d4e ]

LED core does not allow LED_COLOR_ID_MULTI for now and instead for RGB
LEDs prefers LED_COLOR_ID_RGB.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 77dce3a22e89 ("leds: disallow /sys/class/leds/*:multi:* for now")
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 8c5bdc3847ee7..880fc8def5309 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -98,9 +98,9 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 	}
 
 	ret = of_property_read_u32(np, "color", &color);
-	if (ret || color != LED_COLOR_ID_MULTI) {
+	if (ret || color != LED_COLOR_ID_RGB) {
 		dev_warn(dev,
-			 "Node %pOF: must contain 'color' property with value LED_COLOR_ID_MULTI\n",
+			 "Node %pOF: must contain 'color' property with value LED_COLOR_ID_RGB\n",
 			 np);
 		return 0;
 	}
-- 
2.27.0



