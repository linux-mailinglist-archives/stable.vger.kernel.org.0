Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E30BCD50
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409933AbfIXQo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409911AbfIXQo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21A621783;
        Tue, 24 Sep 2019 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343497;
        bh=PWhTwKba2ZSNQzRTJqTmC99Bkw2ToZ0yxWIRCb0nwZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fj8W8+PQ2yv3VqaJ0FUs/bLEQbPNd0EsFh0Hs8J42j9JLBH63qcLVuuPO5R7Mjz0
         6O56794Z9mXV6ioV9NvjxuY3hlkq3ixnQkHXJTx5eLm4VSKb1th2Gwip7RXqBkdmfY
         VVRr1YvNg+WGl02jDrNdOrUrRR9F5zX+NESgKjyc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Otto Meier <gf435@gmx.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 72/87] pinctrl: meson-gxbb: Fix wrong pinning definition for uart_c
Date:   Tue, 24 Sep 2019 12:41:28 -0400
Message-Id: <20190924164144.25591-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Otto Meier <gf435@gmx.net>

[ Upstream commit cb0438e4436085d89706b5ccfce4d5da531253de ]

Hi i tried to use the uart_C of the the odroid-c2.

I enabled it in the dts file. During boot it crashed when the
the sdcard slot is addressed.

After long search in the net i found this:

https://forum.odroid.com/viewtopic.php?f=139&t=25371&p=194370&hilit=uart_C#p177856

After changing the pin definitions accordingly erverything works.
Uart_c is functioning and sdcard ist working.

Fixes: 6db0f3a8a04e46 ("pinctrl: amlogic: gxbb: add more UART pins")
Signed-off-by: Otto Meier <gf435@gmx.net>
Link: https://lore.kernel.org/r/1cc32a18-464d-5531-7a1c-084390e2ecb1@gmx.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
index 6c640837073ef..5bfa56f3847ef 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
@@ -192,8 +192,8 @@ static const unsigned int uart_rts_b_pins[]	= { GPIODV_27 };
 
 static const unsigned int uart_tx_c_pins[]	= { GPIOY_13 };
 static const unsigned int uart_rx_c_pins[]	= { GPIOY_14 };
-static const unsigned int uart_cts_c_pins[]	= { GPIOX_11 };
-static const unsigned int uart_rts_c_pins[]	= { GPIOX_12 };
+static const unsigned int uart_cts_c_pins[]	= { GPIOY_11 };
+static const unsigned int uart_rts_c_pins[]	= { GPIOY_12 };
 
 static const unsigned int i2c_sck_a_pins[]	= { GPIODV_25 };
 static const unsigned int i2c_sda_a_pins[]	= { GPIODV_24 };
@@ -439,10 +439,10 @@ static struct meson_pmx_group meson_gxbb_periphs_groups[] = {
 	GROUP(pwm_f_x,		3,	18),
 
 	/* Bank Y */
-	GROUP(uart_cts_c,	1,	19),
-	GROUP(uart_rts_c,	1,	18),
-	GROUP(uart_tx_c,	1,	17),
-	GROUP(uart_rx_c,	1,	16),
+	GROUP(uart_cts_c,	1,	17),
+	GROUP(uart_rts_c,	1,	16),
+	GROUP(uart_tx_c,	1,	19),
+	GROUP(uart_rx_c,	1,	18),
 	GROUP(pwm_a_y,		1,	21),
 	GROUP(pwm_f_y,		1,	20),
 	GROUP(i2s_out_ch23_y,	1,	5),
-- 
2.20.1

