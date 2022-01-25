Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD8499FE2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842294AbiAXXBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579276AbiAXWre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:47:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B05C058C8D;
        Mon, 24 Jan 2022 13:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96FAE6138B;
        Mon, 24 Jan 2022 21:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87CDC340E5;
        Mon, 24 Jan 2022 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058399;
        bh=A7FifYEoNq3WcY60AzUYb/DEVXnbG0VC8sCAVJ03L+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8fTVul/2M26OjLr5pUG2NVCQP1bZkV/I5sFw/a/rRLVAUJqDfZm3TOoi3PMPOMwP
         JknVRRNxREFa1WX09dKOcbEFXFasMVsexiIpg3UcZxtgpaZhg0i1rzYxA44Dw5iP91
         ZVQgRGI6PyiV0dkg7tGsCMLznaj9jOrk8oV25euE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0277/1039] crypto: stm32 - Revert broken pm_runtime_resume_and_get changes
Date:   Mon, 24 Jan 2022 19:34:26 +0100
Message-Id: <20220124184134.595013115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 389de9e3302d5..d33006d43f761 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -813,7 +813,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
@@ -962,7 +962,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
@@ -1000,7 +1000,7 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
-	pm_runtime_resume_and_get(hdev->dev);
+	pm_runtime_get_sync(hdev->dev);
 
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
-- 
2.34.1



