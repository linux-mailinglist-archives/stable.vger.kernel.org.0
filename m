Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33AA37C38C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhELPUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhELPRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:17:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C1876143E;
        Wed, 12 May 2021 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832033;
        bh=eMf4jyMm8BFS+tTjdkDT6gTNKThouwd1zoQLiyk8vk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qs712h8/mW9Vz9z4LKtQlds6IHx8/vwTl6alzEpOCegEuqnF4xWsmk6yJXFbrNykM
         T3D8SURUeiGICpNU/6vhC88Hj61iyTLV3n0EIjJ0PC6lE1eSmaues6La2UpxDn63U0
         lR4XQ8PqsoS9bvzz9cuwuclvqTaqcauDpkwzf2mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/530] crypto: sun8i-ss - fix result memory leak on error path
Date:   Wed, 12 May 2021 16:43:45 +0200
Message-Id: <20210512144823.583079148@linuxfoundation.org>
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

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit 1dbc6a1e25be8575d6c4114d1d2b841a796507f7 ]

This patch fixes a memory leak on an error path.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index b6ab2054f217..541bcd814384 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -437,8 +437,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	kfree(pad);
 
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-	kfree(result);
 theend:
+	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
 	return 0;
 }
-- 
2.30.2



