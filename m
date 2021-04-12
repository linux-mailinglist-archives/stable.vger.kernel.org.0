Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB96B35C001
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238828AbhDLJIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238627AbhDLJGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4D9F61398;
        Mon, 12 Apr 2021 09:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218207;
        bh=xbUPT3LN7PVYDuZXEkPkqXWnMHNZf1ODOAMORpEw98E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b52WhsTSlgawwJanqjZdL2TbESLbPvs1BM001yVb1Yw9F5cxzwhuDlbiLAgTmEXGl
         M6Etz2km/R2ZedwHmZEztjZed9VAsuevuIZNo/r0Yl0U1oBltuBbqAZ08A3CoHhw7M
         1tGKAP1LGe26wDdXugYdIVKUZsEuR1TcbJD3lXGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 111/210] esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
Date:   Mon, 12 Apr 2021 10:40:16 +0200
Message-Id: <20210412084019.705727188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 154deab6a3ba47792936edf77f2f13a1cbc4351d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 6 ++++--
 net/ipv6/esp6_offload.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 5bda5aeda579..d5c0f5a2a551 100644
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



