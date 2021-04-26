Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CE36AD86
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhDZHhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhDZHd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5FA611BD;
        Mon, 26 Apr 2021 07:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422397;
        bh=84fEXRoir9ZD96qpuD0HzoQzv/MQfRsgEFL6wgpLaVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQUeEWlpb0PboCNaInyhSuP8AW+4k0+/zPg8Lx6LacrJg3obrkZe4tK31WfwirQ/0
         jWGbE/fi6yHGNFtclKChJO/bY09RDg3kbxkYV88X7HiXktdtpNWbBJN7EYm2RgWmhj
         TDpSNkj6gNzALs1Vzzij1Eg726b+i1jzbHXOAcKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Brown <mbrown@fensystems.co.uk>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 33/37] xen-netback: Check for hotplug-status existence before watching
Date:   Mon, 26 Apr 2021 09:29:34 +0200
Message-Id: <20210426072818.365616663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Brown <mbrown@fensystems.co.uk>

[ Upstream commit 2afeec08ab5c86ae21952151f726bfe184f6b23d ]

The logic in connect() is currently written with the assumption that
xenbus_watch_pathfmt() will return an error for a node that does not
exist.  This assumption is incorrect: xenstore does allow a watch to
be registered for a nonexistent node (and will send notifications
should the node be subsequently created).

As of commit 1f2565780 ("xen-netback: remove 'hotplug-status' once it
has served its purpose"), this leads to a failure when a domU
transitions into XenbusStateConnected more than once.  On the first
domU transition into Connected state, the "hotplug-status" node will
be deleted by the hotplug_status_changed() callback in dom0.  On the
second or subsequent domU transition into Connected state, the
hotplug_status_changed() callback will therefore never be invoked, and
so the backend will remain stuck in InitWait.

This failure prevents scenarios such as reloading the xen-netfront
module within a domU, or booting a domU via iPXE.  There is
unfortunately no way for the domU to work around this dom0 bug.

Fix by explicitly checking for existence of the "hotplug-status" node,
thereby creating the behaviour that was previously assumed to exist.

Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 78788402edd8..e6646c8a7bdb 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -1040,11 +1040,15 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
-				   hotplug_status_changed,
-				   "%s/%s", dev->nodename, "hotplug-status");
-	if (!err)
+	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
+		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
+					   NULL, hotplug_status_changed,
+					   "%s/%s", dev->nodename,
+					   "hotplug-status");
+		if (err)
+			goto err;
 		be->have_hotplug_status_watch = 1;
+	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
-- 
2.30.2



