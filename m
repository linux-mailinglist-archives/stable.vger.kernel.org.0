Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354A4DD4B7
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406189AbfJRW0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfJRWEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D80A6222C6;
        Fri, 18 Oct 2019 22:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436250;
        bh=Q2r+wUblGCSZcJscrAMf78V19psDjFOH4jTfp5UiFkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjtXs+OMQ5DL4slE8rdGyUHtz0A3JOqyVvyOFxBErG5/K8ZJyeYwN3v03WSXOtbTz
         Nm1oxeHYVlnhq9d1YXuxCdSK+rESgzGzkpcJ/7Q0oAX8L6nzvaJkKyZXeE22l/Vxo2
         WtU/zUK43vcEBSfuShdsITzA0d4pOdn3tFjIKoWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 34/89] RDMA/cm: Fix memory leak in cm_add/remove_one
Date:   Fri, 18 Oct 2019 18:02:29 -0400
Message-Id: <20191018220324.8165-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -4399,6 +4399,7 @@ static void cm_add_one(struct ib_device *ib_device)
 error1:
 	port_modify.set_port_cap_mask = 0;
 	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
+	kfree(port);
 	while (--i) {
 		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
@@ -4407,6 +4408,7 @@ static void cm_add_one(struct ib_device *ib_device)
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

