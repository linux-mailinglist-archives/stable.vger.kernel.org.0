Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02619AFB5
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbgDAQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732943AbgDAQU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C653120658;
        Wed,  1 Apr 2020 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758026;
        bh=d6VKuddZD86LFfUIk9GqNfHzWMUmnWM9/G4hQecQH5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btHH2dDdnZ+faT1W2865E94WCOM/7g1nt8pf2HfF4R/OsfQPdqoqSZVqYbDktojT8
         0K0PZCBZItx/0cjwme7gqeDLnrOuSz7zyRXotes709lkrRAx+C1EEe7U65D9vhTE+/
         Eft3O0NzaNuS5U2wl/+1woCg2RafItaA7L/A+OP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 02/30] mac80211: Check port authorization in the ieee80211_tx_dequeue() case
Date:   Wed,  1 Apr 2020 18:17:06 +0200
Message-Id: <20200401161416.929794261@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit ce2e1ca703071723ca2dd94d492a5ab6d15050da upstream.

mac80211 used to check port authorization in the Data frame enqueue case
when going through start_xmit(). However, that authorization status may
change while the frame is waiting in a queue. Add a similar check in the
dequeue case to avoid sending previously accepted frames after
authorization change. This provides additional protection against
potential leaking of frames after a station has been disconnected and
the keys for it are being removed.

Cc: stable@vger.kernel.org
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3604,8 +3604,25 @@ begin:
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta)
+	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
+		/*
+		 * Drop unicast frames to unauthorised stations unless they are
+		 * EAPOL frames from the local station.
+		 */
+		if (unlikely(!ieee80211_vif_is_mesh(&tx.sdata->vif) &&
+			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
+			     !is_multicast_ether_addr(hdr->addr1) &&
+			     !test_sta_flag(tx.sta, WLAN_STA_AUTHORIZED) &&
+			     (!(info->control.flags &
+				IEEE80211_TX_CTRL_PORT_CTRL_PROTO) ||
+			      !ether_addr_equal(tx.sdata->vif.addr,
+						hdr->addr2)))) {
+			I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
+			ieee80211_free_txskb(&local->hw, skb);
+			goto begin;
+		}
+	}
 
 	/*
 	 * The key can be removed while the packet was queued, so need to call


