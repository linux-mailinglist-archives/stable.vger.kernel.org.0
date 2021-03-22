Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4ED3443DA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhCVMyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhCVMw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 001AE6188B;
        Mon, 22 Mar 2021 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417215;
        bh=uX1D6qk/JYN3J9uFjoQB7x2f0GGo9Ml9DZWCqri93WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4sGTCKKrxlygmNxrY7Zk88WWlq+izmak7z3NfjiEeK8C3LqXTRrsaxJCYpvvyZDM
         GkP2mfB6XNf7gE5AyVRuyvAl/ntPleYGYPlvzSU1zONtcDiL3Flwjtu+qM/6nJw+/1
         XaKDPwzFwd/PHCybEzz3ybpT3aYce9g+YnrkLoPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.9 05/25] ixgbe: check for Tx timestamp timeouts during watchdog
Date:   Mon, 22 Mar 2021 13:28:55 +0100
Message-Id: <20210322121920.576526692@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

commit 622a2ef538fb3ca8eccf49716aba8267d6e95a47 upstream.

The ixgbe driver has logic to handle only one Tx timestamp at a time,
using a state bit lock to avoid multiple requests at once.

It may be possible, if incredibly unlikely, that a Tx timestamp event is
requested but never completes. Since we use an interrupt scheme to
determine when the Tx timestamp occurred we would never clear the state
bit in this case.

Add an ixgbe_ptp_tx_hang() function similar to the already existing
ixgbe_ptp_rx_hang() function. This function runs in the watchdog routine
and makes sure we eventually recover from this case instead of
permanently disabling Tx timestamps.

Note: there is no currently known way to cause this without hacking the
driver code to force it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |   27 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -991,6 +991,7 @@ void ixgbe_ptp_suspend(struct ixgbe_adap
 void ixgbe_ptp_stop(struct ixgbe_adapter *adapter);
 void ixgbe_ptp_overflow_check(struct ixgbe_adapter *adapter);
 void ixgbe_ptp_rx_hang(struct ixgbe_adapter *adapter);
+void ixgbe_ptp_tx_hang(struct ixgbe_adapter *adapter);
 void ixgbe_ptp_rx_pktstamp(struct ixgbe_q_vector *, struct sk_buff *);
 void ixgbe_ptp_rx_rgtstamp(struct ixgbe_q_vector *, struct sk_buff *skb);
 static inline void ixgbe_ptp_rx_hwtstamp(struct ixgbe_ring *rx_ring,
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7258,6 +7258,7 @@ static void ixgbe_service_task(struct wo
 	if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state)) {
 		ixgbe_ptp_overflow_check(adapter);
 		ixgbe_ptp_rx_hang(adapter);
+		ixgbe_ptp_tx_hang(adapter);
 	}
 
 	ixgbe_service_event_complete(adapter);
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -663,6 +663,33 @@ static void ixgbe_ptp_clear_tx_timestamp
 }
 
 /**
+ * ixgbe_ptp_tx_hang - detect error case where Tx timestamp never finishes
+ * @adapter: private network adapter structure
+ */
+void ixgbe_ptp_tx_hang(struct ixgbe_adapter *adapter)
+{
+	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
+					      IXGBE_PTP_TX_TIMEOUT);
+
+	if (!adapter->ptp_tx_skb)
+		return;
+
+	if (!test_bit(__IXGBE_PTP_TX_IN_PROGRESS, &adapter->state))
+		return;
+
+	/* If we haven't received a timestamp within the timeout, it is
+	 * reasonable to assume that it will never occur, so we can unlock the
+	 * timestamp bit when this occurs.
+	 */
+	if (timeout) {
+		cancel_work_sync(&adapter->ptp_tx_work);
+		ixgbe_ptp_clear_tx_timestamp(adapter);
+		adapter->tx_hwtstamp_timeouts++;
+		e_warn(drv, "clearing Tx timestamp hang\n");
+	}
+}
+
+/**
  * ixgbe_ptp_tx_hwtstamp - utility function which checks for TX time stamp
  * @adapter: the private adapter struct
  *


