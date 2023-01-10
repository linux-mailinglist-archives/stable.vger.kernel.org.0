Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCB664AE2
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbjAJShc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbjAJSgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:36:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564B787F0E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02105B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38509C433EF;
        Tue, 10 Jan 2023 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375503;
        bh=wmeA+/15IfbFAiwM0k0873nBRbGrRizZY/H1BrAIg2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZ8aDMYv+8f/0Me27PM8/ojd3Rwij6biOnayndVgO5KhafpFQ7SPLVfd4wDLvgwF3
         4/ezVS5XpU7Ua7Jvi43X74XMb/0zaoAdXLMD9/+HSfyKPNQtwqabfZ1iDAufRKkhxj
         GmZL3tgs7WQ19n/PVwF4DuvVsdL01G0XPQ40Kg+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian Shen <shenjian15@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/290] net: hns3: fix miss L3E checking for rx packet
Date:   Tue, 10 Jan 2023 19:05:03 +0100
Message-Id: <20230110180039.272769186@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 7d89b53cea1a702f97117fb4361523519bb1e52c ]

For device supports RXD advanced layout, the driver will
return directly if the hardware finish the checksum
calculate. It cause missing L3E checking for ip packets.
Fixes it.

Fixes: 1ddc028ac849 ("net: hns3: refactor out RX completion checksum")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d06e2d0bae2e..822193b0d709 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3667,18 +3667,16 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	return 0;
 }
 
-static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
+static void hns3_checksum_complete(struct hns3_enet_ring *ring,
 				   struct sk_buff *skb, u32 ptype, u16 csum)
 {
 	if (ptype == HNS3_INVALID_PTYPE ||
 	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
-		return false;
+		return;
 
 	hns3_ring_stats_update(ring, csum_complete);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum = csum_unfold((__force __sum16)csum);
-
-	return true;
 }
 
 static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
@@ -3738,8 +3736,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
 					HNS3_RXD_PTYPE_S);
 
-	if (hns3_checksum_complete(ring, skb, ptype, csum))
-		return;
+	hns3_checksum_complete(ring, skb, ptype, csum);
 
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
@@ -3748,6 +3745,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
+		skb->ip_summed = CHECKSUM_NONE;
 		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
-- 
2.35.1



