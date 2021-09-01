Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19CA3FDA28
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbhIAMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244571AbhIAM34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A4E6102A;
        Wed,  1 Sep 2021 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499338;
        bh=SSgTprFdfkjFhkooqfWAOUr0gc5o9bqBCiA0UxVorWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FnbNzsGRfSwPHlc3FlJgxnydwb1TXtP0nxyU+1znRROsFZMvp4lUKtK5HthvV//L
         DVMEY0iFHWE3IQ1vCZ3VdLg47CbYzm2QlF1rfbEsJI9YjzV004qSzt6PlXHi5VGK0y
         CIR6WcDuPL5/0FAQwLyQ8xPX1eabulW3KappuP7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/23] IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()
Date:   Wed,  1 Sep 2021 14:26:52 +0200
Message-Id: <20210901122250.016752834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
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
index 741938409f8e..c1c6d2c570aa 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3067,6 +3067,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int i;
+	struct sdma_desc *descp;
 
 	/* Handle last descriptor */
 	if (unlikely((tx->num_desc == (MAX_DESC - 1)))) {
@@ -3087,12 +3088,10 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
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



