Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53138A93F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhETLAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239092AbhETK5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE34661CF7;
        Thu, 20 May 2021 10:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504932;
        bh=8APKXRuvakIe0b/7cybuTVvzfs8YW/6wc5fHM9HTOAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdJbTjKEL0VohGecP0X6DN5f6sjGjiYtwYiNwSYjIgf7LUkQygIEqL0QVzrne3Vnp
         xGWYGRbqsF1Uszp06YdcJnNmCKSt9koyJjO0ostJRqlVoW9KXqsFgNPk2BrGo4zaqC
         TMY2CEW3CwD8wiDqrGDjbcsIo7OsIN/Op0HYRKeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 113/240] crypto: qat - Fix a double free in adf_create_ring
Date:   Thu, 20 May 2021 11:21:45 +0200
Message-Id: <20210520092112.470581889@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 57d2622728a5..4c0067f8c079 100644
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



