Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF21C5B7372
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiIMPJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbiIMPJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:09:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0189177540;
        Tue, 13 Sep 2022 07:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 892A9B80F02;
        Tue, 13 Sep 2022 14:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D44C43140;
        Tue, 13 Sep 2022 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078456;
        bh=QVfWmvO8kgJgY3aFKPNUlaDBsJjL74N0VE5S1zVPeLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cF641/0JrR0tBOhZjLJEo81VerzzD7LrJtCgr/DRUpuMOcHSlf7Lp/B9SWFkc3xA
         SAcgL+EeAgRfrXmeLClkxnrHAc26twRG42yECiGrBJstrGZvslafi7mlbO4TZ1znmV
         hdwn9ogNj7hqvMYTtALk6qsNecB918xWw3cFvPxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 147/192] net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb
Date:   Tue, 13 Sep 2022 16:04:13 +0200
Message-Id: <20220913140417.345778357@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f27b405ef43319a3ceefc2123245201a63ed4e00 ]

Even if max hash configured in hw in mtk_ppe_hash_entry is
MTK_PPE_ENTRIES - 1, check theoretical OOB accesses in
mtk_ppe_check_skb routine

Fixes: c4f033d9e03e9 ("net: ethernet: mtk_eth_soc: rework hardware flow table management")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 1f5cf1c9a9475..69ffce04d6306 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -293,6 +293,9 @@ mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	if (!ppe)
 		return;
 
+	if (hash > MTK_PPE_HASH_MASK)
+		return;
+
 	now = (u16)jiffies;
 	diff = now - ppe->foe_check_time[hash];
 	if (diff < HZ / 10)
-- 
2.35.1



