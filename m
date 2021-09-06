Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4074013E8
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbhIFBcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239196AbhIFB1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F3E61027;
        Mon,  6 Sep 2021 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891372;
        bh=kfvp6RxnixOZswBUFl3mXIebYjbttY6adhaxG+mPoPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV33SirZSwJT9kiqVGp5mkz4O2H0qA8vNtRkSY+hBTwIpTgJ+Jy8EsAPQQ+uTo11m
         4JUn/+cdzUrs8ao8Dz3FHaKKALdzURj1zSXS/sh+o3+sgc49b0RF+BRPRvSe7+vRdj
         sdx83l/ZVaeLmSX4/8vPfEq/b6FNOIlU4a/EXaDWBGjULRVHrP/ViYzqoiWiWspsWq
         WV1swUA1Zn3i6EJitPvPln7wZrYxgidLhZO0GPkix2tJynb6TF+s3qUVspwx9O8b8Z
         sgSDVFB5QH0QF/D2sknxmwoAlma+bY5JJE7gfkQl1RFw16nXE2VXGp4+pTcblzYaZb
         GLHfEoRU2aZNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/30] crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
Date:   Sun,  5 Sep 2021 21:22:19 -0400
Message-Id: <20210906012244.930338-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit fe28140b3393b0ba1eb95cc109f974a7e58b26fd ]

We should not clear FLAGS_DMA_ACTIVE before omap_sham_update_dma_stop() is
done calling dma_unmap_sg(). We already clear FLAGS_DMA_ACTIVE at the
end of omap_sham_update_dma_stop().

The early clearing of FLAGS_DMA_ACTIVE is not causing issues as we do not
need to defer anything based on FLAGS_DMA_ACTIVE currently. So this can be
applied as clean-up.

Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index f80db1eb2994..f8a146554b1f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1734,7 +1734,7 @@ static void omap_sham_done_task(unsigned long data)
 		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
 			goto finish;
 	} else if (test_bit(FLAGS_DMA_READY, &dd->flags)) {
-		if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
+		if (test_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
 			omap_sham_update_dma_stop(dd);
 			if (dd->err) {
 				err = dd->err;
-- 
2.30.2

