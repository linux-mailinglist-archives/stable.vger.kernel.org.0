Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711D160BDE3
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiJXWxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiJXWwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:52:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556D57C779;
        Mon, 24 Oct 2022 14:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 662E560E7F;
        Mon, 24 Oct 2022 12:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B02C433D6;
        Mon, 24 Oct 2022 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615758;
        bh=oi1CZUVpo8tc5lnU4a5h7UpgZgb2bjuEFwx20nMrjHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X264bYKZl13qxeEOyVb/43PnGY42lLOlkHX3sQaOa7KwlqoxSLDUql6zIOBMQmfv
         ZlqhzQsf9ugZGQibmszxLLZds4whyc7D0r1yRePfrX2Vgk239LQy5vGj1wA6u5KBZD
         WEp5EgsHbxK+MkanbLS+7RvIb4gPn9+m1zywHKyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/530] crypto: sahara - dont sleep when in softirq
Date:   Mon, 24 Oct 2022 13:31:57 +0200
Message-Id: <20221024113101.919603892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 108586eba094b318e6a831f977f4ddcc403a15da ]

Function of sahara_aes_crypt maybe could be called by function
of crypto_skcipher_encrypt during the rx softirq, so it is not
allowed to use mutex lock.

Fixes: c0c3c89ae347 ("crypto: sahara - replace tasklets with...")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 457084b344c1..b07ae4ba165e 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -26,10 +26,10 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #define SHA_BUFFER_LEN		PAGE_SIZE
 #define SAHARA_MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
@@ -196,7 +196,7 @@ struct sahara_dev {
 	void __iomem		*regs_base;
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
-	struct mutex		queue_mutex;
+	spinlock_t		queue_spinlock;
 	struct task_struct	*kthread;
 	struct completion	dma_completion;
 
@@ -642,9 +642,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	mutex_lock(&dev->queue_mutex);
+	spin_lock_bh(&dev->queue_spinlock);
 	err = crypto_enqueue_request(&dev->queue, &req->base);
-	mutex_unlock(&dev->queue_mutex);
+	spin_unlock_bh(&dev->queue_spinlock);
 
 	wake_up_process(dev->kthread);
 
@@ -1043,10 +1043,10 @@ static int sahara_queue_manage(void *data)
 	do {
 		__set_current_state(TASK_INTERRUPTIBLE);
 
-		mutex_lock(&dev->queue_mutex);
+		spin_lock_bh(&dev->queue_spinlock);
 		backlog = crypto_get_backlog(&dev->queue);
 		async_req = crypto_dequeue_request(&dev->queue);
-		mutex_unlock(&dev->queue_mutex);
+		spin_unlock_bh(&dev->queue_spinlock);
 
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
@@ -1092,9 +1092,9 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 		rctx->first = 1;
 	}
 
-	mutex_lock(&dev->queue_mutex);
+	spin_lock_bh(&dev->queue_spinlock);
 	ret = crypto_enqueue_request(&dev->queue, &req->base);
-	mutex_unlock(&dev->queue_mutex);
+	spin_unlock_bh(&dev->queue_spinlock);
 
 	wake_up_process(dev->kthread);
 
@@ -1449,7 +1449,7 @@ static int sahara_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
 
-	mutex_init(&dev->queue_mutex);
+	spin_lock_init(&dev->queue_spinlock);
 
 	dev_ptr = dev;
 
-- 
2.35.1



