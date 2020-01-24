Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185DC147FEA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbgAXLGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389054AbgAXLGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:14 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7642075D;
        Fri, 24 Jan 2020 11:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863973;
        bh=0cen+96gV8nuYXBzOi/9uNPKp81ha0jv8IpQFNMl9Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/ckKkO7BBn0ehoxJSuifABr5eqn6JVbqC75WjiwcWowk+eO8oP2OlPdGzfFEogxT
         KDJIy5hGWtB+x5xaQBlCADQEldPCCcOFa7FRK3VhmT1+P0wbYHR477FgHOdpJVGTqm
         SfmUPQl2BB44Gm/G1qUw9rBUNvfbqtgWHqy+70Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/639] crypto: brcm - Fix some set-but-not-used warning
Date:   Fri, 24 Jan 2020 10:25:06 +0100
Message-Id: <20200124093104.307464086@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 707d0cf8f7cff6dfee9197002859912310532c4f ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/bcm/cipher.c: In function 'handle_ahash_req':
drivers/crypto/bcm/cipher.c:720:15: warning:
 variable 'chunk_start' set but not used [-Wunused-but-set-variable]

drivers/crypto/bcm/cipher.c: In function 'spu_rx_callback':
drivers/crypto/bcm/cipher.c:1679:31: warning:
 variable 'areq' set but not used [-Wunused-but-set-variable]

drivers/crypto/bcm/cipher.c:1678:22: warning:
 variable 'ctx' set but not used [-Wunused-but-set-variable]

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 49c0097fa4749..0b1fc5664b1d8 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -717,7 +717,7 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
 	 */
 	unsigned int new_data_len;
 
-	unsigned int chunk_start = 0;
+	unsigned int __maybe_unused chunk_start = 0;
 	u32 db_size;	 /* Length of data field, incl gcm and hash padding */
 	int pad_len = 0; /* total pad len, including gcm, hash, stat padding */
 	u32 data_pad_len = 0;	/* length of GCM/CCM padding */
@@ -1675,8 +1675,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
 	struct spu_hw *spu = &iproc_priv.spu;
 	struct brcm_message *mssg = msg;
 	struct iproc_reqctx_s *rctx;
-	struct iproc_ctx_s *ctx;
-	struct crypto_async_request *areq;
 	int err = 0;
 
 	rctx = mssg->ctx;
@@ -1686,8 +1684,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
 		err = -EFAULT;
 		goto cb_finish;
 	}
-	areq = rctx->parent;
-	ctx = rctx->ctx;
 
 	/* process the SPU status */
 	err = spu->spu_status_process(rctx->msg_buf.rx_stat);
-- 
2.20.1



