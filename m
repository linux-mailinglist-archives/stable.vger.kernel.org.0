Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8907370C85
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhEBOGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233257AbhEBOGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EAB4613E4;
        Sun,  2 May 2021 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964312;
        bh=1ZR2hGCVxl/AUz/DPdg4lR6EqMKap5Sr4BtBZj9BvF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFVib25LXxUmVygEkyQazzfwdGmDOiBvDTFwbN7c/4fGMtL8Vs21i7NbNU7qc2wkK
         CH45N4bpwaSI92o+Q4vCSsb5Y+6O2dcADIxLCzlYdmrOXsRhkovLjtju9AdrqW0ama
         Yj0RgXBkeR3zoRMLdYwN3/VbFv3hwRLz8IXfaFouse5Xlqq8pH/s6foPulvbXPT8/x
         /+vlhRUreHT4fekV8BRUQoP1A5R5fpymgk+TZryY8kT/sj/+JzglZO8lWcgaw5bpVk
         pNOcPVZIFuQkto6EzdcAu1BfI66m12c8qO+5KCYJdxH7v8DmKmyDGiG4p0khmPO737
         sI/oxq9d0FAAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 30/34] crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
Date:   Sun,  2 May 2021 10:04:30 -0400
Message-Id: <20210502140434.2719553-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 1cb3ad701970e68f18a9e5d090baf2b1b703d729 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index cfc8e0e37bee..dcce15b55809 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -810,7 +810,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
@@ -959,7 +959,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
@@ -997,7 +997,7 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
@@ -1553,7 +1553,7 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	if (!hdev)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(hdev->dev);
+	ret = pm_runtime_resume_and_get(hdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

