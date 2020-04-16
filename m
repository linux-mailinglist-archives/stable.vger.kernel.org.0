Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029781AC916
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632799AbgDPPSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898742AbgDPNs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54BF321744;
        Thu, 16 Apr 2020 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044906;
        bh=fMLIyDP/lYEuiTPFzI3pkD5ODNrHkB8NU4tNj+hxTOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuSSBMwqY23MxjoBoDX1bX0LxiGk4f1oiWHKS82/GH/r1I9kJgY2/z1a6lWaYQPWX
         mPzROdt8YaBzmcH5V8dvlNyPi4/MeDg7VCPyTJDtrMzSPuAji/U0f4IusuL0oXb+mT
         Gqy6K0KIyRfdwakaUCEQkcdnwV7bK2Y+5sd6/cdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rosioru Dragos <dragos.rosioru@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 150/232] crypto: mxs-dcp - fix scatterlist linearization for hash
Date:   Thu, 16 Apr 2020 15:24:04 +0200
Message-Id: <20200416131333.754132608@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rosioru Dragos <dragos.rosioru@nxp.com>

commit fa03481b6e2e82355c46644147b614f18c7a8161 upstream.

The incorrect traversal of the scatterlist, during the linearization phase
lead to computing the hash value of the wrong input buffer.
New implementation uses scatterwalk_map_and_copy()
to address this issue.

Cc: <stable@vger.kernel.org>
Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
Signed-off-by: Rosioru Dragos <dragos.rosioru@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/mxs-dcp.c |   54 ++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -20,6 +20,7 @@
 #include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
@@ -621,49 +622,46 @@ static int dcp_sha_req_to_buf(struct cry
 	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
 	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
-	const int nents = sg_nents(req->src);
 
 	uint8_t *in_buf = sdcp->coh->sha_in_buf;
 	uint8_t *out_buf = sdcp->coh->sha_out_buf;
 
-	uint8_t *src_buf;
-
 	struct scatterlist *src;
 
-	unsigned int i, len, clen;
+	unsigned int i, len, clen, oft = 0;
 	int ret;
 
 	int fin = rctx->fini;
 	if (fin)
 		rctx->fini = 0;
 
-	for_each_sg(req->src, src, nents, i) {
-		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
+	src = req->src;
+	len = req->nbytes;
 
-		do {
-			if (actx->fill + len > DCP_BUF_SZ)
-				clen = DCP_BUF_SZ - actx->fill;
-			else
-				clen = len;
+	while (len) {
+		if (actx->fill + len > DCP_BUF_SZ)
+			clen = DCP_BUF_SZ - actx->fill;
+		else
+			clen = len;
 
-			memcpy(in_buf + actx->fill, src_buf, clen);
-			len -= clen;
-			src_buf += clen;
-			actx->fill += clen;
+		scatterwalk_map_and_copy(in_buf + actx->fill, src, oft, clen,
+					 0);
 
-			/*
-			 * If we filled the buffer and still have some
-			 * more data, submit the buffer.
-			 */
-			if (len && actx->fill == DCP_BUF_SZ) {
-				ret = mxs_dcp_run_sha(req);
-				if (ret)
-					return ret;
-				actx->fill = 0;
-				rctx->init = 0;
-			}
-		} while (len);
+		len -= clen;
+		oft += clen;
+		actx->fill += clen;
+
+		/*
+		 * If we filled the buffer and still have some
+		 * more data, submit the buffer.
+		 */
+		if (len && actx->fill == DCP_BUF_SZ) {
+			ret = mxs_dcp_run_sha(req);
+			if (ret)
+				return ret;
+			actx->fill = 0;
+			rctx->init = 0;
+		}
 	}
 
 	if (fin) {


