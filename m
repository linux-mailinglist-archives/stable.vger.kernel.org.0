Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FADF283AD2
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgJEPhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgJEPcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94CEC207BC;
        Mon,  5 Oct 2020 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911923;
        bh=OU6c3u+NfqWTixuEJ5jige+WjXRgeOTj/SKNJQI2Miw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joCWyx9+oIIzUu0WqN1VlbBZ7mpf3pfRQ9d8oMGGmlvbdj0fB70gLFSHz0dKRXtOy
         Hrr7wr0GtlLGbC/PIw8SBpDdtW9AFha6QcO0Ujf7EtDLt/VCATkbuScC193fGYTSuL
         jbfEtcnaQuaaaN3X5VwhMyqZskmTZaiVw4YhQxjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 31/85] hv_netvsc: Cache the current data path to avoid duplicate call and message
Date:   Mon,  5 Oct 2020 17:26:27 +0200
Message-Id: <20201005142116.234428283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit da26658c3d7005aa67a706dceff7b2807b59e123 ]

The previous change "hv_netvsc: Switch the data path at the right time
during hibernation" adds the call of netvsc_vf_changed() upon
NETDEV_CHANGE, so it's necessary to avoid the duplicate call and message
when the VF is brought UP or DOWN.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/hyperv_net.h |  3 +++
 drivers/net/hyperv/netvsc_drv.c | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index abda736e7c7dc..a4d2dd2637e26 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -973,6 +973,9 @@ struct net_device_context {
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
 
+	/* Is the current data path through the VF NIC? */
+	bool  data_path_is_vf;
+
 	/* Used to temporarily save the config info across hibernation */
 	struct netvsc_device_info *saved_netvsc_dev_info;
 };
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a2db5ef3b62a2..3b0dc1f0ef212 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2323,7 +2323,16 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	return NOTIFY_OK;
 }
 
-/* VF up/down change detected, schedule to change data path */
+/* Change the data path when VF UP/DOWN/CHANGE are detected.
+ *
+ * Typically a UP or DOWN event is followed by a CHANGE event, so
+ * net_device_ctx->data_path_is_vf is used to cache the current data path
+ * to avoid the duplicate call of netvsc_switch_datapath() and the duplicate
+ * message.
+ *
+ * During hibernation, if a VF NIC driver (e.g. mlx5) preserves the network
+ * interface, there is only the CHANGE event and no UP or DOWN event.
+ */
 static int netvsc_vf_changed(struct net_device *vf_netdev)
 {
 	struct net_device_context *net_device_ctx;
@@ -2340,6 +2349,10 @@ static int netvsc_vf_changed(struct net_device *vf_netdev)
 	if (!netvsc_dev)
 		return NOTIFY_DONE;
 
+	if (net_device_ctx->data_path_is_vf == vf_is_up)
+		return NOTIFY_OK;
+	net_device_ctx->data_path_is_vf = vf_is_up;
+
 	netvsc_switch_datapath(ndev, vf_is_up);
 	netdev_info(ndev, "Data path switched %s VF: %s\n",
 		    vf_is_up ? "to" : "from", vf_netdev->name);
@@ -2581,6 +2594,12 @@ static int netvsc_resume(struct hv_device *dev)
 	rtnl_lock();
 
 	net_device_ctx = netdev_priv(net);
+
+	/* Reset the data path to the netvsc NIC before re-opening the vmbus
+	 * channel. Later netvsc_netdev_event() will switch the data path to
+	 * the VF upon the UP or CHANGE event.
+	 */
+	net_device_ctx->data_path_is_vf = false;
 	device_info = net_device_ctx->saved_netvsc_dev_info;
 
 	ret = netvsc_attach(net, device_info);
-- 
2.25.1



