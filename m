Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034FB382EA4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbhEQOJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237931AbhEQOH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC148611ED;
        Mon, 17 May 2021 14:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260385;
        bh=eRQv70/rNK0L19ExA/Yr0MbrNbSgIIBgiMbTNbkG54c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXaUhsLf68MJPHMVh5YJ6O0d0Kly/LFBKCpaZ5p3YAPGPgKfTqWzn9wuPV+hRXvVQ
         sieQyDeAu9ej6b8o2dwVfwqchpoPtrUJ5dw72a7HUVdplwzZz4GYGBDu+i8kVCHodR
         aR0UW4g8HdxN+334r02ghE4bVioTr0OcI4vJNdy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 056/363] mac80211: Set priority and queue mapping for injected frames
Date:   Mon, 17 May 2021 15:58:42 +0200
Message-Id: <20210517140304.508044967@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 96a7109a16665255b65d021e24141c2edae0e202 ]

Some drivers, for example mt76, use the skb priority field, and
expects that to be consistent with the skb queue mapping. On some
frame injection code paths that was not true, and it broke frame
injection. Now the skb queue mapping is set according to the skb
priority value when the frame is injected. The skb priority value
is also derived from the frame data for all frame types, as it
was done prior to commit dbd50a851c50 (only allocate one queue
when using iTXQs). Fixes frame injection with the mt76 driver on
MT7610E chipset.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Link: https://lore.kernel.org/r/20210401164455.978245-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3b3bcefbf657..28422d687096 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2267,17 +2267,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 						    payload[7]);
 	}
 
-	/* Initialize skb->priority for QoS frames. If the DONT_REORDER flag
-	 * is set, stick to the default value for skb->priority to assure
-	 * frames injected with this flag are not reordered relative to each
-	 * other.
-	 */
-	if (ieee80211_is_data_qos(hdr->frame_control) &&
-	    !(info->control.flags & IEEE80211_TX_CTRL_DONT_REORDER)) {
-		u8 *p = ieee80211_get_qos_ctl(hdr);
-		skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
-	}
-
 	rcu_read_lock();
 
 	/*
@@ -2341,6 +2330,15 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	info->band = chandef->chan->band;
 
+	/* Initialize skb->priority according to frame type and TID class,
+	 * with respect to the sub interface that the frame will actually
+	 * be transmitted on. If the DONT_REORDER flag is set, the original
+	 * skb-priority is preserved to assure frames injected with this
+	 * flag are not reordered relative to each other.
+	 */
+	ieee80211_select_queue_80211(sdata, skb, hdr);
+	skb_set_queue_mapping(skb, ieee80211_ac_from_tid(skb->priority));
+
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
-- 
2.30.2



