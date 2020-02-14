Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4015E81D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392732AbgBNQ5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404496AbgBNQRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D73246EA;
        Fri, 14 Feb 2020 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697053;
        bh=ZXhnpMrj5CaWrpKLVqIdetget1X44xH0z5FU1tXfW64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKM/19JYgfNzj9EAFus2gHlsp+LlpFbRIk+77Wk0ZlqXFf5WUsedZw+mBVl7PdKEP
         kvlBlvqmVW+0paVsbyNnraNnTqbzwxUlLfWp31BeBKRSkEfEuzfGcaepwhHfOePCvv
         EVSCwjatc9JO41FfQ27W8suOSjEW5jSOrzsmyc3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 013/186] pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
Date:   Fri, 14 Feb 2020 11:14:22 -0500
Message-Id: <20200214161715.18113-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 55b1cb1f03ad5eea39897d0c74035e02deddcff2 ]

pinmux_func_gpios[] contains a hole due to the missing function GPIO
definition for the "CTX0&CTX1" signal, which is the logical "AND" of the
two CAN outputs.

Fix this by:
  - Renaming CRX0_CRX1_MARK to CTX0_CTX1_MARK, as PJ2MD[2:0]=010
    configures the combined "CTX0&CTX1" output signal,
  - Renaming CRX0X1_MARK to CRX0_CRX1_MARK, as PJ3MD[1:0]=10 configures
    the shared "CRX0/CRX1" input signal, which is fed to both CAN
    inputs,
  - Adding the missing function GPIO definition for "CTX0&CTX1" to
    pinmux_func_gpios[],
  - Moving all CAN enums next to each other.

See SH7262 Group, SH7264 Group User's Manual: Hardware, Rev. 4.00:
  [1] Figure 1.2 (3) (Pin Assignment for the SH7264 Group (1-Mbyte
      Version),
  [2] Figure 1.2 (4) Pin Assignment for the SH7264 Group (640-Kbyte
      Version,
  [3] Table 1.4 List of Pins,
  [4] Figure 20.29 Connection Example when Using This Module as 1-Channel
      Module (64 Mailboxes x 1 Channel),
  [5] Table 32.10 Multiplexed Pins (Port J),
  [6] Section 32.2.30 (3) Port J Control Register 0 (PJCR0).

Note that the last 2 disagree about PJ2MD[2:0], which is probably the
root cause of this bug.  But considering [4], "CTx0&CTx1" in [5] must
be correct, and "CRx0&CRx1" in [6] must be wrong.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191218194812.12741-4-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh7264.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7264.c b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
index e1c34e19222ee..3ddb9565ed804 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7264.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
@@ -500,17 +500,15 @@ enum {
 	SD_WP_MARK, SD_CLK_MARK, SD_CMD_MARK,
 	CRX0_MARK, CRX1_MARK,
 	CTX0_MARK, CTX1_MARK,
+	CRX0_CRX1_MARK, CTX0_CTX1_MARK,
 
 	PWM1A_MARK, PWM1B_MARK, PWM1C_MARK, PWM1D_MARK,
 	PWM1E_MARK, PWM1F_MARK, PWM1G_MARK, PWM1H_MARK,
 	PWM2A_MARK, PWM2B_MARK, PWM2C_MARK, PWM2D_MARK,
 	PWM2E_MARK, PWM2F_MARK, PWM2G_MARK, PWM2H_MARK,
 	IERXD_MARK, IETXD_MARK,
-	CRX0_CRX1_MARK,
 	WDTOVF_MARK,
 
-	CRX0X1_MARK,
-
 	/* DMAC */
 	TEND0_MARK, DACK0_MARK, DREQ0_MARK,
 	TEND1_MARK, DACK1_MARK, DREQ1_MARK,
@@ -998,12 +996,12 @@ static const u16 pinmux_data[] = {
 
 	PINMUX_DATA(PJ3_DATA, PJ3MD_00),
 	PINMUX_DATA(CRX1_MARK, PJ3MD_01),
-	PINMUX_DATA(CRX0X1_MARK, PJ3MD_10),
+	PINMUX_DATA(CRX0_CRX1_MARK, PJ3MD_10),
 	PINMUX_DATA(IRQ1_PJ_MARK, PJ3MD_11),
 
 	PINMUX_DATA(PJ2_DATA, PJ2MD_000),
 	PINMUX_DATA(CTX1_MARK, PJ2MD_001),
-	PINMUX_DATA(CRX0_CRX1_MARK, PJ2MD_010),
+	PINMUX_DATA(CTX0_CTX1_MARK, PJ2MD_010),
 	PINMUX_DATA(CS2_MARK, PJ2MD_011),
 	PINMUX_DATA(SCK0_MARK, PJ2MD_100),
 	PINMUX_DATA(LCD_M_DISP_MARK, PJ2MD_101),
@@ -1248,6 +1246,7 @@ static const struct pinmux_func pinmux_func_gpios[] = {
 	GPIO_FN(CTX1),
 	GPIO_FN(CRX1),
 	GPIO_FN(CTX0),
+	GPIO_FN(CTX0_CTX1),
 	GPIO_FN(CRX0),
 	GPIO_FN(CRX0_CRX1),
 
-- 
2.20.1

