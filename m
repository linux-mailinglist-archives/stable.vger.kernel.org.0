Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50C664ADF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbjAJSh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239400AbjAJSgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:36:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25A06E415
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 393E16183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41772C433D2;
        Tue, 10 Jan 2023 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375497;
        bh=Jm8H1epJ6/Le4i8EliMB04LmVsM+jAfYxzi3yKDP0S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng7rIzwn7lxckC2qDi3U1VnyTEozuoakPa9wS4c+6/utXhHS3UvODCsj/ywqG/AV5
         I4B/N/kHEgLrBzsgiEWEO55JHWSQi7ouk3VZ/tpTVi1HRuLv3ZQaRwzmMCV1+16I3k
         8MYq+2VJK48+resPtIPcn1v9lmYuTE3QREm134qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/290] net: hns3: refactor hns3_nic_reuse_page()
Date:   Tue, 10 Jan 2023 19:05:01 +0100
Message-Id: <20230110180039.205573126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit e74a726da2c4dcedb8b0631f423d0044c7901a20 ]

Split rx copybreak handle into a separate function from function
hns3_nic_reuse_page() to improve code simplicity.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7d89b53cea1a ("net: hns3: fix miss L3E checking for rx packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 55 ++++++++++++-------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 818a028703c6..e9f2d51a8b7b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3561,6 +3561,38 @@ static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
 	return page_count(cb->priv) == cb->pagecnt_bias;
 }
 
+static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
+				    struct hns3_enet_ring *ring,
+				    int pull_len,
+				    struct hns3_desc_cb *desc_cb)
+{
+	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
+	u32 frag_offset = desc_cb->page_offset + pull_len;
+	int size = le16_to_cpu(desc->rx.size);
+	u32 frag_size = size - pull_len;
+	void *frag = napi_alloc_frag(frag_size);
+
+	if (unlikely(!frag)) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.frag_alloc_err++;
+		u64_stats_update_end(&ring->syncp);
+
+		hns3_rl_err(ring_to_netdev(ring),
+			    "failed to allocate rx frag\n");
+		return -ENOMEM;
+	}
+
+	desc_cb->reuse_flag = 1;
+	memcpy(frag, desc_cb->buf + frag_offset, frag_size);
+	skb_add_rx_frag(skb, i, virt_to_page(frag),
+			offset_in_page(frag), frag_size, frag_size);
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.frag_alloc++;
+	u64_stats_update_end(&ring->syncp);
+	return 0;
+}
+
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_enet_ring *ring, int pull_len,
 				struct hns3_desc_cb *desc_cb)
@@ -3570,6 +3602,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
 	u32 frag_size = size - pull_len;
+	int ret = 0;
 	bool reused;
 
 	if (ring->page_pool) {
@@ -3604,27 +3637,9 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		desc_cb->page_offset = 0;
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
-		void *frag = napi_alloc_frag(frag_size);
-
-		if (unlikely(!frag)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.frag_alloc_err++;
-			u64_stats_update_end(&ring->syncp);
-
-			hns3_rl_err(ring_to_netdev(ring),
-				    "failed to allocate rx frag\n");
+		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
+		if (ret)
 			goto out;
-		}
-
-		desc_cb->reuse_flag = 1;
-		memcpy(frag, desc_cb->buf + frag_offset, frag_size);
-		skb_add_rx_frag(skb, i, virt_to_page(frag),
-				offset_in_page(frag), frag_size, frag_size);
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.frag_alloc++;
-		u64_stats_update_end(&ring->syncp);
-		return;
 	}
 
 out:
-- 
2.35.1



