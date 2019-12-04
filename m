Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593001134B1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfLDR6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbfLDR6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:58:23 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B6EE2073B;
        Wed,  4 Dec 2019 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482302;
        bh=2ruCfQM2uGTJfrjE1Ri3MmU/nY3aN8p9UYu2mdRhDEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqFQZExxfGOBNJ06yoThk2aHR9etQlXEaaismbjICYVgtvSBvxxYCkTP1wdeaQCq2
         iq6vAPGkshVtMHilYhiOm8VVO4sudz3vqBCGLFSI3ShoyoJDzO7ocmMc2a99gYvTbO
         jX18xP1oIFTKDVB4ERw0/hsbrCR8sHJB3MtNBvJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 32/92] pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
Date:   Wed,  4 Dec 2019 18:49:32 +0100
Message-Id: <20191204174332.533260362@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



