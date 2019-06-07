Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AEB38FF9
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbfFGPra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731604AbfFGPr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB65D20657;
        Fri,  7 Jun 2019 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922448;
        bh=VIgfzRyviqbodzti/XiJCoIgpVOGfvlrzpRm5fnrB0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ye+ZFPB/PqKqjfTRRG3eixGi0GVxBTgNPZBBK0cKNlvIBBgPc8hHeaLLqE63CZmRS
         Au7ZWtIZbRTPcukzZOduxFOhFioWeLZkH/K0sQbBbvS3D3SVmIdKcpL+d/A/LEXI0E
         91UhHyBkjPtuhZBsI0tIBtdOTzeFm3Y9cZUlU9p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.1 17/85] brcmfmac: fix NULL pointer derefence during USB disconnect
Date:   Fri,  7 Jun 2019 17:39:02 +0200
Message-Id: <20190607153851.322758205@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Figiel <p.figiel@camlintechnologies.com>

commit 5cdb0ef6144f47440850553579aa923c20a63f23 upstream.

In case USB disconnect happens at the moment transmitting workqueue is in
progress the underlying interface may be gone causing a NULL pointer
dereference. Add synchronization of the workqueue destruction with the
detach implementation in core so that the transmitting workqueue is stopped
during detach before the interfaces are removed.

Fix following Oops:

Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = 9e6a802d
[00000008] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in: nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_mangle
xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_rndis u_ether
usb_serial_simple usbserial cdc_acm brcmfmac brcmutil smsc95xx usbnet
ci_hdrc_imx ci_hdrc ulpi usbmisc_imx 8250_exar 8250_pci 8250 8250_base
libcomposite configfs udc_core
CPU: 0 PID: 7 Comm: kworker/u8:0 Not tainted 4.19.23-00076-g03740aa-dirty #102
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: brcmf_fws_wq brcmf_fws_dequeue_worker [brcmfmac]
PC is at brcmf_txfinalize+0x34/0x90 [brcmfmac]
LR is at brcmf_fws_dequeue_worker+0x218/0x33c [brcmfmac]
pc : [<7f0dee64>]    lr : [<7f0e4140>]    psr: 60010093
sp : ee8abef0  ip : 00000000  fp : edf38000
r10: ffffffed  r9 : edf38970  r8 : edf38004
r7 : edf3e970  r6 : 00000000  r5 : ede69000  r4 : 00000000
r3 : 00000a97  r2 : 00000000  r1 : 0000888e  r0 : ede69000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 7d03c04a  DAC: 00000051
Process kworker/u8:0 (pid: 7, stack limit = 0x24ec3e04)
Stack: (0xee8abef0 to 0xee8ac000)
bee0:                                     ede69000 00000000 ed56c3e0 7f0e4140
bf00: 00000001 00000000 edf38004 edf3e99c ed56c3e0 80d03d00 edfea43a edf3e970
bf20: ee809880 ee804200 ee971100 00000000 edf3e974 00000000 ee804200 80135a70
bf40: 80d03d00 ee804218 ee809880 ee809894 ee804200 80d03d00 ee804218 ee8aa000
bf60: 00000088 80135d5c 00000000 ee829f00 ee829dc0 00000000 ee809880 80135d30
bf80: ee829f1c ee873eac 00000000 8013b1a0 ee829dc0 8013b07c 00000000 00000000
bfa0: 00000000 00000000 00000000 801010e8 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<7f0dee64>] (brcmf_txfinalize [brcmfmac]) from [<7f0e4140>] (brcmf_fws_dequeue_worker+0x218/0x33c [brcmfmac])
[<7f0e4140>] (brcmf_fws_dequeue_worker [brcmfmac]) from [<80135a70>] (process_one_work+0x138/0x3f8)
[<80135a70>] (process_one_work) from [<80135d5c>] (worker_thread+0x2c/0x554)
[<80135d5c>] (worker_thread) from [<8013b1a0>] (kthread+0x124/0x154)
[<8013b1a0>] (kthread) from [<801010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xee8abfb0 to 0xee8abff8)
bfa0:                                     00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e1530001 0a000007 e3560000 e1a00005 (05942008)
---[ end trace 079239dd31c86e90 ]---

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c     |   11 ++++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h     |    6 +++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     |    4 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c |   16 +++++++++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h |    3 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c    |   10 ++++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h    |    3 +-
 7 files changed, 40 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -490,11 +490,18 @@ fail:
 	return -ENOMEM;
 }
 
-void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
+void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr)
+{
+	struct brcmf_bcdc *bcdc = drvr->proto->pd;
+
+	brcmf_fws_detach_pre_delif(bcdc->fws);
+}
+
+void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc = drvr->proto->pd;
 
 	drvr->proto->pd = NULL;
-	brcmf_fws_detach(bcdc->fws);
+	brcmf_fws_detach_post_delif(bcdc->fws);
 	kfree(bcdc);
 }
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
@@ -18,14 +18,16 @@
 
 #ifdef CONFIG_BRCMFMAC_PROTO_BCDC
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
-void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state);
 void brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
 				 bool success);
 struct brcmf_fws_info *drvr_to_fws(struct brcmf_pub *drvr);
 #else
 static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return 0; }
-static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
+static void brcmf_proto_bcdc_detach_pre_delif(struct brcmf_pub *drvr) {};
+static inline void brcmf_proto_bcdc_detach_post_delif(struct brcmf_pub *drvr) {}
 #endif
 
 #endif /* BRCMFMAC_BCDC_H */
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1303,6 +1303,8 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
 
+	brcmf_proto_detach_pre_delif(drvr);
+
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
 		brcmf_remove_interface(drvr->iflist[i], false);
@@ -1312,7 +1314,7 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_bus_stop(drvr->bus_if);
 
-	brcmf_proto_detach(drvr);
+	brcmf_proto_detach_post_delif(drvr);
 
 	bus_if->drvr = NULL;
 	wiphy_free(drvr->wiphy);
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2443,17 +2443,25 @@ struct brcmf_fws_info *brcmf_fws_attach(
 	return fws;
 
 fail:
-	brcmf_fws_detach(fws);
+	brcmf_fws_detach_pre_delif(fws);
+	brcmf_fws_detach_post_delif(fws);
 	return ERR_PTR(rc);
 }
 
-void brcmf_fws_detach(struct brcmf_fws_info *fws)
+void brcmf_fws_detach_pre_delif(struct brcmf_fws_info *fws)
 {
 	if (!fws)
 		return;
-
-	if (fws->fws_wq)
+	if (fws->fws_wq) {
 		destroy_workqueue(fws->fws_wq);
+		fws->fws_wq = NULL;
+	}
+}
+
+void brcmf_fws_detach_post_delif(struct brcmf_fws_info *fws)
+{
+	if (!fws)
+		return;
 
 	/* cleanup */
 	brcmf_fws_lock(fws);
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -19,7 +19,8 @@
 #define FWSIGNAL_H_
 
 struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr);
-void brcmf_fws_detach(struct brcmf_fws_info *fws);
+void brcmf_fws_detach_pre_delif(struct brcmf_fws_info *fws);
+void brcmf_fws_detach_post_delif(struct brcmf_fws_info *fws);
 void brcmf_fws_debugfs_create(struct brcmf_pub *drvr);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
@@ -67,16 +67,22 @@ fail:
 	return -ENOMEM;
 }
 
-void brcmf_proto_detach(struct brcmf_pub *drvr)
+void brcmf_proto_detach_post_delif(struct brcmf_pub *drvr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr->proto) {
 		if (drvr->bus_if->proto_type == BRCMF_PROTO_BCDC)
-			brcmf_proto_bcdc_detach(drvr);
+			brcmf_proto_bcdc_detach_post_delif(drvr);
 		else if (drvr->bus_if->proto_type == BRCMF_PROTO_MSGBUF)
 			brcmf_proto_msgbuf_detach(drvr);
 		kfree(drvr->proto);
 		drvr->proto = NULL;
 	}
 }
+
+void brcmf_proto_detach_pre_delif(struct brcmf_pub *drvr)
+{
+	if (drvr->proto && drvr->bus_if->proto_type == BRCMF_PROTO_BCDC)
+		brcmf_proto_bcdc_detach_pre_delif(drvr);
+}
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -54,7 +54,8 @@ struct brcmf_proto {
 
 
 int brcmf_proto_attach(struct brcmf_pub *drvr);
-void brcmf_proto_detach(struct brcmf_pub *drvr);
+void brcmf_proto_detach_pre_delif(struct brcmf_pub *drvr);
+void brcmf_proto_detach_post_delif(struct brcmf_pub *drvr);
 
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 				      struct sk_buff *skb,


