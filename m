Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6A5EA4C9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbiIZLwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbiIZLwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C615F76776;
        Mon, 26 Sep 2022 03:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C83E6091B;
        Mon, 26 Sep 2022 10:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76258C433D6;
        Mon, 26 Sep 2022 10:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189277;
        bh=35QbhhOVsLOLHDUh8lJLi/FhzdK+RLyAIztfOmmiqzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAXsebbvNT7+d3RrrloQ2x6EPGYD4dfVYLN+Mr64nYVfCKenKSxmDIh6M/14JPTik
         BRhpqiJ9V1DreBSnTgWRn+zp+dQ7IwFLfRRk6RMAIiyNh9vqdDUJTsQXMN5/m5TVIp
         +kmg30Mwujqo4e13ESpW4W2QPipfny9VNQcRsbo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 131/207] net: enetc: deny offload of tc-based TSN features on VF interfaces
Date:   Mon, 26 Sep 2022 12:12:00 +0200
Message-Id: <20220926100812.387053554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5641c751fe2f92d3d9e8a8e03c1263ac8caa0b42 ]

TSN features on the ENETC (taprio, cbs, gate, police) are configured
through a mix of command BD ring messages and port registers:
enetc_port_rd(), enetc_port_wr().

Port registers are a region of the ENETC memory map which are only
accessible from the PCIe Physical Function. They are not accessible from
the Virtual Functions.

Moreover, attempting to access these registers crashes the kernel:

$ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
fsl_enetc_vf 0000:00:01.0: Adding to iommu group 15
fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0
$ tc qdisc replace dev eno0vf0 root taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
	sched-entry S 0x7f 900000 sched-entry S 0x80 100000 flags 0x2
Unable to handle kernel paging request at virtual address ffff800009551a08
Internal error: Oops: 96000007 [#1] PREEMPT SMP
pc : enetc_setup_tc_taprio+0x170/0x47c
lr : enetc_setup_tc_taprio+0x16c/0x47c
Call trace:
 enetc_setup_tc_taprio+0x170/0x47c
 enetc_setup_tc+0x38/0x2dc
 taprio_change+0x43c/0x970
 taprio_init+0x188/0x1e0
 qdisc_create+0x114/0x470
 tc_modify_qdisc+0x1fc/0x6c0
 rtnetlink_rcv_msg+0x12c/0x390

Split enetc_setup_tc() into separate functions for the PF and for the
VF drivers. Also remove enetc_qos.o from being included into
enetc-vf.ko, since it serves absolutely no purpose there.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220916133209.3351399-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/Makefile |  1 -
 drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 ++++++++++++++++++-
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 13 +++++++++++-
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index a139f2e9d59f..e0e8dfd13793 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -9,7 +9,6 @@ fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
-fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
 fsl-enetc-ierb-y := enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3df099f6cbe0..9f5b921039bd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2432,7 +2432,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
@@ -2486,25 +2486,6 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_QDISC_MQPRIO:
-		return enetc_setup_tc_mqprio(ndev, type_data);
-	case TC_SETUP_QDISC_TAPRIO:
-		return enetc_setup_tc_taprio(ndev, type_data);
-	case TC_SETUP_QDISC_CBS:
-		return enetc_setup_tc_cbs(ndev, type_data);
-	case TC_SETUP_QDISC_ETF:
-		return enetc_setup_tc_txtime(ndev, type_data);
-	case TC_SETUP_BLOCK:
-		return enetc_setup_tc_psfp(ndev, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index caa12509d06b..2cfe6944ebd3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -395,8 +395,7 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data);
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
 int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 201b5f3f634e..bb7750222691 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -734,6 +734,25 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return enetc_setup_tc_psfp(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
 	.ndo_stop		= enetc_close,
@@ -748,7 +767,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_pf_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 4048101c42be..dfcaac302e24 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -93,6 +93,17 @@ static int enetc_vf_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int enetc_vf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* Probing/ Init */
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
@@ -102,7 +113,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_vf_setup_tc,
 };
 
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.35.1



