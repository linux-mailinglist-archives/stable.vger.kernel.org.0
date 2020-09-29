Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AB027C6AA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgI2Lr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgI2Lr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97294221E7;
        Tue, 29 Sep 2020 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380047;
        bh=nWC9bumt/thuz8lzMMyHRXsr8TjNEpoiBVneue43Flw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZgqqJkWdDqU6fQAjLaRV8dbKQfMhbwXVrS2UNQIJVwqRElRwDNY76tgC78s0xdnf
         6EAqqFEy/kmmberEDSRYHw2QAjCgFQnP1KYwuli689IaRcL+Pd49jbvHgjwMwtvdir
         OVop0aRj8LUpDbHlFZmZUbo05p8i+Sa4W8uNAS5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 43/99] hv_netvsc: Switch the data path at the right time during hibernation
Date:   Tue, 29 Sep 2020 13:01:26 +0200
Message-Id: <20200929105931.847444271@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit de214e52de1bba5392b5b7054924a08dbd57c2f6 ]

When netvsc_resume() is called, the mlx5 VF NIC has not been resumed yet,
so in the future the host might sliently fail the call netvsc_vf_changed()
-> netvsc_switch_datapath() there, even if the call works now.

Call netvsc_vf_changed() in the NETDEV_CHANGE event handler: at that time
the mlx5 VF NIC has been resumed.

Fixes: 19162fd4063a ("hv_netvsc: Fix hibernation for mlx5 VF driver")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8309194b351a9..a2db5ef3b62a2 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2576,7 +2576,6 @@ static int netvsc_resume(struct hv_device *dev)
 	struct net_device *net = hv_get_drvdata(dev);
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info;
-	struct net_device *vf_netdev;
 	int ret;
 
 	rtnl_lock();
@@ -2589,15 +2588,6 @@ static int netvsc_resume(struct hv_device *dev)
 	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
-	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
-	 * hibernation, but here the data path is implicitly switched to the
-	 * netvsc NIC since the vmbus channel is closed and re-opened, so
-	 * netvsc_vf_changed() must be used to switch the data path to the VF.
-	 */
-	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
-	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
-		ret = -EINVAL;
-
 	rtnl_unlock();
 
 	return ret;
@@ -2658,6 +2648,7 @@ static int netvsc_netdev_event(struct notifier_block *this,
 		return netvsc_unregister_vf(event_dev);
 	case NETDEV_UP:
 	case NETDEV_DOWN:
+	case NETDEV_CHANGE:
 		return netvsc_vf_changed(event_dev);
 	default:
 		return NOTIFY_DONE;
-- 
2.25.1



