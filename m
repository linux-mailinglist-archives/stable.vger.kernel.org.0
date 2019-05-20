Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE9B23478
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389449AbfETM1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389052AbfETM1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 305CB20645;
        Mon, 20 May 2019 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355228;
        bh=mGZuO5mLXz5ShEQoB2BcixLr4I+NlYsB+ziiX3D8IPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKql2jXbgx2fr9m7lB5OZOIFesWcvD7qRXFtoZEcK7mtzJ8ncuNQzlEtSYBs9dT3R
         HoqYBs9nLnk9ORW/Z5S70BQjpG0p1mkuvm90m3TbFXKk7R92vAtIK/XxFSn8FGFSS/
         +2EU98iawPx8nw/64pQ2tcJwFwuaCZMoPbU4LYss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 039/123] crypto: caam/qi2 - fix zero-length buffer DMA mapping
Date:   Mon, 20 May 2019 14:13:39 +0200
Message-Id: <20190520115247.318383594@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 07586d3ddf284dd7a1a6579579d8efa7296fe60f upstream.

Commit 04e6d25c5bb2 ("crypto: caam - fix zero-length buffer DMA mapping")
fixed an issue in caam/jr driver where ahash implementation was
DMA mapping a zero-length buffer.

Current commit applies a similar fix for caam/qi2 driver.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_qi2.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3756,10 +3756,13 @@ static int ahash_final_no_ctx(struct aha
 	if (!edesc)
 		return ret;
 
-	state->buf_dma = dma_map_single(ctx->dev, buf, buflen, DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->dev, state->buf_dma)) {
-		dev_err(ctx->dev, "unable to map src\n");
-		goto unmap;
+	if (buflen) {
+		state->buf_dma = dma_map_single(ctx->dev, buf, buflen,
+						DMA_TO_DEVICE);
+		if (dma_mapping_error(ctx->dev, state->buf_dma)) {
+			dev_err(ctx->dev, "unable to map src\n");
+			goto unmap;
+		}
 	}
 
 	edesc->dst_dma = dma_map_single(ctx->dev, req->result, digestsize,
@@ -3772,9 +3775,17 @@ static int ahash_final_no_ctx(struct aha
 
 	memset(&req_ctx->fd_flt, 0, sizeof(req_ctx->fd_flt));
 	dpaa2_fl_set_final(in_fle, true);
-	dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(in_fle, state->buf_dma);
-	dpaa2_fl_set_len(in_fle, buflen);
+	/*
+	 * crypto engine requires the input entry to be present when
+	 * "frame list" FD is used.
+	 * Since engine does not support FMT=2'b11 (unused entry type), leaving
+	 * in_fle zeroized (except for "Final" flag) is the best option.
+	 */
+	if (buflen) {
+		dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
+		dpaa2_fl_set_addr(in_fle, state->buf_dma);
+		dpaa2_fl_set_len(in_fle, buflen);
+	}
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
 	dpaa2_fl_set_addr(out_fle, edesc->dst_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);


