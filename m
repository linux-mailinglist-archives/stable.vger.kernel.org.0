Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF726C8B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732712AbfEVTfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbfEVTbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D9B20675;
        Wed, 22 May 2019 19:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553459;
        bh=M61L/6BGJAO/b4IL2zPrUUeO5cdIEunpER62ILyu/fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/pD/prmw/Wnp3JpbUHi0stwBNwt6i6EbcIEn5/tdwvW9+l53UGc3QSmPJ+Ddp3hA
         wzc7acWEFEVuyIqSbd+fff1dacN5BVI5FMQ8xnRG6Wcp2Uw2RDl+x2+4loceJJvqq3
         H8UIF9qzhqM9gy/mVV/cs3KGXnkyAwaDxP0Tcieg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 027/114] crypto: sun4i-ss - Fix invalid calculation of hash end
Date:   Wed, 22 May 2019 15:28:50 -0400
Message-Id: <20190522193017.26567-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit f87391558acf816b48f325a493d81d45dec40da0 ]

When nbytes < 4, end is wronlgy set to a negative value which, due to
uint, is then interpreted to a large value leading to a deadlock in the
following code.

This patch fix this problem.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 0de2f62d51ff7..ec16ec2e284d0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -250,7 +250,10 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 	} else {
 		/* Since we have the flag final, we can go up to modulo 4 */
-		end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
+		if (areq->nbytes < 4)
+			end = 0;
+		else
+			end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
 	}
 
 	/* TODO if SGlen % 4 and op->len == 0 then DMA */
-- 
2.20.1

