Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F787FAD2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393754AbfHBNWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393726AbfHBNWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:22:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396C3217D4;
        Fri,  2 Aug 2019 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752143;
        bh=8G0xjL5wX9rZT733svEXgWfiwMIBLWzgUjruXDyMgRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5BU2tSRAjG7mBaSBHlGvHHcVtNCREjq6aY9HQWlQzHu5emRvuM3VPaxh/0KXIulC
         DGJwYTRN5oatiAdaiLXYqJbaOsUHxHJBsTqI/b7EMe3WNR7JmStrm04Gx1Smwal8f/
         R8ghwgtP1573GZh6/gWUwo1IwqExj13ujsD8siCY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 60/76] nvme: fix memory leak caused by incorrect subsystem free
Date:   Fri,  2 Aug 2019 09:19:34 -0400
Message-Id: <20190802131951.11600-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit e654dfd38c1ecf58d8d019f3c053189413484a5b ]

When freeing the subsystem after finding another match with
__nvme_find_get_subsystem(), use put_device() instead of
__nvme_release_subsystem() which calls kfree() directly.

Per the documentation, put_device() should always be used
after device_initialization() is called. Otherwise, leaks
like the one below which was detected by kmemleak may occur.

Once the call of __nvme_release_subsystem() is removed it no
longer makes sense to keep the helper, so fold it back
into nvme_release_subsystem().

unreferenced object 0xffff8883d12bfbc0 (size 16):
  comm "nvme", pid 2635, jiffies 4294933602 (age 739.952s)
  hex dump (first 16 bytes):
    6e 76 6d 65 2d 73 75 62 73 79 73 32 00 88 ff ff  nvme-subsys2....
  backtrace:
    [<000000007d8fc208>] __kmalloc_track_caller+0x16d/0x2a0
    [<0000000081169e5f>] kvasprintf+0xad/0x130
    [<0000000025626f25>] kvasprintf_const+0x47/0x120
    [<00000000fa66ad36>] kobject_set_name_vargs+0x44/0x120
    [<000000004881f8b3>] dev_set_name+0x98/0xc0
    [<000000007124dae3>] nvme_init_identify+0x1995/0x38e0
    [<000000009315020a>] nvme_loop_configure_admin_queue+0x4fa/0x5e0
    [<000000001a63e766>] nvme_loop_create_ctrl+0x489/0xf80
    [<00000000a46ecc23>] nvmf_dev_write+0x1a12/0x2220
    [<000000002259b3d5>] __vfs_write+0x66/0x120
    [<000000002f6df81e>] vfs_write+0x154/0x490
    [<000000007e8cfc19>] ksys_write+0x10a/0x240
    [<00000000ff5c7b85>] __x64_sys_write+0x73/0xb0
    [<00000000fee6d692>] do_syscall_64+0xaa/0x470
    [<00000000997e1ede>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: ab9e00cc72fa ("nvme: track subsystems")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4a1d2ab4d1612..5deb4deb38209 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2264,17 +2264,15 @@ static void nvme_init_subnqn(struct nvme_subsystem *subsys, struct nvme_ctrl *ct
 	memset(subsys->subnqn + off, 0, sizeof(subsys->subnqn) - off);
 }
 
-static void __nvme_release_subsystem(struct nvme_subsystem *subsys)
+static void nvme_release_subsystem(struct device *dev)
 {
+	struct nvme_subsystem *subsys =
+		container_of(dev, struct nvme_subsystem, dev);
+
 	ida_simple_remove(&nvme_subsystems_ida, subsys->instance);
 	kfree(subsys);
 }
 
-static void nvme_release_subsystem(struct device *dev)
-{
-	__nvme_release_subsystem(container_of(dev, struct nvme_subsystem, dev));
-}
-
 static void nvme_destroy_subsystem(struct kref *ref)
 {
 	struct nvme_subsystem *subsys =
@@ -2429,7 +2427,7 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	mutex_lock(&nvme_subsystems_lock);
 	found = __nvme_find_get_subsystem(subsys->subnqn);
 	if (found) {
-		__nvme_release_subsystem(subsys);
+		put_device(&subsys->dev);
 		subsys = found;
 
 		if (!nvme_validate_cntlid(subsys, ctrl, id)) {
-- 
2.20.1

