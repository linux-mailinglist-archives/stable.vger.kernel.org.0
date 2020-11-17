Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714A2B6686
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgKQOE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbgKQNKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:10:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA4E221EB;
        Tue, 17 Nov 2020 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618629;
        bh=b/B0sE51PX47ZSXg2FeuQH7K3pDnPX7RH+Ui0MQFjbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyb8pMyE+1mz1Ep9u8rg/Mq72znShWKTRKErcV/EKDW6go2J2seU5AQi5qyZgS0t3
         y31W1MnbmoW64g1RKQKnecXM9EcGkHbeN1BBtjEVijQH2R3eWwjbrsTzG+BPSWHp1l
         GkBGtJqSNCVBjzUani0ZCZMyjvdv4bbUkEfqz2ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 31/78] mac80211: fix use of skb payload instead of header
Date:   Tue, 17 Nov 2020 14:04:57 +0100
Message-Id: <20201117122110.622076557@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 14f46c1e5108696ec1e5a129e838ecedf108c7bf ]

When ieee80211_skb_resize() is called from ieee80211_build_hdr()
the skb has no 802.11 header yet, in fact it consist only of the
payload as the ethernet frame is removed. As such, we're using
the payload data for ieee80211_is_mgmt(), which is of course
completely wrong. This didn't really hurt us because these are
always data frames, so we could only have added more tailroom
than we needed if we determined it was a management frame and
sdata->crypto_tx_tailroom_needed_cnt was false.

However, syzbot found that of course there need not be any payload,
so we're using at best uninitialized memory for the check.

Fix this to pass explicitly the kind of frame that we have instead
of checking there, by replacing the "bool may_encrypt" argument
with an argument that can carry the three possible states - it's
not going to be encrypted, it's a management frame, or it's a data
frame (and then we check sdata->crypto_tx_tailroom_needed_cnt).

Reported-by: syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20201009132538.e1fd7f802947.I799b288466ea2815f9d4c84349fae697dca2f189@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6216279efc468..eebbddccb47b7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1847,19 +1847,24 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 /* device xmit handlers */
 
+enum ieee80211_encrypt {
+	ENCRYPT_NO,
+	ENCRYPT_MGMT,
+	ENCRYPT_DATA,
+};
+
 static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
-				int head_need, bool may_encrypt)
+				int head_need,
+				enum ieee80211_encrypt encrypt)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_hdr *hdr;
 	bool enc_tailroom;
 	int tail_need = 0;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
-	enc_tailroom = may_encrypt &&
-		       (sdata->crypto_tx_tailroom_needed_cnt ||
-			ieee80211_is_mgmt(hdr->frame_control));
+	enc_tailroom = encrypt == ENCRYPT_MGMT ||
+		       (encrypt == ENCRYPT_DATA &&
+			sdata->crypto_tx_tailroom_needed_cnt);
 
 	if (enc_tailroom) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
@@ -1892,21 +1897,27 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int headroom;
-	bool may_encrypt;
+	enum ieee80211_encrypt encrypt;
 
-	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
+	if (info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)
+		encrypt = ENCRYPT_NO;
+	else if (ieee80211_is_mgmt(hdr->frame_control))
+		encrypt = ENCRYPT_MGMT;
+	else
+		encrypt = ENCRYPT_DATA;
 
 	headroom = local->tx_headroom;
-	if (may_encrypt)
+	if (encrypt != ENCRYPT_NO)
 		headroom += sdata->encrypt_headroom;
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
-	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
+	if (ieee80211_skb_resize(sdata, skb, headroom, encrypt)) {
 		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
 
+	/* reload after potential resize */
 	hdr = (struct ieee80211_hdr *) skb->data;
 	info->control.vif = &sdata->vif;
 
@@ -2688,7 +2699,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		head_need += sdata->encrypt_headroom;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
+		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
 			return ERR_PTR(-ENOMEM);
@@ -3313,7 +3324,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (unlikely(ieee80211_skb_resize(sdata, skb,
 					  max_t(int, extra_head + hw_headroom -
 						     skb_headroom(skb), 0),
-					  false))) {
+					  ENCRYPT_NO))) {
 		kfree_skb(skb);
 		return true;
 	}
-- 
2.27.0



