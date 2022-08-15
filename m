Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6366C5940A4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiHOVA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiHOU7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E33C2E8C;
        Mon, 15 Aug 2022 12:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B0276069E;
        Mon, 15 Aug 2022 19:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C6BC433C1;
        Mon, 15 Aug 2022 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590764;
        bh=h5vc3yvXunEp0SALg3u9XixYh+znlF9+B4f8XKf+EY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeMMLWqNTGFpCuAF+WHxo5+qzpkYZlF7GP+UUtaQrqyhu/3GOkNKlCDdj6Nh69s5V
         Ozfqmgptq6QkIMbWfIKPfl58G9PGRLCdNpiDvpECWjAWK39cAuWtf3OoljRld1luNz
         Y8AZQ4o9NzXNzxWOeM6iZ7/TKSCTwFQSTd2ZhgXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0333/1095] crypto: sun8i-ss - do not allocate memory when handling hash requests
Date:   Mon, 15 Aug 2022 19:55:32 +0200
Message-Id: <20220815180443.573724777@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 8eec4563f152981a441693fc97c5459843dc5e6e ]

Instead of allocate memory on each requests, it is easier to
pre-allocate buffers.
This made error path easier.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 10 ++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 15 +++------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      |  4 ++++
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 657530578643..786b6f5cf300 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -486,6 +486,16 @@ static int allocate_flows(struct sun8i_ss_dev *ss)
 				goto error_engine;
 		}
 
+		/* the padding could be up to two block. */
+		ss->flows[i].pad = devm_kmalloc(ss->dev, SHA256_BLOCK_SIZE * 2,
+						GFP_KERNEL | GFP_DMA);
+		if (!ss->flows[i].pad)
+			goto error_engine;
+		ss->flows[i].result = devm_kmalloc(ss->dev, SHA256_DIGEST_SIZE,
+						   GFP_KERNEL | GFP_DMA);
+		if (!ss->flows[i].result)
+			goto error_engine;
+
 		ss->flows[i].engine = crypto_engine_alloc_init(ss->dev, true);
 		if (!ss->flows[i].engine) {
 			dev_err(ss->dev, "Cannot allocate engine\n");
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index ca4f280af35d..f89a580618aa 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -342,18 +342,11 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (digestsize == SHA224_DIGEST_SIZE)
 		digestsize = SHA256_DIGEST_SIZE;
 
-	/* the padding could be up to two block. */
-	pad = kzalloc(algt->alg.hash.halg.base.cra_blocksize * 2, GFP_KERNEL | GFP_DMA);
-	if (!pad)
-		return -ENOMEM;
+	result = ss->flows[rctx->flow].result;
+	pad = ss->flows[rctx->flow].pad;
+	memset(pad, 0, algt->alg.hash.halg.base.cra_blocksize * 2);
 	bf = (__le32 *)pad;
 
-	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result) {
-		kfree(pad);
-		return -ENOMEM;
-	}
-
 	for (i = 0; i < MAX_SG; i++) {
 		rctx->t_dst[i].addr = 0;
 		rctx->t_dst[i].len = 0;
@@ -449,8 +442,6 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
 theend:
-	kfree(pad);
-	kfree(result);
 	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
 	local_bh_enable();
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 57ada8653855..eb82ee5345ae 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -123,6 +123,8 @@ struct sginfo {
  * @stat_req:	number of request done by this flow
  * @iv:		list of IV to use for each step
  * @biv:	buffer which contain the backuped IV
+ * @pad:	padding buffer for hash operations
+ * @result:	buffer for storing the result of hash operations
  */
 struct sun8i_ss_flow {
 	struct crypto_engine *engine;
@@ -130,6 +132,8 @@ struct sun8i_ss_flow {
 	int status;
 	u8 *iv[MAX_SG];
 	u8 *biv;
+	void *pad;
+	void *result;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
 	unsigned long stat_req;
 #endif
-- 
2.35.1



