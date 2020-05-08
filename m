Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5080E1CAC80
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgEHMxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbgEHMxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B056824953;
        Fri,  8 May 2020 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942431;
        bh=56woS8LEI0GUYirpNpsY8qbcbWSMp8QDzGBNhNmOXEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAUIniaX9SC8U1ohSP3sfiTFu8IyFP+Me3ZKNEWO7rXHKanVrDDVNwJvbGg9HuLfI
         OawgPAgWIZh8Qo5eJl2diEDwcmYpMIh8c7eVa+4+lZ0OftPQ8Y8r7E4dUzwCexmfsG
         gjvIevr+qvRxzCHOc/4sHPlbHOKU94zuVUiPXwaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 43/50] mac80211: add ieee80211_is_any_nullfunc()
Date:   Fri,  8 May 2020 14:35:49 +0200
Message-Id: <20200508123049.036844424@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

commit 30b2f0be23fb40e58d0ad2caf8702c2a44cda2e1 upstream.

commit 08a5bdde3812 ("mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED")
Fixed a bug where we failed to take into account a
nullfunc frame can be either non-QoS or QoS. It turns out
there is at least one more bug in
ieee80211_sta_tx_notify(), introduced in
commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing"),
where we forgot to check for the QoS variant and so
assumed the QoS nullfunc frame never went out

Fix this by adding a helper ieee80211_is_any_nullfunc()
which consolidates the check for non-QoS and QoS nullfunc
frames. Replace existing compound conditionals and add a
couple more missing checks for QoS variant.

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20200114055940.18502-3-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ieee80211.h |    9 +++++++++
 net/mac80211/mlme.c       |    2 +-
 net/mac80211/rx.c         |    8 +++-----
 net/mac80211/status.c     |    5 ++---
 net/mac80211/tx.c         |    2 +-
 5 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -620,6 +620,15 @@ static inline bool ieee80211_is_qos_null
 }
 
 /**
+ * ieee80211_is_any_nullfunc - check if frame is regular or QoS nullfunc frame
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline bool ieee80211_is_any_nullfunc(__le16 fc)
+{
+	return (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc));
+}
+
+/**
  * ieee80211_is_bufferable_mmpdu - check if frame is bufferable MMPDU
  * @fc: frame control field in little-endian byteorder
  */
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2460,7 +2460,7 @@ void ieee80211_sta_tx_notify(struct ieee
 	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
-	if (ieee80211_is_nullfunc(hdr->frame_control) &&
+	if (ieee80211_is_any_nullfunc(hdr->frame_control) &&
 	    sdata->u.mgd.probe_send_count > 0) {
 		if (ack)
 			ieee80211_sta_reset_conn_monitor(sdata);
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1450,8 +1450,7 @@ ieee80211_rx_h_check_dup(struct ieee8021
 		return RX_CONTINUE;
 
 	if (ieee80211_is_ctl(hdr->frame_control) ||
-	    ieee80211_is_nullfunc(hdr->frame_control) ||
-	    ieee80211_is_qos_nullfunc(hdr->frame_control) ||
+	    ieee80211_is_any_nullfunc(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1))
 		return RX_CONTINUE;
 
@@ -1838,8 +1837,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
 	 */
-	if (ieee80211_is_nullfunc(hdr->frame_control) ||
-	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+	if (ieee80211_is_any_nullfunc(hdr->frame_control)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_nullfunc);
 
 		/*
@@ -2319,7 +2317,7 @@ static int ieee80211_drop_unencrypted(st
 
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!ieee80211_has_protected(fc) &&
-		     !ieee80211_is_nullfunc(fc) &&
+		     !ieee80211_is_any_nullfunc(fc) &&
 		     ieee80211_is_data(fc) && rx->key))
 		return -EACCES;
 
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -643,8 +643,7 @@ static void ieee80211_report_ack_skb(str
 		rcu_read_lock();
 		sdata = ieee80211_sdata_from_skb(local, skb);
 		if (sdata) {
-			if (ieee80211_is_nullfunc(hdr->frame_control) ||
-			    ieee80211_is_qos_nullfunc(hdr->frame_control))
+			if (ieee80211_is_any_nullfunc(hdr->frame_control))
 				cfg80211_probe_status(sdata->dev, hdr->addr1,
 						      cookie, acked,
 						      info->status.ack_signal,
@@ -1030,7 +1029,7 @@ static void __ieee80211_tx_status(struct
 			I802_DEBUG_INC(local->dot11FailedCount);
 	}
 
-	if ((ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
+	if (ieee80211_is_any_nullfunc(fc) &&
 	    ieee80211_has_pm(fc) &&
 	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -297,7 +297,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
 	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
 	    !ieee80211_is_probe_req(hdr->frame_control) &&
-	    !ieee80211_is_nullfunc(hdr->frame_control))
+	    !ieee80211_is_any_nullfunc(hdr->frame_control))
 		/*
 		 * When software scanning only nullfunc frames (to notify
 		 * the sleep state to the AP) and probe requests (for the


