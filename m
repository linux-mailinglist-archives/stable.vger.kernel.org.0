Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD04C31145B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhBEWEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232936AbhBEO5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED6065038;
        Fri,  5 Feb 2021 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534304;
        bh=WFkbVPtm1HOMJAXeFh3+vHxFl0eQWhWtUVW+kV4Z2x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0p+DyCjRVnlwXsmEbZQRGa9ktDsC9Gejp8RJOeU4pepk17JARE3u8EgQHGUOfnQDb
         xRRvj+2AFbRBWsuJUm3qT4TpuGEC5wDGyUu1+++XQA9WfgWoFOF+6icc3wUMjLJQva
         MfWZlXa5NgVdc1xk2ZZIASq/GXtRVV5FpFbmNpgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/57] mac80211: fix encryption key selection for 802.3 xmit
Date:   Fri,  5 Feb 2021 15:07:00 +0100
Message-Id: <20210205140657.425541985@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b101dd2d22f45d203010b40c739df346a0cbebef ]

When using WEP, the default unicast key needs to be selected, instead of
the STA PTK.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201218184718.93650-4-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ca1e9de388910..88868bf300513 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4278,7 +4278,6 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 	struct ieee80211_key *key;
 	struct sta_info *sta;
-	bool offload = true;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -4294,18 +4293,22 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 
 	if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
 	    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-		sdata->control_port_protocol == ehdr->h_proto))
-		offload = false;
-	else if ((key = rcu_dereference(sta->ptk[sta->ptk_idx])) &&
-		 (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
-		  key->conf.cipher == WLAN_CIPHER_SUITE_TKIP))
-		offload = false;
-
-	if (offload)
-		ieee80211_8023_xmit(sdata, dev, sta, key, skb);
-	else
-		ieee80211_subif_start_xmit(skb, dev);
+	    sdata->control_port_protocol == ehdr->h_proto))
+		goto skip_offload;
+
+	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (!key)
+		key = rcu_dereference(sdata->default_unicast_key);
+
+	if (key && (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
+		    key->conf.cipher == WLAN_CIPHER_SUITE_TKIP))
+		goto skip_offload;
+
+	ieee80211_8023_xmit(sdata, dev, sta, key, skb);
+	goto out;
 
+skip_offload:
+	ieee80211_subif_start_xmit(skb, dev);
 out:
 	rcu_read_unlock();
 
-- 
2.27.0



