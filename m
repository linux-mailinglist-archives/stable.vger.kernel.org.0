Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71E912B7BB
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfL0Rnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:43:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfL0Rny (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62EE821582;
        Fri, 27 Dec 2019 17:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468634;
        bh=FnZPoNBagxvxWxZ/U8zTvEliUMOg4jheX72GYnmXcUg=;
        h=From:To:Cc:Subject:Date:From;
        b=mi6cYWBY+h19R539OjUDK+Lx3QbVOhHOFt3/5sUe/fr8TPmewInFLaTcdrUVHYHMm
         7dRvNfeve+EetLdGsK9723kY1FsQqGUMmHQzU1tApAJFmhBzv2cpKu1NtiBqWb4lY6
         O5EHsIwbC/rWFbdk2RuLzWyW0WFU7rjnEHqg/tkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/84] regulator: fix use after free issue
Date:   Fri, 27 Dec 2019 12:42:29 -0500
Message-Id: <20191227174352.6264-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
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
index f312764660e6..4bab758d14b1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1724,8 +1724,8 @@ struct regulator *_regulator_get(struct device *dev, const char *id,
 	regulator = create_regulator(rdev, dev, id);
 	if (regulator == NULL) {
 		regulator = ERR_PTR(-ENOMEM);
-		put_device(&rdev->dev);
 		module_put(rdev->owner);
+		put_device(&rdev->dev);
 		return regulator;
 	}
 
@@ -1851,13 +1851,13 @@ static void _regulator_put(struct regulator *regulator)
 
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

