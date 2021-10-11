Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E074290D3
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbhJKOMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239415AbhJKOKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A508060F38;
        Mon, 11 Oct 2021 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960963;
        bh=yqZMI8f3ATTSyETu6Bnp8MRP/qdjM/b8X0MSerHCGIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RLsyvr7JrpyXbLcAISV+0ISoQ4D1h95IlJT6MBxwbHSZk5sK6K5TNsEhyZFYyZy4
         KH5Wbs09rCFc4vxDrzSJsN0FKx6WK6DxiYiXpci5MAys8l97Kg8e7i7lyX0iqxZpsO
         czPSZzfqfE8ko5JrPaZCuepbKMT3Zb1Cm7wr8YP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <xliutaox@google.com>,
        Catherine Sully <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 109/151] gve: Avoid freeing NULL pointer
Date:   Mon, 11 Oct 2021 15:46:21 +0200
Message-Id: <20211011134521.343266266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

[ Upstream commit 922aa9bcac92b3ab6a423526a8e785b35a60b441 ]

Prevent possible crashes when cleaning up after unsuccessful
initializations.

Fixes: 893ce44df5658 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Tao Liu <xliutaox@google.com>
Signed-off-by: Catherine Sully <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 27 ++++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 099a2bc5ae67..29c5f994f92e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -82,6 +82,9 @@ static int gve_alloc_counter_array(struct gve_priv *priv)
 
 static void gve_free_counter_array(struct gve_priv *priv)
 {
+	if (!priv->counter_array)
+		return;
+
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_event_counters *
 			  sizeof(*priv->counter_array),
@@ -142,6 +145,9 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 
 static void gve_free_stats_report(struct gve_priv *priv)
 {
+	if (!priv->stats_report)
+		return;
+
 	del_timer_sync(&priv->stats_report_timer);
 	dma_free_coherent(&priv->pdev->dev, priv->stats_report_len,
 			  priv->stats_report, priv->stats_report_bus);
@@ -370,18 +376,19 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 {
 	int i;
 
-	if (priv->msix_vectors) {
-		/* Free the irqs */
-		for (i = 0; i < priv->num_ntfy_blks; i++) {
-			struct gve_notify_block *block = &priv->ntfy_blocks[i];
-			int msix_idx = i;
+	if (!priv->msix_vectors)
+		return;
 
-			irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
-					      NULL);
-			free_irq(priv->msix_vectors[msix_idx].vector, block);
-		}
-		free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
+	/* Free the irqs */
+	for (i = 0; i < priv->num_ntfy_blks; i++) {
+		struct gve_notify_block *block = &priv->ntfy_blocks[i];
+		int msix_idx = i;
+
+		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+				      NULL);
+		free_irq(priv->msix_vectors[msix_idx].vector, block);
 	}
+	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
 			  priv->ntfy_blocks, priv->ntfy_block_bus);
-- 
2.33.0



