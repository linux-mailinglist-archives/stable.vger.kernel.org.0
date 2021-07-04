Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A23BB2EB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhGDXQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhGDXOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F4B61983;
        Sun,  4 Jul 2021 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440176;
        bh=9vnRA3Wy++7LojlzO1B1ztaIrIE2VgJhbNw4DsA2KLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCDhOJULiY5CbzQrUFq2SWGHdwAm4DYHNXWhMPdP8RClxGjMvxHejW6C5/759CpMx
         e+xZR1a02yzGfuvNwJCbQlKdPtFWZCA4eA2/fVGz3bUBVmsTNKiavU1VGscgdEAg4t
         Vm423irUa9oULdsjJmaon+1Smo7YlCB9uGBubQqfg1QXcuQQSK9DGux5oSXErUtF+k
         RG67LeWhlX9OxJQZ3unIu2rWRgANJnjMy7/Dhk+nwAUBeFEgO5gKRbE0WmrZwOqr8h
         qo5BJY3fDSXbR2hdbcH4kmxRMiBJGbw02Honmswb3lZsH0Va0M4pY5a5RbpA98qlUk
         qtBFULaLANUFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 69/70] regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
Date:   Sun,  4 Jul 2021 19:08:02 -0400
Message-Id: <20210704230804.1490078-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit a336dc8f683e5be794186b5643cd34cb28dd2c53 ]

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Also fix returning negative value when new_sel < old_sel.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210618141412.4014912-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9052-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index e18d291c7f21..23fa429ebe76 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -250,7 +250,8 @@ static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	case DA9052_ID_BUCK3:
 	case DA9052_ID_LDO2:
 	case DA9052_ID_LDO3:
-		ret = (new_sel - old_sel) * info->step_uV / 6250;
+		ret = DIV_ROUND_UP(abs(new_sel - old_sel) * info->step_uV,
+				   6250);
 		break;
 	}
 
-- 
2.30.2

