Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEA515F48D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgBNPtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbgBNPte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E79324654;
        Fri, 14 Feb 2020 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695374;
        bh=Wg6DfDmhJX8CmKYfKrG4vk4WEruzi4uSKrwmTAYfZMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYFqkP2GHBdiFlw0aKanFboibn5fMyeY3t64fxMUBycQ4t3g12V2tpLUCU9SXqSDw
         wpzAhllkaeLaw4QD2gBVgYsr6sefmmmFykQhrdw196qjNPY70r4+218iDOehwIwoAc
         gWDhdHslQeKqELmoYhsluO23BEjZvZ4PZvY8rN4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 030/542] pinctrl: sh-pfc: r8a77965: Fix DU_DOTCLKIN3 drive/bias control
Date:   Fri, 14 Feb 2020 10:40:22 -0500
Message-Id: <20200214154854.6746-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a34cd9dfd03fa9ec380405969f1d638bc63b8d63 ]

R-Car Gen3 Hardware Manual Errata for Rev. 2.00 of October 24, 2019
changed the configuration bits for drive and bias control for the
DU_DOTCLKIN3 pin on R-Car M3-N, to match the same pin on R-Car H3.
Update the driver to reflect this.

After this, the handling of drive and bias control for the various
DU_DOTCLKINx pins is consistent across all of the R-Car H3, M3-W,
M3-W+, and M3-N SoCs.

Fixes: 86c045c2e4201e94 ("pinctrl: sh-pfc: r8a77965: Replace DU_DOTCLKIN2 by DU_DOTCLKIN3")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191113101653.28428-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77965.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77965.c b/drivers/pinctrl/sh-pfc/pfc-r8a77965.c
index 8bdf33c807f6c..6616f5210b9d9 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77965.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77965.c
@@ -5998,7 +5998,7 @@ static const struct pinmux_drive_reg pinmux_drive_regs[] = {
 		{ PIN_DU_DOTCLKIN1,    0, 2 },	/* DU_DOTCLKIN1 */
 	} },
 	{ PINMUX_DRIVE_REG("DRVCTRL12", 0xe6060330) {
-		{ PIN_DU_DOTCLKIN3,   28, 2 },	/* DU_DOTCLKIN3 */
+		{ PIN_DU_DOTCLKIN3,   24, 2 },	/* DU_DOTCLKIN3 */
 		{ PIN_FSCLKST,        20, 2 },	/* FSCLKST */
 		{ PIN_TMS,             4, 2 },	/* TMS */
 	} },
@@ -6254,8 +6254,8 @@ static const struct pinmux_bias_reg pinmux_bias_regs[] = {
 		[31] = PIN_DU_DOTCLKIN1,	/* DU_DOTCLKIN1 */
 	} },
 	{ PINMUX_BIAS_REG("PUEN3", 0xe606040c, "PUD3", 0xe606044c) {
-		[ 0] = PIN_DU_DOTCLKIN3,	/* DU_DOTCLKIN3 */
-		[ 1] = SH_PFC_PIN_NONE,
+		[ 0] = SH_PFC_PIN_NONE,
+		[ 1] = PIN_DU_DOTCLKIN3,	/* DU_DOTCLKIN3 */
 		[ 2] = PIN_FSCLKST,		/* FSCLKST */
 		[ 3] = PIN_EXTALR,		/* EXTALR*/
 		[ 4] = PIN_TRST_N,		/* TRST# */
-- 
2.20.1

