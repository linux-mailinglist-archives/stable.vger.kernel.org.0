Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA69C60F6DA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiJ0MKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiJ0MKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:10:38 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C246B97ED7;
        Thu, 27 Oct 2022 05:10:37 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7839720F06A3;
        Thu, 27 Oct 2022 05:10:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7839720F06A3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1666872637;
        bh=oPoYxf92pQI9GMHdlC4nr330p9SHzntFV3KDZDy4k70=;
        h=From:To:Cc:Subject:Date:From;
        b=LaPEmaiUSUuVpRwykG6hnRCDPSesIpnUZIipLIkDS7c+mkGhgS6p1Czx3jcDdph4X
         ul54US2nLM/MWwz0ZtFBwdwawx6Iof+G64tJNm1hhpzBDEZnhUjoTQ75eQfuiFLpZ+
         BVr557m+MJLiAxiZoqohyGhdo8VqI7Oz5M6FSGtM=
From:   Gaurav Kohli <gauravkohli@linux.microsoft.com>
To:     stable@vger.kernel.org, gauravkohli@linux.microsoft.com
Cc:     gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org
Subject: [PATCH 5.4] hv_netvsc: Fix race between VF offering and VF association message from host
Date:   Thu, 27 Oct 2022 05:10:32 -0700
Message-Id: <1666872632-8476-1-git-send-email-gauravkohli@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 365e1ececb2905f94cc10a5817c5b644a32a3ae2 ]

During vm boot, there might be possibility that vf registration
call comes before the vf association from host to vm.

And this might break netvsc vf path, To prevent the same block
vf registration until vf bind message comes from host.

Cc: stable@vger.kernel.org
Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/hyperv/hyperv_net.h |  3 +++
 drivers/net/hyperv/netvsc.c     |  4 ++++
 drivers/net/hyperv/netvsc_drv.c | 20 ++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index fb547f37af1e..8fc14aac0ec8 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -953,6 +953,9 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
+
+	/* completion variable to confirm vf association */
+	struct completion vf_add;
 };
 
 /* Per channel data */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index eab83e71567a..021b57261170 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1223,6 +1223,10 @@ static void netvsc_send_vf(struct net_device *ndev,
 
 	net_device_ctx->vf_alloc = nvmsg->msg.v4_msg.vf_assoc.allocated;
 	net_device_ctx->vf_serial = nvmsg->msg.v4_msg.vf_assoc.serial;
+
+	if (net_device_ctx->vf_alloc)
+		complete(&net_device_ctx->vf_add);
+
 	netdev_info(ndev, "VF slot %u %s\n",
 		    net_device_ctx->vf_serial,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 963509add611..0dae4dce6654 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2129,6 +2129,7 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 {
 	struct device *parent = vf_netdev->dev.parent;
 	struct net_device_context *ndev_ctx;
+	struct net_device *ndev;
 	struct pci_dev *pdev;
 	u32 serial;
 
@@ -2155,6 +2156,18 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 			return hv_get_drvdata(ndev_ctx->device_ctx);
 	}
 
+	/* Fallback path to check synthetic vf with
+	 * help of mac addr
+	 */
+	list_for_each_entry(ndev_ctx, &netvsc_dev_list, list) {
+		ndev = hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ether_addr_equal(vf_netdev->perm_addr, ndev->perm_addr)) {
+			netdev_notice(vf_netdev,
+				      "falling back to mac addr based matching\n");
+			return ndev;
+		}
+	}
+
 	netdev_notice(vf_netdev,
 		      "no netdev found for vf serial:%u\n", serial);
 	return NULL;
@@ -2228,6 +2241,11 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 	if (!netvsc_dev)
 		return NOTIFY_DONE;
 
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
+		netdev_info(ndev, "Waiting for the VF association from host\n");
+		wait_for_completion(&net_device_ctx->vf_add);
+	}
+
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
 		    vf_is_up ? "to" : "from", vf_netdev->name);
@@ -2249,6 +2267,7 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 
 	netdev_info(ndev, "VF unregistering: %s\n", vf_netdev->name);
 
+	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2286,6 +2305,7 @@ static int netvsc_probe(struct hv_device *dev,
 
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
 
+	init_completion(&net_device_ctx->vf_add);
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);
-- 
2.25.1

