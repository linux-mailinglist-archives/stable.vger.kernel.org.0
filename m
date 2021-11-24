Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6587645C628
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353856AbhKXOFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353854AbhKXOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B22613D5;
        Wed, 24 Nov 2021 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759425;
        bh=GEtDmeKQnJJLO4FbMcsiFwX34oq/kU66muHkCl0pqsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNrpaebed22Rj+sb/KqYqtmbkKTxFuapZ8YgrOg79XMzxIddW18S94zdxp5Vr2OEs
         3XemTp0v6TMrw/2NmA4hQn+/CgvEFfl+jbkGHFp+6U/woX9pejf7ahfb9yunt83f2A
         KUm8oYBuBSFqN92sPKfV3pP2wCdxVlU9373JUbN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 238/279] mac80211: drop check for DONT_REORDER in __ieee80211_select_queue
Date:   Wed, 24 Nov 2021 12:58:45 +0100
Message-Id: <20211124115726.961480964@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit f6ab25d41b18f3d26883cb9c20875e1a85c4f05b upstream.

When __ieee80211_select_queue is called, skb->cb has not been cleared yet,
which means that info->control.flags can contain garbage.
In some cases this leads to IEEE80211_TX_CTRL_DONT_REORDER being set, causing
packets marked for other queues to randomly end up in BE instead.

This flag only needs to be checked in ieee80211_select_queue_80211, since
the radiotap parser is the only piece of code that sets it

Fixes: 66d06c84730c ("mac80211: adhere to Tx control flag that prevents frame reordering")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20211110212201.35452-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/wme.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -143,7 +143,6 @@ u16 ieee80211_select_queue_80211(struct
 u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta, struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
@@ -156,7 +155,7 @@ u16 __ieee80211_select_queue(struct ieee
 	else
 		qos = false;
 
-	if (!qos || (info->control.flags & IEEE80211_TX_CTRL_DONT_REORDER)) {
+	if (!qos) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
 		return IEEE80211_AC_BE;
 	}


