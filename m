Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8612A11AF34
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbfLKPLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbfLKPLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4312173E;
        Wed, 11 Dec 2019 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077105;
        bh=i0jMtDCTHVYMDyPPt+5DCAj8ZJVgjtyo0kPjoSUaZO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIqF5i9x9tdls1qpNjCi2TbdqQopXtAq2plrWNR6+q1L5R1jQF9MVjDoLCXgFerwR
         m05XPoEbNY65mDLjne+l1VZt8EOR97UzjX7xhOKzbLlBytv+3e+AVnnJjeeo3g9P5M
         Eew2isvCHKkkOB3XQahqcy0OL81G3sCxkE/SlSvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 019/105] iwlwifi: pcie: dont consider IV len in A-MSDU
Date:   Wed, 11 Dec 2019 16:05:08 +0100
Message-Id: <20191211150226.390827048@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit cb1a4badf59275eb7221dcec621e8154917eabd1 ]

>From gen2 PN is totally offloaded to hardware (also the space for the
IV isn't part of the skb).  As you can see in mvm/mac80211.c:3545, the
MAC for cipher types CCMP/GCMP doesn't set
IEEE80211_KEY_FLAG_PUT_IV_SPACE for gen2 NICs.

This causes all the AMSDU data to be corrupted with cipher enabled.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 9ef6b8fe03c1b..0fbf8c1d5c98b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -252,27 +252,23 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
-	u16 length, iv_len, amsdu_pad;
+	u16 length, amsdu_pad;
 	u8 *start_hdr;
 	struct iwl_tso_hdr_page *hdr_page;
 	struct page **page_ptr;
 	struct tso_t tso;
 
-	/* if the packet is protected, then it must be CCMP or GCMP */
-	iv_len = ieee80211_has_protected(hdr->frame_control) ?
-		IEEE80211_CCMP_HDR_LEN : 0;
-
 	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd),
 			     &dev_cmd->hdr, start_len, 0);
 
 	ip_hdrlen = skb_transport_header(skb) - skb_network_header(skb);
 	snap_ip_tcp_hdrlen = 8 + ip_hdrlen + tcp_hdrlen(skb);
-	total_len = skb->len - snap_ip_tcp_hdrlen - hdr_len - iv_len;
+	total_len = skb->len - snap_ip_tcp_hdrlen - hdr_len;
 	amsdu_pad = 0;
 
 	/* total amount of header we may need for this A-MSDU */
 	hdr_room = DIV_ROUND_UP(total_len, mss) *
-		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr)) + iv_len;
+		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr));
 
 	/* Our device supports 9 segments at most, it will fit in 1 page */
 	hdr_page = get_page_hdr(trans, hdr_room);
@@ -283,14 +279,12 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 	start_hdr = hdr_page->pos;
 	page_ptr = (void *)((u8 *)skb->cb + trans_pcie->page_offs);
 	*page_ptr = hdr_page->page;
-	memcpy(hdr_page->pos, skb->data + hdr_len, iv_len);
-	hdr_page->pos += iv_len;
 
 	/*
-	 * Pull the ieee80211 header + IV to be able to use TSO core,
+	 * Pull the ieee80211 header to be able to use TSO core,
 	 * we will restore it for the tx_status flow.
 	 */
-	skb_pull(skb, hdr_len + iv_len);
+	skb_pull(skb, hdr_len);
 
 	/*
 	 * Remove the length of all the headers that we don't actually
@@ -365,8 +359,8 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 		}
 	}
 
-	/* re -add the WiFi header and IV */
-	skb_push(skb, hdr_len + iv_len);
+	/* re -add the WiFi header */
+	skb_push(skb, hdr_len);
 
 	return 0;
 
-- 
2.20.1



