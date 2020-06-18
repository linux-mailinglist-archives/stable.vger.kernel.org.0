Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8CB1FDB0D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgFRBKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbgFRBJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C066E21D81;
        Thu, 18 Jun 2020 01:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442594;
        bh=iZ1o1yPV/RcV9olBx73vgaWmv1mp/Xdd0HgpzYi4P5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXdBmNSb5q3kr5EMdNT5nB49nzHJ7iKd5je/QrxY6IvowUwgIr/mMT221ZFRcW0Tx
         Rc5ioXNO04pw5l9gb+r3Dwr6H8z+yHG7jBPUbUJYmWOoR5wL7neHfBDSf3V7s1O3zO
         bFd/t///m0khmCY4TyBFihqkvl9qPyHzKJAV45KE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 083/388] RDMA/core: Fix several reference count leaks.
Date:   Wed, 17 Jun 2020 21:03:00 -0400
Message-Id: <20200618010805.600873-83-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 0b8e125e213204508e1b3c4bdfe69713280b7abd ]

kobject_init_and_add() takes reference even when it fails.  If this
function returns an error, kobject_put() must be called to properly clean
up the memory associated with the object. Previous
commit b8eb718348b8 ("net-sysfs: Fix reference count leak in
rx|netdev_queue_add_kobject") fixed a similar problem.

Link: https://lore.kernel.org/r/20200528030231.9082-1-wu000273@umn.edu
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 087682e6969e..defe9cd4c5ee 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1058,8 +1058,7 @@ static int add_port(struct ib_core_device *coredev, int port_num)
 				   coredev->ports_kobj,
 				   "%d", port_num);
 	if (ret) {
-		kfree(p);
-		return ret;
+		goto err_put;
 	}
 
 	p->gid_attr_group = kzalloc(sizeof(*p->gid_attr_group), GFP_KERNEL);
@@ -1072,8 +1071,7 @@ static int add_port(struct ib_core_device *coredev, int port_num)
 	ret = kobject_init_and_add(&p->gid_attr_group->kobj, &gid_attr_type,
 				   &p->kobj, "gid_attrs");
 	if (ret) {
-		kfree(p->gid_attr_group);
-		goto err_put;
+		goto err_put_gid_attrs;
 	}
 
 	if (device->ops.process_mad && is_full_dev) {
@@ -1404,8 +1402,10 @@ int ib_port_register_module_stat(struct ib_device *device, u8 port_num,
 
 		ret = kobject_init_and_add(kobj, ktype, &port->kobj, "%s",
 					   name);
-		if (ret)
+		if (ret) {
+			kobject_put(kobj);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.25.1

