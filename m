Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE1237C19C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhELPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhELPAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B167613DF;
        Wed, 12 May 2021 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831427;
        bh=VVZX0h+3JHXPOh0pkxo0jrQ9QeoOMjMCX0vLZQ0e0f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfnUc4em7S+teGBkO4ASX+aHv8qEbzCX5litRr43lCvkgJC08k6kH9h7IpYUcacQs
         UaCEBGYsxfkFHYUUjW2Y5aBOOr53kd8BKgKJkSYNd367rWpU0bLSNU2NZ1wtdd2igQ
         dsvocg26jwf8WhwUjDjZJa4CgnL4nAfCqqosS+bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/244] crypto: qat - Fix a double free in adf_create_ring
Date:   Wed, 12 May 2021 16:48:05 +0200
Message-Id: <20210512144746.670928949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit f7cae626cabb3350b23722b78fe34dd7a615ca04 ]

In adf_create_ring, if the callee adf_init_ring() failed, the callee will
free the ring->base_addr by dma_free_coherent() and return -EFAULT. Then
adf_create_ring will goto err and the ring->base_addr will be freed again
in adf_cleanup_ring().

My patch sets ring->base_addr to NULL after the first freed to avoid the
double free.

Fixes: a672a9dc872ec ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 2136cbe4bf6c..f65ebc4117d1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -197,6 +197,7 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 		dev_err(&GET_DEV(accel_dev), "Ring address not aligned\n");
 		dma_free_coherent(&GET_DEV(accel_dev), ring_size_bytes,
 				  ring->base_addr, ring->dma_addr);
+		ring->base_addr = NULL;
 		return -EFAULT;
 	}
 
-- 
2.30.2



