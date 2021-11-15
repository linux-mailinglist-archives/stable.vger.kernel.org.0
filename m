Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD09745127E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346714AbhKOTgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244733AbhKOTRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B78763329;
        Mon, 15 Nov 2021 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000607;
        bh=DkVPsgTcnYQexjp5QByTiOThIF1L2YtZWbBC5nljprs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRQQUfQBJlVeZDCgNfejnv4F+vg355LuIBqg5jcqQuqZekd93Yz6hn86c8pHxhHv3
         JJH1Du/nUZiY4vjl32nj2Zrt1Elv3TeTFII+9WTohC1zuYFYWxb3qr6nftTkdzRR/c
         mzs6vOQgxs+tpIxdUbfLKLo8cstZ7TlplotmVLQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 724/849] net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
Date:   Mon, 15 Nov 2021 18:03:27 +0100
Message-Id: <20211115165444.746577946@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit deab6b1cd9789bb9bd466d5e76aecb8b336259b4 ]

As explained here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
DSA tagging protocol drivers cannot depend on symbols exported by switch
drivers, because this creates a circular dependency that breaks module
autoloading.

The tag_ocelot.c file depends on the ocelot_ptp_rew_op() function
exported by the common ocelot switch lib. This function looks at
OCELOT_SKB_CB(skb) and computes how to populate the REW_OP field of the
DSA tag, for PTP timestamping (the command: one-step/two-step, and the
TX timestamp identifier).

None of that requires deep insight into the driver, it is quite
stateless, as it only depends upon the skb->cb. So let's make it a
static inline function and put it in include/linux/dsa/ocelot.h, a
file that despite its name is used by the ocelot switch driver for
populating the injection header too - since commit 40d3f295b5fe ("net:
mscc: ocelot: use common tag parsing code with DSA").

With that function declared as static inline, its body is expanded
inside each call site, so the dependency is broken and the DSA tagger
can be built without the switch library, upon which the felix driver
depends.

Fixes: 39e5308b3250 ("net: mscc: ocelot: support PTP Sync one-step timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c     | 17 ------------
 drivers/net/ethernet/mscc/ocelot_net.c |  1 +
 include/linux/dsa/ocelot.h             | 37 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              | 24 -----------------
 net/dsa/Kconfig                        |  2 --
 net/dsa/tag_ocelot.c                   |  1 -
 net/dsa/tag_ocelot_8021q.c             |  1 +
 7 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index acfbe94b52918..ece2ddadaf3bf 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -568,23 +568,6 @@ static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
-	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
-	u32 rew_op = 0;
-
-	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
-		rew_op = ptp_cmd;
-		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		rew_op = ptp_cmd;
-	}
-
-	return rew_op;
-}
-EXPORT_SYMBOL(ocelot_ptp_rew_op);
-
 static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
 				       unsigned int ptp_class)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e9d260d84bf33..855833fd42e3d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,7 @@
  * Copyright 2020-2021 NXP Semiconductors
  */
 
+#include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <net/pkt_cls.h>
 #include "ocelot.h"
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index c6bc45ae5e03a..5a6a6fad62ccc 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -6,6 +6,26 @@
 #define _NET_DSA_TAG_OCELOT_H
 
 #include <linux/packing.h>
+#include <linux/skbuff.h>
+
+struct ocelot_skb_cb {
+	struct sk_buff *clone;
+	unsigned int ptp_class; /* valid only for clones */
+	u8 ptp_cmd;
+	u8 ts_id;
+};
+
+#define OCELOT_SKB_CB(skb) \
+	((struct ocelot_skb_cb *)((skb)->cb))
+
+#define IFH_TAG_TYPE_C			0
+#define IFH_TAG_TYPE_S			1
+
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_DSCP			0x1
+#define IFH_REW_OP_ONE_STEP_PTP		0x2
+#define IFH_REW_OP_TWO_STEP_PTP		0x3
+#define IFH_REW_OP_ORIGIN_PTP		0x5
 
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
@@ -215,4 +235,21 @@ static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
 	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
 }
 
+/* Determine the PTP REW_OP to use for injecting the given skb */
+static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
+{
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
+	u32 rew_op = 0;
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
+		rew_op = ptp_cmd;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
+	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		rew_op = ptp_cmd;
+	}
+
+	return rew_op;
+}
+
 #endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4984093882372..a02f0d7515f25 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -89,15 +89,6 @@
 /* Source PGIDs, one per physical port */
 #define PGID_SRC			80
 
-#define IFH_TAG_TYPE_C			0
-#define IFH_TAG_TYPE_S			1
-
-#define IFH_REW_OP_NOOP			0x0
-#define IFH_REW_OP_DSCP			0x1
-#define IFH_REW_OP_ONE_STEP_PTP		0x2
-#define IFH_REW_OP_TWO_STEP_PTP		0x3
-#define IFH_REW_OP_ORIGIN_PTP		0x5
-
 #define OCELOT_NUM_TC			8
 
 #define OCELOT_SPEED_2500		0
@@ -692,16 +683,6 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-struct ocelot_skb_cb {
-	struct sk_buff *clone;
-	unsigned int ptp_class; /* valid only for clones */
-	u8 ptp_cmd;
-	u8 ts_id;
-};
-
-#define OCELOT_SKB_CB(skb) \
-	((struct ocelot_skb_cb *)((skb)->cb))
-
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -762,7 +743,6 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb);
 #else
 
 static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
@@ -786,10 +766,6 @@ static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 {
 }
 
-static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	return 0;
-}
 #endif
 
 /* Hardware initialization */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 970906eb5b2cd..3d3015146f24f 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -101,8 +101,6 @@ config NET_DSA_TAG_RTL4_A
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
-	depends on MSCC_OCELOT_SWITCH_LIB || \
-		   (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	select PACKING
 	help
 	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 190f4bfd3bef6..fdaae23890047 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -2,7 +2,6 @@
 /* Copyright 2019 NXP Semiconductors
  */
 #include <linux/dsa/ocelot.h>
-#include <soc/mscc/ocelot.h>
 #include "dsa_priv.h"
 
 static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 85ac85c3af8c0..b4cd6842b69a2 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,6 +9,7 @@
  *   that on egress
  */
 #include <linux/dsa/8021q.h>
+#include <linux/dsa/ocelot.h>
 #include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
-- 
2.33.0



