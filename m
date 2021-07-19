Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EEC3CDCDC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbhGSOyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240761AbhGSOvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5D1611F2;
        Mon, 19 Jul 2021 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708701;
        bh=xlilkF81wLezhEZzWIUeIJLlq1Gu4coF4me7/PhymMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEErI84eAUb1hjajE34Kd/IqbwqXKenmoAr0DsR7jdhaJUIigIiPkUMdwLzUt6FNL
         eKWrreR9N05MlRk6ozoKHlUxKOPbHcFKgv/9tvH45qzgDSQn5CL0UeGKUrpBbFBgjn
         2o79V1hMkmcBdgnmNOE0C81KkC8j4rLYoqd7Ly+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/421] crypto: ixp4xx - dma_unmap the correct address
Date:   Mon, 19 Jul 2021 16:48:26 +0200
Message-Id: <20210719144949.920737978@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 9395c58fdddd79cdd3882132cdd04e8ac7ad525f ]

Testing ixp4xx_crypto with CONFIG_DMA_API_DEBUG lead to the following error:
DMA-API: platform ixp4xx_crypto.0: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=24 bytes]

This is due to dma_unmap using the wrong address.

Fixes: 0d44dc59b2b4 ("crypto: ixp4xx - Fix handling of chained sg buffers")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 9b7b8558db31..abb84996f2ca 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -332,7 +332,7 @@ static void free_buf_chain(struct device *dev, struct buffer_desc *buf,u32 phys)
 
 		buf1 = buf->next;
 		phys1 = buf->phys_next;
-		dma_unmap_single(dev, buf->phys_next, buf->buf_len, buf->dir);
+		dma_unmap_single(dev, buf->phys_addr, buf->buf_len, buf->dir);
 		dma_pool_free(buffer_pool, buf, phys);
 		buf = buf1;
 		phys = phys1;
-- 
2.30.2



