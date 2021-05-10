Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC537878C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhEJLP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236575AbhEJLIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D90C3619B5;
        Mon, 10 May 2021 11:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644544;
        bh=6nfKnmaO/Jr+W8MVnfjgZR/sXWTOTqfJ8mZR4HK+ick=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mS8MG+EnP3lUdwySzr1S5QCVGN0+jpicXLlHTNQh1udPPg2fBYfmGqNowgTDxrucV
         QsoTPbeyarEBKnf4U7+b8Y+INiUjwkFLdzGoc7QTr+jdC9l493tmCaJ98MytoThktB
         xr2cPu5aMNEH1AFTJlcyqrcQ5XTwXpvEXesdOqbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 126/384] crypto: sun8i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
Date:   Mon, 10 May 2021 12:18:35 +0200
Message-Id: <20210510102019.052323944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 06cd7423cf451d68bfab289278d7890c9ae01a14 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index ed2a69f82e1c..7c355bc2fb06 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -351,7 +351,7 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 	op->enginectx.op.prepare_request = NULL;
 	op->enginectx.op.unprepare_request = NULL;
 
-	err = pm_runtime_get_sync(op->ss->dev);
+	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0) {
 		dev_err(op->ss->dev, "pm error %d\n", err);
 		goto error_pm;
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index e0ddc684798d..80e89066dbd1 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -753,7 +753,7 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 	if (err)
 		goto error_alg;
 
-	err = pm_runtime_get_sync(ss->dev);
+	err = pm_runtime_resume_and_get(ss->dev);
 	if (err < 0)
 		goto error_alg;
 
-- 
2.30.2



