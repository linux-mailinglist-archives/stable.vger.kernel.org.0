Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA0396258
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhEaOzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhEaOxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C83D613F5;
        Mon, 31 May 2021 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469529;
        bh=Q6mA6D0soW/kCeWiI5cvmV+dDk1a114klHTObJLnEXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdontsgZPH6QX/gfeZfEABrWK9I6XMA12YsJf6Qvy1cv97WU1n9eeKZHQ7N0u/R5E
         fofEYv9Gk2wPhO7lMjBU085ZbrutK3cFvPJu2G6669vL2Vqd1ccD8uTvU+0oxPREM1
         8Zeap6/lVmS3W4RLhlf9KjZYFXEj2uuyGtJrNPNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Richard Sanger <rsanger@wand.net.nz>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 232/296] net: packetmmap: fix only tx timestamp on request
Date:   Mon, 31 May 2021 15:14:47 +0200
Message-Id: <20210531130711.608742062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Sanger <rsanger@wand.net.nz>

[ Upstream commit 171c3b151118a2fe0fc1e2a9d1b5a1570cfe82d2 ]

The packetmmap tx ring should only return timestamps if requested via
setsockopt PACKET_TIMESTAMP, as documented. This allows compatibility
with non-timestamp aware user-space code which checks
tp_status == TP_STATUS_AVAILABLE; not expecting additional timestamp
flags to be set in tp_status.

Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Richard Sanger <rsanger@wand.net.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9611e41c7b8b..c52557ec7fb3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -422,7 +422,8 @@ static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
 	    ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
 		return TP_STATUS_TS_RAW_HARDWARE;
 
-	if (ktime_to_timespec64_cond(skb->tstamp, ts))
+	if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
+	    ktime_to_timespec64_cond(skb->tstamp, ts))
 		return TP_STATUS_TS_SOFTWARE;
 
 	return 0;
@@ -2340,7 +2341,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
 
-	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
+	/* Always timestamp; prefer an existing software timestamp taken
+	 * closer to the time of capture.
+	 */
+	ts_status = tpacket_get_timestamp(skb, &ts,
+					  po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
+	if (!ts_status)
 		ktime_get_real_ts64(&ts);
 
 	status |= ts_status;
-- 
2.30.2



