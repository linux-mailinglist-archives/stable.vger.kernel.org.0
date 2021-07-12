Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3343C4D8E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbhGLHNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242037AbhGLHLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA76610CD;
        Mon, 12 Jul 2021 07:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073739;
        bh=itDZxyg1Nov1gCuG1NWM0w2b1oSHOd/fpWu51t+Cujg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPMc28wXQ9VQbw2es64RKNOaGkrhS0jSQK9+JQ8yV/8+16q8CcvLRIurnU9uULhAP
         tlWlb88YOY1lI7RrXEzhRf36WBoSG3mc/FnB0Ar0E89QKwAUlub5wHRCyJF+rciM+Y
         PsK5gEGUhFWa4aDfFNsG/XaaMuqNJFE1pHa7Non8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 306/700] regulator: hi6421v600: Fix setting idle mode
Date:   Mon, 12 Jul 2021 08:06:29 +0200
Message-Id: <20210712061008.942268012@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 57c045bc727001c43b6a65adb0418aa7b3e6dbd0 ]

commit db27f8294cd7 changed eco_mode << (ffs(sreg->eco_mode_mask) - 1)
to sreg->eco_mode_mask << (ffs(sreg->eco_mode_mask) - 1) which is wrong.
Fix it by simply set val = sreg->eco_mode_mask.

In additional, sreg->eco_mode_mask can be 0 (LDO3, LDO33, LDO34).
Return -EINVAL if idle mode is not supported when sreg->eco_mode_mask is 0.

While at it, also use unsigned int for reg_val/val which is the expected
type for regmap_read and regmap_update_bits.

Fixes: db27f8294cd7 ("staging: regulator: hi6421v600-regulator: use shorter names for OF properties")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210619123423.4091429-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/hikey9xx/hi6421v600-regulator.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hikey9xx/hi6421v600-regulator.c b/drivers/staging/hikey9xx/hi6421v600-regulator.c
index e10fe3058176..91136db3961e 100644
--- a/drivers/staging/hikey9xx/hi6421v600-regulator.c
+++ b/drivers/staging/hikey9xx/hi6421v600-regulator.c
@@ -129,7 +129,7 @@ static unsigned int hi6421_spmi_regulator_get_mode(struct regulator_dev *rdev)
 {
 	struct hi6421_spmi_reg_info *sreg = rdev_get_drvdata(rdev);
 	struct hi6421_spmi_pmic *pmic = sreg->pmic;
-	u32 reg_val;
+	unsigned int reg_val;
 
 	regmap_read(pmic->regmap, rdev->desc->enable_reg, &reg_val);
 
@@ -144,14 +144,17 @@ static int hi6421_spmi_regulator_set_mode(struct regulator_dev *rdev,
 {
 	struct hi6421_spmi_reg_info *sreg = rdev_get_drvdata(rdev);
 	struct hi6421_spmi_pmic *pmic = sreg->pmic;
-	u32 val;
+	unsigned int val;
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
 		val = 0;
 		break;
 	case REGULATOR_MODE_IDLE:
-		val = sreg->eco_mode_mask << (ffs(sreg->eco_mode_mask) - 1);
+		if (!sreg->eco_mode_mask)
+			return -EINVAL;
+
+		val = sreg->eco_mode_mask;
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2



