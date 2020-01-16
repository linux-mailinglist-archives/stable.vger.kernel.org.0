Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D1013F49F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbgAPRIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389393AbgAPRIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 703802192A;
        Thu, 16 Jan 2020 17:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194502;
        bh=ktKayj4vR4a5/DigIu8znMV+M/E0kYyG1sE7OYTItto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGdjIggqI02Ejhe6q+fGX2YIspoNw7A3iFLNkw2eBBFXtQ9p6iyXafW8POH+YHnEB
         mV4zUDBNhiQTHf95Uw1exl0lukzbr78Y8Blyf9hbC0+fOEg1fkcEueBirwq+df50rW
         9VuPBaApoTq4MAGvYrIbyIbRcy0q2df6VCZ/IrwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 398/671] crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
Date:   Thu, 16 Jan 2020 12:00:36 -0500
Message-Id: <20200116170509.12787-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit b926213d6fede9c9427d7c12eaf7d9f0895deb4e ]

A request is zeroed in safexcel_ahash_exit_inv(). This request total
size is EIP197_AHASH_REQ_SIZE while the memset zeroing it uses
sizeof(struct ahash_request), which happens to be less than
EIP197_AHASH_REQ_SIZE. This patch fixes it.

Fixes: f6beaea30487 ("crypto: inside-secure - authenc(hmac(sha256), cbc(aes)) support")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ac9282c1a5ec..9a02f64a45b9 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -486,7 +486,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(req, 0, sizeof(struct ahash_request));
+	memset(req, 0, EIP197_AHASH_REQ_SIZE);
 
 	/* create invalidation request */
 	init_completion(&result.completion);
-- 
2.20.1

