Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF5E74677
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfGYFwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404384AbfGYFkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:40:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A122C22BEB;
        Thu, 25 Jul 2019 05:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033230;
        bh=bvC6FSodImCU9kv/a3YnWaIXPQ0HpUZhJp5QuxXzYO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOMqZmS5RAbcIB0qRjuFjECWfZWWIbO4cT/ovv2+Qscn1go8ehVWe7MVR52Fmy9ob
         EvJSEno+zsq4UHv6H2XTF6fCYiNGTbd4Xl+Ffm8MVq8g9r2fNZKoVGAObHsAEngE5x
         +/qfxZMBZwQzi221bLYgIFhgG1LEAMqHKIY/VXnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Przemyslaw Hausman <przemyslaw.hausman@canonical.com>
Subject: [PATCH 4.19 138/271] bnx2x: Prevent ptp_task to be rescheduled indefinitely
Date:   Wed, 24 Jul 2019 21:20:07 +0200
Message-Id: <20190724191707.033952924@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3c91f25c2f72ba6001775a5932857c1d2131c531 ]

Currently bnx2x ptp worker tries to read a register with timestamp
information in case of TX packet timestamping and in case it fails,
the routine reschedules itself indefinitely. This was reported as a
kworker always at 100% of CPU usage, which was narrowed down to be
bnx2x ptp_task.

By following the ioctl handler, we could narrow down the problem to
an NTP tool (chrony) requesting HW timestamping from bnx2x NIC with
RX filter zeroed; this isn't reproducible for example with ptp4l
(from linuxptp) since this tool requests a supported RX filter.
It seems NIC FW timestamp mechanism cannot work well with
RX_FILTER_NONE - driver's PTP filter init routine skips a register
write to the adapter if there's not a supported filter request.

This patch addresses the problem of bnx2x ptp thread's everlasting
reschedule by retrying the register read 10 times; between the read
attempts the thread sleeps for an increasing amount of time starting
in 1ms to give FW some time to perform the timestamping. If it still
fails after all retries, we bail out in order to prevent an unbound
resource consumption from bnx2x.

The patch also adds an ethtool statistic for accounting the skipped
TX timestamp packets and it reduces the priority of timestamping
error messages to prevent log flooding. The code was tested using
both linuxptp and chrony.

Reported-and-tested-by: Przemyslaw Hausman <przemyslaw.hausman@canonical.com>
Suggested-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  5 ++-
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  4 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 33 ++++++++++++++-----
 .../net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  3 ++
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 5a727d4729da..e3ce29951c5e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3858,9 +3858,12 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		if (!(bp->flags & TX_TIMESTAMPING_EN)) {
+			bp->eth_stats.ptp_skip_tx_ts++;
 			BNX2X_ERR("Tx timestamping was not enabled, this packet will not be timestamped\n");
 		} else if (bp->ptp_tx_skb) {
-			BNX2X_ERR("The device supports only a single outstanding packet to timestamp, this packet will not be timestamped\n");
+			bp->eth_stats.ptp_skip_tx_ts++;
+			netdev_err_once(bp->dev,
+					"Device supports only a single outstanding packet to timestamp, this packet won't be timestamped\n");
 		} else {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			/* schedule check for Tx timestamp */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index c428b0655c26..00f9ed93360c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -182,7 +182,9 @@ static const struct {
 	{ STATS_OFFSET32(driver_filtered_tx_pkt),
 				4, false, "driver_filtered_tx_pkt" },
 	{ STATS_OFFSET32(eee_tx_lpi),
-				4, true, "Tx LPI entry count"}
+				4, true, "Tx LPI entry count"},
+	{ STATS_OFFSET32(ptp_skip_tx_ts),
+				4, false, "ptp_skipped_tx_tstamp" },
 };
 
 #define BNX2X_NUM_STATS		ARRAY_SIZE(bnx2x_stats_arr)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index a585f1025a58..2c9af0f420e5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -15244,11 +15244,24 @@ static void bnx2x_ptp_task(struct work_struct *work)
 	u32 val_seq;
 	u64 timestamp, ns;
 	struct skb_shared_hwtstamps shhwtstamps;
+	bool bail = true;
+	int i;
+
+	/* FW may take a while to complete timestamping; try a bit and if it's
+	 * still not complete, may indicate an error state - bail out then.
+	 */
+	for (i = 0; i < 10; i++) {
+		/* Read Tx timestamp registers */
+		val_seq = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
+				 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
+		if (val_seq & 0x10000) {
+			bail = false;
+			break;
+		}
+		msleep(1 << i);
+	}
 
-	/* Read Tx timestamp registers */
-	val_seq = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
-			 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
-	if (val_seq & 0x10000) {
+	if (!bail) {
 		/* There is a valid timestamp value */
 		timestamp = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_TS_MSB :
 				   NIG_REG_P0_TLLH_PTP_BUF_TS_MSB);
@@ -15263,16 +15276,18 @@ static void bnx2x_ptp_task(struct work_struct *work)
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(ns);
 		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
-		dev_kfree_skb_any(bp->ptp_tx_skb);
-		bp->ptp_tx_skb = NULL;
 
 		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles = %llu, ns = %llu\n",
 		   timestamp, ns);
 	} else {
-		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp yet\n");
-		/* Reschedule to keep checking for a valid timestamp value */
-		schedule_work(&bp->ptp_task);
+		DP(BNX2X_MSG_PTP,
+		   "Tx timestamp is not recorded (register read=%u)\n",
+		   val_seq);
+		bp->eth_stats.ptp_skip_tx_ts++;
 	}
+
+	dev_kfree_skb_any(bp->ptp_tx_skb);
+	bp->ptp_tx_skb = NULL;
 }
 
 void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
index b2644ed13d06..d55e63692cf3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
@@ -207,6 +207,9 @@ struct bnx2x_eth_stats {
 	u32 driver_filtered_tx_pkt;
 	/* src: Clear-on-Read register; Will not survive PMF Migration */
 	u32 eee_tx_lpi;
+
+	/* PTP */
+	u32 ptp_skip_tx_ts;
 };
 
 struct bnx2x_eth_q_stats {
-- 
2.20.1



