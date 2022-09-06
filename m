Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACEE5AEBCE
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbiIFOFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbiIFOEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C639FE3;
        Tue,  6 Sep 2022 06:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F20761547;
        Tue,  6 Sep 2022 13:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7794AC4347C;
        Tue,  6 Sep 2022 13:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471787;
        bh=4249EGzH/Ah7i3H9+B9/vA/MvEtjY/oZVBLD6qjqI4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PQDolIDpzELuy/IWYQG6d0i2PLyBfzFoybIyvVFaBViEkbipeIK+FxVAXJoWJOAI
         dpn8RN1f/oxVFRdaWh+NoDUZfaO1qtznSjMKnITHnk0Tcf2UCGpb6omhnQmrKmOtlP
         go4aUymhyk1w1IqbBSDpD23U6Lr+9Ji4mGmWmm4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alasdair McWilliam <alasdair.mcwilliam@outlook.com>,
        Intrusion Shield Team <dnevil@intrusion.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 009/155] xsk: Fix corrupted packets for XDP_SHARED_UMEM
Date:   Tue,  6 Sep 2022 15:29:17 +0200
Message-Id: <20220906132829.812292562@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 58ca14ed98c87cfe0d1408cc65a9745d9e9b7a56 ]

Fix an issue in XDP_SHARED_UMEM mode together with aligned mode where
packets are corrupted for the second and any further sockets bound to
the same umem. In other words, this does not affect the first socket
bound to the umem. The culprit for this bug is that the initialization
of the DMA addresses for the pre-populated xsk buffer pool entries was
not performed for any socket but the first one bound to the umem. Only
the linear array of DMA addresses was populated. Fix this by populating
the DMA addresses in the xsk buffer pool for every socket bound to the
same umem.

Fixes: 94033cd8e73b8 ("xsk: Optimize for aligned case")
Reported-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Reported-by: Intrusion Shield Team <dnevil@intrusion.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/xdp-newbies/6205E10C-292E-4995-9D10-409649354226@outlook.com/
Link: https://lore.kernel.org/bpf/20220812113259.531-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index f70112176b7c1..a71a8c6edf553 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -379,6 +379,16 @@ static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
 
 static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
 {
+	if (!pool->unaligned) {
+		u32 i;
+
+		for (i = 0; i < pool->heads_cnt; i++) {
+			struct xdp_buff_xsk *xskb = &pool->heads[i];
+
+			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
+		}
+	}
+
 	pool->dma_pages = kvcalloc(dma_map->dma_pages_cnt, sizeof(*pool->dma_pages), GFP_KERNEL);
 	if (!pool->dma_pages)
 		return -ENOMEM;
@@ -428,12 +438,6 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 
 	if (pool->unaligned)
 		xp_check_dma_contiguity(dma_map);
-	else
-		for (i = 0; i < pool->heads_cnt; i++) {
-			struct xdp_buff_xsk *xskb = &pool->heads[i];
-
-			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
-		}
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {
-- 
2.35.1



