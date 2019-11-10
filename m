Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435C4F62D6
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfKJCqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:46:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbfKJCqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6A2E2085B;
        Sun, 10 Nov 2019 02:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353960;
        bh=2nG+f6/8R2SGBJCEGEqoz1aBXB5qp42nEOs/chALn5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=St736J5rjWNZsmsMD9S6YwrQt/fx2JUfe2bv7q2sn5oNfZCFcc2YKYxpy9OISuKjg
         8tqFLEJIUlJ3KYpK1DEJ21YKAHXoU3HSoEpI+tTxYheTSjcw/iyVsGdnSNnh1wAz8h
         LDkWf3Zsinei4txSaHP32DaOA7kOLJ2tFyHU8RR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 014/109] RDMA/i40iw: Fix incorrect iterator type
Date:   Sat,  9 Nov 2019 21:44:06 -0500
Message-Id: <20191110024541.31567-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge@oracle.com>

[ Upstream commit 802fa45cd320de319e86c93bca72abec028ba059 ]

Commit f27b4746f378 ("i40iw: add connection management code") uses an
incorrect rcu iterator, whilst holding the rtnl_lock. Since the
critical region invokes i40iw_manage_qhash(), which is a sleeping
function, the rcu locking and traversal cannot be used.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index b7f1ce5333cb8..880c63579ba88 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1667,7 +1667,7 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 	unsigned long flags;
 
 	rtnl_lock();
-	for_each_netdev_rcu(&init_net, ip_dev) {
+	for_each_netdev(&init_net, ip_dev) {
 		if ((((rdma_vlan_dev_vlan_id(ip_dev) < I40IW_NO_VLAN) &&
 		      (rdma_vlan_dev_real_dev(ip_dev) == iwdev->netdev)) ||
 		     (ip_dev == iwdev->netdev)) && (ip_dev->flags & IFF_UP)) {
-- 
2.20.1

