Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340E38DB63
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfHNRGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbfHNRGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B9A21744;
        Wed, 14 Aug 2019 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802381;
        bh=t2XG4CmWsTIyBrHSCGBno53f3jKzblsHT8JKdD8A2O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTNj5xDfxHfKjvtkaOaAKbJI9zBtOrAxpGe7IWOwe/Il5WlqzsdaiPX+rvLrcKjGj
         8P2/MJ9RErDn3cdvIAr6T2xgCkM18NCvQ0lnRsMR0Fr+Ux0kgDIyE5PqNNkzTvpWOj
         +pOjIYxvGJ6K/ikFr6994uTAghcHh+x2iVxiav88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 104/144] nvme: fix memory leak caused by incorrect subsystem free
Date:   Wed, 14 Aug 2019 19:01:00 +0200
Message-Id: <20190814165804.250036186@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



