Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37001B3BEC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgDVKA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDVKAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9251420CC7;
        Wed, 22 Apr 2020 10:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549624;
        bh=U7Sc4UcTpVDfD4AYm+6C7inxC7cWRxuNaqsEtdpjJLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVVOzdwJmpVjp5k6JO4zoHDr4xcu+mWONUMA6eBGFMZwdH9noiZgFzAIlQcqjfXja
         FYEYcv579At765qTLROJ8ODRy0JSw0KDHeyG37RciYhZwKzIPOdgkc0fT/JKNgsGks
         8LmM6p2XumzMGBl7D12VIWpI++5a+CmwJyzQnLJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 039/100] IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush
Date:   Wed, 22 Apr 2020 11:56:09 +0200
Message-Id: <20200422095029.531359213@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

commit 1f80bd6a6cc8358b81194e1f5fc16449947396ec upstream.

The locking order of vlan_rwsem (LOCK A) and then rtnl (LOCK B),
contradicts other flows such as ipoib_open possibly causing a deadlock.
To prevent this deadlock heavy flush is called with RTNL locked and
only then tries to acquire vlan_rwsem.
This deadlock is possible only when there are child interfaces.

[  140.941758] ======================================================
[  140.946276] WARNING: possible circular locking dependency detected
[  140.950950] 4.15.0-rc1+ #9 Tainted: G           O
[  140.954797] ------------------------------------------------------
[  140.959424] kworker/u32:1/146 is trying to acquire lock:
[  140.963450]  (rtnl_mutex){+.+.}, at: [<ffffffffc083516a>] __ipoib_ib_dev_flush+0x2da/0x4e0 [ib_ipoib]
[  140.970006]
but task is already holding lock:
[  140.975141]  (&priv->vlan_rwsem){++++}, at: [<ffffffffc0834ee1>] __ipoib_ib_dev_flush+0x51/0x4e0 [ib_ipoib]
[  140.982105]
which lock already depends on the new lock.
[  140.990023]
the existing dependency chain (in reverse order) is:
[  140.998650]
-> #1 (&priv->vlan_rwsem){++++}:
[  141.005276]        down_read+0x4d/0xb0
[  141.009560]        ipoib_open+0xad/0x120 [ib_ipoib]
[  141.014400]        __dev_open+0xcb/0x140
[  141.017919]        __dev_change_flags+0x1a4/0x1e0
[  141.022133]        dev_change_flags+0x23/0x60
[  141.025695]        devinet_ioctl+0x704/0x7d0
[  141.029156]        sock_do_ioctl+0x20/0x50
[  141.032526]        sock_ioctl+0x221/0x300
[  141.036079]        do_vfs_ioctl+0xa6/0x6d0
[  141.039656]        SyS_ioctl+0x74/0x80
[  141.042811]        entry_SYSCALL_64_fastpath+0x1f/0x96
[  141.046891]
-> #0 (rtnl_mutex){+.+.}:
[  141.051701]        lock_acquire+0xd4/0x220
[  141.055212]        __mutex_lock+0x88/0x970
[  141.058631]        __ipoib_ib_dev_flush+0x2da/0x4e0 [ib_ipoib]
[  141.063160]        __ipoib_ib_dev_flush+0x71/0x4e0 [ib_ipoib]
[  141.067648]        process_one_work+0x1f5/0x610
[  141.071429]        worker_thread+0x4a/0x3f0
[  141.074890]        kthread+0x141/0x180
[  141.078085]        ret_from_fork+0x24/0x30
[  141.081559]

other info that might help us debug this:
[  141.088967]  Possible unsafe locking scenario:
[  141.094280]        CPU0                    CPU1
[  141.097953]        ----                    ----
[  141.101640]   lock(&priv->vlan_rwsem);
[  141.104771]                                lock(rtnl_mutex);
[  141.109207]                                lock(&priv->vlan_rwsem);
[  141.114032]   lock(rtnl_mutex);
[  141.116800]
 *** DEADLOCK ***

Fixes: b4b678b06f6e ("IB/ipoib: Grab rtnl lock on heavy flush when calling ndo_open/stop")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1057,13 +1057,10 @@ static void __ipoib_ib_dev_flush(struct
 		ipoib_ib_dev_down(dev);
 
 	if (level == IPOIB_FLUSH_HEAVY) {
-		rtnl_lock();
 		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 			ipoib_ib_dev_stop(dev);
 
-		result = ipoib_ib_dev_open(dev);
-		rtnl_unlock();
-		if (result)
+		if (ipoib_ib_dev_open(dev))
 			return;
 
 		if (netif_queue_stopped(dev))
@@ -1102,7 +1099,9 @@ void ipoib_ib_dev_flush_heavy(struct wor
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, flush_heavy);
 
+	rtnl_lock();
 	__ipoib_ib_dev_flush(priv, IPOIB_FLUSH_HEAVY, 0);
+	rtnl_unlock();
 }
 
 void ipoib_ib_dev_cleanup(struct net_device *dev)


