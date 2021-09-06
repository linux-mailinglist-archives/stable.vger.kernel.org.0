Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF64401484
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351139AbhIFBdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351848AbhIFBbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C3660EBA;
        Mon,  6 Sep 2021 01:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891476;
        bh=aJbU3niOMiqWDfuuNzo+NUQMkgvX7J+4DUaYisS19y0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ut/yU9UV/VHkvbu/gp2zWav9gMLUP+cq3hlkN15ksiXvHMI95J4bOxKWLn0h79rYW
         WXdMuay1hl9igGOcH0TS2eZpD6vFqsIJ5jFJiRyl5FK3uC1MCcC4u+RUBUqwFPYhPx
         kzsGs2G8CJ3KMLT0uYnH9n76SRVpUmH5y2mFVdnQ1bJL/pCYayRkbI51sAzZvLf7mK
         6odEW3FtiHjN+i5Lc0t8h1dUvJImLOkvb9QY0QBeFVThTEWUoHDeHTVWScnNqe7LoH
         W9DF+7b2mzmmohhAfnj4Dwcz/FHGpIxShdMYqn83x9DR5BNXlexQvKRob5+8bbelCT
         Bt9BwT+G9LXtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/9] regulator: tps65910: Silence deferred probe error
Date:   Sun,  5 Sep 2021 21:24:26 -0400
Message-Id: <20210906012435.931318-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 9cde7b075701..1603d730919b 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1208,12 +1208,10 @@ static int tps65910_probe(struct platform_device *pdev)
 
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

