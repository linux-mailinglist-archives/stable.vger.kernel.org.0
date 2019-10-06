Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E661CD4EF
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfJFRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbfJFRar (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:30:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2DE2080F;
        Sun,  6 Oct 2019 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383046;
        bh=X83HWbTqofVal5zxoKrVPyIEsOibVmg3PU1ULh3YdLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri2TllZFWox0pDxHeQrqKQSqdNuMUiSTNd7qVLeWC83sUzOtCl672IVFyvj9d2/R/
         fnQw4kgRsDWi49/CmsrgtwAT+U791gF9DV1Mv1ckrd1fEBCzUsvTwqfma7s47D2O2G
         BCh5QJiutAk1cyefMLlLwq/KxvOo+e7nZJZ837Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Otto Meier <gf435@gmx.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/106] pinctrl: meson-gxbb: Fix wrong pinning definition for uart_c
Date:   Sun,  6 Oct 2019 19:20:45 +0200
Message-Id: <20191006171141.542066648@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4edeb4cae72aa..c4c70dc57dbee 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
@@ -198,8 +198,8 @@ static const unsigned int uart_rts_b_pins[]	= { GPIODV_27 };
 
 static const unsigned int uart_tx_c_pins[]	= { GPIOY_13 };
 static const unsigned int uart_rx_c_pins[]	= { GPIOY_14 };
-static const unsigned int uart_cts_c_pins[]	= { GPIOX_11 };
-static const unsigned int uart_rts_c_pins[]	= { GPIOX_12 };
+static const unsigned int uart_cts_c_pins[]	= { GPIOY_11 };
+static const unsigned int uart_rts_c_pins[]	= { GPIOY_12 };
 
 static const unsigned int i2c_sck_a_pins[]	= { GPIODV_25 };
 static const unsigned int i2c_sda_a_pins[]	= { GPIODV_24 };
@@ -445,10 +445,10 @@ static struct meson_pmx_group meson_gxbb_periphs_groups[] = {
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



