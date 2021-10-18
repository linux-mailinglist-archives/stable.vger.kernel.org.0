Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B11431EBE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhJROFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234921AbhJRODe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 513F56135E;
        Mon, 18 Oct 2021 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564616;
        bh=fI1uiQxqbOO361F5XdBqN7wyao4gVHverHJa7SFikqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgJi9wNzfGjKeLVb2lGiNcuzfxpoGCiCaaQrBkNbrE9IJ59pdEifEotKz9JHXQpwE
         7oj6oQC/RvT+4T0HNXD3EI80cmKqummLozTvFFJr87670ljPPjI6qj0MOIR5zKLleh
         wRETs8Gn7gBfyf8WLrx0krazYiSycnnhbqJvJu88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 145/151] net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
Date:   Mon, 18 Oct 2021 15:25:24 +0200
Message-Id: <20211018132345.379645054@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit c57fe0037a4e3863d9b740f8c14df9c51ac31aa1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    4 +++-
 include/soc/mscc/ocelot_ptp.h      |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -546,7 +546,9 @@ static void ocelot_port_add_txtstamp_skb
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
-	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
+	ocelot_port->ts_id++;
+	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
+		ocelot_port->ts_id = 0;
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
 	spin_unlock(&ocelot_port->ts_id_lock);
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


