Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B46523307
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbfETLul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:50:41 -0400
Received: from foss.arm.com ([217.140.101.70]:43990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731777AbfETLuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 07:50:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E45715AD;
        Mon, 20 May 2019 04:50:40 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7584D3F5AF;
        Mon, 20 May 2019 04:50:38 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     gregkh@linuxfoundation.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [STABLE PATCH 2/2] crypto: ccree: fix backlog notifications
Date:   Mon, 20 May 2019 14:50:24 +0300
Message-Id: <20190520115025.16457-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115025.16457-1-gilad@benyossef.com>
References: <20190520115025.16457-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were doing backlog notification callbacks via a cipher/hash/aead
request structure cast to the base structure, which may or may not
work based on how the structure is laid in memory and is not safe.

Fix it by delegating the backlog notification to the appropriate
internal callbacks which are type aware.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c        |  4 ++++
 drivers/crypto/ccree/cc_cipher.c      |  4 ++++
 drivers/crypto/ccree/cc_hash.c        | 28 +++++++++++++++++++--------
 drivers/crypto/ccree/cc_request_mgr.c | 11 ++++++++---
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index a3527c00b29a..8c08a50a4008 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -220,6 +220,10 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
+	/* BACKLOG notification */
+	if (err == -EINPROGRESS)
+		goto done;
+
 	cc_unmap_aead_request(dev, areq);
 
 	/* Restore ordinary iv pointer */
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d9c17078517b..202526648e4a 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -654,6 +654,9 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
 	unsigned int len;
 
+	if (err == -EINPROGRESS)
+		goto done;
+
 	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
 
 	switch (ctx_p->cipher_mode) {
@@ -687,6 +690,7 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 
 	kzfree(req_ctx->iv);
 
+done:
 	skcipher_request_complete(req, err);
 }
 
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 2c4ddc8fb76b..e824ab60b59c 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -280,8 +280,12 @@ static void cc_update_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
@@ -295,9 +299,13 @@ static void cc_digest_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
@@ -311,9 +319,13 @@ static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 83a8aaae61c7..ddaa41de7ae7 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -336,10 +336,12 @@ static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
 			       struct cc_bl_item *bli)
 {
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
 
 	spin_lock_bh(&mgr->bl_lock);
 	list_add_tail(&bli->list, &mgr->backlog);
 	++mgr->bl_len;
+	dev_dbg(dev, "+++bl len: %d\n", mgr->bl_len);
 	spin_unlock_bh(&mgr->bl_lock);
 	tasklet_schedule(&mgr->comptask);
 }
@@ -349,7 +351,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
 	struct cc_bl_item *bli;
 	struct cc_crypto_req *creq;
-	struct crypto_async_request *req;
+	void *req;
 	bool ivgen;
 	unsigned int total_len;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -359,17 +361,20 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 
 	while (mgr->bl_len) {
 		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
+		dev_dbg(dev, "---bl len: %d\n", mgr->bl_len);
+
 		spin_unlock(&mgr->bl_lock);
 
+
 		creq = &bli->creq;
-		req = (struct crypto_async_request *)creq->user_arg;
+		req = creq->user_arg;
 
 		/*
 		 * Notify the request we're moving out of the backlog
 		 * but only if we haven't done so already.
 		 */
 		if (!bli->notif) {
-			req->complete(req, -EINPROGRESS);
+			creq->user_cb(dev, req, -EINPROGRESS);
 			bli->notif = true;
 		}
 
-- 
2.21.0

