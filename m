Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1FA4A4426
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377357AbiAaL0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377825AbiAaLYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F02FB82A5F;
        Mon, 31 Jan 2022 11:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFFCC340EF;
        Mon, 31 Jan 2022 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628272;
        bh=h5wXTcjiTMvA3SO2YOFReimdJuI467zY2G4HA4CEC70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtcbO/Wh8isutgDpFhYJHFyr0D4MIOaCR9F6T8aXhDYipWE8lzOS2ZKYz7z/WtVQz
         AMusNGbsc8wdEUNUnxVib8K9JuBokf+dnT2w+jmDcE3K6C3EtzRbEmlPr+0EMY7vRW
         DduOmp8VP9RrJuzmmyjW0Fh3TBR4SwK0YwW0Y3PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 180/200] gve: Fix GFP flags when allocing pages
Date:   Mon, 31 Jan 2022 11:57:23 +0100
Message-Id: <20220131105239.607269908@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
index b719f72281c44..3d469073fbc54 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -830,7 +830,7 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction);
+		   enum dma_data_direction, gfp_t gfp_flags);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 59b66f679e46e..28e2d4d8ed7c6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -752,9 +752,9 @@ static void gve_free_rings(struct gve_priv *priv)
 
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
@@ -797,7 +797,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	for (i = 0; i < pages; i++) {
 		err = gve_alloc_page(priv, &priv->pdev->dev, &qpl->pages[i],
 				     &qpl->page_buses[i],
-				     gve_qpl_dma_dir(priv, id));
+				     gve_qpl_dma_dir(priv, id), GFP_KERNEL);
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 3d04b5aff331b..04a08904305a9 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -86,7 +86,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
+			     GFP_ATOMIC);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index beb8bb079023c..8c939628e2d85 100644
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



