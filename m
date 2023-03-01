Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869716A72E5
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCASKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCASKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250133CE0D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0AC46140D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69C9C433EF;
        Wed,  1 Mar 2023 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694230;
        bh=poIkIYgz/XPHmp8iv8kF/HMBQWJucD1pFg/cdPeqn9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUSdA2vZV8Sk65Ir8ZyvBHws8fNq95XsN62p8o4frYTwgihSLQPq8cfTEXyQ7VqM1
         0nvx14rNBgcdZPauga3liENdWH1+4EoECNnOrdrK7l7OF25X5TVn7ENS6VjHCOonqc
         aUph4IyL0r1Bm4Iv7Zmx4l7TxjVnwRgLk/z4CElg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/22] ionic: refactor use of ionic_rx_fill()
Date:   Wed,  1 Mar 2023 19:08:34 +0100
Message-Id: <20230301180652.716575022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neel Patel <neel@pensando.io>

[ Upstream commit e55f0f5befc26e2ba6bb8c1f945ea8e37ee0e334 ]

The same pre-work code is used before each call to
ionic_rx_fill(), so bring it in and make it a part of
the routine.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 37c39581b6599..376f97b4008bb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -353,16 +353,25 @@ void ionic_rx_fill(struct ionic_queue *q)
 	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_buf_info *buf_info;
+	unsigned int fill_threshold;
 	struct ionic_rxq_desc *desc;
 	unsigned int remain_len;
 	unsigned int frag_len;
 	unsigned int nfrags;
+	unsigned int n_fill;
 	unsigned int i, j;
 	unsigned int len;
 
+	n_fill = ionic_q_space_avail(q);
+
+	fill_threshold = min_t(unsigned int, IONIC_RX_FILL_THRESHOLD,
+			       q->num_descs / IONIC_RX_FILL_DIV);
+	if (n_fill < fill_threshold)
+		return;
+
 	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 
-	for (i = ionic_q_space_avail(q); i; i--) {
+	for (i = n_fill; i; i--) {
 		nfrags = 0;
 		remain_len = len;
 		desc_info = &q->info[q->head_idx];
@@ -518,7 +527,6 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *cq = napi_to_cq(napi);
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
-	u16 rx_fill_threshold;
 	u32 work_done = 0;
 	u32 flags = 0;
 
@@ -528,10 +536,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	work_done = ionic_cq_service(cq, budget,
 				     ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  cq->num_descs / IONIC_RX_FILL_DIV);
-	if (work_done && ionic_q_space_avail(cq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(cq->bound_q);
+	ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
@@ -559,7 +564,6 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
-	u16 rx_fill_threshold;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
@@ -574,10 +578,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	rx_work_done = ionic_cq_service(rxcq, budget,
 					ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  rxcq->num_descs / IONIC_RX_FILL_DIV);
-	if (rx_work_done && ionic_q_space_avail(rxcq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(rxcq->bound_q);
+	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
 		ionic_dim_update(qcq, 0);
-- 
2.39.0



