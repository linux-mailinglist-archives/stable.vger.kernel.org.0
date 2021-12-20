Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5FB47ABD1
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhLTOjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:39:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhLTOij (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3610B80EE0;
        Mon, 20 Dec 2021 14:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B601C36AE8;
        Mon, 20 Dec 2021 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011117;
        bh=vxQGH/F4L0g0ZYb8bm4uKhQSh35ghDEjnnb1g0JrjfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKAiNchsvpRtqDtTDKf1Kij2S2cEW0+eLeN2JGBsW1A2enEA8WNxQ1bvmQaWhs+j5
         JdpO+GpbUKqJSHQBayQdtE4BrrIGg72/Ru+s27hgSeV+j/TDGMLmwm3+m9fgs5Z9hD
         57EYlzCBJdyuFDxrGoCVYf3gb88mxBnpoxoI1E/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 10/45] mac80211: send ADDBA requests using the tid/queue of the aggregation session
Date:   Mon, 20 Dec 2021 15:34:05 +0100
Message-Id: <20211220143022.608658706@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
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


