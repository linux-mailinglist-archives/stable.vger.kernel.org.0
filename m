Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80C2EE4F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbfE3DqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732295AbfE3DUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB5024949;
        Thu, 30 May 2019 03:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186441;
        bh=5PplgaAws3iXqb6sbpckHoEGhKhqIT2kiGkYsYt5o04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcIGmiEvIsxWG/oyt+pNK4MaVrssJ40bKpDAdkI7k23Qa3CnUBAn0Z+7jCOWKnY6C
         MSMVC3o/2jaaNJSNe7F0W9c/SIbs95wxFpSE/P2C/Wn8Kq6pJtCGld4p1BkRi/Zqir
         ZRW0enx7bFdYgMpbzysxQv3wDjxEAugECBG2omSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 045/128] crypto: sun4i-ss - Fix invalid calculation of hash end
Date:   Wed, 29 May 2019 20:06:17 -0700
Message-Id: <20190530030442.779255122@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



