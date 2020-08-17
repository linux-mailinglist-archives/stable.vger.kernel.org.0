Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F94247518
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392285AbgHQTTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730568AbgHQPhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BC8208E4;
        Mon, 17 Aug 2020 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678665;
        bh=05ebuUc09f862f7GfK6svroTc1ljzoi3btmGR8atQdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYGtRHnjYDDF3EcoggoKFs0pj/qA0VdQWlvYCvRtwA0H0LA43YhdqYvJvDOoH2P6y
         zIKceOF1PNxD5OYJ9cseWCCUVQRiQkc5JH6QKREzoEQPjmSv1nitd0fh8YzBEoYC/n
         wLbI83h3QDuCDuTvc/34w0oz+BWlotEdU2ctxnAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Allen <john.allen@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.8 412/464] crypto: ccp - Fix use of merged scatterlists
Date:   Mon, 17 Aug 2020 17:16:05 +0200
Message-Id: <20200817143853.516540055@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Allen <john.allen@amd.com>

commit 8a302808c60d441d9884cb00ea7f2b534f2e3ca5 upstream.

Running the crypto manager self tests with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS may result in several types of errors
when using the ccp-crypto driver:

alg: skcipher: cbc-des3-ccp encryption failed on test vector 0; expected_error=0, actual_error=-5 ...

alg: skcipher: ctr-aes-ccp decryption overran dst buffer on test vector 0 ...

alg: ahash: sha224-ccp test failed (wrong result) on test vector ...

These errors are the result of improper processing of scatterlists mapped
for DMA.

Given a scatterlist in which entries are merged as part of mapping the
scatterlist for DMA, the DMA length of a merged entry will reflect the
combined length of the entries that were merged. The subsequent
scatterlist entry will contain DMA information for the scatterlist entry
after the last merged entry, but the non-DMA information will be that of
the first merged entry.

The ccp driver does not take this scatterlist merging into account. To
address this, add a second scatterlist pointer to track the current
position in the DMA mapped representation of the scatterlist. Both the DMA
representation and the original representation of the scatterlist must be
tracked as while most of the driver can use just the DMA representation,
scatterlist_map_and_copy() must use the original representation and
expects the scatterlist pointer to be accurate to the original
representation.

In order to properly walk the original scatterlist, the scatterlist must
be walked until the combined lengths of the entries seen is equal to the
DMA length of the current entry being processed in the DMA mapped
representation.

Fixes: 63b945091a070 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: John Allen <john.allen@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-dev.h |    1 +
 drivers/crypto/ccp/ccp-ops.c |   37 ++++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -469,6 +469,7 @@ struct ccp_sg_workarea {
 	unsigned int sg_used;
 
 	struct scatterlist *dma_sg;
+	struct scatterlist *dma_sg_head;
 	struct device *dma_dev;
 	unsigned int dma_count;
 	enum dma_data_direction dma_dir;
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -63,7 +63,7 @@ static u32 ccp_gen_jobid(struct ccp_devi
 static void ccp_sg_free(struct ccp_sg_workarea *wa)
 {
 	if (wa->dma_count)
-		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
+		dma_unmap_sg(wa->dma_dev, wa->dma_sg_head, wa->nents, wa->dma_dir);
 
 	wa->dma_count = 0;
 }
@@ -92,6 +92,7 @@ static int ccp_init_sg_workarea(struct c
 		return 0;
 
 	wa->dma_sg = sg;
+	wa->dma_sg_head = sg;
 	wa->dma_dev = dev;
 	wa->dma_dir = dma_dir;
 	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
@@ -104,14 +105,28 @@ static int ccp_init_sg_workarea(struct c
 static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
 {
 	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
+	unsigned int sg_combined_len = 0;
 
 	if (!wa->sg)
 		return;
 
 	wa->sg_used += nbytes;
 	wa->bytes_left -= nbytes;
-	if (wa->sg_used == wa->sg->length) {
-		wa->sg = sg_next(wa->sg);
+	if (wa->sg_used == sg_dma_len(wa->dma_sg)) {
+		/* Advance to the next DMA scatterlist entry */
+		wa->dma_sg = sg_next(wa->dma_sg);
+
+		/* In the case that the DMA mapped scatterlist has entries
+		 * that have been merged, the non-DMA mapped scatterlist
+		 * must be advanced multiple times for each merged entry.
+		 * This ensures that the current non-DMA mapped entry
+		 * corresponds to the current DMA mapped entry.
+		 */
+		do {
+			sg_combined_len += wa->sg->length;
+			wa->sg = sg_next(wa->sg);
+		} while (wa->sg_used > sg_combined_len);
+
 		wa->sg_used = 0;
 	}
 }
@@ -299,7 +314,7 @@ static unsigned int ccp_queue_buf(struct
 	/* Update the structures and generate the count */
 	buf_count = 0;
 	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
-		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
+		nbytes = min(sg_dma_len(sg_wa->dma_sg) - sg_wa->sg_used,
 			     dm_wa->length - buf_count);
 		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
 
@@ -331,11 +346,11 @@ static void ccp_prepare_data(struct ccp_
 	 * and destination. The resulting len values will always be <= UINT_MAX
 	 * because the dma length is an unsigned int.
 	 */
-	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
+	sg_src_len = sg_dma_len(src->sg_wa.dma_sg) - src->sg_wa.sg_used;
 	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
 
 	if (dst) {
-		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
+		sg_dst_len = sg_dma_len(dst->sg_wa.dma_sg) - dst->sg_wa.sg_used;
 		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
 		op_len = min(sg_src_len, sg_dst_len);
 	} else {
@@ -365,7 +380,7 @@ static void ccp_prepare_data(struct ccp_
 		/* Enough data in the sg element, but we need to
 		 * adjust for any previously copied data
 		 */
-		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
+		op->src.u.dma.address = sg_dma_address(src->sg_wa.dma_sg);
 		op->src.u.dma.offset = src->sg_wa.sg_used;
 		op->src.u.dma.length = op_len & ~(block_size - 1);
 
@@ -386,7 +401,7 @@ static void ccp_prepare_data(struct ccp_
 			/* Enough room in the sg element, but we need to
 			 * adjust for any previously used area
 			 */
-			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
+			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.dma_sg);
 			op->dst.u.dma.offset = dst->sg_wa.sg_used;
 			op->dst.u.dma.length = op->src.u.dma.length;
 		}
@@ -2028,7 +2043,7 @@ ccp_run_passthru_cmd(struct ccp_cmd_queu
 	dst.sg_wa.sg_used = 0;
 	for (i = 1; i <= src.sg_wa.dma_count; i++) {
 		if (!dst.sg_wa.sg ||
-		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
+		    (sg_dma_len(dst.sg_wa.sg) < sg_dma_len(src.sg_wa.sg))) {
 			ret = -EINVAL;
 			goto e_dst;
 		}
@@ -2054,8 +2069,8 @@ ccp_run_passthru_cmd(struct ccp_cmd_queu
 			goto e_dst;
 		}
 
-		dst.sg_wa.sg_used += src.sg_wa.sg->length;
-		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
+		dst.sg_wa.sg_used += sg_dma_len(src.sg_wa.sg);
+		if (dst.sg_wa.sg_used == sg_dma_len(dst.sg_wa.sg)) {
 			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
 			dst.sg_wa.sg_used = 0;
 		}


