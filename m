Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950DC2E425B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436687AbgL1OBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436683AbgL1OBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2BC2064B;
        Mon, 28 Dec 2020 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164093;
        bh=sWprI9hDxxxWkJ+bto1AeTgVjAkssyCT7jwQaldy4nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj8UaNZveD8qsGvoFfdHX6GrUHwwYotF26fgXJTodKQAlDkT5v91Vx0M2SfBQ9Qag
         UuGk6ib+nIs4CS98NBbdXJIt7dp8PZ81lHcYyOlFGyP0P+Nr2ve8oMmfYlnNRRBn4k
         FY8A5E5j+1AHoT+Pt2p0to8bIKPZfPAWeJMCHn3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/717] crypto: caam - fix printing on xts fallback allocation error path
Date:   Mon, 28 Dec 2020 13:40:56 +0100
Message-Id: <20201228125023.775784485@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit ab95bd2aa904e4f53b7358efeea1d57693fb7889 ]

At the time xts fallback tfm allocation fails the device struct
hasn't been enabled yet in the caam xts tfm's private context.

Fix this by using the device struct from xts algorithm's private context
or, when not available, by replacing dev_err with pr_err.

Fixes: 9d9b14dbe077 ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
Fixes: 83e8aa912138 ("crypto: caam/qi - add fallback for XTS with more than 8B IV")
Fixes: 36e2d7cfdcf1 ("crypto: caam/qi2 - add fallback for XTS with more than 8B IV")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c     | 4 ++--
 drivers/crypto/caam/caamalg_qi.c  | 4 ++--
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cf5bd7666dfcd..8697ae53b0633 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3404,8 +3404,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
-				tfm_name, PTR_ERR(fallback));
+			pr_err("Failed to allocate %s fallback: %ld\n",
+			       tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 66f60d78bdc84..a24ae966df4a3 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2502,8 +2502,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
-				tfm_name, PTR_ERR(fallback));
+			pr_err("Failed to allocate %s fallback: %ld\n",
+			       tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 98c1ff1744bb1..a780e627838ae 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1611,7 +1611,8 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
 		fallback = crypto_alloc_skcipher(tfm_name, 0,
 						 CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(fallback)) {
-			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
+			dev_err(caam_alg->caam.dev,
+				"Failed to allocate %s fallback: %ld\n",
 				tfm_name, PTR_ERR(fallback));
 			return PTR_ERR(fallback);
 		}
-- 
2.27.0



