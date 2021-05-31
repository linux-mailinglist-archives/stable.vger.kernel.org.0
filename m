Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE82C3962C8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhEaPBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhEaO7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABDC61462;
        Mon, 31 May 2021 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469675;
        bh=DNOU7Ire3QsPKNVLBmPXwU/3EefUuQa36zGP6CxesFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMK9lKEZyG6PLWGMh8zVS4y1uzzSSPwWCmkYn4guNwtALw8v7Xbg/pw08niJ77fp/
         Wkxw344hWpuo38DwH+s6vNm/OdSO05SjdxibgXhCoUIA9bL1FemAa3Nrs7CYSVMhLF
         YtrBaEZRsAdtGBup0w+lj6DJsYN/5uCDw8PSvVNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 253/296] gve: Add NULL pointer checks when freeing irqs.
Date:   Mon, 31 May 2021 15:15:08 +0200
Message-Id: <20210531130712.266054327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>

[ Upstream commit 5218e919c8d06279884aa0baf76778a6817d5b93 ]

When freeing notification blocks, we index priv->msix_vectors.
If we failed to allocate priv->msix_vectors (see abort_with_msix_vectors)
this could lead to a NULL pointer dereference if the driver is unloaded.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 64192942ca53..21a5d058dab4 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -301,20 +301,22 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 {
 	int i;
 
-	/* Free the irqs */
-	for (i = 0; i < priv->num_ntfy_blks; i++) {
-		struct gve_notify_block *block = &priv->ntfy_blocks[i];
-		int msix_idx = i;
-
-		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
-				      NULL);
-		free_irq(priv->msix_vectors[msix_idx].vector, block);
+	if (priv->msix_vectors) {
+		/* Free the irqs */
+		for (i = 0; i < priv->num_ntfy_blks; i++) {
+			struct gve_notify_block *block = &priv->ntfy_blocks[i];
+			int msix_idx = i;
+
+			irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+					      NULL);
+			free_irq(priv->msix_vectors[msix_idx].vector, block);
+		}
+		free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	}
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
 			  priv->ntfy_blocks, priv->ntfy_block_bus);
 	priv->ntfy_blocks = NULL;
-	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	pci_disable_msix(priv->pdev);
 	kvfree(priv->msix_vectors);
 	priv->msix_vectors = NULL;
-- 
2.30.2



