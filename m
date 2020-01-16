Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604513F29B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391518AbgAPRYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391228AbgAPRYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA56D24684;
        Thu, 16 Jan 2020 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195448;
        bh=8JNZbyGhx3IWm4yjWkvDnV+8UHOchZf0Zt+UWJSIZgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgXiShcBKhUMqtjaFnA8y5+5E/U7ynppYAz4yIvdbcxKf4ywuHdJ6KOfBlBToqu2d
         vMGki43iN1KApn2qL/JkDyUuNSio/Xhb+loOB0F+AUu1xqHMOIeRnftoWrM3JMnh5N
         KwsZSQOU5yejyu939Cg/Pp6U7rcACNnTm7/HHsl0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 060/371] crypto: brcm - Fix some set-but-not-used warning
Date:   Thu, 16 Jan 2020 12:18:52 -0500
Message-Id: <20200116172403.18149-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 84422435f39b..279e907590e9 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -718,7 +718,7 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
 	 */
 	unsigned int new_data_len;
 
-	unsigned int chunk_start = 0;
+	unsigned int __maybe_unused chunk_start = 0;
 	u32 db_size;	 /* Length of data field, incl gcm and hash padding */
 	int pad_len = 0; /* total pad len, including gcm, hash, stat padding */
 	u32 data_pad_len = 0;	/* length of GCM/CCM padding */
@@ -1676,8 +1676,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
 	struct spu_hw *spu = &iproc_priv.spu;
 	struct brcm_message *mssg = msg;
 	struct iproc_reqctx_s *rctx;
-	struct iproc_ctx_s *ctx;
-	struct crypto_async_request *areq;
 	int err = 0;
 
 	rctx = mssg->ctx;
@@ -1687,8 +1685,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
 		err = -EFAULT;
 		goto cb_finish;
 	}
-	areq = rctx->parent;
-	ctx = rctx->ctx;
 
 	/* process the SPU status */
 	err = spu->spu_status_process(rctx->msg_buf.rx_stat);
-- 
2.20.1

