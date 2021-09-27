Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66A7419B12
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhI0RPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236892AbhI0RNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14CFD610E8;
        Mon, 27 Sep 2021 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762553;
        bh=hcXWIwXEqJZRgb+BK1m5fNT2PHWpzTTQkULV40mzPEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Em56yDTTICve5bC5SaRbs/EGUw+rh8R4WkRmtnM0hwHf0XnUT7kN3d9ZViDM6Prf/
         3UfmABfkFdMYLOiqy3gTQWCFB1ALVq+EvnuGIPVHphYJt0qhaRwdp5Hac2VAKdIWzQ
         +xHn6sBm3LT+db2BUlFjLhxQGplrp7wqk3XOg+/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>, NeilBrown <neilb@suse.de>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/103] md: fix a lock order reversal in md_alloc
Date:   Mon, 27 Sep 2021 19:02:40 +0200
Message-Id: <20210927170228.128635855@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7df835a32a8bedf7ce88efcfa7c9b245b52ff139 ]

Commit b0140891a8cea3 ("md: Fix race when creating a new md device.")
not only moved assigning mddev->gendisk before calling add_disk, which
fixes the races described in the commit log, but also added a
mddev->open_mutex critical section over add_disk and creation of the
md kobj.  Adding a kobject after add_disk is racy vs deleting the gendisk
right after adding it, but md already prevents against that by holding
a mddev->active reference.

On the other hand taking this lock added a lock order reversal with what
is not disk->open_mutex (used to be bdev->bd_mutex when the commit was
added) for partition devices, which need that lock for the internal open
for the partition scan, and a recent commit also takes it for
non-partitioned devices, leading to further lockdep splatter.

Fixes: b0140891a8ce ("md: Fix race when creating a new md device.")
Fixes: d62633873590 ("block: support delayed holder registration")
Reported-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 288d26013de2..f16f190546ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5759,10 +5759,6 @@ static int md_alloc(dev_t dev, char *name)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
-	/* As soon as we call add_disk(), another thread could get
-	 * through to md_open, so make sure it doesn't get too far
-	 */
-	mutex_lock(&mddev->open_mutex);
 	add_disk(disk);
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
@@ -5777,7 +5773,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
-	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
-- 
2.33.0



