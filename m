Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61FD370C8A
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhEBOGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhEBOGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866DC6102A;
        Sun,  2 May 2021 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964313;
        bh=lUX4eytSW0bGZZYiuwe9s9CZeSADcmyNb4eWnzvha/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXR3I1Z3inrnG4in57J/MruXywKCsBE8xnlcdCmjouytG7jT8XmeNyeo+rVHEfD0m
         lytIJKbXzie2Ytoofam3zgb7VqWQuztf2PVRvLjkPYe4TeyxdX6wPQE7SxvOH2TDev
         OYud/Jxt8jZydQEGCJkfRJnWagY6oCbkVa8i9dPtfEq75JinnRBWoRZcTMKFox3uD9
         mVoC3pLrC8EFpJfkqsq2RMl9jZ4EX+RunomwnN2f9WRS+OZC7wbz8GMZgkuxQRKl87
         US8ZDWQ7KVNd4t/2xZJAp3CUHAzVYhH+RsVPBhDjVb8w8SSAaTIV3VdcxPrvBnvXLj
         Fp0aaOXRenXyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 31/34] crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c
Date:   Sun,  2 May 2021 10:04:31 -0400
Message-Id: <20210502140434.2719553-31-sashal@kernel.org>
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

[ Upstream commit 747bf30fd944f02f341b5f3bc7d97a13f2ae2fbe ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index ba5ea6434f9c..9b3511236ba2 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -537,7 +537,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	int ret;
 	u32 cfg, hw_mode;
 
-	pm_runtime_get_sync(cryp->dev);
+	pm_runtime_resume_and_get(cryp->dev);
 
 	/* Disable interrupt */
 	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
@@ -2054,7 +2054,7 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 	if (!cryp)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(cryp->dev);
+	ret = pm_runtime_resume_and_get(cryp->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

