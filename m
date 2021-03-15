Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE533B95D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhCON7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhCON6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5CE864F13;
        Mon, 15 Mar 2021 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816692;
        bh=l+SCoD+9sPzcS+20Dh2UubUyL0fYn9MJQn1R7W7mzGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lze8GsqMGcnpv38jr77dcWza/zyL+A2PnhP/m/0zQUnILzkfTJpo9o4Vz7Q+Wbaiy
         PUAKNZy3QVvKTlTziVMDD5398raweBSiHx3ryk87JwKGAj+t3J5qaBEOXMDSfCeKSK
         Epxbt/R8D9uyd1+62wIiHG02mSO86Efrt0TuMYJc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 059/290] net: enetc: allow hardware timestamping on TX queues with tc-etf enabled
Date:   Mon, 15 Mar 2021 14:52:32 +0100
Message-Id: <20210315135543.920115349@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -384,6 +384,12 @@ static void enetc_tstamp_tx(struct sk_bu
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


