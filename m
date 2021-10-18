Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2B43176D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhJRLgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJRLgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E21D360EE5;
        Mon, 18 Oct 2021 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556879;
        bh=NZ2JVewieaD1xSdyQBufGLYr2vgtLo66rPCwgxgr+1A=;
        h=Subject:To:Cc:From:Date:From;
        b=yuHcXWo40+QVeC7G6pOiw6A3+zgQkmeyWuO6/4FABuQdzGvD1FOmpnBtuH3V2fZXM
         FrzktM5sbpVUolyp99GUCsiLfznQv5Eo/0W0YNTy6YKg6tuUBnrf7Xlkto2ObGvH+D
         mPy0XhzLE0R79Tu7M7WZOEeb7mxhBsEY7WjFvx5E=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: make use of all 63 PTP timestamp" failed to apply to 5.4-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:34:36 +0200
Message-ID: <1634556876199113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c57fe0037a4e3863d9b740f8c14df9c51ac31aa1 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:35 +0300
Subject: [PATCH] net: mscc: ocelot: make use of all 63 PTP timestamp
 identifiers

At present, there is a problem when user space bombards a port with PTP
event frames which have TX timestamping requests (or when a tc-taprio
offload is installed on a port, which delays the TX timestamps by a
significant amount of time). The driver will happily roll over the 2-bit
timestamp ID and this will cause incorrect matches between an skb and
the TX timestamp collected from the FIFO.

The Ocelot switches have a 6-bit PTP timestamp identifier, and the value
63 is reserved, so that leaves identifiers 0-62 to be used.

The timestamp identifiers are selected by the REW_OP packet field, and
are actually shared between CPU-injected frames and frames which match a
VCAP IS2 rule that modifies the REW_OP. The hardware supports
partitioning between the two uses of the REW_OP field through the
PTP_ID_LOW and PTP_ID_HIGH registers, and by default reserves the PTP
IDs 0-3 for CPU-injected traffic and the rest for VCAP IS2.

The driver does not use VCAP IS2 to set REW_OP for 2-step timestamping,
and it also writes 0xffffffff to both PTP_ID_HIGH and PTP_ID_LOW in
ocelot_init_timestamp() which makes all timestamp identifiers available
to CPU injection.

Therefore, we can make use of all 63 timestamp identifiers, which should
allow more timestampable packets to be in flight on each port. This is
only part of the solution, more issues will be addressed in future changes.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4de58321907c..c43c8f53faaf 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -579,7 +579,9 @@ static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
-	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
+	ocelot_port->ts_id++;
+	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
+		ocelot_port->ts_id = 0;
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
 	spin_unlock(&ocelot_port->ts_id_lock);
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index ded497d72bdb..6e54442b49ad 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -13,6 +13,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <soc/mscc/ocelot.h>
 
+#define OCELOT_MAX_PTP_ID		63
+
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ

