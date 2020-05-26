Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E25B19B3E9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbgDAQ0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733134AbgDAQ0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:26:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D9E20857;
        Wed,  1 Apr 2020 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758401;
        bh=HXV7RpBGT25AERW4zD7Td0Ay2o0uP43mJJuwTAIU6WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PU3w5HF2Xe4PYYaJb+QNJmvRY3GipXV7VFyi838zoLicrVmJ9mQdhTvGpwGQEJBGK
         p6W6Uh3p/1ZoOB2KgNSVjnKVRdiHPWooEzfv8fa5PGpAKiLKVGKp4CfBV1pJX81Paq
         u5sDdUpb9bbr7SWopuWyX+dZ2+ZvEbtalgKlrI68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/116] mac80211: add option for setting control flags
Date:   Wed,  1 Apr 2020 18:17:33 +0200
Message-Id: <20200401161552.567123694@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajkumar Manoharan <rmanohar@codeaurora.org>

[ Upstream commit 060167729a78d626abaee1a0ebb64b252374426e ]

Allows setting of control flags of skb cb - if needed -
when calling ieee80211_subif_start_xmit().

Tested-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/tdls.c        |    2 +-
 net/mac80211/tx.c          |   18 +++++++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1729,7 +1729,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 				       struct net_device *dev);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags);
+				  u32 info_flags,
+				  u32 ctrl_flags);
 void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 			      struct sk_buff_head *skbs);
 struct sk_buff *
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1055,7 +1055,7 @@ ieee80211_tdls_prep_mgmt_packet(struct w
 
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, dev, flags);
+	__ieee80211_subif_start_xmit(skb, dev, flags, 0);
 	local_bh_enable();
 
 	return ret;
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2399,6 +2399,7 @@ static int ieee80211_lookup_ra_sta(struc
  * @sdata: virtual interface to build the header for
  * @skb: the skb to build the header in
  * @info_flags: skb flags to set
+ * @ctrl_flags: info control flags to set
  *
  * This function takes the skb with 802.3 header and reformats the header to
  * the appropriate IEEE 802.11 header based on which interface the packet is
@@ -2414,7 +2415,7 @@ static int ieee80211_lookup_ra_sta(struc
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info *sta)
+					   struct sta_info *sta, u32 ctrl_flags)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -2786,6 +2787,7 @@ static struct sk_buff *ieee80211_build_h
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 	info->band = band;
+	info->control.flags = ctrl_flags;
 
 	return skb;
  free:
@@ -3595,7 +3597,8 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-				  u32 info_flags)
+				  u32 info_flags,
+				  u32 ctrl_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
@@ -3666,7 +3669,8 @@ void __ieee80211_subif_start_xmit(struct
 		skb->prev = NULL;
 		skb->next = NULL;
 
-		skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+		skb = ieee80211_build_hdr(sdata, skb, info_flags,
+					  sta, ctrl_flags);
 		if (IS_ERR(skb))
 			goto out;
 
@@ -3806,9 +3810,9 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		__skb_queue_head_init(&queue);
 		ieee80211_convert_to_unicast(skb, dev, &queue);
 		while ((skb = __skb_dequeue(&queue)))
-			__ieee80211_subif_start_xmit(skb, dev, 0);
+			__ieee80211_subif_start_xmit(skb, dev, 0, 0);
 	} else {
-		__ieee80211_subif_start_xmit(skb, dev, 0);
+		__ieee80211_subif_start_xmit(skb, dev, 0, 0);
 	}
 
 	return NETDEV_TX_OK;
@@ -3833,7 +3837,7 @@ ieee80211_build_data_template(struct iee
 		goto out;
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -4870,7 +4874,7 @@ int ieee80211_tx_control_port(struct wip
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
 	local_bh_enable();
 
 	return 0;


