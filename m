Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD9E241070
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgHJTK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgHJTK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C7F2224D;
        Mon, 10 Aug 2020 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086625;
        bh=2K2iG1CjBSTPdSLSG5ajTMC50p1FwenSlUrZitpjRWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TPOITXTNJaUhXrVs2LaaU/NlwHdsIB/XYpMETbz47cme8+Z+xCRIg4vsiPhfDVRI
         67lCfD2jP+onaRAbL94v58qOyWBLTFvoIgjstZHYL7cK6B9OAQWgXmF5+ebhbmib1e
         Yip2pMQ3KjyOxsMDnakm/NCwtTrEWULbUlO5O2Uo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 63/64] crypto: caam - silence .setkey in case of bad key length
Date:   Mon, 10 Aug 2020 15:08:58 -0400
Message-Id: <20200810190859.3793319-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit da6a66853a381864f4b040832cf11f0dbba0a097 ]

In case of bad key length, driver emits "key size mismatch" messages,
but only for xts(aes) algorithms.

Reduce verbosity by making them visible only when debugging.
This way crypto fuzz testing log cleans up a bit.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c     | 2 +-
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2f9882bc010f..bf90a4fcabd1f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -838,7 +838,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 27e36bdf6163b..315d53499ce85 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -728,7 +728,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 28669cbecf77c..e1b6bc6ef091b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1058,7 +1058,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(dev, "key size mismatch\n");
+		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
-- 
2.25.1

