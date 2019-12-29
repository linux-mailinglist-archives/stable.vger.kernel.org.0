Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C34412C802
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbfL2RuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731729AbfL2RuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1679720718;
        Sun, 29 Dec 2019 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641799;
        bh=+uKGfkqX3p9SoCvvXDvnvHaWwHst2Gv0EPmg14apGh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8aZ/aAnb83RoqJRE2U8qGQxT0w8NPgEPXu6z2wY0FydffpZGYNIiF7MMO54ASE+I
         kgnUb3H5T6k33ylwqERuTy2W32DdUnIe44+DJ/noJMpuR4Z9VYkyr71ci6Gj0amCt8
         tehbJc0k9WIr3s5Lqfd6ASciFsNaUBSps6DFTi0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/434] pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B
Date:   Sun, 29 Dec 2019 18:24:29 +0100
Message-Id: <20191229172716.182448024@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 96f0246ad2f2..82b63208135a 100644
--- a/arch/sh/include/cpu-sh4/cpu/sh7734.h
+++ b/arch/sh/include/cpu-sh4/cpu/sh7734.h
@@ -134,7 +134,7 @@ enum {
 	GPIO_FN_EX_WAIT1, GPIO_FN_SD1_DAT0_A, GPIO_FN_DREQ2, GPIO_FN_CAN1_TX_C,
 		GPIO_FN_ET0_LINK_C, GPIO_FN_ET0_ETXD5_A,
 	GPIO_FN_EX_WAIT0, GPIO_FN_TCLK1_B,
-	GPIO_FN_RD_WR, GPIO_FN_TCLK0,
+	GPIO_FN_RD_WR, GPIO_FN_TCLK0, GPIO_FN_CAN_CLK_B, GPIO_FN_ET0_ETXD4,
 	GPIO_FN_EX_CS5, GPIO_FN_SD1_CMD_A, GPIO_FN_ATADIR, GPIO_FN_QSSL_B,
 		GPIO_FN_ET0_ETXD3_A,
 	GPIO_FN_EX_CS4, GPIO_FN_SD1_WP_A, GPIO_FN_ATAWR, GPIO_FN_QMI_QIO1_B,
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index 5dfd991ffdaa..dbc36079c381 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -1450,7 +1450,7 @@ static const struct pinmux_func pinmux_func_gpios[] = {
 	GPIO_FN(ET0_ETXD2_A),
 	GPIO_FN(EX_CS5), GPIO_FN(SD1_CMD_A), GPIO_FN(ATADIR), GPIO_FN(QSSL_B),
 	GPIO_FN(ET0_ETXD3_A),
-	GPIO_FN(RD_WR), GPIO_FN(TCLK1_B),
+	GPIO_FN(RD_WR), GPIO_FN(TCLK0), GPIO_FN(CAN_CLK_B), GPIO_FN(ET0_ETXD4),
 	GPIO_FN(EX_WAIT0), GPIO_FN(TCLK1_B),
 	GPIO_FN(EX_WAIT1), GPIO_FN(SD1_DAT0_A), GPIO_FN(DREQ2),
 		GPIO_FN(CAN1_TX_C), GPIO_FN(ET0_LINK_C), GPIO_FN(ET0_ETXD5_A),
@@ -1949,7 +1949,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
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



