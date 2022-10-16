Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2054D5FFDC2
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiJPHMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJPHMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:12:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D96E3DF05
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF60460AB3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65E4C433C1;
        Sun, 16 Oct 2022 07:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904371;
        bh=zZ1aAEBVB5Zdb0vkCBSpZLNAVafxcCkIhT5omvLh5hY=;
        h=Subject:To:Cc:From:Date:From;
        b=hy7UAbjhRwaRu8772YmzPF/60C3ne5dR8g+uO06rSTyHSDBpHO9V6/ikD1RLeDbSw
         sRZyIqbH6JFRq4i8z2FwX7veCBjU7wIhDjdyaCVhICRphhyju51AU3jrvqjIgemjPA
         e+q2NES1AcZrV/Mv4t9/4Z1ZcwZS0y736gRqdEWg=
Subject: FAILED: patch "[PATCH] hv_netvsc: Fix race between VF offering and VF association" failed to apply to 5.4-stable tree
To:     gauravkohli@linux.microsoft.com, davem@davemloft.net,
        haiyangz@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:13:27 +0200
Message-ID: <1665904407106129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

365e1ececb29 ("hv_netvsc: Fix race between VF offering and VF association message from host")
d0922bf79817 ("hv_netvsc: Add error handling while switching data path")
34b06a2eee44 ("hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove")
8b31f8c982b7 ("hv_netvsc: Wait for completion on request SWITCH_DATA_PATH")
4d18fcc95f50 ("hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus hardening")
e8b7db38449a ("Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus hardening")
4907a43da831 ("Merge tag 'hyperv-next-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 365e1ececb2905f94cc10a5817c5b644a32a3ae2 Mon Sep 17 00:00:00 2001
From: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Date: Wed, 5 Oct 2022 22:52:59 -0700
Subject: [PATCH] hv_netvsc: Fix race between VF offering and VF association
 message from host

During vm boot, there might be possibility that vf registration
call comes before the vf association from host to vm.

And this might break netvsc vf path, To prevent the same block
vf registration until vf bind message comes from host.

Cc: stable@vger.kernel.org
Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 25b38a374e3c..dd5919ec408b 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1051,7 +1051,8 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
-
+	/* completion variable to confirm vf association */
+	struct completion vf_add;
 	/* Is the current data path through the VF NIC? */
 	bool  data_path_is_vf;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index f066de0da492..9352dad58996 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1580,6 +1580,10 @@ static void netvsc_send_vf(struct net_device *ndev,
 
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
index 5f08482065ca..89eb4f179a3c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2313,6 +2313,18 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 
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
@@ -2409,6 +2421,11 @@ static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 	if (net_device_ctx->data_path_is_vf == vf_is_up)
 		return NOTIFY_OK;
 
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
+		netdev_info(ndev, "Waiting for the VF association from host\n");
+		wait_for_completion(&net_device_ctx->vf_add);
+	}
+
 	ret = netvsc_switch_datapath(ndev, vf_is_up);
 
 	if (ret) {
@@ -2440,6 +2457,7 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 
 	netvsc_vf_setxdp(vf_netdev, NULL);
 
+	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2479,6 +2497,7 @@ static int netvsc_probe(struct hv_device *dev,
 
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
 
+	init_completion(&net_device_ctx->vf_add);
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);

