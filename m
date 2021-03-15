Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367AA33B6F8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhCON7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232262AbhCON6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8CD64F0C;
        Mon, 15 Mar 2021 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816696;
        bh=8xBIHKGi36KsqUwk6+5ujil96Cd17m+OsJBBrQQ0Npg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPKx1nj60XJtrzroapeHFeD95AxV1+/k/Daq+LPHM1OTQYHE3RcSfiXZRRCvhZ0wI
         lV9CoOqqa3fmBWza0jnu7L1KfJGw1F4wY6gUWOB86q1wNvbas6w4vG3/YlFDcaC9uw
         Lm3b5DhRfhjoAMz6rKQXlsl8o+2ALFRxlForpLOU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 070/306] net: enetc: allow hardware timestamping on TX queues with tc-etf enabled
Date:   Mon, 15 Mar 2021 14:52:13 +0100
Message-Id: <20210315135510.012734740@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 29d98f54a4fe1b6a9089bec8715a1b89ff9ad59c upstream.

The txtime is passed to the driver in skb->skb_mstamp_ns, which is
actually in a union with skb->tstamp (the place where software
timestamps are kept).

Since commit b50a5c70ffa4 ("net: allow simultaneous SW and HW transmit
timestamping"), __sock_recv_timestamp has some logic for making sure
that the two calls to skb_tstamp_tx:

skb_tx_timestamp(skb) # Software timestamp in the driver
-> skb_tstamp_tx(skb, NULL)

and

skb_tstamp_tx(skb, &shhwtstamps) # Hardware timestamp in the driver

will both do the right thing and in a race-free manner, meaning that
skb_tx_timestamp will deliver a cmsg with the software timestamp only,
and skb_tstamp_tx with a non-NULL hwtstamps argument will deliver a cmsg
with the hardware timestamp only.

Why are races even possible? Well, because although the software timestamp
skb->tstamp is private per skb, the hardware timestamp skb_hwtstamps(skb)
lives in skb_shinfo(skb), an area which is shared between skbs and their
clones. And skb_tstamp_tx works by cloning the packets when timestamping
them, therefore attempting to perform hardware timestamping on an skb's
clone will also change the hardware timestamp of the original skb. And
the original skb might have been yet again cloned for software
timestamping, at an earlier stage.

So the logic in __sock_recv_timestamp can't be as simple as saying
"does this skb have a hardware timestamp? if yes I'll send the hardware
timestamp to the socket, otherwise I'll send the software timestamp",
precisely because the hardware timestamp is shared.
Instead, it's quite the other way around: __sock_recv_timestamp says
"does this skb have a software timestamp? if yes, I'll send the software
timestamp, otherwise the hardware one". This works because the software
timestamp is not shared with clones.

But that means we have a problem when we attempt hardware timestamping
with skbs that don't have the skb->tstamp == 0. __sock_recv_timestamp
will say "oh, yeah, this must be some sort of odd clone" and will not
deliver the hardware timestamp to the socket. And this is exactly what
is happening when we have txtime enabled on the socket: as mentioned,
that is put in a union with skb->tstamp, so it is quite easy to mistake
it.

Do what other drivers do (intel igb/igc) and write zero to skb->tstamp
before taking the hardware timestamp. It's of no use to us now (we're
already on the TX confirmation path).

Fixes: 0d08c9ec7d6e ("enetc: add support time specific departure base on the qos etf")
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -344,6 +344,12 @@ static void enetc_tstamp_tx(struct sk_bu
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+		/* Ensure skb_mstamp_ns, which might have been populated with
+		 * the txtime, is not mistaken for a software timestamp,
+		 * because this will prevent the dispatch of our hardware
+		 * timestamp to the socket.
+		 */
+		skb->tstamp = ktime_set(0, 0);
 		skb_tstamp_tx(skb, &shhwtstamps);
 	}
 }


