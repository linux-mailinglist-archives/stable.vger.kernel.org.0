Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7903CC507
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhGQRvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:51:46 -0400
Received: from aposti.net ([89.234.176.197]:56904 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234214AbhGQRvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:51:46 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0?= <zhouyanjie@wanyeetech.com>,
        linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] pinctrl: ingenic: Fix bias config for X2000(E)
Date:   Sat, 17 Jul 2021 18:48:35 +0100
Message-Id: <20210717174836.14776-2-paul@crapouillou.net>
In-Reply-To: <20210717174836.14776-1-paul@crapouillou.net>
References: <20210717174836.14776-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ingenic_set_bias() function's "bias" argument is not a
"enum pin_config_param", so its value should not be compared against
values of that enum.

This should fix the bias config not working on the X2000(E) SoCs.

Fixes: 943e0da15370 ("pinctrl: Ingenic: Add pinctrl driver for X2000.")
Cc: <stable@vger.kernel.org> # v5.12
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/pinctrl/pinctrl-ingenic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 126ca671c3cd..263498be8e31 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -3441,17 +3441,17 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 {
 	if (jzpc->info->version >= ID_X2000) {
 		switch (bias) {
-		case PIN_CONFIG_BIAS_PULL_UP:
+		case GPIO_PULL_UP:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, true);
 			break;
 
-		case PIN_CONFIG_BIAS_PULL_DOWN:
+		case GPIO_PULL_DOWN:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, true);
 			break;
 
-		case PIN_CONFIG_BIAS_DISABLE:
+		case GPIO_PULL_DIS:
 		default:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
-- 
2.30.2

