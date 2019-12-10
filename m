Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41AD119CE2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfLJWeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbfLJWeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A601C208C3;
        Tue, 10 Dec 2019 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017239;
        bh=12JXYKByqO3x4CmWFEQUCTSCcQ7aP0VNMdMcR4qvP5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvFXmAIdgCe0YBaNDcDXzVVhPk6IlWPMao0315zoYWpielJQ3RF5nmqbtYNec6iRk
         AtplWmPBotTxaGfdAh6dYfKbaJEJlXuP6u8uR+HkV7P/aofbK5F9C+3EMzRtOqc6oo
         Z87ZhaaFJj7YrEEF9YjlsUMwf1hvn319H/z6GIzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>, linux-sh@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 36/71] pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B
Date:   Tue, 10 Dec 2019 17:32:41 -0500
Message-Id: <20191210223316.14988-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 884caadad128efad8e00c1cdc3177bc8912ee8ec ]

The definitions for bit field [19:18] of the Peripheral Function Select
Register 3 were accidentally copied from bit field [20], leading to
duplicates for the TCLK1_B function, and missing TCLK0, CAN_CLK_B, and
ET0_ETXD4 functions.

Fix this by adding the missing GPIO_FN_CAN_CLK_B and GPIO_FN_ET0_ETXD4
enum values, and correcting the functions.

Reported-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191024131308.16659-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/cpu-sh4/cpu/sh7734.h | 2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sh/include/cpu-sh4/cpu/sh7734.h b/arch/sh/include/cpu-sh4/cpu/sh7734.h
index 2fb9a7b71b412..a2667c9b5819a 100644
--- a/arch/sh/include/cpu-sh4/cpu/sh7734.h
+++ b/arch/sh/include/cpu-sh4/cpu/sh7734.h
@@ -133,7 +133,7 @@ enum {
 	GPIO_FN_EX_WAIT1, GPIO_FN_SD1_DAT0_A, GPIO_FN_DREQ2, GPIO_FN_CAN1_TX_C,
 		GPIO_FN_ET0_LINK_C, GPIO_FN_ET0_ETXD5_A,
 	GPIO_FN_EX_WAIT0, GPIO_FN_TCLK1_B,
-	GPIO_FN_RD_WR, GPIO_FN_TCLK0,
+	GPIO_FN_RD_WR, GPIO_FN_TCLK0, GPIO_FN_CAN_CLK_B, GPIO_FN_ET0_ETXD4,
 	GPIO_FN_EX_CS5, GPIO_FN_SD1_CMD_A, GPIO_FN_ATADIR, GPIO_FN_QSSL_B,
 		GPIO_FN_ET0_ETXD3_A,
 	GPIO_FN_EX_CS4, GPIO_FN_SD1_WP_A, GPIO_FN_ATAWR, GPIO_FN_QMI_QIO1_B,
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index c691b2e343746..ab09d385f95d1 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -1458,7 +1458,7 @@ static const struct pinmux_func pinmux_func_gpios[] = {
 	GPIO_FN(ET0_ETXD2_A),
 	GPIO_FN(EX_CS5), GPIO_FN(SD1_CMD_A), GPIO_FN(ATADIR), GPIO_FN(QSSL_B),
 	GPIO_FN(ET0_ETXD3_A),
-	GPIO_FN(RD_WR), GPIO_FN(TCLK1_B),
+	GPIO_FN(RD_WR), GPIO_FN(TCLK0), GPIO_FN(CAN_CLK_B), GPIO_FN(ET0_ETXD4),
 	GPIO_FN(EX_WAIT0), GPIO_FN(TCLK1_B),
 	GPIO_FN(EX_WAIT1), GPIO_FN(SD1_DAT0_A), GPIO_FN(DREQ2),
 		GPIO_FN(CAN1_TX_C), GPIO_FN(ET0_LINK_C), GPIO_FN(ET0_ETXD5_A),
@@ -1954,7 +1954,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 	    /* IP3_20 [1] */
 		FN_EX_WAIT0, FN_TCLK1_B,
 	    /* IP3_19_18 [2] */
-		FN_RD_WR, FN_TCLK1_B, 0, 0,
+		FN_RD_WR, FN_TCLK0, FN_CAN_CLK_B, FN_ET0_ETXD4,
 	    /* IP3_17_15 [3] */
 		FN_EX_CS5, FN_SD1_CMD_A, FN_ATADIR, FN_QSSL_B,
 		FN_ET0_ETXD3_A, 0, 0, 0,
-- 
2.20.1

