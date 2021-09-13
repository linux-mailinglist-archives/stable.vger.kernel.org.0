Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9AF408EAF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhIMNgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242431AbhIMN3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213706127C;
        Mon, 13 Sep 2021 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539442;
        bh=Ot+28yzud98tBNnOiqNPW6YBHnIqP50O9qr9lr6+dQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORik520NMJMx2VwHYbegxDdE7QwE6On3LCQhfs9tc+zYmN/vZh+SqChKK12EOkEi9
         Tr50qOBO1t2WAC+KeSW/ZCapJ+t5b4zi5546eD7KJcbPrNPat8uHCzQPcU9bhmUF7S
         nlxfpXoJJ+GnUlXwidhZw4A5XOBK1MuHdqm4gS5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Matt Merhar <mattmerhar@protonmail.com>
Subject: [PATCH 5.10 003/236] regulator: tps65910: Silence deferred probe error
Date:   Mon, 13 Sep 2021 15:11:48 +0200
Message-Id: <20210913131100.434781737@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



