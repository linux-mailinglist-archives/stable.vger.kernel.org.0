Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C502121A0C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfEQOwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 10:52:18 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:51625 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbfEQOwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 10:52:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C4E1837E;
        Fri, 17 May 2019 10:52:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 10:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=o3D4jM
        ooEj2l3jKrgA92tm7Wlh6F00a9o+A7WlvYGio=; b=6Kmlt0DssCEALksJZdXn4G
        Ma67hCzvH28Jk4vEh4FmyuGLF3ucij+tnN3o3030bt9gNo7/BDask/SBrf3vXrDd
        QM3oasdCRZEZq1IbDGc9+B4VM8hl4u1aDm3hM1RsXgrRTL7b0Ty5vr1fF8ROtGrG
        Up966T7Dh6xvRd2ASyb+KMmN4ITaTaruXOAbx1bI2Z4YPI4LECdoLZnxn2FakW4n
        km6FuMBeOxcHgqt7tsAa/lTiOl61PKKshCme4r163AQuc705ARxdK1uBjkw+WHz+
        p+eDT4zUt8foYig5Da3f4JmryjD//Aj1uowQ1Ow5qMvhmd4V02+veLOGo81Lf+2g
        ==
X-ME-Sender: <xms:oMreXE7KVxobiRNap9zGmVmsjHEUqANAyQ2a-L0upGIV0aunL5BoPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:oMreXGo7073eqRA7sp_O_ccVrDXK06ossdg-Y4Jyw1GrGae127YFnQ>
    <xmx:oMreXDGZep6DSSXDC1rn4sFeLds-_U51b-Dq5p_33hgEXDbLxXJS2g>
    <xmx:oMreXCXHbVYRRFNmT5GSBCp9yaXlOIqUYz0VKh42aLo507puAVUK8g>
    <xmx:oMreXJoDaAGcW9mNa960u_W4JM7-Bx68MuENPbmlmzqe7Y-E6aodrw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C04CF103CC;
        Fri, 17 May 2019 10:52:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - fix backlog notifications" failed to apply to 5.1-stable tree
To:     gilad@benyossef.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 16:52:10 +0200
Message-ID: <155810473016363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a108f9311c01271bccad45d321cf9ddfac852c4b Mon Sep 17 00:00:00 2001
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Thu, 18 Apr 2019 16:38:46 +0300
Subject: [PATCH] crypto: ccree - fix backlog notifications

We were doing backlog notification callbacks via a cipher/hash/aead
request structure cast to the base structure, which may or may not
work based on how the structure is laid in memory and is not safe.

Fix it by delegating the backlog notification to the appropriate
internal callbacks which are type aware.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index c5cde327cf1f..1fa3c7fef851 100644
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
index 15da3a35a6a1..1ba7c8a7bd52 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -818,9 +818,13 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 	struct crypto_skcipher *sk_tfm = crypto_skcipher_reqtfm(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
 
-	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
-	memcpy(req->iv, req_ctx->iv, ivsize);
-	kzfree(req_ctx->iv);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
+		memcpy(req->iv, req_ctx->iv, ivsize);
+		kzfree(req_ctx->iv);
+	}
+
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
index 88c97a580dd8..c2e8190bb067 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -364,10 +364,12 @@ static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
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
@@ -377,7 +379,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
 	struct cc_bl_item *bli;
 	struct cc_crypto_req *creq;
-	struct crypto_async_request *req;
+	void *req;
 	bool ivgen;
 	unsigned int total_len;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -387,17 +389,20 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 
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
 

