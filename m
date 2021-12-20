Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5B47ADBD
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbhLTOy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbhLTOwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05FDC08EB25;
        Mon, 20 Dec 2021 06:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7091D611AA;
        Mon, 20 Dec 2021 14:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BBFC36AE7;
        Mon, 20 Dec 2021 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011624;
        bh=PL7atF7u9n3Ahlv3yEYikXcHo/7QbLXdGyN5GTHfztQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIRpomNM14Y3/AeSTRFkLY2/fwHDgmoRDjvliWmMlh9w2nYoxK0zxzu4Cyf1Oau6w
         J9rTJLkp4nFx4cp0IbwVLn2aomXlMnFIoOA4F69Nsr7N3HK+TkaDwHjNwEs4oMZ3X7
         i0l/RH95yCwRNoH8iflIxslg3TV42ZnYKf74berk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 05/99] mac80211: send ADDBA requests using the tid/queue of the aggregation session
Date:   Mon, 20 Dec 2021 15:33:38 +0100
Message-Id: <20211220143029.531281318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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


