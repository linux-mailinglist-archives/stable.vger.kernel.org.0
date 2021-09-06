Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB09B401271
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhIFBVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238579AbhIFBU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DA561039;
        Mon,  6 Sep 2021 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891195;
        bh=Ot+28yzud98tBNnOiqNPW6YBHnIqP50O9qr9lr6+dQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeTfT5OUYZAS4VH32BSBHOiYWgQG91NFdDmWJ47F9tQjHJe9b9s4NPgBPdJvZL9zJ
         mp44GjgWlJZmem1DcRf3vxnuq93GZZjgP5oXMVVwbD32ohquEF2b4hR7FGB9adDBAm
         gFcI2JQrtfY9eYLSwkW16Dq9oSS/cNCpW61IRNiOnwEkRaGiMmglHY8xFJXUWD+HI+
         5ySOBnsGEp6bsaPgwJ48MoUYLjjnomxMOshmSsorIjQGJQTjmwq0dogkjFfnWwvr+3
         O+4gvUOS8/d6NAZlgTq/Evp905dSzvY1I+pPFpfqY9N5nH+oXK5nF8IcJjjnitQ2hr
         +pZxtOckBsJ+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 03/47] regulator: tps65910: Silence deferred probe error
Date:   Sun,  5 Sep 2021 21:19:07 -0400
Message-Id: <20210906011951.928679-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit e301df76472cc929fa62d923bc3892931f7ad71d ]

The TPS65910 regulator now gets a deferred probe until supply regulator is
registered. Silence noisy error message about the deferred probe.

Reported-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30
Tested-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210705201211.16082-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65910-regulator.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 1d5b0a1b86f7..06cbe60c990f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1211,12 +1211,10 @@ static int tps65910_probe(struct platform_device *pdev)
 
 		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[i],
 					       &config);
-		if (IS_ERR(rdev)) {
-			dev_err(tps65910->dev,
-				"failed to register %s regulator\n",
-				pdev->name);
-			return PTR_ERR(rdev);
-		}
+		if (IS_ERR(rdev))
+			return dev_err_probe(tps65910->dev, PTR_ERR(rdev),
+					     "failed to register %s regulator\n",
+					     pdev->name);
 
 		/* Save regulator for cleanup */
 		pmic->rdev[i] = rdev;
-- 
2.30.2

