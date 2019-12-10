Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4BC1197E9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbfLJVfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730264AbfLJVfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8834E24653;
        Tue, 10 Dec 2019 21:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013729;
        bh=RLShHQeXVG4YlSKwBDqxLbQ7OdzK7yYlJ1FwnCfry8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQtF4IKdDXs+f04n09KmUo0XVA3I1ygWBnKy1EEZcGBsb//kAqd8S/iPis2TREGp8
         YAP0Ir5QWogN30U83dnoxWMKSUB0/3JLBLWeKuGRWEXsowY0/hKlr+P3mNvG1juft5
         2iAsrXBGlRasGKtAkP4GyHYYecTc8YOc2R+NLR2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 154/177] crypto: virtio - deal with unsupported input sizes
Date:   Tue, 10 Dec 2019 16:31:58 -0500
Message-Id: <20191210213221.11921-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 19c5da7d4a2662e85ea67d2d81df57e038fde3ab ]

Return -EINVAL for input sizes that are not a multiple of the AES
block size, since they are not supported by our CBC chaining mode.

While at it, remove the pr_err() that reports unsupported key sizes
being used: we shouldn't spam the kernel log with that.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 2c573d1aaa64f..523b712770ac5 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -117,8 +117,6 @@ virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
 		*alg = VIRTIO_CRYPTO_CIPHER_AES_CBC;
 		break;
 	default:
-		pr_err("virtio_crypto: Unsupported key length: %d\n",
-			key_len);
 		return -EINVAL;
 	}
 	return 0;
@@ -498,6 +496,11 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
+	if (!req->nbytes)
+		return 0;
+	if (req->nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
 	vc_sym_req->ablkcipher_ctx = ctx;
@@ -518,6 +521,11 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
+	if (!req->nbytes)
+		return 0;
+	if (req->nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	vc_req->dataq = data_vq;
 	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
 	vc_sym_req->ablkcipher_ctx = ctx;
-- 
2.20.1

