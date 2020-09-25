Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A052788C5
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgIYM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbgIYMu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6403321741;
        Fri, 25 Sep 2020 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038226;
        bh=SbFW5lEaEAJt3SSuBox/g1l9WBSLDiVEaFH41OoPtD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaBa2BEgXRorDCi+WuLFScmoZY0VCZaSE86FI4O084jyC33r8bVT9fUaCRc1uVQQS
         YKHm3uDr6VBs/QwNAIP/XAfBRctNi9cLS4yVNLw1vyfJyZD0hp9XlWuoyggqh03/hJ
         ek80oaUwgSabNZMMhqHNmIRWg10mfzHoDsLb+/MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 49/56] hv_netvsc: Fix hibernation for mlx5 VF driver
Date:   Fri, 25 Sep 2020 14:48:39 +0200
Message-Id: <20200925124735.192924542@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 19162fd4063a3211843b997a454b505edb81d5ce ]

mlx5_suspend()/resume() keep the network interface, so during hibernation
netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
netvsc_resume() should call netvsc_vf_changed() to switch the data path
back to the VF after hibernation. Note: after we close and re-open the
vmbus channel of the netvsc NIC in netvsc_suspend() and netvsc_resume(),
the data path is implicitly switched to the netvsc NIC. Similarly,
netvsc_suspend() should not call netvsc_unregister_vf(), otherwise the VF
can no longer be used after hibernation.

For mlx4, since the VF network interafce is explicitly destroyed and
re-created during hibernation (see mlx4_suspend()/resume()), hv_netvsc
already explicitly switches the data path from and to the VF automatically
via netvsc_register_vf() and netvsc_unregister_vf(), so mlx4 doesn't need
this fix. Note: mlx4 can still work with the fix because in
netvsc_suspend()/resume() ndev_ctx->vf_netdev is NULL for mlx4.

Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2544,8 +2544,8 @@ static int netvsc_remove(struct hv_devic
 static int netvsc_suspend(struct hv_device *dev)
 {
 	struct net_device_context *ndev_ctx;
-	struct net_device *vf_netdev, *net;
 	struct netvsc_device *nvdev;
+	struct net_device *net;
 	int ret;
 
 	net = hv_get_drvdata(dev);
@@ -2561,10 +2561,6 @@ static int netvsc_suspend(struct hv_devi
 		goto out;
 	}
 
-	vf_netdev = rtnl_dereference(ndev_ctx->vf_netdev);
-	if (vf_netdev)
-		netvsc_unregister_vf(vf_netdev);
-
 	/* Save the current config info */
 	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
 
@@ -2580,6 +2576,7 @@ static int netvsc_resume(struct hv_devic
 	struct net_device *net = hv_get_drvdata(dev);
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info;
+	struct net_device *vf_netdev;
 	int ret;
 
 	rtnl_lock();
@@ -2592,6 +2589,15 @@ static int netvsc_resume(struct hv_devic
 	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
+	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
+	 * hibernation, but here the data path is implicitly switched to the
+	 * netvsc NIC since the vmbus channel is closed and re-opened, so
+	 * netvsc_vf_changed() must be used to switch the data path to the VF.
+	 */
+	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
+	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
+		ret = -EINVAL;
+
 	rtnl_unlock();
 
 	return ret;


