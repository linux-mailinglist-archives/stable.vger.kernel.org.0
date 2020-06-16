Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4031FBB1F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgFPPje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729937AbgFPPjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C348620B1F;
        Tue, 16 Jun 2020 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321972;
        bh=QmE2oagzGzBT6yjswqscQUYQAHfcNAFmEQ61WuPLDRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO1uIuc/ZGhxXv4SX/h8/UeCXw6N3la0I3NH6nJfsGs/GaL4FhCwjfNj/S0lZMkwz
         fZb7B7d/g3Q155ckaALlSq9vRmxQDERaHPi3+MAJRSZMvYIa5vkVscn/zxsd9NMceu
         Gxa4RTpI6Gf9KTn62OL36gUN3vaM9FLCTJTPb218=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LABBE Corentin <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Gonglei <arei.gonglei@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/134] crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
Date:   Tue, 16 Jun 2020 17:34:31 +0200
Message-Id: <20200616153104.949860321@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng(Mike) <longpeng2@huawei.com>

[ Upstream commit b02989f37fc5e865ceeee9070907e4493b3a21e2 ]

The system will crash when the users insmod crypto/tcrypt.ko with mode=38
( testing "cts(cbc(aes))" ).

Usually the next entry of one sg will be @sg@ + 1, but if this sg element
is part of a chained scatterlist, it could jump to the start of a new
scatterlist array. Fix it by sg_next() on calculation of src/dst
scatterlist.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Reported-by: LABBE Corentin <clabbe@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Link: https://lore.kernel.org/r/20200602070501.2023-2-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index fea55b5da8b5..3b37d0150814 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -353,13 +353,18 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	int err;
 	unsigned long flags;
 	struct scatterlist outhdr, iv_sg, status_sg, **sgs;
-	int i;
 	u64 dst_len;
 	unsigned int num_out = 0, num_in = 0;
 	int sg_total;
 	uint8_t *iv;
+	struct scatterlist *sg;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (src_nents < 0) {
+		pr_err("Invalid number of src SG.\n");
+		return src_nents;
+	}
+
 	dst_nents = sg_nents(req->dst);
 
 	pr_debug("virtio_crypto: Number of sgs (src_nents: %d, dst_nents: %d)\n",
@@ -445,12 +450,12 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	vc_sym_req->iv = iv;
 
 	/* Source data */
-	for (i = 0; i < src_nents; i++)
-		sgs[num_out++] = &req->src[i];
+	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
+		sgs[num_out++] = sg;
 
 	/* Destination data */
-	for (i = 0; i < dst_nents; i++)
-		sgs[num_out + num_in++] = &req->dst[i];
+	for (sg = req->dst; sg; sg = sg_next(sg))
+		sgs[num_out + num_in++] = sg;
 
 	/* Status */
 	sg_init_one(&status_sg, &vc_req->status, sizeof(vc_req->status));
-- 
2.25.1



