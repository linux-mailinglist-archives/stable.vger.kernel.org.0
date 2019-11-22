Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5933910638E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfKVGLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbfKVF4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00BA22070A;
        Fri, 22 Nov 2019 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402193;
        bh=2ruCfQM2uGTJfrjE1Ri3MmU/nY3aN8p9UYu2mdRhDEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPIter8JCQ/ELTkZn8yIH+V3Xnd9H7M76npVv08dyQL9In7wuL3exdU27vxuN7kwU
         apGpkPW0qqag1rMG4ikuCivUTFdjd+azahEbaW0eUrReq3lkxKeYQS3rraAGS+B+2g
         wIRYUsUU3NtvedQuNBQUhfpc8DdhHJCJTj9FQBDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 043/127] pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
Date:   Fri, 22 Nov 2019 00:54:21 -0500
Message-Id: <20191122055544.3299-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1b99d0c80bbe1810572c2cb77b90f67886adfa8d ]

The Port F Control Register 3 (PFCR3) contains only a single field.
However, counting from left to right, it is the fourth field, not the
first field.
Insert the missing dummy configuration values (3 fields of 16 values) to
fix this.

The descriptor for the Port F Control Register 0 (PFCR0) lacks the
description for the 4th field (PF0 Mode, PF0MD[2:0]).
Add the missing configuration values to fix this.

Fixes: a8d42fc4217b1ea1 ("sh-pfc: Add sh7264 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh7264.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7264.c b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
index 8070765311dbf..e1c34e19222ee 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7264.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7264.c
@@ -1716,6 +1716,9 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 	},
 
 	{ PINMUX_CFG_REG("PFCR3", 0xfffe38a8, 16, 4) {
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		PF12MD_000, PF12MD_001, 0, PF12MD_011,
 		PF12MD_100, PF12MD_101, 0, 0,
 		0, 0, 0, 0, 0, 0, 0, 0 }
@@ -1759,8 +1762,10 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		0, 0, 0, 0, 0, 0, 0, 0,
 		PF1MD_000, PF1MD_001, PF1MD_010, PF1MD_011,
 		PF1MD_100, PF1MD_101, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0
-	 }
+		0, 0, 0, 0, 0, 0, 0, 0,
+		PF0MD_000, PF0MD_001, PF0MD_010, PF0MD_011,
+		PF0MD_100, PF0MD_101, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0 }
 	},
 
 	{ PINMUX_CFG_REG("PFIOR0", 0xfffe38b2, 16, 1) {
-- 
2.20.1

