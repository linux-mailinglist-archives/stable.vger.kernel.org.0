Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901A41FB9FE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbgFPPrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731538AbgFPPrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9846214DB;
        Tue, 16 Jun 2020 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322420;
        bh=Cy0Pcw1eJIo5XdE8jhQZwIHhrSWVtsnsbrsGEpRIzio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiEPnp7yHmPZeu5VSUCD9zXGpssBw6zGIxklCS4HCcd7+4Ht6bJ1+LNKG8gb5IF5x
         scRfcI/d2gnKrjb0ZVtsvTH2ysSFaxWFLHWZBEtthL2CQhjfC2lo6sNimXTQJoLB6C
         ng7blha3TkALEW9mc3LKk83dLtWtVGims1JGf7Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LABBE Corentin <clabbe@baylibre.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH 5.7 094/163] crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
Date:   Tue, 16 Jun 2020 17:34:28 +0200
Message-Id: <20200616153111.334565319@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng(Mike) <longpeng2@huawei.com>

commit 8c855f0720ff006d75d0a2512c7f6c4f60ff60ee upstream.

The system'll crash when the users insmod crypto/tcrypto.ko with mode=155
( testing "authenc(hmac(sha1),cbc(aes))" ). It's caused by reuse the memory
of request structure.

In crypto_authenc_init_tfm(), the reqsize is set to:
  [PART 1] sizeof(authenc_request_ctx) +
  [PART 2] ictx->reqoff +
  [PART 3] MAX(ahash part, skcipher part)
and the 'PART 3' is used by both ahash and skcipher in turn.

When the virtio_crypto driver finish skcipher req, it'll call ->complete
callback(in crypto_finalize_skcipher_request) and then free its
resources whose pointers are recorded in 'skcipher parts'.

However, the ->complete is 'crypto_authenc_encrypt_done' in this case,
it will use the 'ahash part' of the request and change its content,
so virtio_crypto driver will get the wrong pointer after ->complete
finish and mistakenly free some other's memory. So the system will crash
when these memory will be used again.

The resources which need to be cleaned up are not used any more. But the
pointers of these resources may be changed in the function
"crypto_finalize_skcipher_request". Thus release specific resources before
calling this function.

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Reported-by: LABBE Corentin <clabbe@baylibre.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
Acked-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Link: https://lore.kernel.org/r/20200602070501.2023-3-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/virtio/virtio_crypto_algs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -578,10 +578,11 @@ static void virtio_crypto_skcipher_final
 		scatterwalk_map_and_copy(req->iv, req->dst,
 					 req->cryptlen - AES_BLOCK_SIZE,
 					 AES_BLOCK_SIZE, 0);
-	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
-					   req, err);
 	kzfree(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
+
+	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
+					   req, err);
 }
 
 static struct virtio_crypto_algo virtio_crypto_algs[] = { {


