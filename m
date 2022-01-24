Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AC949A071
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384021AbiAXXHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841091AbiAXW5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:57:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA85FC055ABE;
        Mon, 24 Jan 2022 13:12:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B8A66147D;
        Mon, 24 Jan 2022 21:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506B0C340E5;
        Mon, 24 Jan 2022 21:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058720;
        bh=RLQt645kFXrizzQINI9AoTr4vJ0Bgr5GYFhh/k5hya0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnEOIYi8EPGNwvbEhbseyNOl7+paVpl9TdrCp6r/4fyZIIyhq5lL1zlyz8jRlqPo6
         xoZmCEoHtP6rkeTHOM8gCPt6qt+vIPT2f/RbmJeq9oKpZjBdKVq8zhlQSUffy5o7rI
         iCwc/jia0U+5DtJUDKQKLk7eaQxFsDOLvefXz8Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0381/1039] net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets
Date:   Mon, 24 Jan 2022 19:36:10 +0100
Message-Id: <20220124184138.119678932@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 007747a984ea5e895b7d8b056b24ebf431e1e71d ]

When multiple sockets using the SOF_TIMESTAMPING_BIND_PHC flag received
a packet with a hardware timestamp (e.g. multiple PTP instances in
different PTP domains using the UDPv4/v6 multicast or L2 transport),
the timestamps received on some sockets were corrupted due to repeated
conversion of the same timestamp (by the same or different vclocks).

Fix ptp_convert_timestamp() to not modify the shared skb timestamp
and return the converted timestamp as a ktime_t instead. If the
conversion fails, return 0 to not confuse the application with
timestamps corresponding to an unexpected PHC.

Fixes: d7c088265588 ("net: socket: support hardware timestamp conversion to PHC bound")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vclock.c         | 10 +++++-----
 include/linux/ptp_clock_kernel.h | 12 +++++++-----
 net/socket.c                     |  9 ++++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index baee0379482bc..ab1d233173e13 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -185,8 +185,8 @@ out:
 }
 EXPORT_SYMBOL(ptp_get_vclocks_index);
 
-void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-			   int vclock_index)
+ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+			      int vclock_index)
 {
 	char name[PTP_CLOCK_NAME_LEN] = "";
 	struct ptp_vclock *vclock;
@@ -198,12 +198,12 @@ void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
 	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", vclock_index);
 	dev = class_find_device_by_name(ptp_class, name);
 	if (!dev)
-		return;
+		return 0;
 
 	ptp = dev_get_drvdata(dev);
 	if (!ptp->is_virtual_clock) {
 		put_device(dev);
-		return;
+		return 0;
 	}
 
 	vclock = info_to_vclock(ptp->info);
@@ -215,7 +215,7 @@ void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
 	spin_unlock_irqrestore(&vclock->lock, flags);
 
 	put_device(dev);
-	hwtstamps->hwtstamp = ns_to_ktime(ns);
+	return ns_to_ktime(ns);
 }
 EXPORT_SYMBOL(ptp_convert_timestamp);
 #endif
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 2e5565067355b..554454cb86931 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -351,15 +351,17 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
  *
  * @hwtstamps:    skb_shared_hwtstamps structure pointer
  * @vclock_index: phc index of ptp vclock.
+ *
+ * Returns converted timestamp, or 0 on error.
  */
-void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-			   int vclock_index);
+ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+			      int vclock_index);
 #else
 static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 { return 0; }
-static inline void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-					 int vclock_index)
-{ }
+static inline ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+					    int vclock_index)
+{ return 0; }
 
 #endif
 
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63f..5053eb0100e48 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -829,6 +829,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	int empty = 1, false_tstamp = 0;
 	struct skb_shared_hwtstamps *shhwtstamps =
 		skb_hwtstamps(skb);
+	ktime_t hwtstamp;
 
 	/* Race occurred between timestamp enabling and packet
 	   receiving.  Fill in the current time for now. */
@@ -877,10 +878,12 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			ptp_convert_timestamp(shhwtstamps, sk->sk_bind_phc);
+			hwtstamp = ptp_convert_timestamp(shhwtstamps,
+							 sk->sk_bind_phc);
+		else
+			hwtstamp = shhwtstamps->hwtstamp;
 
-		if (ktime_to_timespec64_cond(shhwtstamps->hwtstamp,
-					     tss.ts + 2)) {
+		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
 
 			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
-- 
2.34.1



