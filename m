Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3C02ABAB3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388108AbgKINVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388088AbgKINVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7F22065D;
        Mon,  9 Nov 2020 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928098;
        bh=0UJ8wjG8e3mJkJAcQS878fIT03u4N7tu2eZskINx980=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiB0qGi2cj1EsJX6c4xXjBhAEArDPfLsC1RJCs57rSAadxq8Ugh3+83I1ooUiNUjP
         GDVLrRcembRGukOhDv4FIF0Vc9mjD0WhKjFeO+ocSQ5RUCj9q2G8N9GgB0IDMvHZnK
         fjGFHK8PACLDpaqI9HO+k9FAxVzO3HWPh0J9M3cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Deutschmann <whissi@gentoo.org>,
        Christian Hesse <list@eworm.de>,
        Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.9 125/133] mac80211: fix regression where EAPOL frames were sent in plaintext
Date:   Mon,  9 Nov 2020 13:56:27 +0100
Message-Id: <20201109125036.699937228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit 804fc6a2931e692f50e8e317fcb0c8887331b405 upstream.

When sending EAPOL frames via NL80211 they are treated as injected
frames in mac80211. Due to commit 1df2bdba528b ("mac80211: never drop
injected frames even if normally not allowed") these injected frames
were not assigned a sta context in the function ieee80211_tx_dequeue,
causing certain wireless network cards to always send EAPOL frames in
plaintext. This may cause compatibility issues with some clients or
APs, which for instance can cause the group key handshake to fail and
in turn would cause the station to get disconnected.

This commit fixes this regression by assigning a sta context in
ieee80211_tx_dequeue to injected frames as well.

Note that sending EAPOL frames in plaintext is not a security issue
since they contain their own encryption and authentication protection.

Cc: stable@vger.kernel.org
Fixes: 1df2bdba528b ("mac80211: never drop injected frames even if normally not allowed")
Reported-by: Thomas Deutschmann <whissi@gentoo.org>
Tested-by: Christian Hesse <list@eworm.de>
Tested-by: Thomas Deutschmann <whissi@gentoo.org>
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3613,13 +3613,14 @@ begin:
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta && !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
+	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
 		/*
 		 * Drop unicast frames to unauthorised stations unless they are
-		 * EAPOL frames from the local station.
+		 * injected frames or EAPOL frames from the local station.
 		 */
-		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
+		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+			     ieee80211_is_data(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&


