Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F8A15C1A9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgBMPZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728919AbgBMPZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:08 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C526C246A3;
        Thu, 13 Feb 2020 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607506;
        bh=rnUAQxha5PjK5HbsT8UT0RJBat2b5wPYL/hdyIgr9r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCfDcfWmwNhg6BB8Vh1sZt5T4lTslmaW25Eis7JtKfTavtnLzAujr6+crJ2+L+lSE
         DaFfTJrX4Z310AOyHN91ZmUZdHQbYdPzCD0PYU9GfEH4RxPmeDXQMN/+/JZCvFyt9N
         oIq1ZmJ8tUfhtz0XzKAKYhYrCCBKoCTVMemOI2SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 065/173] crypto: atmel-aes - Fix counter overflow in CTR mode
Date:   Thu, 13 Feb 2020 07:19:28 -0800
Message-Id: <20200213151950.113618457@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 781a08d9740afa73357f1a60d45d7c93d7cca2dd upstream.

32 bit counter is not supported by neither of our AES IPs, all implement
a 16 bit block counter. Drop the 32 bit block counter logic.

Fixes: fcac83656a3e ("crypto: atmel-aes - fix the counter overflow in CTR mode")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/atmel-aes.c |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -91,7 +91,6 @@
 struct atmel_aes_caps {
 	bool			has_dualbuff;
 	bool			has_cfb64;
-	bool			has_ctr32;
 	bool			has_gcm;
 	bool			has_xts;
 	bool			has_authenc;
@@ -990,8 +989,9 @@ static int atmel_aes_ctr_transfer(struct
 	struct atmel_aes_ctr_ctx *ctx = atmel_aes_ctr_ctx_cast(dd->ctx);
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
 	struct scatterlist *src, *dst;
-	u32 ctr, blocks;
 	size_t datalen;
+	u32 ctr;
+	u16 blocks, start, end;
 	bool use_dma, fragmented = false;
 
 	/* Check for transfer completion. */
@@ -1003,27 +1003,17 @@ static int atmel_aes_ctr_transfer(struct
 	datalen = req->nbytes - ctx->offset;
 	blocks = DIV_ROUND_UP(datalen, AES_BLOCK_SIZE);
 	ctr = be32_to_cpu(ctx->iv[3]);
-	if (dd->caps.has_ctr32) {
-		/* Check 32bit counter overflow. */
-		u32 start = ctr;
-		u32 end = start + blocks - 1;
-
-		if (end < start) {
-			ctr |= 0xffffffff;
-			datalen = AES_BLOCK_SIZE * -start;
-			fragmented = true;
-		}
-	} else {
-		/* Check 16bit counter overflow. */
-		u16 start = ctr & 0xffff;
-		u16 end = start + (u16)blocks - 1;
-
-		if (blocks >> 16 || end < start) {
-			ctr |= 0xffff;
-			datalen = AES_BLOCK_SIZE * (0x10000-start);
-			fragmented = true;
-		}
+
+	/* Check 16bit counter overflow. */
+	start = ctr & 0xffff;
+	end = start + blocks - 1;
+
+	if (blocks >> 16 || end < start) {
+		ctr |= 0xffff;
+		datalen = AES_BLOCK_SIZE * (0x10000 - start);
+		fragmented = true;
 	}
+
 	use_dma = (datalen >= ATMEL_AES_DMA_THRESHOLD);
 
 	/* Jump to offset. */
@@ -2536,7 +2526,6 @@ static void atmel_aes_get_cap(struct atm
 {
 	dd->caps.has_dualbuff = 0;
 	dd->caps.has_cfb64 = 0;
-	dd->caps.has_ctr32 = 0;
 	dd->caps.has_gcm = 0;
 	dd->caps.has_xts = 0;
 	dd->caps.has_authenc = 0;
@@ -2547,7 +2536,6 @@ static void atmel_aes_get_cap(struct atm
 	case 0x500:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
-		dd->caps.has_ctr32 = 1;
 		dd->caps.has_gcm = 1;
 		dd->caps.has_xts = 1;
 		dd->caps.has_authenc = 1;
@@ -2556,7 +2544,6 @@ static void atmel_aes_get_cap(struct atm
 	case 0x200:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
-		dd->caps.has_ctr32 = 1;
 		dd->caps.has_gcm = 1;
 		dd->caps.max_burst_size = 4;
 		break;


