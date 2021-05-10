Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D033785DD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhEJLCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234691AbhEJK4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55E6619B0;
        Mon, 10 May 2021 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643693;
        bh=Vo/FISjJaBiKCzJj1+PChnmpKZgW/xNpicjNwharwo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YW3Eg2D39Mctg23Ehm/hJVsU9VRl0ALm49Gz8bcggZ/8Bql/N+5OsAJVqAJTimLz
         kXXiSveRJoJPRXLpbzVLIRzrPI9+3PHmMotRB4l+iF3U0OYV+gwDz+JS4srlpc783m
         G0F5THUvw/aqRnII6d7RGWbIoVFV5yxToCpcmHps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 119/342] crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
Date:   Mon, 10 May 2021 12:18:29 +0200
Message-Id: <20210510102014.014588570@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7ac0573ef663..389de9e3302d 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -813,7 +813,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
@@ -962,7 +962,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
@@ -1000,7 +1000,7 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
-	pm_runtime_get_sync(hdev->dev);
+	pm_runtime_resume_and_get(hdev->dev);
 
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
@@ -1566,7 +1566,7 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	if (!hdev)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(hdev->dev);
+	ret = pm_runtime_resume_and_get(hdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



