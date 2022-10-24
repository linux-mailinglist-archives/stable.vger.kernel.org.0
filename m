Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8120460AB8C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiJXNxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiJXNw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A79BB051;
        Mon, 24 Oct 2022 05:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7386129B;
        Mon, 24 Oct 2022 12:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDE5C433D7;
        Mon, 24 Oct 2022 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614809;
        bh=j+llqBp2k+sAGf2EGii9kYZd/fNj8d78G9EUXEXjwjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SehbzU76vMQo9a1E6gKg9VgvkF90hGaDedZDtvS5KdB9lQn4ozWy/iEU2FFYyvN8d
         DlqTcrxmIEk3YI+Fo7Tqahc+F01npxkF+Rzp4eDfXS2vhBp05OGGWWxDn/LIgLM4Ge
         mH/q6XzQbJruXfzoVpua+JwRFrbKCyb5bC2h5Lns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Gaurav Kohli <gauravkohli@linux.microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 012/530] hv_netvsc: Fix race between VF offering and VF association message from host
Date:   Mon, 24 Oct 2022 13:25:56 +0200
Message-Id: <20221024113045.557080126@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Kohli <gauravkohli@linux.microsoft.com>

commit 365e1ececb2905f94cc10a5817c5b644a32a3ae2 upstream.

During vm boot, there might be possibility that vf registration
call comes before the vf association from host to vm.

And this might break netvsc vf path, To prevent the same block
vf registration until vf bind message comes from host.

Cc: stable@vger.kernel.org
Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/hyperv_net.h |    3 ++-
 drivers/net/hyperv/netvsc.c     |    4 ++++
 drivers/net/hyperv/netvsc_drv.c |   19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1037,7 +1037,8 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
-
+	/* completion variable to confirm vf association */
+	struct completion vf_add;
 	/* Is the current data path through the VF NIC? */
 	bool  data_path_is_vf;
 
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1450,6 +1450,10 @@ static void netvsc_send_vf(struct net_de
 
 	net_device_ctx->vf_alloc = nvmsg->msg.v4_msg.vf_assoc.allocated;
 	net_device_ctx->vf_serial = nvmsg->msg.v4_msg.vf_assoc.serial;
+
+	if (net_device_ctx->vf_alloc)
+		complete(&net_device_ctx->vf_add);
+
 	netdev_info(ndev, "VF slot %u %s\n",
 		    net_device_ctx->vf_serial,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2336,6 +2336,18 @@ static struct net_device *get_netvsc_bys
 
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
@@ -2432,6 +2444,11 @@ static int netvsc_vf_changed(struct net_
 	if (net_device_ctx->data_path_is_vf == vf_is_up)
 		return NOTIFY_OK;
 
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
+		netdev_info(ndev, "Waiting for the VF association from host\n");
+		wait_for_completion(&net_device_ctx->vf_add);
+	}
+
 	ret = netvsc_switch_datapath(ndev, vf_is_up);
 
 	if (ret) {
@@ -2463,6 +2480,7 @@ static int netvsc_unregister_vf(struct n
 
 	netvsc_vf_setxdp(vf_netdev, NULL);
 
+	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2502,6 +2520,7 @@ static int netvsc_probe(struct hv_device
 
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
 
+	init_completion(&net_device_ctx->vf_add);
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);


