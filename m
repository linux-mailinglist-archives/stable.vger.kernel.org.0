Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3447AC32
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhLTOmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:42:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhLTOks (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:40:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DC0BB80EDA;
        Mon, 20 Dec 2021 14:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FEC36AEA;
        Mon, 20 Dec 2021 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011246;
        bh=vxQGH/F4L0g0ZYb8bm4uKhQSh35ghDEjnnb1g0JrjfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eLtSqxI0kWJmK8bH/aw5J3kMg5ZC2IV3b0PieB8SXNWxr/9c1oclfofDIJ/2ZgrW
         PorrcVGhoDyI1rg8BD32SgeaZPq9L9eBuCS/cIRJmRdZp2KjzUC/aMFWBNjf9WHpGA
         bGWnZd0xf2l6lWULUeume8hIkIrTYLRBGmFePM9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 10/56] mac80211: send ADDBA requests using the tid/queue of the aggregation session
Date:   Mon, 20 Dec 2021 15:34:03 +0100
Message-Id: <20211220143023.785960074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
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
@@ -109,7 +109,7 @@ static void ieee80211_send_addba_request
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)


