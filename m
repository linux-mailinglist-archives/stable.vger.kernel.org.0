Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB09E12C860
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbfL2RyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732585AbfL2Rx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5881A20718;
        Sun, 29 Dec 2019 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642038;
        bh=doqTYewzucexqNabndyd7CtBHmYOg0GVCojdAimXsII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjRzeFiiu0qksp8Yr4uCiKbXTZ01kAbeLLLmVH3UKdWrK+A8n5a0uL2Eck5qGV1jW
         rwy8LTxOPaOYff5MA4nH0qFMtr9UD/RRT8QRGuwilhu+skEqjtZRVkfVT/j1d7g0Oe
         s3TmzjiXtThtdtBPYyrUB9C0OUXQcMaWl3uAb638=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 315/434] crypto: virtio - deal with unsupported input sizes
Date:   Sun, 29 Dec 2019 18:26:08 +0100
Message-Id: <20191229172722.878348386@linuxfoundation.org>
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
index 42d19205166b..673fb29fda53 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -105,8 +105,6 @@ virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
 		*alg = VIRTIO_CRYPTO_CIPHER_AES_CBC;
 		break;
 	default:
-		pr_err("virtio_crypto: Unsupported key length: %d\n",
-			key_len);
 		return -EINVAL;
 	}
 	return 0;
@@ -484,6 +482,11 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
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
@@ -504,6 +507,11 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
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



