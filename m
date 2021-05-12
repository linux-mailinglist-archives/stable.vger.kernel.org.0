Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1B437C8D7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhELQNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239180AbhELQHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADFC6195F;
        Wed, 12 May 2021 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833802;
        bh=AvDDK1Y6Oua6B9Ocw9/JoBQjCp4NDpQvoAS1goOTYVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmLxY4xx8aThlUK7VjCXiHoRAMlD90sd4V5819AObOeQeZBp4WXD2eiWJt6zLq4qe
         HdFibaw/Em+zrB7kZ+Y6vgv/rvBQUuuth3yAu8I4s4PBGfuN8ECb1tjyLH4uT8aDjm
         y+6rj5l3XsX0l4OP/xtz14CnhqTWuJaI8Rc+FZ7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 259/601] crypto: sa2ul - Fix memory leak of rxd
Date:   Wed, 12 May 2021 16:45:36 +0200
Message-Id: <20210512144836.353060430@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index d7b1628fb484..b0f0502a5bb0 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1146,8 +1146,10 @@ static int sa_run(struct sa_req *req)
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
@@ -1155,8 +1157,10 @@ static int sa_run(struct sa_req *req)
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



