Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBD395F62
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhEaOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhEaOHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248186140A;
        Mon, 31 May 2021 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468372;
        bh=vf2R1pwzOzf+f1ro2bIxCj3uHCxoj+ts+iVokRCQiOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mxe3u8JPKX6bC7D9ODe2FxuRGZL4jH21YpWbx2zZ0KRBw/pGTdMwoEP03X6ysLgH6
         w2RxVsXBd0n7krXSqFzZqB99Ur1hujn8VTzJ1QSYAv2brDK1jRbrMDJWs21uaEeJ/f
         +8LIDfBVMJr7j0Pxcle+5UVxyeERIzAUTMDj6b6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/252] gve: Add NULL pointer checks when freeing irqs.
Date:   Mon, 31 May 2021 15:14:43 +0200
Message-Id: <20210531130705.417386172@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index a8fcf1227391..839102ea6aa1 100644
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



