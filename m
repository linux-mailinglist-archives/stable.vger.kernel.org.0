Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88666767E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbjALOc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236821AbjALObo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:31:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B15274F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79826B81DB2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B155DC433D2;
        Thu, 12 Jan 2023 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533402;
        bh=u794NnSVD1/6JND4uxH/cYeF5osLO0TIQYL4i34sftM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmXua/pJu9fQAHtHoZESF2eEO/bhrGjj5U6DcKotU4sLHMv7Pwl0fs1yHSy+V0tp5
         bJjZ6XS5/op/5jitvUEiJkuJJZhfUeBDzVQum6hOGtUNGI4f+sn1pHqNvQsp5g3bQX
         mAPEmmLmVgbdpot9uVaXwWxeDevodM9iT9XGrqSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 465/783] net: add inline function skb_csum_is_sctp
Date:   Thu, 12 Jan 2023 14:53:01 +0100
Message-Id: <20230112135545.803693490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit fa82117010430aff2ce86400f7328f55a31b48a6 ]

This patch is to define a inline function skb_csum_is_sctp(), and
also replace all places where it checks if it's a SCTP CSUM skb.
This function would be used later in many networking drivers in
the following patches.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
 include/linux/skbuff.h                           | 5 +++++
 net/core/dev.c                                   | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 46dbb49f837c..5463c8b8e43c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -986,7 +986,7 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 		stats->vlan_inserted++;
 	}
 
-	if (skb->csum_not_inet)
+	if (skb_csum_is_sctp(skb))
 		stats->crc32_csum++;
 	else
 		stats->csum++;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 521d66ec8d80..39636fe7e8f0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4620,6 +4620,11 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+static inline bool skb_csum_is_sctp(struct sk_buff *skb)
+{
+	return skb->csum_not_inet;
+}
+
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 34b5aab42b91..a421c54331ea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3631,7 +3631,7 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
-	if (unlikely(skb->csum_not_inet))
+	if (unlikely(skb_csum_is_sctp(skb)))
 		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-- 
2.35.1



