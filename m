Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0461A3075
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 09:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgDIHvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 03:51:39 -0400
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:51644 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDIHvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 03:51:39 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 0397pZoi014475; Thu, 9 Apr 2020 16:51:35 +0900
X-Iguazu-Qid: 34trpDa8KlGclt4ngY
X-Iguazu-QSIG: v=2; s=0; t=1586418695; q=34trpDa8KlGclt4ngY; m=+bEVUz5DVDGwgDDYlKeUM30AbXsOxVKWS+a0+yeHYrg=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id 0397pZ5E003712;
        Thu, 9 Apr 2020 16:51:35 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0397pZhG017028;
        Thu, 9 Apr 2020 16:51:35 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0397pYBx010724;
        Thu, 9 Apr 2020 16:51:34 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH for 4.4.y] xen-netfront: Update features after registering netdev
Date:   Thu,  9 Apr 2020 16:51:34 +0900
X-TSB-HOP: ON
Message-Id: <20200409075134.1402588-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit 45c8184c1bed1ca8a7f02918552063a00b909bf5 upstream.

Update the features after calling register_netdev() otherwise the
device features are not set up correctly and it not possible to change
the MTU of the device. After this change, the features reported by
ethtool match the device's features before the commit which introduced
the issue and it is possible to change the device's MTU.

Fixes: f599c64fdf7d ("xen-netfront: Fix race between device setup and open")
Reported-by: Liam Shepherd <liam@dancer.es>
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/xen-netfront.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 744b111cff6a3..e99a07d5fda71 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1982,10 +1982,6 @@ static int xennet_connect(struct net_device *dev)
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
 
-	rtnl_lock();
-	netdev_update_features(dev);
-	rtnl_unlock();
-
 	if (dev->reg_state == NETREG_UNINITIALIZED) {
 		err = register_netdev(dev);
 		if (err) {
@@ -1995,6 +1991,10 @@ static int xennet_connect(struct net_device *dev)
 		}
 	}
 
+	rtnl_lock();
+	netdev_update_features(dev);
+	rtnl_unlock();
+
 	/*
 	 * All public and private state should now be sane.  Get
 	 * ready to start sending and receiving packets and give the driver
-- 
2.26.0

