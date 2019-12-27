Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D8312B622
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfL0R3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfL0R3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:29:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA22C222C2;
        Fri, 27 Dec 2019 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577467755;
        bh=4IyyrK3rcc20TYIu/QyrdI8yxLZaiEYZrJ/T8FRNMo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcmHrjXfclLV8Vsoee1bIIkoaLFa83xDzhbwLpmiFiuAOlmFBaVK62nLP48/UrF1j
         1JDz44YJFkPh1AzlGOv8HBSUHsmZ6p1LAiJD+856pbs2u5mMeo0AyiPxEcMjH3QdvI
         NEFlbey1JNPcgyPnTH4zSE9k2vuQ4W3tg6a3I9PU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 003/187] regulator: fix use after free issue
Date:   Fri, 27 Dec 2019 12:26:07 -0500
Message-Id: <20191227172911.4430-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227172911.4430-1-sashal@kernel.org>
References: <20191227172911.4430-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 4affd79a125ac91e6a53be843ea3960a8fc00cbb ]

This is caused by dereferencing 'rdev' after put_device() in
the _regulator_get()/_regulator_put() functions.
This patch just moves the put_device() down a bit to avoid the
issue.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20191124145835.25999-1-wenyang@linux.alibaba.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a46be221dbdc..71c1467e1e2e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1935,8 +1935,8 @@ struct regulator *_regulator_get(struct device *dev, const char *id,
 	regulator = create_regulator(rdev, dev, id);
 	if (regulator == NULL) {
 		regulator = ERR_PTR(-ENOMEM);
-		put_device(&rdev->dev);
 		module_put(rdev->owner);
+		put_device(&rdev->dev);
 		return regulator;
 	}
 
@@ -2057,13 +2057,13 @@ static void _regulator_put(struct regulator *regulator)
 
 	rdev->open_count--;
 	rdev->exclusive = 0;
-	put_device(&rdev->dev);
 	regulator_unlock(rdev);
 
 	kfree_const(regulator->supply_name);
 	kfree(regulator);
 
 	module_put(rdev->owner);
+	put_device(&rdev->dev);
 }
 
 /**
-- 
2.20.1

