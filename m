Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5AE3906B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbfFGPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731626AbfFGPtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EAC120840;
        Fri,  7 Jun 2019 15:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922592;
        bh=je00nHXy2hhHJLoChkbtjJCQOLib/hdvZbih/h8p3Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnk/M67UsZdFwJPGjYml4Di37Ogg/+PwkTDDPvDLpZFygIzuWLeAFa+IR4UC7qk4p
         WRGfyO0BJRZExGvRk3n92fGu+zGer4ErbhZy8h3GRS/d6N/6OVsy0/gQJqQReUGIUu
         SqjM1F0zabi75OqtVXNzuPdEoUSEQsxrHFDUrW7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Patrick Steuer <steuer@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 5.1 32/85] s390/crypto: fix gcm-aes-s390 selftest failures
Date:   Fri,  7 Jun 2019 17:39:17 +0200
Message-Id: <20190607153853.224903648@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit bef9f0ba300a55d79a69aa172156072182176515 upstream.

The current kernel uses improved crypto selftests. These
tests showed that the current implementation of gcm-aes-s390
is not able to deal with chunks of output buffers which are
not a multiple of 16 bytes. This patch introduces a rework
of the gcm aes s390 scatter walk handling which now is able
to handle any input and output scatter list chunk sizes
correctly.

Code has been verified by the crypto selftests, the tcrypt
kernel module and additional tests ran via the af_alg interface.

Cc: <stable@vger.kernel.org>
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Patrick Steuer <steuer@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/aes_s390.c |  148 +++++++++++++++++++++++++++++++-------------
 1 file changed, 107 insertions(+), 41 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -826,19 +826,45 @@ static int gcm_aes_setauthsize(struct cr
 	return 0;
 }
 
-static void gcm_sg_walk_start(struct gcm_sg_walk *gw, struct scatterlist *sg,
-			      unsigned int len)
+static void gcm_walk_start(struct gcm_sg_walk *gw, struct scatterlist *sg,
+			   unsigned int len)
 {
 	memset(gw, 0, sizeof(*gw));
 	gw->walk_bytes_remain = len;
 	scatterwalk_start(&gw->walk, sg);
 }
 
-static int gcm_sg_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
+static inline unsigned int _gcm_sg_clamp_and_map(struct gcm_sg_walk *gw)
+{
+	struct scatterlist *nextsg;
+
+	gw->walk_bytes = scatterwalk_clamp(&gw->walk, gw->walk_bytes_remain);
+	while (!gw->walk_bytes) {
+		nextsg = sg_next(gw->walk.sg);
+		if (!nextsg)
+			return 0;
+		scatterwalk_start(&gw->walk, nextsg);
+		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
+						   gw->walk_bytes_remain);
+	}
+	gw->walk_ptr = scatterwalk_map(&gw->walk);
+	return gw->walk_bytes;
+}
+
+static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
+					     unsigned int nbytes)
+{
+	gw->walk_bytes_remain -= nbytes;
+	scatterwalk_unmap(&gw->walk);
+	scatterwalk_advance(&gw->walk, nbytes);
+	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
+	gw->walk_ptr = NULL;
+}
+
+static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 {
 	int n;
 
-	/* minbytesneeded <= AES_BLOCK_SIZE */
 	if (gw->buf_bytes && gw->buf_bytes >= minbytesneeded) {
 		gw->ptr = gw->buf;
 		gw->nbytes = gw->buf_bytes;
@@ -851,13 +877,11 @@ static int gcm_sg_walk_go(struct gcm_sg_
 		goto out;
 	}
 
-	gw->walk_bytes = scatterwalk_clamp(&gw->walk, gw->walk_bytes_remain);
-	if (!gw->walk_bytes) {
-		scatterwalk_start(&gw->walk, sg_next(gw->walk.sg));
-		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
-						   gw->walk_bytes_remain);
+	if (!_gcm_sg_clamp_and_map(gw)) {
+		gw->ptr = NULL;
+		gw->nbytes = 0;
+		goto out;
 	}
-	gw->walk_ptr = scatterwalk_map(&gw->walk);
 
 	if (!gw->buf_bytes && gw->walk_bytes >= minbytesneeded) {
 		gw->ptr = gw->walk_ptr;
@@ -869,51 +893,90 @@ static int gcm_sg_walk_go(struct gcm_sg_
 		n = min(gw->walk_bytes, AES_BLOCK_SIZE - gw->buf_bytes);
 		memcpy(gw->buf + gw->buf_bytes, gw->walk_ptr, n);
 		gw->buf_bytes += n;
-		gw->walk_bytes_remain -= n;
-		scatterwalk_unmap(&gw->walk);
-		scatterwalk_advance(&gw->walk, n);
-		scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
-
+		_gcm_sg_unmap_and_advance(gw, n);
 		if (gw->buf_bytes >= minbytesneeded) {
 			gw->ptr = gw->buf;
 			gw->nbytes = gw->buf_bytes;
 			goto out;
 		}
-
-		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
-						   gw->walk_bytes_remain);
-		if (!gw->walk_bytes) {
-			scatterwalk_start(&gw->walk, sg_next(gw->walk.sg));
-			gw->walk_bytes = scatterwalk_clamp(&gw->walk,
-							gw->walk_bytes_remain);
+		if (!_gcm_sg_clamp_and_map(gw)) {
+			gw->ptr = NULL;
+			gw->nbytes = 0;
+			goto out;
 		}
-		gw->walk_ptr = scatterwalk_map(&gw->walk);
 	}
 
 out:
 	return gw->nbytes;
 }
 
-static void gcm_sg_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
+static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 {
-	int n;
+	if (gw->walk_bytes_remain == 0) {
+		gw->ptr = NULL;
+		gw->nbytes = 0;
+		goto out;
+	}
+
+	if (!_gcm_sg_clamp_and_map(gw)) {
+		gw->ptr = NULL;
+		gw->nbytes = 0;
+		goto out;
+	}
 
+	if (gw->walk_bytes >= minbytesneeded) {
+		gw->ptr = gw->walk_ptr;
+		gw->nbytes = gw->walk_bytes;
+		goto out;
+	}
+
+	scatterwalk_unmap(&gw->walk);
+	gw->walk_ptr = NULL;
+
+	gw->ptr = gw->buf;
+	gw->nbytes = sizeof(gw->buf);
+
+out:
+	return gw->nbytes;
+}
+
+static int gcm_in_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
+{
 	if (gw->ptr == NULL)
-		return;
+		return 0;
 
 	if (gw->ptr == gw->buf) {
-		n = gw->buf_bytes - bytesdone;
+		int n = gw->buf_bytes - bytesdone;
 		if (n > 0) {
 			memmove(gw->buf, gw->buf + bytesdone, n);
-			gw->buf_bytes -= n;
+			gw->buf_bytes = n;
 		} else
 			gw->buf_bytes = 0;
-	} else {
-		gw->walk_bytes_remain -= bytesdone;
-		scatterwalk_unmap(&gw->walk);
-		scatterwalk_advance(&gw->walk, bytesdone);
-		scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
-	}
+	} else
+		_gcm_sg_unmap_and_advance(gw, bytesdone);
+
+	return bytesdone;
+}
+
+static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
+{
+	int i, n;
+
+	if (gw->ptr == NULL)
+		return 0;
+
+	if (gw->ptr == gw->buf) {
+		for (i = 0; i < bytesdone; i += n) {
+			if (!_gcm_sg_clamp_and_map(gw))
+				return i;
+			n = min(gw->walk_bytes, bytesdone - i);
+			memcpy(gw->walk_ptr, gw->buf + i, n);
+			_gcm_sg_unmap_and_advance(gw, n);
+		}
+	} else
+		_gcm_sg_unmap_and_advance(gw, bytesdone);
+
+	return bytesdone;
 }
 
 static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
@@ -926,7 +989,7 @@ static int gcm_aes_crypt(struct aead_req
 	unsigned int pclen = req->cryptlen;
 	int ret = 0;
 
-	unsigned int len, in_bytes, out_bytes,
+	unsigned int n, len, in_bytes, out_bytes,
 		     min_bytes, bytes, aad_bytes, pc_bytes;
 	struct gcm_sg_walk gw_in, gw_out;
 	u8 tag[GHASH_DIGEST_SIZE];
@@ -963,14 +1026,14 @@ static int gcm_aes_crypt(struct aead_req
 	*(u32 *)(param.j0 + ivsize) = 1;
 	memcpy(param.k, ctx->key, ctx->key_len);
 
-	gcm_sg_walk_start(&gw_in, req->src, len);
-	gcm_sg_walk_start(&gw_out, req->dst, len);
+	gcm_walk_start(&gw_in, req->src, len);
+	gcm_walk_start(&gw_out, req->dst, len);
 
 	do {
 		min_bytes = min_t(unsigned int,
 				  aadlen > 0 ? aadlen : pclen, AES_BLOCK_SIZE);
-		in_bytes = gcm_sg_walk_go(&gw_in, min_bytes);
-		out_bytes = gcm_sg_walk_go(&gw_out, min_bytes);
+		in_bytes = gcm_in_walk_go(&gw_in, min_bytes);
+		out_bytes = gcm_out_walk_go(&gw_out, min_bytes);
 		bytes = min(in_bytes, out_bytes);
 
 		if (aadlen + pclen <= bytes) {
@@ -997,8 +1060,11 @@ static int gcm_aes_crypt(struct aead_req
 			  gw_in.ptr + aad_bytes, pc_bytes,
 			  gw_in.ptr, aad_bytes);
 
-		gcm_sg_walk_done(&gw_in, aad_bytes + pc_bytes);
-		gcm_sg_walk_done(&gw_out, aad_bytes + pc_bytes);
+		n = aad_bytes + pc_bytes;
+		if (gcm_in_walk_done(&gw_in, n) != n)
+			return -ENOMEM;
+		if (gcm_out_walk_done(&gw_out, n) != n)
+			return -ENOMEM;
 		aadlen -= aad_bytes;
 		pclen -= pc_bytes;
 	} while (aadlen + pclen > 0);


