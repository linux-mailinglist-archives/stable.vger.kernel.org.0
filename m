Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D593BB377
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhGDXSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhGDXPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E669613F1;
        Sun,  4 Jul 2021 23:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440361;
        bh=D3D6XPU+wiqf0XUCXJoRP0z41QiQhDjJilDE8NdqY+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L519fOgKF5q9EHY3s8JDjbYvXHhVKAnSQ3qLjb/WCFOzo6gxV3GcTozZe3q3suj4U
         zyqnTxR+VUhV6oTyuFDjcrQFCjiAlIAuHEzoZd71/XaLzLtueXQXmRTvx7CGI9QPEZ
         jeQ3bFmv+68ksbTG5ybGayLw8AsXVFWnKrlDmN/v6Jf48/BnznHmEkFCbQI5jiT8Z3
         GXC0decqp3GZ9xjOAXhFsur3fKUknGT+11vze6YF9ty4PTskAC1LjQsAWkKGT0Zc5a
         suc7Bu0zQdY+vI7Ryd0l7tpT6sxBA39F3CeO1SnjiAgeKyIA4dDHLlrellAf39mUMB
         tf4QdbXFtwtAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 15/15] regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
Date:   Sun,  4 Jul 2021 19:12:21 -0400
Message-Id: <20210704231222.1492037-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231222.1492037-1-sashal@kernel.org>
References: <20210704231222.1492037-1-sashal@kernel.org>
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
index 12a25b40e473..fa9cb7df79de 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -258,7 +258,8 @@ static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
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

