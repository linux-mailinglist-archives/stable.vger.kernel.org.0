Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22439CD70A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfJFRvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8477521D56;
        Sun,  6 Oct 2019 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383944;
        bh=qM3PEEnWMa2iOxubfqWEcdDHC4Vu51bGICgjCStkxto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ra5bLSI8ZNzQgXK2Q2vjtn2EjNRo4gdwCos2bd8FDTzFCANsv471y9GR2rRJZnYo6
         zOLF7Seswb3bWUVJdBA9xb5MYep3fWQhGVOCE4u+XxDkMjkA5sA0r8/vBJlkzzGXdz
         EoRwyG+7wqG8rc+ZHkxjjAmUISAk3uNnxzg5kwWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 153/166] net: dsa: sja1105: Ensure PTP time for rxtstamp reconstruction is not in the past
Date:   Sun,  6 Oct 2019 19:21:59 +0200
Message-Id: <20191006171225.785468470@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit b6f2494d311a19b33b19708543e7ef6dea1de459 ]

Sometimes the PTP synchronization on the switch 'jumps':

  ptp4l[11241.155]: rms    8 max   16 freq -21732 +/-  11 delay   742 +/-   0
  ptp4l[11243.157]: rms    7 max   17 freq -21731 +/-  10 delay   744 +/-   0
  ptp4l[11245.160]: rms 33592410 max 134217731 freq +192422 +/- 8530253 delay   743 +/-   0
  ptp4l[11247.163]: rms 811631 max 964131 freq +10326 +/- 557785 delay   743 +/-   0
  ptp4l[11249.166]: rms 261936 max 533876 freq -304323 +/- 126371 delay   744 +/-   0
  ptp4l[11251.169]: rms 48700 max 57740 freq -20218 +/- 30532 delay   744 +/-   0
  ptp4l[11253.171]: rms 14570 max 30163 freq  -5568 +/- 7563 delay   742 +/-   0
  ptp4l[11255.174]: rms 2914 max 3440 freq -22001 +/- 1667 delay   744 +/-   1
  ptp4l[11257.177]: rms  811 max 1710 freq -22653 +/- 451 delay   744 +/-   1
  ptp4l[11259.180]: rms  177 max  218 freq -21695 +/-  89 delay   741 +/-   0
  ptp4l[11261.182]: rms   45 max   92 freq -21677 +/-  32 delay   742 +/-   0
  ptp4l[11263.186]: rms   14 max   32 freq -21733 +/-  11 delay   742 +/-   0
  ptp4l[11265.188]: rms    9 max   14 freq -21725 +/-  12 delay   742 +/-   0
  ptp4l[11267.191]: rms    9 max   16 freq -21727 +/-  13 delay   742 +/-   0
  ptp4l[11269.194]: rms    6 max   15 freq -21726 +/-   9 delay   743 +/-   0
  ptp4l[11271.197]: rms    8 max   15 freq -21728 +/-  11 delay   743 +/-   0
  ptp4l[11273.200]: rms    6 max   12 freq -21727 +/-   8 delay   743 +/-   0
  ptp4l[11275.202]: rms    9 max   17 freq -21720 +/-  11 delay   742 +/-   0
  ptp4l[11277.205]: rms    9 max   18 freq -21725 +/-  12 delay   742 +/-   0

Background: the switch only offers partial RX timestamps (24 bits) and
it is up to the driver to read the PTP clock to fill those timestamps up
to 64 bits. But the PTP clock readout needs to happen quickly enough (in
0.135 seconds, in fact), otherwise the PTP clock will wrap around 24
bits, condition which cannot be detected.

Looking at the 'max 134217731' value on output line 3, one can see that
in hex it is 0x8000003. Because the PTP clock resolution is 8 ns,
that means 0x1000000 in ticks, which is exactly 2^24. So indeed this is
a PTP clock wraparound, but the reason might be surprising.

What is going on is that sja1105_tstamp_reconstruct(priv, now, ts)
expects a "now" time that is later than the "ts" was snapshotted at.
This, of course, is obvious: we read the PTP time _after_ the partial RX
timestamp was received. However, the workqueue is processing frames from
a skb queue and reuses the same PTP time, read once at the beginning.
Normally the skb queue only contains one frame and all goes well. But
when the skb queue contains two frames, the second frame that gets
dequeued might have been partially timestamped by the RX MAC _after_ we
had read our PTP time initially.

The code was originally like that due to concerns that SPI access for
PTP time readout is a slow process, and we are time-constrained anyway
(aka: premature optimization). But some timing analysis reveals that the
time spent until the RX timestamp is completely reconstructed is 1 order
of magnitude lower than the 0.135 s deadline even under worst-case
conditions. So we can afford to read the PTP time for each frame in the
RX timestamping queue, which of course ensures that the full PTP time is
in the partial timestamp's future.

Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1986,12 +1986,12 @@ static void sja1105_rxtstamp_work(struct
 
 	mutex_lock(&priv->ptp_lock);
 
-	now = priv->tstamp_cc.read(&priv->tstamp_cc);
-
 	while ((skb = skb_dequeue(&data->skb_rxtstamp_queue)) != NULL) {
 		struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
 		u64 ts;
 
+		now = priv->tstamp_cc.read(&priv->tstamp_cc);
+
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
 		ts = SJA1105_SKB_CB(skb)->meta_tstamp;


