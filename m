Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16731450D16
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhKORtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238684AbhKORrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA6363299;
        Mon, 15 Nov 2021 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997384;
        bh=kYp81w3g/KtyltFfpbFBBt9D268HH73qAO/kwUuEHBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/pyIiZfGpo440o/oTN3cPAc3azjdLZS37SAZR369PFltU/kvvfuN7+g5by5Yu2EY
         GhX1f/h1wSXaLiCLzqL22aiEoEj+N4EWtXmFPokx2bpUh4aPJigcl/OC8ec1HaMCfm
         ky9I5W8VLrP9gjNi5limHTFGWFM6fkddNjojaCHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 111/575] rsi: fix occasional initialisation failure with BT coex
Date:   Mon, 15 Nov 2021 17:57:16 +0100
Message-Id: <20211115165347.506439996@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit 9b14ed6e11b72dd4806535449ca6c6962cb2369d upstream.

When BT coexistence is enabled (eg oper mode 13, which is the default)
the initialisation on startup sometimes silently fails.

In a normal initialisation we see
	usb 1-1.3: Product: Wireless USB Network Module
	usb 1-1.3: Manufacturer: Redpine Signals, Inc.
	usb 1-1.3: SerialNumber: 000000000001
	rsi_91x: rsi_probe: Initialized os intf ops
	rsi_91x: rsi_load_9116_firmware: Loading chunk 0
	rsi_91x: rsi_load_9116_firmware: Loading chunk 1
	rsi_91x: rsi_load_9116_firmware: Loading chunk 2
	rsi_91x: Max Stations Allowed = 1

But sometimes the last log is missing and the wlan net device is
not created.

Running a userspace loop that resets the hardware via a GPIO shows the
problem occurring ~5/100 resets.

The problem does not occur in oper mode 1 (wifi only).

Adding logs shows that the initialisation state machine requests a MAC
reset via rsi_send_reset_mac() but the firmware does not reply, leading
to the initialisation sequence being incomplete.

Fix this by delaying attaching the BT adapter until the wifi
initialisation has completed.

With this applied I have done > 300 reset loops with no errors.

Fixes: 716b840c7641 ("rsi: handle BT traffic in driver")
Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
CC: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1630337206-12410-2-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_main.c |   16 +++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    3 +++
 drivers/net/wireless/rsi/rsi_main.h     |    2 ++
 3 files changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -211,9 +211,10 @@ int rsi_read_pkt(struct rsi_common *comm
 			bt_pkt_type = frame_desc[offset + BT_RX_PKT_TYPE_OFST];
 			if (bt_pkt_type == BT_CARD_READY_IND) {
 				rsi_dbg(INFO_ZONE, "BT Card ready recvd\n");
-				if (rsi_bt_ops.attach(common, &g_proto_ops))
-					rsi_dbg(ERR_ZONE,
-						"Failed to attach BT module\n");
+				if (common->fsm_state == FSM_MAC_INIT_DONE)
+					rsi_attach_bt(common);
+				else
+					common->bt_defer_attach = true;
 			} else {
 				if (common->bt_adapter)
 					rsi_bt_ops.recv_pkt(common->bt_adapter,
@@ -278,6 +279,15 @@ void rsi_set_bt_context(void *priv, void
 }
 #endif
 
+void rsi_attach_bt(struct rsi_common *common)
+{
+#ifdef CONFIG_RSI_COEX
+	if (rsi_bt_ops.attach(common, &g_proto_ops))
+		rsi_dbg(ERR_ZONE,
+			"Failed to attach BT module\n");
+#endif
+}
+
 /**
  * rsi_91x_init() - This function initializes os interface operations.
  * @oper_mode: One of DEV_OPMODE_*.
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -2071,6 +2071,9 @@ static int rsi_handle_ta_confirm_type(st
 				if (common->reinit_hw) {
 					complete(&common->wlan_init_completion);
 				} else {
+					if (common->bt_defer_attach)
+						rsi_attach_bt(common);
+
 					return rsi_mac80211_attach(common);
 				}
 			}
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -320,6 +320,7 @@ struct rsi_common {
 	struct ieee80211_vif *roc_vif;
 
 	bool eapol4_confirm;
+	bool bt_defer_attach;
 	void *bt_adapter;
 
 	struct cfg80211_scan_request *hwscan;
@@ -401,5 +402,6 @@ struct rsi_host_intf_ops {
 
 enum rsi_host_intf rsi_get_host_intf(void *priv);
 void rsi_set_bt_context(void *priv, void *bt_context);
+void rsi_attach_bt(struct rsi_common *common);
 
 #endif


