Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6E3A84A6
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhFOPvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFOPvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CBF86142E;
        Tue, 15 Jun 2021 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772151;
        bh=7XithQDclGVMskiYSnk+wc7QQ9CgiuP0MCr5Rw/yn7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0VV09TD3lXNNel2eilozmKyY2d8KRQEtBHDLeJDR8jWaKSppxF8LhG6z6oJi9xnn
         Ld4i23dt0OkjtKjvso6AswQEbm9ZkSnHf4cR4l8yjYE432lVSEX9jji92l07EOp5/5
         2tIcdC2fzyvENzTBA067080BYgUHfHyOvb6SDO89sh5bjfORna9ux2pi2lHiQOI6dw
         co/7CfwlE+geZPlspZl/UfWde5O/3dVeAmjAIC4nEKV31a3EtUAg+ougfXANUjd2Am
         lvxP8ASBi/6W5xkralH6FdijK1lkiVr2+hmVwrntw50EzwAdrPYsn8ROxsWrlRM+0U
         qPg5cQ64JIWRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 02/30] regulator: max77620: Silence deferred probe error
Date:   Tue, 15 Jun 2021 11:48:39 -0400
Message-Id: <20210615154908.62388-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 62499a94ce5b9a41047dbadaad885347b1176079 ]

One of previous changes to regulator core causes PMIC regulators to
re-probe until supply regulator is registered. Silence noisy error
message about the deferred probe.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210523224243.13219-3-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max77620-regulator.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max77620-regulator.c b/drivers/regulator/max77620-regulator.c
index 8d9731e4052b..6d0a8c696ecd 100644
--- a/drivers/regulator/max77620-regulator.c
+++ b/drivers/regulator/max77620-regulator.c
@@ -839,12 +839,10 @@ static int max77620_regulator_probe(struct platform_device *pdev)
 			return ret;
 
 		rdev = devm_regulator_register(dev, rdesc, &config);
-		if (IS_ERR(rdev)) {
-			ret = PTR_ERR(rdev);
-			dev_err(dev, "Regulator registration %s failed: %d\n",
-				rdesc->name, ret);
-			return ret;
-		}
+		if (IS_ERR(rdev))
+			return dev_err_probe(dev, PTR_ERR(rdev),
+					     "Regulator registration %s failed\n",
+					     rdesc->name);
 	}
 
 	return 0;
-- 
2.30.2

