Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7EE37C46F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhELPbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235149AbhELP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DC406117A;
        Wed, 12 May 2021 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832312;
        bh=XG0I6EgqkskKlZgYejXZ41crSv6zjD0uBky2z+qTnhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQW97QJqxsJ4HBc7woel3Jq9MnWNq0lYDUw56E2Gb911x+nWylA7cmRc3aT1SXmbz
         7bM/LZmpYGIp5ufLeU597iSnMF95+mq4tDVk41prlRZ1BHeNg+dnC6VJtgUEBLC+cH
         5Bh4RchGayNX9eGedFT8Fa67fGcl0nCoQVST0QWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/530] crypto: qat - Fix a double free in adf_create_ring
Date:   Wed, 12 May 2021 16:45:39 +0200
Message-Id: <20210512144827.354243034@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 2ad774017200..cdfd56c9e345 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -153,6 +153,7 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 		dev_err(&GET_DEV(accel_dev), "Ring address not aligned\n");
 		dma_free_coherent(&GET_DEV(accel_dev), ring_size_bytes,
 				  ring->base_addr, ring->dma_addr);
+		ring->base_addr = NULL;
 		return -EFAULT;
 	}
 
-- 
2.30.2



