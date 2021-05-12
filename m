Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65FB37C46E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhELPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235148AbhELP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC61761A0F;
        Wed, 12 May 2021 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832310;
        bh=GrDk/zsa2GMA97HFS9gxyKbTjbhNFRNPg2EHVtDo/N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydIkueQFvcZcxq01KoFHr2kRTJd85VctD6/kdIxhpr+SXtNpQuDBY300ech2Jb8sO
         BJVlcrKrsVZ1yOJuDO6Hcp+uXfF3nQWJKxH6LeK2n43gCsCoRMfjQEn23ZIW7UfpCs
         CszCwBWV2YC5b+2P+REhbWGMpi0r2z/MpKH6GcHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/530] crypto: sa2ul - Fix memory leak of rxd
Date:   Wed, 12 May 2021 16:45:38 +0200
Message-Id: <20210512144827.322331687@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 854b7737199848a91f6adfa0a03cf6f0c46c86e8 ]

There are two error return paths that are not freeing rxd and causing
memory leaks.  Fix these.

Addresses-Coverity: ("Resource leak")
Fixes: 00c9211f60db ("crypto: sa2ul - Fix DMA mapping API usage")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 39d56ab12f27..4640fe0c1f22 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1138,8 +1138,10 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.sgl = src;
 		mapped_sg->sgt.orig_nents = src_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
-		if (ret)
+		if (ret) {
+			kfree(rxd);
 			return ret;
+		}
 
 		mapped_sg->dir = dir_src;
 		mapped_sg->mapped = true;
@@ -1147,8 +1149,10 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.sgl = req->src;
 		mapped_sg->sgt.orig_nents = sg_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
-		if (ret)
+		if (ret) {
+			kfree(rxd);
 			return ret;
+		}
 
 		mapped_sg->dir = dir_src;
 		mapped_sg->mapped = true;
-- 
2.30.2



