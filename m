Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4F49A8FE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321842AbiAYDTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46130 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351078AbiAXTs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 944E1601B6;
        Mon, 24 Jan 2022 19:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7176DC340E5;
        Mon, 24 Jan 2022 19:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053736;
        bh=qmKODafzn0xTB1HxAA7mC+0HKJowUFd9fWKDNtYGq94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSlOggtwDSwsYd1B8bmxp2EJvIH1mtVhtXNNoXCHFI+Yg6Wau9yGk+AKV3Zg3De9H
         muU6BwebHBAmZzzTcky3su14oV6xySMEKaUHEGnoxnmJcVnq/24xCK86UWaJzvo1CJ
         4Eo+3Blm5GjtIoBqdCD+TVT/KulrJRxApbcGqEig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/563] crypto: stm32 - Revert broken pm_runtime_resume_and_get changes
Date:   Mon, 24 Jan 2022 19:38:45 +0100
Message-Id: <20220124184029.923441972@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3d6b661330a7954d8136df98160d525eb04dcd6a ]

We should not call pm_runtime_resume_and_get where the reference
count is expected to be incremented unconditionally.  This patch
reverts these calls to the original unconditional get_sync call.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Fixes: 747bf30fd944 ("crypto: stm32/cryp - Fix PM reference leak...")
Fixes: 1cb3ad701970 ("crypto: stm32/hash - Fix PM reference leak...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 3 ++-
 drivers/crypto/stm32/stm32-hash.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cd57c5bae3ce9..81eb136b6c11d 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -529,7 +529,8 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 {
 	int ret;
 	u32 cfg, hw_mode;
-	pm_runtime_resume_and_get(cryp->dev);
+
+	pm_runtime_get_sync(cryp->dev);
 
 	/* Disable interrupt */
 	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index ff5362da118d8..16bb52836b28d 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -812,7 +812,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
@@ -961,7 +961,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
@@ -999,7 +999,7 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
-- 
2.34.1



