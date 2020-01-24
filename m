Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115DB147F7B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbgAXLCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgAXLCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:38 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BA82071A;
        Fri, 24 Jan 2020 11:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863757;
        bh=rBrSTr++073TbHtN/5lZ5NdS+N8p2wX8huWZpIDsgzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1K3DHqZTZJ+UC9cpo9qzYRj1ltceoa5yMYuxq3kQ78xZp852vRRXuAL1IC2dQtmNh
         m+0qZCzV9QwIkGvhQ8NC8QTf96U1mbJy0roktK1ZPDn6+3ugIzi8S567GYv/hTWQS2
         ToB9ZiO+iYErUMkFr25SRMxfvnw86HKjxE4AtaJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/639] pinctrl: meson-gxl: remove invalid GPIOX tsin_a pins
Date:   Fri, 24 Jan 2020 10:23:57 +0100
Message-Id: <20200124093055.804234781@linuxfoundation.org>
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

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit d801064cb871806e6843738ecad38993646f53f7 ]

The GPIOX tsin_a pins wrongly uses the SDCard pinctrl bits, this
patch completely removes these pins entries until we find out what
are the correct bits and registers to be used instead.

Fixes: 5a6ae9b80139 ("pinctrl: meson-gxl: add tsin_a pins")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-gxl.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxl.c b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
index 158f618f16957..0c0a5018102b0 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxl.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
@@ -239,13 +239,9 @@ static const unsigned int eth_link_led_pins[]	= { GPIOZ_14 };
 static const unsigned int eth_act_led_pins[]	= { GPIOZ_15 };
 
 static const unsigned int tsin_a_d0_pins[]	= { GPIODV_0 };
-static const unsigned int tsin_a_d0_x_pins[]	= { GPIOX_10 };
 static const unsigned int tsin_a_clk_pins[]	= { GPIODV_8 };
-static const unsigned int tsin_a_clk_x_pins[]	= { GPIOX_11 };
 static const unsigned int tsin_a_sop_pins[]	= { GPIODV_9 };
-static const unsigned int tsin_a_sop_x_pins[]	= { GPIOX_8 };
 static const unsigned int tsin_a_d_valid_pins[] = { GPIODV_10 };
-static const unsigned int tsin_a_d_valid_x_pins[] = { GPIOX_9 };
 static const unsigned int tsin_a_fail_pins[]	= { GPIODV_11 };
 static const unsigned int tsin_a_dp_pins[] = {
 	GPIODV_1, GPIODV_2, GPIODV_3, GPIODV_4, GPIODV_5, GPIODV_6, GPIODV_7,
@@ -432,10 +428,6 @@ static struct meson_pmx_group meson_gxl_periphs_groups[] = {
 	GROUP(spi_miso,		5,	2),
 	GROUP(spi_ss0,		5,	1),
 	GROUP(spi_sclk,		5,	0),
-	GROUP(tsin_a_sop_x,	6,	3),
-	GROUP(tsin_a_d_valid_x,	6,	2),
-	GROUP(tsin_a_d0_x,	6,	1),
-	GROUP(tsin_a_clk_x,	6,	0),
 
 	/* Bank Z */
 	GROUP(eth_mdio,		4,	23),
@@ -698,8 +690,8 @@ static const char * const eth_led_groups[] = {
 };
 
 static const char * const tsin_a_groups[] = {
-	"tsin_a_clk", "tsin_a_clk_x", "tsin_a_sop", "tsin_a_sop_x",
-	"tsin_a_d_valid", "tsin_a_d_valid_x", "tsin_a_d0", "tsin_a_d0_x",
+	"tsin_a_clk", "tsin_a_sop",
+	"tsin_a_d_valid", "tsin_a_d0",
 	"tsin_a_dp", "tsin_a_fail",
 };
 
-- 
2.20.1



