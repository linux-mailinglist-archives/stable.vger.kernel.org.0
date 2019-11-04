Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906E8EED53
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389846AbfKDWFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389324AbfKDWFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:32 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A90E214D8;
        Mon,  4 Nov 2019 22:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905131;
        bh=u+PDeIpENxF2w8Mc5c9ZgN3DXHT+XJyO2627PXUD5/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4cf/7qJHtcFQku8b9CTHtQWz2PwKi/hNd7fLkoTTPb5fePfTGht6/9OddHNmRZe8
         ++2jvHftLqg/GJxsxEDT6C5YX1OzY8YhTM3nwQWo4m8Fq9g0+T8m+B+RYY3psoUp16
         lCl0CqLAH/1Jf26130fB3QID+urewmD7occn4d1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 038/163] RDMA/cm: Fix memory leak in cm_add/remove_one
Date:   Mon,  4 Nov 2019 22:43:48 +0100
Message-Id: <20191104212142.987992009@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 94635c36f3854934a46d9e812e028d4721bbb0e6 ]

In the process of moving the debug counters sysfs entries, the commit
mentioned below eliminated the cm_infiniband sysfs directory.

This sysfs directory was tied to the cm_port object allocated in procedure
cm_add_one().

Before the commit below, this cm_port object was freed via a call to
kobject_put(port->kobj) in procedure cm_remove_port_fs().

Since port no longer uses its kobj, kobject_put(port->kobj) was eliminated.
This, however, meant that kfree was never called for the cm_port buffers.

Fix this by adding explicit kfree(port) calls to functions cm_add_one()
and cm_remove_one().

Note: the kfree call in the first chunk below (in the cm_add_one error
flow) fixes an old, undetected memory leak.

Fixes: c87e65cfb97c ("RDMA/cm: Move debug counters to be under relevant IB device")
Link: https://lore.kernel.org/r/20190916071154.20383-2-leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index da10e6ccb43cd..5920c0085d35b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4399,6 +4399,7 @@ error2:
 error1:
 	port_modify.set_port_cap_mask = 0;
 	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
+	kfree(port);
 	while (--i) {
 		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
@@ -4407,6 +4408,7 @@ error1:
 		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
 		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
+		kfree(port);
 	}
 free:
 	kfree(cm_dev);
@@ -4460,6 +4462,7 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 		spin_unlock_irq(&cm.state_lock);
 		ib_unregister_mad_agent(cur_mad_agent);
 		cm_remove_port_fs(port);
+		kfree(port);
 	}
 
 	kfree(cm_dev);
-- 
2.20.1



