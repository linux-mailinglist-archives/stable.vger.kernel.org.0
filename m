Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FAF148208
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391298AbgAXLYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390795AbgAXLYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:46 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3869820704;
        Fri, 24 Jan 2020 11:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865085;
        bh=INEsZP7PXDWtOvMsGz1Rlra28S6OdJ1WEjF2pXAB404=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIr2Lfp5pkAUfycHu53p7Bo8nnvZcgP6cbU0TWDpBCiikiU4WlyzP4+Afhit+SbYH
         UpTxHjB2Xt5/Fs/vw8vyEAfZ8E/cryDsdaMy561U6qXHpleU1cz5h9hNlFrE1PiGJx
         p5ym9o/nxs6Isas8b6HilDys9oHKS2H+sTJmpeCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fred Klassen <fklassen@appneta.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 436/639] net/udp_gso: Allow TX timestamp with UDP GSO
Date:   Fri, 24 Jan 2020 10:30:06 +0100
Message-Id: <20200124093141.620234674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fred Klassen <fklassen@appneta.com>

[ Upstream commit 76e21533a48bb42d1fa894f93f6233bf4554f45e ]

Fixes an issue where TX Timestamps are not arriving on the error queue
when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
This can be illustrated with an updated updgso_bench_tx program which
includes the '-T' option to test for this condition. It also introduces
the '-P' option which will call poll() before reading the error queue.

    ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
    poll timeout
    udp tx:      0 MB/s        1 calls/s      1 msg/s

The "poll timeout" message above indicates that TX timestamp never
arrived.

This patch preserves tx_flags for the first UDP GSO segment. Only the
first segment is timestamped, even though in some cases there may be
benefital in timestamping both the first and last segment.

Factors in deciding on first segment timestamp only:

- Timestamping both first and last segmented is not feasible. Hardware
can only have one outstanding TS request at a time.

- Timestamping last segment may under report network latency of the
previous segments. Even though the doorbell is suppressed, the ring
producer counter has been incremented.

- Timestamping the first segment has the upside in that it reports
timestamps from the application's view, e.g. RTT.

- Timestamping the first segment has the downside that it may
underreport tx host network latency. It appears that we have to pick
one or the other. And possibly follow-up with a config flag to choose
behavior.

v2: Remove tests as noted by Willem de Bruijn <willemb@google.com>
    Moving tests from net to net-next

v3: Update only relevant tx_flag bits as per
    Willem de Bruijn <willemb@google.com>

v4: Update comments and commit message as per
    Willem de Bruijn <willemb@google.com>

Fixes: ee80d1ebe5ba ("udp: add udp gso")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 0c0522b79b43f..aa343654abfc0 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -227,6 +227,11 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	seg = segs;
 	uh = udp_hdr(seg);
 
+	/* preserve TX timestamp flags and TS key for first segment */
+	skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
+	skb_shinfo(seg)->tx_flags |=
+			(skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP);
+
 	/* compute checksum adjustment based on old length versus new */
 	newlen = htons(sizeof(*uh) + mss);
 	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
-- 
2.20.1



