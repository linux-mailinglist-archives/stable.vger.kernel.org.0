Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF86447AD22
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhLTOuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhLTOr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A483FC07E5DC;
        Mon, 20 Dec 2021 06:44:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA40B80EE6;
        Mon, 20 Dec 2021 14:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91FBC36AE8;
        Mon, 20 Dec 2021 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011454;
        bh=PL7atF7u9n3Ahlv3yEYikXcHo/7QbLXdGyN5GTHfztQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx6eSKViQY3zOsWlSZYwN30P3eBOXgcDQEfSUTV5IOZ0fGOTpbt4CSVb5802ngoAS
         P+DZox/+GLSaavgwF80TATJcY8Xty4FPFWHMUIaTHaW5yBhajvFzBR76D4zX7aVBvH
         LbHHnmPMR15HSQUE2iz89XZxF2VcUVoisrvZVnYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 03/71] mac80211: send ADDBA requests using the tid/queue of the aggregation session
Date:   Mon, 20 Dec 2021 15:33:52 +0100
Message-Id: <20211220143025.795976688@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 1fe98f5690c4219d419ea9cc190f94b3401cf324 upstream.

Sending them out on a different queue can cause a race condition where a
number of packets in the queue may be discarded by the receiver, because
the ADDBA request is sent too early.
This affects any driver with software A-MPDU setup which does not allocate
packet seqno in hardware on tx, regardless of whether iTXQ is used or not.
The only driver I've seen that explicitly deals with this issue internally
is mwl8k.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20211202124533.80388-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/agg-tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -106,7 +106,7 @@ static void ieee80211_send_addba_request
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)


