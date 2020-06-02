Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772201EB629
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 09:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgFBHFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 03:05:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgFBHF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 03:05:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 44A5D1D4FF79B3E0B03A;
        Tue,  2 Jun 2020 15:05:23 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.115) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 2 Jun 2020 15:05:13 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 3/3] crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()
Date:   Tue, 2 Jun 2020 15:05:01 +0800
Message-ID: <20200602070501.2023-4-longpeng2@huawei.com>
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

The src/dst length is not aligned with AES_BLOCK_SIZE(which is 16) in some
testcases in tcrypto.ko.

For example, the src/dst length of one of cts(cbc(aes))'s testcase is 17, the
crypto_virtio driver will set @src_data_len=16 but @dst_data_len=17 in this
case and get a wrong at then end.

  SRC: pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp (17 bytes)
  EXP: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc pp (17 bytes)
  DST: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 00 (pollute the last bytes)
  (pp: plaintext  cc:ciphertext)

Fix this issue by limit the length of dest buffer.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 52261b6..cb8a6ea 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -407,6 +407,7 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 		goto free;
 	}
 
+	dst_len = min_t(unsigned int, req->cryptlen, dst_len);
 	pr_debug("virtio_crypto: src_len: %u, dst_len: %llu\n",
 			req->cryptlen, dst_len);
 
-- 
1.8.3.1

