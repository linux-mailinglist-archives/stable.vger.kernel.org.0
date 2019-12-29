Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1020412C733
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfL2RzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732801AbfL2RzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9170A206A4;
        Sun, 29 Dec 2019 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642101;
        bh=mm9Jzp1MQhRaACJ7gkpP5EbpTipjhlRnBEMgtQa5KKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsL+gLXcTbyxxCVZtk+R8HkB40cj+8csQG9njCOdBBYInFi5szJUYBLHE8XLfQMSJ
         uee87UKoNwOfI00FrDch+sU+rBL22Oifq58Ax3c58tkD2bAibTflcjq3MIRqGKli+L
         xe3dyMluueuNyTsSPV1Y4HL3FG+UWz4BlqNFkovM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 343/434] crypto: sun4i-ss - Fix 64-bit size_t warnings
Date:   Sun, 29 Dec 2019 18:26:36 +0100
Message-Id: <20191229172724.754000564@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit d6e9da21ee8246b5e556b3b153401ab045adb986 ]

If you try to compile this driver on a 64-bit platform then you
will get warnings because it mixes size_t with unsigned int which
only works on 32-bit.

This patch fixes all of the warnings.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 6536fd4bee65..7e5e092a23b3 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -72,7 +72,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	oi = 0;
 	oo = 0;
 	do {
-		todo = min3(rx_cnt, ileft, (mi.length - oi) / 4);
+		todo = min(rx_cnt, ileft);
+		todo = min_t(size_t, todo, (mi.length - oi) / 4);
 		if (todo) {
 			ileft -= todo;
 			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
@@ -87,7 +88,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
-		todo = min3(tx_cnt, oleft, (mo.length - oo) / 4);
+		todo = min(tx_cnt, oleft);
+		todo = min_t(size_t, todo, (mo.length - oo) / 4);
 		if (todo) {
 			oleft -= todo;
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
@@ -239,7 +241,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
 			 */
-			todo = min3(rx_cnt, ileft / 4, (mi.length - oi) / 4);
+			todo = min(rx_cnt, ileft / 4);
+			todo = min_t(size_t, todo, (mi.length - oi) / 4);
 			if (todo && !ob) {
 				writesl(ss->base + SS_RXFIFO, mi.addr + oi,
 					todo);
@@ -253,8 +256,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 * we need to be able to write all buf in one
 				 * pass, so it is why we min() with rx_cnt
 				 */
-				todo = min3(rx_cnt * 4 - ob, ileft,
-					    mi.length - oi);
+				todo = min(rx_cnt * 4 - ob, ileft);
+				todo = min_t(size_t, todo, mi.length - oi);
 				memcpy(buf + ob, mi.addr + oi, todo);
 				ileft -= todo;
 				oi += todo;
@@ -274,7 +277,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
-		dev_dbg(ss->dev, "%x %u/%u %u/%u cnt=%u %u/%u %u/%u cnt=%u %u\n",
+		dev_dbg(ss->dev,
+			"%x %u/%zu %u/%u cnt=%u %u/%zu %u/%u cnt=%u %u\n",
 			mode,
 			oi, mi.length, ileft, areq->cryptlen, rx_cnt,
 			oo, mo.length, oleft, areq->cryptlen, tx_cnt, ob);
@@ -282,7 +286,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		if (!tx_cnt)
 			continue;
 		/* todo in 4bytes word */
-		todo = min3(tx_cnt, oleft / 4, (mo.length - oo) / 4);
+		todo = min(tx_cnt, oleft / 4);
+		todo = min_t(size_t, todo, (mo.length - oo) / 4);
 		if (todo) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
@@ -308,7 +313,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 * no more than remaining buffer
 				 * no need to test against oleft
 				 */
-				todo = min(mo.length - oo, obl - obo);
+				todo = min_t(size_t,
+					     mo.length - oo, obl - obo);
 				memcpy(mo.addr + oo, bufo + obo, todo);
 				oleft -= todo;
 				obo += todo;
-- 
2.20.1



