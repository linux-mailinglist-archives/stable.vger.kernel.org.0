Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7CE3FDC10
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346095AbhIAMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345633AbhIAMow (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFAB461152;
        Wed,  1 Sep 2021 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499927;
        bh=GUlel7U2taPP8HHreNxMPsRKeXvAGeJk+74as13K/00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRLuIC0LKD7AjoFiv8VpaDcquE8o+PsJYoi2Ef1aEqk0cFltSUhz6aYb7IDH4yIQM
         LR4adjjMxUHahnm0axtnEkBdwqME8SIJvBlc8gCa9Fu1ofbzeP1MF8QrtISFe6VIk3
         b90gRSzkCiWiyxP2hqUTWLOmjfscC76TymJy6DGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 038/113] IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()
Date:   Wed,  1 Sep 2021 14:27:53 +0200
Message-Id: <20210901122303.257265886@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit cbe71c61992c38f72c2b625b2ef25916b9f0d060 ]

kmalloc_array() is called to allocate memory for tx->descp. If it fails,
the function __sdma_txclean() is called:
  __sdma_txclean(dd, tx);

However, in the function __sdma_txclean(), tx-descp is dereferenced if
tx->num_desc is not zero:
  sdma_unmap_desc(dd, &tx->descp[0]);

To fix this possible null-pointer dereference, assign the return value of
kmalloc_array() to a local variable descp, and then assign it to tx->descp
if it is not NULL. Otherwise, go to enomem.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20210806133029.194964-1-islituo@gmail.com
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Tested-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 1fcc6e9666e0..8e902b83ce26 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3055,6 +3055,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int i;
+	struct sdma_desc *descp;
 
 	/* Handle last descriptor */
 	if (unlikely((tx->num_desc == (MAX_DESC - 1)))) {
@@ -3075,12 +3076,10 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 	if (unlikely(tx->num_desc == MAX_DESC))
 		goto enomem;
 
-	tx->descp = kmalloc_array(
-			MAX_DESC,
-			sizeof(struct sdma_desc),
-			GFP_ATOMIC);
-	if (!tx->descp)
+	descp = kmalloc_array(MAX_DESC, sizeof(struct sdma_desc), GFP_ATOMIC);
+	if (!descp)
 		goto enomem;
+	tx->descp = descp;
 
 	/* reserve last descriptor for coalescing */
 	tx->desc_limit = MAX_DESC - 1;
-- 
2.30.2



