Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556A560E21E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 15:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiJZNY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 09:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiJZNYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 09:24:10 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA289AEA17;
        Wed, 26 Oct 2022 06:23:49 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9F4A6210185B;
        Wed, 26 Oct 2022 06:23:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F4A6210185B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1666790628;
        bh=6fCTFFKJE64Z/YLmNey+rlj3zBPszoKkH2V6PRGhTDI=;
        h=From:To:Cc:Subject:Date:From;
        b=HhQ1vsH7RQd2iePFpuijE5BXnwo3d64ZR7IO6iR6v3TqMxolKv0UofgLbOSX5Xxlb
         BWYRrDNRl7F4lQ3YKpW+wmfG4DvGYc9cnz0L7sDHhf2BpeithSJlzec8IBCIBsx3K7
         9CKNLOHTzNkjkoNV50aUmYXUhTAIa76Olaa16Ajg=
From:   Gaurav Kohli <gauravkohli@linux.microsoft.com>
To:     stable@vger.kernel.org, gauravkohli@linux.microsoft.com
Cc:     gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org
Subject: [PATCH 5.10] hv_netvsc: Fix race between VF offering and VF association message from host
Date:   Wed, 26 Oct 2022 06:23:43 -0700
Message-Id: <1666790623-29227-1-git-send-email-gauravkohli@linux.microsoft.com>
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
 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     |  4 ++++
 drivers/net/hyperv/netvsc_drv.c | 20 ++++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index a0f338cf1424..367878493e70 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -977,7 +977,8 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
-
+	/* completion variable to confirm vf association */
+	struct completion vf_add;
 	/* Is the current data path through the VF NIC? */
 	bool  data_path_is_vf;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 0c3de94b5178..f813ec586049 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1324,6 +1324,10 @@ static void netvsc_send_vf(struct net_device *ndev,
 
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
index 261e6e55a907..db6e2f8cc16e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2287,6 +2287,7 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 {
 	struct device *parent = vf_netdev->dev.parent;
 	struct net_device_context *ndev_ctx;
+	struct net_device *ndev;
 	struct pci_dev *pdev;
 	u32 serial;
 
@@ -2313,6 +2314,18 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
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
@@ -2403,6 +2416,11 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 		return NOTIFY_OK;
 	net_device_ctx->data_path_is_vf = vf_is_up;
 
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
+		netdev_info(ndev, "Waiting for the VF association from host\n");
+		wait_for_completion(&net_device_ctx->vf_add);
+	}
+
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
 		    vf_is_up ? "to" : "from", vf_netdev->name);
@@ -2426,6 +2444,7 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 
 	netvsc_vf_setxdp(vf_netdev, NULL);
 
+	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2463,6 +2482,7 @@ static int netvsc_probe(struct hv_device *dev,
 
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
 
+	init_completion(&net_device_ctx->vf_add);
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);
-- 
2.25.1

