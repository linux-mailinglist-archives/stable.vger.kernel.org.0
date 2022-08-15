Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23035594113
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbiHOVJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347775AbiHOVHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2B2D7CC5;
        Mon, 15 Aug 2022 12:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6189BCE1087;
        Mon, 15 Aug 2022 19:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F872C433D6;
        Mon, 15 Aug 2022 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590962;
        bh=UDGcVwRi7O++OPdySi9hrL7ej4PyhcDWLK6vrD9AdiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHhiBrLRc2TI11CAY/7SSrB4m8picCbIOAyWrNvrUhUz3YTTfAN2IW78C3qppFeF8
         UWQMbrMSMr+pET/wBTGSFM0PncJIfONeqhl9yYy10hpAe5QZyD6/xJJW3qzfO8UNtH
         GRkFg81TW6XrYaEjGLTLnGchy6oUwcrq7xCd7GtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0426/1095] crypto: hisilicon - Kunpeng916 crypto driver dont sleep when in softirq
Date:   Mon, 15 Aug 2022 19:57:05 +0200
Message-Id: <20220815180447.347753642@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 68740ab505431f268dc1ee26a54b871e75f0ddaa ]

When kunpeng916 encryption driver is used to deencrypt and decrypt
packets during the softirq, it is not allowed to use mutex lock.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 14 +++++++-------
 drivers/crypto/hisilicon/sec/sec_drv.h  |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 0a3c8f019b02..490e1542305e 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -449,7 +449,7 @@ static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
 		 */
 	}
 
-	mutex_lock(&ctx->queue->queuelock);
+	spin_lock_bh(&ctx->queue->queuelock);
 	/* Put the IV in place for chained cases */
 	switch (ctx->cipher_alg) {
 	case SEC_C_AES_CBC_128:
@@ -509,7 +509,7 @@ static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
 			list_del(&backlog_req->backlog_head);
 		}
 	}
-	mutex_unlock(&ctx->queue->queuelock);
+	spin_unlock_bh(&ctx->queue->queuelock);
 
 	mutex_lock(&sec_req->lock);
 	list_del(&sec_req_el->head);
@@ -798,7 +798,7 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	 */
 
 	/* Grab a big lock for a long time to avoid concurrency issues */
-	mutex_lock(&queue->queuelock);
+	spin_lock_bh(&queue->queuelock);
 
 	/*
 	 * Can go on to queue if we have space in either:
@@ -814,15 +814,15 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 		ret = -EBUSY;
 		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
-			mutex_unlock(&queue->queuelock);
+			spin_unlock_bh(&queue->queuelock);
 			goto out;
 		}
 
-		mutex_unlock(&queue->queuelock);
+		spin_unlock_bh(&queue->queuelock);
 		goto err_free_elements;
 	}
 	ret = sec_send_request(sec_req, queue);
-	mutex_unlock(&queue->queuelock);
+	spin_unlock_bh(&queue->queuelock);
 	if (ret)
 		goto err_free_elements;
 
@@ -881,7 +881,7 @@ static int sec_alg_skcipher_init(struct crypto_skcipher *tfm)
 	if (IS_ERR(ctx->queue))
 		return PTR_ERR(ctx->queue);
 
-	mutex_init(&ctx->queue->queuelock);
+	spin_lock_init(&ctx->queue->queuelock);
 	ctx->queue->havesoftqueue = false;
 
 	return 0;
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.h b/drivers/crypto/hisilicon/sec/sec_drv.h
index 179a8250d691..e2a50bf2234b 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.h
+++ b/drivers/crypto/hisilicon/sec/sec_drv.h
@@ -347,7 +347,7 @@ struct sec_queue {
 	DECLARE_BITMAP(unprocessed, SEC_QUEUE_LEN);
 	DECLARE_KFIFO_PTR(softqueue, typeof(struct sec_request_el *));
 	bool havesoftqueue;
-	struct mutex queuelock;
+	spinlock_t queuelock;
 	void *shadow[SEC_QUEUE_LEN];
 };
 
-- 
2.35.1



