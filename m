Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1769F1EB620
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 09:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgFBHFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 03:05:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59954 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgFBHFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 03:05:20 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8051E987EABACD40B531;
        Tue,  2 Jun 2020 15:05:18 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.115) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 2 Jun 2020 15:05:11 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        LABBE Corentin <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH v3 1/3] crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
Date:   Tue, 2 Jun 2020 15:04:59 +0800
Message-ID: <20200602070501.2023-2-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20200602070501.2023-1-longpeng2@huawei.com>
References: <20200602070501.2023-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Message-Id: <20200123101000.GB24255@Red>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index fd045e64..5f82435 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -350,13 +350,18 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 	int err;
 	unsigned long flags;
 	struct scatterlist outhdr, iv_sg, status_sg, **sgs;
-	int i;
 	u64 dst_len;
 	unsigned int num_out = 0, num_in = 0;
 	int sg_total;
 	uint8_t *iv;
+	struct scatterlist *sg;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
+	if (src_nents < 0) {
+		pr_err("Invalid number of src SG.\n");
+		return src_nents;
+	}
+
 	dst_nents = sg_nents(req->dst);
 
 	pr_debug("virtio_crypto: Number of sgs (src_nents: %d, dst_nents: %d)\n",
@@ -442,12 +447,12 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
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
1.8.3.1

