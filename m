Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3553BB17C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGDXMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhGDXLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A977661935;
        Sun,  4 Jul 2021 23:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440081;
        bh=9vnRA3Wy++7LojlzO1B1ztaIrIE2VgJhbNw4DsA2KLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ea+BhstPmuIxbgLZxhzoc5EejIRrtcvZBFjNhOYUJ8HXv/tia1Hb5G0jbgRrjmSp5
         9TzVpcV3b7qFhI4v/XCPLjd1kLHK1GrCtmuoE3LnD2Vf5aU5Oc45wDBFaAsRetNkS8
         tf0R/w8ZoLceHIatOIDE6qaeThA4nOvJatVe9GaMk5pdGpvOfXyHkoFxSxdArBzACW
         zZuI3o61sSwhlrgp8sZnXo2CZ+oM/07r4eFBL7GOaV0ffRGFg31gULdJcg5jvjkCMb
         BXZ/e68hC/plP2IRCph+3+b/pt5nXY6/2dyeeZYdPzdm0cpCyfioYcQC8saEeJO9dW
         RdGdNX+/PwVzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 79/80] regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
Date:   Sun,  4 Jul 2021 19:06:15 -0400
Message-Id: <20210704230616.1489200-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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

