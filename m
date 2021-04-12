Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25BD35B896
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhDLCXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDLCXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9D96120E;
        Mon, 12 Apr 2021 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194211;
        bh=ytWmcET1qz00Fa2VHfoRsLT9A/pT/RhOrD4YL2BCXMk=;
        h=From:To:Cc:Subject:Date:From;
        b=sp1OHJnocZiyC1D5htqgg7+n//i6lRMr6+KQEcCXwRGWCojqplwYmJz+OqqCpzSug
         bIS1dDxphL3E5U+HSo0bBTyhiF8GAMSUmX25iAYN9gdA9ARSLXOXieSjhrbhUjGXh6
         UT6ClV4oEA6WXXbS0+o/DhSazr5ao9pXMdaXkKDTdI3bFE3cNa1M6HLu0weYdS5W95
         tpCJGZHMB3IMV/yBy16AaLW/W8o740U92AGOwpRFEcWjKhxc0WWia/8FHzjKySphkn
         lb5WhjYIsVG9qC4B3rQBqGG6Ck8z4i+k17Woo6O7tkLc1e8b0p8t/PjJuRxJeT6tEz
         s4+xuR/mAR3Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, lucien.xin@gmail.com
Cc:     Xiumei Mu <xmu@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: FAILED: Patch "esp: delete NETIF_F_SCTP_CRC bit from features for esp offload" failed to apply to 4.14-stable tree
Date:   Sun, 11 Apr 2021 22:23:29 -0400
Message-Id: <20210412022329.284529-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 154deab6a3ba47792936edf77f2f13a1cbc4351d Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Mar 2021 15:35:07 +0800
Subject: [PATCH] esp: delete NETIF_F_SCTP_CRC bit from features for esp
 offload

Now in esp4/6_gso_segment(), before calling inner proto .gso_segment,
NETIF_F_CSUM_MASK bits are deleted, as HW won't be able to do the
csum for inner proto due to the packet encrypted already.

So the UDP/TCP packet has to do the checksum on its own .gso_segment.
But SCTP is using CRC checksum, and for that NETIF_F_SCTP_CRC should
be deleted to make SCTP do the csum in own .gso_segment as well.

In Xiumei's testing with SCTP over IPsec/veth, the packets are kept
dropping due to the wrong CRC checksum.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 6 ++++--
 net/ipv6/esp6_offload.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 601f5fbfc63f..ed3de486ea34 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -217,10 +217,12 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516fb30e1..f35203ab39f5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -254,9 +254,11 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-- 
2.30.2




