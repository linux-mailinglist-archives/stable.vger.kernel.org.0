Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99AA2B614D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgKQNR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730626AbgKQNRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:17:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C70206D5;
        Tue, 17 Nov 2020 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619075;
        bh=NDPKSAD52SgAlMx77kp/2Gk0mOp4yqDn6IjkPkSJRsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCOm22BR2JGxMYgkVrqIWxk4JkJtECRXSKx2aIEsZFz622Eur9jHbeeYkAI5/Fw7h
         PzzCtlSD/1hcpGkZFci8HzWA5EjEp5mbiKL9dqRg8slDidL4+RyrV5WfASLESQDxdQ
         95za8d7e9uYdufD54k690vHS4IJB9QBFWsRl2+LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabian Inostroza <fabianinostrozap@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/101] can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
Date:   Tue, 17 Nov 2020 14:04:47 +0100
Message-Id: <20201117122114.081392035@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

[ Upstream commit ecc7b4187dd388549544195fb13a11b4ea8e6a84 ]

Fabian Inostroza <fabianinostrozap@gmail.com> has discovered a potential
problem in the hardware timestamp reporting from the PCAN-USB USB CAN interface
(only), related to the fact that a timestamp of an event may precede the
timestamp used for synchronization when both records are part of the same USB
packet. However, this case was used to detect the wrapping of the time counter.

This patch details and fixes the two identified cases where this problem can
occur.

Reported-by: Fabian Inostroza <fabianinostrozap@gmail.com>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Link: https://lore.kernel.org/r/20201014085631.15128-1-s.grosjean@peak-system.com
Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 51 ++++++++++++++++++--
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index afc8d978124ef..db156a11e6db5 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -138,14 +138,55 @@ void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *time)
 	/* protect from getting time before setting now */
 	if (ktime_to_ns(time_ref->tv_host)) {
 		u64 delta_us;
+		s64 delta_ts = 0;
+
+		/* General case: dev_ts_1 < dev_ts_2 < ts, with:
+		 *
+		 * - dev_ts_1 = previous sync timestamp
+		 * - dev_ts_2 = last sync timestamp
+		 * - ts = event timestamp
+		 * - ts_period = known sync period (theoretical)
+		 *             ~ dev_ts2 - dev_ts1
+		 * *but*:
+		 *
+		 * - time counters wrap (see adapter->ts_used_bits)
+		 * - sometimes, dev_ts_1 < ts < dev_ts2
+		 *
+		 * "normal" case (sync time counters increase):
+		 * must take into account case when ts wraps (tsw)
+		 *
+		 *      < ts_period > <          >
+		 *     |             |            |
+		 *  ---+--------+----+-------0-+--+-->
+		 *     ts_dev_1 |    ts_dev_2  |
+		 *              ts             tsw
+		 */
+		if (time_ref->ts_dev_1 < time_ref->ts_dev_2) {
+			/* case when event time (tsw) wraps */
+			if (ts < time_ref->ts_dev_1)
+				delta_ts = 1 << time_ref->adapter->ts_used_bits;
+
+		/* Otherwise, sync time counter (ts_dev_2) has wrapped:
+		 * handle case when event time (tsn) hasn't.
+		 *
+		 *      < ts_period > <          >
+		 *     |             |            |
+		 *  ---+--------+--0-+---------+--+-->
+		 *     ts_dev_1 |    ts_dev_2  |
+		 *              tsn            ts
+		 */
+		} else if (time_ref->ts_dev_1 < ts) {
+			delta_ts = -(1 << time_ref->adapter->ts_used_bits);
+		}
 
-		delta_us = ts - time_ref->ts_dev_2;
-		if (ts < time_ref->ts_dev_2)
-			delta_us &= (1 << time_ref->adapter->ts_used_bits) - 1;
+		/* add delay between last sync and event timestamps */
+		delta_ts += (signed int)(ts - time_ref->ts_dev_2);
 
-		delta_us += time_ref->ts_total;
+		/* add time from beginning to last sync */
+		delta_ts += time_ref->ts_total;
 
-		delta_us *= time_ref->adapter->us_per_ts_scale;
+		/* convert ticks number into microseconds */
+		delta_us = delta_ts * time_ref->adapter->us_per_ts_scale;
 		delta_us >>= time_ref->adapter->us_per_ts_shift;
 
 		*time = ktime_add_us(time_ref->tv_host_0, delta_us);
-- 
2.27.0



