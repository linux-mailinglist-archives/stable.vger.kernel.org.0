Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96682201629
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394877AbgFSQ13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390010AbgFSOzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37893206F7;
        Fri, 19 Jun 2020 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578551;
        bh=5O60frDLooh+Wxctq/Vho1DS6s2cYV6GIPhqgLOjqWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrfLjJ+qQ8JA3OJHJTYPTQviGYkr13G8fYeVZqVerypoSJOCixt6ecZGnvSFgsDVW
         yoDnmtyDZEpdbdvPOv87HqsSKvJnqC2F6mMW53bBY5l+BmaxxSPHhc1v1nC4fD8G7Z
         j1fN+y6tkFpXJGX8xWSIWv9PI9b/bIqkxYzKJ7c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/267] crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()
Date:   Fri, 19 Jun 2020 16:30:51 +0200
Message-Id: <20200619141652.052136865@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng(Mike) <longpeng2@huawei.com>

[ Upstream commit d90ca42012db2863a9a30b564a2ace6016594bda ]

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
Link: https://lore.kernel.org/r/20200602070501.2023-4-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index e9a8485c4929..ab4700e4b409 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -424,6 +424,7 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 		goto free;
 	}
 
+	dst_len = min_t(unsigned int, req->nbytes, dst_len);
 	pr_debug("virtio_crypto: src_len: %u, dst_len: %llu\n",
 			req->nbytes, dst_len);
 
-- 
2.25.1



