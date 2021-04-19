Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCAA3642C9
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbhDSNLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238492AbhDSNKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F4C61364;
        Mon, 19 Apr 2021 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837816;
        bh=rX390SiO/YXKxx4ZKmYe4BkaQu+3j707HAVuSfCyoLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjvRlAXPs0B9tno3wAocHYYa84konwO2BVsOzORcG7AEfFukumfVvNNYlOOmjIMN1
         qK/cGH3aB0EQY8c62+AgnRXa09l5aX4H/mXb5iu/mRiFovz9cpXDp5S54/cpbeG+oE
         VEdvMNS6DbA04Hi11ydDwHTgXgk80FkfVRqo0PnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhu <zhutong@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 029/122] neighbour: Disregard DEAD dst in neigh_update
Date:   Mon, 19 Apr 2021 15:05:09 +0200
Message-Id: <20210419130531.151963067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhu <zhutong@amazon.com>

[ Upstream commit d47ec7a0a7271dda08932d6208e4ab65ab0c987c ]

After a short network outage, the dst_entry is timed out and put
in DST_OBSOLETE_DEAD. We are in this code because arp reply comes
from this neighbour after network recovers. There is a potential
race condition that dst_entry is still in DST_OBSOLETE_DEAD.
With that, another neighbour lookup causes more harm than good.

In best case all packets in arp_queue are lost. This is
counterproductive to the original goal of finding a better path
for those packets.

I observed a worst case with 4.x kernel where a dst_entry in
DST_OBSOLETE_DEAD state is associated with loopback net_device.
It leads to an ethernet header with all zero addresses.
A packet with all zero source MAC address is quite deadly with
mac80211, ath9k and 802.11 block ack.  It fails
ieee80211_find_sta_by_ifaddr in ath9k (xmit.c). Ath9k flushes tx
queue (ath_tx_complete_aggr). BAW (block ack window) is not
updated. BAW logic is damaged and ath9k transmission is disabled.

Signed-off-by: Tong Zhu <zhutong@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6d2d557442dc..7b413fe907d6 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1380,7 +1380,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 			 * we can reinject the packet there.
 			 */
 			n2 = NULL;
-			if (dst) {
+			if (dst && dst->obsolete != DST_OBSOLETE_DEAD) {
 				n2 = dst_neigh_lookup_skb(dst, skb);
 				if (n2)
 					n1 = n2;
-- 
2.30.2



