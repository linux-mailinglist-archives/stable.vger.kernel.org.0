Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3086D328F55
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbhCATtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52977 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241678AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC106517D;
        Mon,  1 Mar 2021 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618593;
        bh=nGnFfrInr+dHRWvcs05EDNB0GEfbf8aJ0AIijUhnAu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XssrpwvALjy7GWjqjOjz9VtPObnyWTWfmKDjiRrkxMEkE5tR2QYn0h8j08yaaKXV
         8+tqs1EtjWpPAfqZG7zrG08Zk9tXzcVsgkuzUImzVLBFS3gx1ykD+hnCTXvuCRH0KA
         AGMDBWQXTelPoVO3FHSUxhwMf3pr1tHdfEhxhPzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/663] crypto: sun4i-ss - linearize buffers content must be kept
Date:   Mon,  1 Mar 2021 17:06:32 +0100
Message-Id: <20210301161148.891094440@linuxfoundation.org>
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

[ Upstream commit 583513510a7acd2306787865bcd19ebb2f629d42 ]

When running the non-optimized cipher function, SS produce partial random
output.
This is due to linearize buffers being reseted after each loop.

For preserving stack, instead of moving them back to start of function,
I move them in sun4i_ss_ctx.

Fixes: 8d3bcb9900ca ("crypto: sun4i-ss - reduce stack usage")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++--------
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h        |  2 ++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index b72de8939497b..19f1aa577ed4d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -233,8 +233,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
-			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
-
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -256,12 +254,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 */
 				todo = min(rx_cnt * 4 - ob, ileft);
 				todo = min_t(size_t, todo, mi.length - oi);
-				memcpy(buf + ob, mi.addr + oi, todo);
+				memcpy(ss->buf + ob, mi.addr + oi, todo);
 				ileft -= todo;
 				oi += todo;
 				ob += todo;
 				if (!(ob % 4)) {
-					writesl(ss->base + SS_RXFIFO, buf,
+					writesl(ss->base + SS_RXFIFO, ss->buf,
 						ob / 4);
 					ob = 0;
 				}
@@ -295,13 +293,11 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				oo = 0;
 			}
 		} else {
-			char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
-
 			/*
 			 * read obl bytes in bufo, we read at maximum for
 			 * emptying the device
 			 */
-			readsl(ss->base + SS_TXFIFO, bufo, tx_cnt);
+			readsl(ss->base + SS_TXFIFO, ss->bufo, tx_cnt);
 			obl = tx_cnt * 4;
 			obo = 0;
 			do {
@@ -313,7 +309,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 */
 				todo = min_t(size_t,
 					     mo.length - oo, obl - obo);
-				memcpy(mo.addr + oo, bufo + obo, todo);
+				memcpy(mo.addr + oo, ss->bufo + obo, todo);
 				oleft -= todo;
 				obo += todo;
 				oo += todo;
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
index 163962f9e2845..02105b39fbfec 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
@@ -148,6 +148,8 @@ struct sun4i_ss_ctx {
 	struct reset_control *reset;
 	struct device *dev;
 	struct resource *res;
+	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
+	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
 	spinlock_t slock; /* control the use of the device */
 #ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
 	u32 seed[SS_SEED_LEN / BITS_PER_LONG];
-- 
2.27.0



