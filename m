Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6116E2469E5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgHQP1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbgHQP1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:27:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE6E2078D;
        Mon, 17 Aug 2020 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678041;
        bh=XmOtBywmvijbi4qbmel2vVyDLiX30NEigxI5LnAU8Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1D0KfV80eSpz5lB682K6x+pIiy5RG0buYj6NZ7lonrKqc8MxHu1Ys8efImwZmuFTE
         VDQL8poS4VBY/EqreyZZofZdkVFajYlTvzE3pmfRPlEujYgxjDhKluL3Ek9Ky+ZBKM
         wSgL9gWQB2cs2T+/i/nReG5Kg3zjK2Kyduo9BCZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 199/464] dma-buf: fix dma-fence-chain out of order test
Date:   Mon, 17 Aug 2020 17:12:32 +0200
Message-Id: <20200817143843.354544668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

[ Upstream commit 4cca2e641641767593583749dec26bfebd8f6f2d ]

There was probably a misunderstand on how the dma-fence-chain is
supposed to work or what dma_fence_chain_find_seqno() is supposed to
return.

dma_fence_chain_find_seqno() is here to give us the fence to wait upon
for a particular point in the timeline. The timeline progresses only
when all the points prior to a given number have completed.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: dc2f7e67a28a5c ("dma-buf: Exercise dma-fence-chain under selftests")
Link: https://patchwork.freedesktop.org/patch/372960/
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/st-dma-fence-chain.c | 43 ++++++++++++++--------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/dma-buf/st-dma-fence-chain.c b/drivers/dma-buf/st-dma-fence-chain.c
index 5d45ba7ba3cd3..9525f7f561194 100644
--- a/drivers/dma-buf/st-dma-fence-chain.c
+++ b/drivers/dma-buf/st-dma-fence-chain.c
@@ -318,15 +318,16 @@ static int find_out_of_order(void *arg)
 		goto err;
 	}
 
-	if (fence && fence != fc.chains[1]) {
+	/*
+	 * We signaled the middle fence (2) of the 1-2-3 chain. The behavior
+	 * of the dma-fence-chain is to make us wait for all the fences up to
+	 * the point we want. Since fence 1 is still not signaled, this what
+	 * we should get as fence to wait upon (fence 2 being garbage
+	 * collected during the traversal of the chain).
+	 */
+	if (fence != fc.chains[0]) {
 		pr_err("Incorrect chain-fence.seqno:%lld reported for completed seqno:2\n",
-		       fence->seqno);
-
-		dma_fence_get(fence);
-		err = dma_fence_chain_find_seqno(&fence, 2);
-		dma_fence_put(fence);
-		if (err)
-			pr_err("Reported %d for finding self!\n", err);
+		       fence ? fence->seqno : 0);
 
 		err = -EINVAL;
 	}
@@ -415,20 +416,18 @@ static int __find_race(void *arg)
 		if (!fence)
 			goto signal;
 
-		err = dma_fence_chain_find_seqno(&fence, seqno);
-		if (err) {
-			pr_err("Reported an invalid fence for find-self:%d\n",
-			       seqno);
-			dma_fence_put(fence);
-			break;
-		}
-
-		if (fence->seqno < seqno) {
-			pr_err("Reported an earlier fence.seqno:%lld for seqno:%d\n",
-			       fence->seqno, seqno);
-			err = -EINVAL;
-			dma_fence_put(fence);
-			break;
+		/*
+		 * We can only find ourselves if we are on fence we were
+		 * looking for.
+		 */
+		if (fence->seqno == seqno) {
+			err = dma_fence_chain_find_seqno(&fence, seqno);
+			if (err) {
+				pr_err("Reported an invalid fence for find-self:%d\n",
+				       seqno);
+				dma_fence_put(fence);
+				break;
+			}
 		}
 
 		dma_fence_put(fence);
-- 
2.25.1



