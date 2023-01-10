Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825D06648FE
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbjAJSQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbjAJSQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E650150
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE1C16182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5B9C433A1;
        Tue, 10 Jan 2023 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374475;
        bh=GJgiAw4nbrY/Ut+LGTQ97pgYhspitOT8WG92by63uNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTbtwBL1Bb0l4ra0ge2nKZYOJgE+9xzA7/lEywTTd7QlxQBb03/yKOeOeHO1SFZ6+
         gIM/V5N/kOWSbSbEA4kAOq4KNcTN/OQV42ShOBTUUZB9xnrBmQDaOr8ygdz4IZUGT2
         KiJhBmGFLvaV65Lkhfhe0hjt2ya+UtuM2DaMEDro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian Shen <shenjian15@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/159] net: hns3: fix miss L3E checking for rx packet
Date:   Tue, 10 Jan 2023 19:02:58 +0100
Message-Id: <20230110180019.272816806@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index 028577943ec5..248f15dac86b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3855,18 +3855,16 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
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
@@ -3926,8 +3924,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
 					HNS3_RXD_PTYPE_S);
 
-	if (hns3_checksum_complete(ring, skb, ptype, csum))
-		return;
+	hns3_checksum_complete(ring, skb, ptype, csum);
 
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
@@ -3936,6 +3933,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
+		skb->ip_summed = CHECKSUM_NONE;
 		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
-- 
2.35.1



