Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD643CC500
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhGQRvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:51:40 -0400
Received: from aposti.net ([89.234.176.197]:56892 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhGQRvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:51:39 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0?= <zhouyanjie@wanyeetech.com>,
        linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] pinctrl: ingenic: Fix incorrect pull up/down info
Date:   Sat, 17 Jul 2021 18:48:34 +0100
Message-Id: <20210717174836.14776-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the pull up/down info for both the JZ4760 and JZ4770 SoCs, as the
previous values sometimes contradicted what's written in the programming
manual.

Fixes: b5c23aa46537 ("pinctrl: add a pinctrl driver for the Ingenic jz47xx SoCs")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/pinctrl/pinctrl-ingenic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 983ba9865f77..126ca671c3cd 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -710,7 +710,7 @@ static const struct ingenic_chip_info jz4755_chip_info = {
 };
 
 static const u32 jz4760_pull_ups[6] = {
-	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
+	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
 };
 
 static const u32 jz4760_pull_downs[6] = {
@@ -936,11 +936,11 @@ static const struct ingenic_chip_info jz4760_chip_info = {
 };
 
 static const u32 jz4770_pull_ups[6] = {
-	0x3fffffff, 0xfff0030c, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0xffa7f00f,
+	0x3fffffff, 0xfff0f3fc, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0x0024f00f,
 };
 
 static const u32 jz4770_pull_downs[6] = {
-	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x00580ff0,
+	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x005b0ff0,
 };
 
 static int jz4770_uart0_data_pins[] = { 0xa0, 0xa3, };
-- 
2.30.2

