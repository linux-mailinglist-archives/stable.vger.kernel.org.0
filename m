Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB014A43D9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbiAaLYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376261AbiAaLVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC715C0797B3;
        Mon, 31 Jan 2022 03:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE806B82A77;
        Mon, 31 Jan 2022 11:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2FDC340E8;
        Mon, 31 Jan 2022 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627654;
        bh=9dVBKrbhU02MiuWvg/Ym6NPghHGBb13fV1UFCzSdg4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWdKtEVD16/TvhwHANJlP50UgBPnrMgmihbzMYV5NvC98W5BCkOuho7+9h5+pW1DA
         EJ8BB9/3ZlyR0usdURE8QrUA7rAde0x48WhPVvdfA4iYBwMJcbPTNxVWg25LGsPDhu
         vvj8GgeIwTNAwYESkVQ9iB4vCOlXPq2KkuM4Y1GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/171] gve: Fix GFP flags when allocing pages
Date:   Mon, 31 Jan 2022 11:56:59 +0100
Message-Id: <20220131105235.229765300@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit a92f7a6feeb3884c69c1c7c1f13bccecb2228ad0 ]

Use GFP_ATOMIC when allocating pages out of the hotpath,
continue to use GFP_KERNEL when allocating pages during setup.

GFP_KERNEL will allow blocking which allows it to succeed
more often in a low memory enviornment but in the hotpath we do
not want to allow the allocation to block.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Link: https://lore.kernel.org/r/20220126003843.3584521-1-awogbemila@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h        | 2 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 6 +++---
 drivers/net/ethernet/google/gve/gve_rx.c     | 3 ++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index c1d4042671f9f..b1273dce4795b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -815,7 +815,7 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction);
+		   enum dma_data_direction, gfp_t gfp_flags);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 959352fceead7..68552848d3888 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -746,9 +746,9 @@ static void gve_free_rings(struct gve_priv *priv)
 
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction dir)
+		   enum dma_data_direction dir, gfp_t gfp_flags)
 {
-	*page = alloc_page(GFP_KERNEL);
+	*page = alloc_page(gfp_flags);
 	if (!*page) {
 		priv->page_alloc_fail++;
 		return -ENOMEM;
@@ -792,7 +792,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	for (i = 0; i < pages; i++) {
 		err = gve_alloc_page(priv, &priv->pdev->dev, &qpl->pages[i],
 				     &qpl->page_buses[i],
-				     gve_qpl_dma_dir(priv, id));
+				     gve_qpl_dma_dir(priv, id), GFP_KERNEL);
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 16169f291ad9f..629d8ed08fc61 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -79,7 +79,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
+			     GFP_ATOMIC);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8500621b2cd41..7b18b4fd9e548 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.34.1



