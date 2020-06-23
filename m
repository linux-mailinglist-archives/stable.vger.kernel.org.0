Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE0205E01
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388831AbgFWUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389728AbgFWUS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E5372064B;
        Tue, 23 Jun 2020 20:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943536;
        bh=c2Uo1Rabt1OgrBwNWL8uOBPetEAqwed41bc3ef7uxDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSLDkMsrY2YvZ/Dmw6KLF2BpZBixIj7SqbG2GK27KU6toviZ+glcvGFv4/hi4dVAD
         tehEjblczHNioy0MJj7qLfakPhtViu0jcbageNxGfge9EXlvwryEINb1uVXC7WTBu6
         DqvOu99C6oB/FYOdzeHc4RR11DSi7HOAzVX1352Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 403/477] net: dsa: sja1105: fix PTP timestamping with large tc-taprio cycles
Date:   Tue, 23 Jun 2020 21:56:40 +0200
Message-Id: <20200623195426.580029300@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c92cbaea3cc0a80807e386922f801eb6d3652c81 ]

It isn't actually described clearly at all in UM10944.pdf, but on TX of
a management frame (such as PTP), this needs to happen:

- The destination MAC address (i.e. 01-80-c2-00-00-0e), along with the
  desired destination port, need to be installed in one of the 4
  management slots of the switch, over SPI.
- The host can poll over SPI for that management slot's ENFPORT field.
  That gets unset when the switch has matched the slot to the frame.

And therein lies the problem. ENFPORT does not mean that the packet has
been transmitted. Just that it has been received over the CPU port, and
that the mgmt slot is yet again available.

This is relevant because of what we are doing in sja1105_ptp_txtstamp_skb,
which is called right after sja1105_mgmt_xmit. We are in a hard
real-time deadline, since the hardware only gives us 24 bits of TX
timestamp, so we need to read the full PTP clock to reconstruct it.
Because we're in a hurry (in an attempt to make sure that we have a full
64-bit PTP time which is as close as possible to the actual transmission
time of the frame, to avoid 24-bit wraparounds), first we read the PTP
clock, then we poll for the TX timestamp to become available.

But of course, we don't know for sure that the frame has been
transmitted when we read the full PTP clock. We had assumed that ENFPORT
means it has, but the assumption is incorrect. And while in most
real-life scenarios this has never been caught due to software delays,
nowhere is this fact more obvious than with a tc-taprio offload, where
PTP traffic gets a small timeslot very rarely (example: 1 packet per 10
ms). In that case, we will be reading the PTP clock for timestamp
reconstruction too early (before the packet has been transmitted), and
this renders the reconstruction procedure incorrect (see the assumptions
described in the comments found on function sja1105_tstamp_reconstruct).
So the PTP TX timestamps will be off by 1<<24 clock ticks, or 135 ms
(1 tick is 8 ns).

So fix this case of premature optimization by simply reordering the
sja1105_ptpegr_ts_poll and the sja1105_ptpclkval_read function calls. It
turns out that in practice, the 135 ms hard deadline for PTP timestamp
wraparound is not so hard, since even the most bandwidth-intensive PTP
profiles, such as 802.1AS-2011, have a sync frame interval of 125 ms.
So if we couldn't deliver a timestamp in 135 ms (which we can), we're
toast and have much bigger problems anyway.

Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index bc0e47c1dbb9b..1771345964580 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -891,16 +891,16 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int port,
 
 	mutex_lock(&ptp_data->lock);
 
-	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
+	rc = sja1105_ptpegr_ts_poll(ds, port, &ts);
 	if (rc < 0) {
-		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
+		dev_err(ds->dev, "timed out polling for tstamp\n");
 		kfree_skb(skb);
 		goto out;
 	}
 
-	rc = sja1105_ptpegr_ts_poll(ds, port, &ts);
+	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
 	if (rc < 0) {
-		dev_err(ds->dev, "timed out polling for tstamp\n");
+		dev_err(ds->dev, "Failed to read PTP clock: %d\n", rc);
 		kfree_skb(skb);
 		goto out;
 	}
-- 
2.25.1



