Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053F8395FC7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhEaOQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhEaONj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD83D6146D;
        Mon, 31 May 2021 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468530;
        bh=8Oy81VEdXomROfATdpP8vyT3Lrxeamkk3bpNm7pWYCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kORbYk392kBHm1ghStJnAUR4QKwXM/BQ/x+U0lc6ynta7nng2iGdHEpV5552n4F/j
         bVeCOZ/LipdvCRvtuOjDTKU5v1crQmWwY4KRchwY1FuywJ6Zt0aIOfeH63dN26Nbtb
         6NDSiAQn/DpjywUt570a4WGCtQqYqYYLK2z5TLy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 025/177] ath10k: drop fragments with multicast DA for PCIe
Date:   Mon, 31 May 2021 15:13:02 +0200
Message-Id: <20210531130648.785266963@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

commit 65c415a144ad8132b6a6d97d4a1919ffc728e2d1 upstream.

Fragmentation is not used with multicast frames. Discard unexpected
fragments with multicast DA. This fixes CVE-2020-26145.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.5a0bd289bda8.Idd6ebea20038fb1cfee6de924aa595e5647c9eae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1761,6 +1761,16 @@ static u64 ath10k_htt_rx_h_get_pn(struct
 	return pn;
 }
 
+static bool ath10k_htt_rx_h_frag_multicast_check(struct ath10k *ar,
+						 struct sk_buff *skb,
+						 u16 offset)
+{
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *)(skb->data + offset);
+	return !is_multicast_ether_addr(hdr->addr1);
+}
+
 static bool ath10k_htt_rx_h_frag_pn_check(struct ath10k *ar,
 					  struct sk_buff *skb,
 					  u16 peer_id,
@@ -1832,7 +1842,7 @@ static void ath10k_htt_rx_h_mpdu(struct
 	bool is_decrypted;
 	bool is_mgmt;
 	u32 attention;
-	bool frag_pn_check = true;
+	bool frag_pn_check = true, multicast_check = true;
 
 	if (skb_queue_empty(amsdu))
 		return;
@@ -1939,13 +1949,20 @@ static void ath10k_htt_rx_h_mpdu(struct
 								      0,
 								      enctype);
 
-		if (!frag_pn_check) {
-			/* Discard the fragment with invalid PN */
+		if (frag)
+			multicast_check = ath10k_htt_rx_h_frag_multicast_check(ar,
+									       msdu,
+									       0);
+
+		if (!frag_pn_check || !multicast_check) {
+			/* Discard the fragment with invalid PN or multicast DA
+			 */
 			temp = msdu->prev;
 			__skb_unlink(msdu, amsdu);
 			dev_kfree_skb_any(msdu);
 			msdu = temp;
 			frag_pn_check = true;
+			multicast_check = true;
 			continue;
 		}
 


