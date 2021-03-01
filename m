Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23B328D44
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbhCATIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhCATES (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C93EA65184;
        Mon,  1 Mar 2021 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618596;
        bh=dUqNOjZytUkYA3sv5OGfmjwWjjwueeh/r84UL6Le+XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzSGypKYhJsE39FJw/QQQKUS80pKO3fd6gcFR6etIL2j6d/WLQoz2b2svR/lJvMEC
         FGSDcpkHQSD6i1Gxa8thwXIQRwiyu6CRkOp4tI8X+W5rqu8+cXf8sfFbYFE+dcvaTy
         y4qwM0mTLMXe+Y8YrfsFPtg+dTyuxb1I/baraQd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/663] crypto: sun4i-ss - fix kmap usage
Date:   Mon,  1 Mar 2021 17:06:33 +0100
Message-Id: <20210301161148.943542630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 9bc3dd24e7dccd50757db743a3635ad5b0497e6e ]

With the recent kmap change, some tests which were conditional on
CONFIG_DEBUG_HIGHMEM now are enabled by default.
This permit to detect a problem in sun4i-ss usage of kmap.

sun4i-ss uses two kmap via sg_miter (one for input, one for output), but
using two kmap at the same time is hard:
"the ordering has to be correct and with sg_miter that's probably hard to get
right." (quoting Tlgx)

So the easiest solution is to never have two sg_miter/kmap open at the same time.
After each use of sg_miter, I store the current index, for being able to
resume sg_miter to the right place.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 109 +++++++++++-------
 1 file changed, 65 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4d..1f8a38d131928 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -30,6 +30,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	unsigned long pi = 0, po = 0; /* progress for in and out */
+	bool miter_err;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo; /* offset for in and out */
 	unsigned long flags;
@@ -55,39 +57,51 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 
 	ileft = areq->cryptlen / 4;
 	oleft = areq->cryptlen / 4;
 	oi = 0;
 	oo = 0;
 	do {
-		todo = min(rx_cnt, ileft);
-		todo = min_t(size_t, todo, (mi.length - oi) / 4);
-		if (todo) {
-			ileft -= todo;
-			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
-			oi += todo * 4;
-		}
-		if (oi == mi.length) {
-			sg_miter_next(&mi);
-			oi = 0;
+		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+					SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (pi)
+				sg_miter_skip(&mi, pi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
+			todo = min(rx_cnt, ileft);
+			todo = min_t(size_t, todo, (mi.length - oi) / 4);
+			if (todo) {
+				ileft -= todo;
+				writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
+				oi += todo * 4;
+			}
+			if (oi == mi.length) {
+				pi += mi.length;
+				oi = 0;
+			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (po)
+			sg_miter_skip(&mo, po);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		todo = min(tx_cnt, oleft);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
 		if (todo) {
@@ -96,9 +110,10 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 			oo += todo * 4;
 		}
 		if (oo == mo.length) {
-			sg_miter_next(&mo);
 			oo = 0;
+			po += mo.length;
 		}
+		sg_miter_stop(&mo);
 	} while (oleft);
 
 	if (areq->iv) {
@@ -109,8 +124,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
-	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 	return err;
@@ -162,6 +175,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
+	unsigned long pi = 0, po = 0; /* progress for in and out */
+	bool miter_err;
 	unsigned int oi, oo;	/* offset for in and out */
 	unsigned int ob = 0;	/* offset in buf */
 	unsigned int obo = 0;	/* offset in bufo*/
@@ -215,17 +230,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 	ileft = areq->cryptlen;
 	oleft = areq->cryptlen;
 	oi = 0;
@@ -233,6 +237,16 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+				       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (pi)
+				sg_miter_skip(&mi, pi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -265,31 +279,38 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				}
 			}
 			if (oi == mi.length) {
-				sg_miter_next(&mi);
+				pi += mi.length;
 				oi = 0;
 			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
-		dev_dbg(ss->dev,
-			"%x %u/%zu %u/%u cnt=%u %u/%zu %u/%u cnt=%u %u\n",
-			mode,
-			oi, mi.length, ileft, areq->cryptlen, rx_cnt,
-			oo, mo.length, oleft, areq->cryptlen, tx_cnt, ob);
 
 		if (!tx_cnt)
 			continue;
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (po)
+			sg_miter_skip(&mo, po);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		/* todo in 4bytes word */
 		todo = min(tx_cnt, oleft / 4);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
+
 		if (todo) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
 			oo += todo * 4;
 			if (oo == mo.length) {
-				sg_miter_next(&mo);
+				po += mo.length;
 				oo = 0;
 			}
 		} else {
@@ -314,12 +335,14 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				obo += todo;
 				oo += todo;
 				if (oo == mo.length) {
+					po += mo.length;
 					sg_miter_next(&mo);
 					oo = 0;
 				}
 			} while (obo < obl);
 			/* bufo must be fully used here */
 		}
+		sg_miter_stop(&mo);
 	}
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
@@ -329,8 +352,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
-	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 
-- 
2.27.0



