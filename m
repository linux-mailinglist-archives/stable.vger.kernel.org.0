Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49A415767B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgBJMw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbgBJMmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3457720733;
        Mon, 10 Feb 2020 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338536;
        bh=eORnYaaVgk1tB4klU3Jhd6OSbnxmgAiQcJcl2bSQH78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIcJTY5TmJDekrRLA2CvYS7gX1qTRrn+rEl/fnmnHcBBDAcjT/Hi7CKcJ3iD5Oh2Q
         URornUJpooMKvNMsu1mo4bRwUkIGaSxDlJ6KMvuf2d1KVjk5LKXJLBo7nrHSCrklV0
         wcF2hljy5pdidcd5iF3mzz/FOIeYA2ZIVN1Y4wsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 364/367] crypto: atmel-aes - Fix CTR counter overflow when multiple fragments
Date:   Mon, 10 Feb 2020 04:34:37 -0800
Message-Id: <20200210122455.932626656@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 3907ccfaec5d9965e306729936fc732c94d2c1e7 ]

The CTR transfer works in fragments of data of maximum 1 MByte because
of the 16 bit CTR counter embedded in the IP. Fix the CTR counter
overflow handling for messages larger than 1 MByte.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 781a08d9740a ("crypto: atmel-aes - Fix counter overflow in CTR mode")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index ea9dcd7ce799b..b4dee726b2530 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -121,7 +121,7 @@ struct atmel_aes_ctr_ctx {
 	size_t			offset;
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
-	u16			blocks;
+	u32			blocks;
 };
 
 struct atmel_aes_gcm_ctx {
@@ -528,6 +528,12 @@ static void atmel_aes_ctr_update_req_iv(struct atmel_aes_dev *dd)
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	int i;
 
+	/*
+	 * The CTR transfer works in fragments of data of maximum 1 MByte
+	 * because of the 16 bit CTR counter embedded in the IP. When reaching
+	 * here, ctx->blocks contains the number of blocks of the last fragment
+	 * processed, there is no need to explicit cast it to u16.
+	 */
 	for (i = 0; i < ctx->blocks; i++)
 		crypto_inc((u8 *)ctx->iv, AES_BLOCK_SIZE);
 
-- 
2.20.1



