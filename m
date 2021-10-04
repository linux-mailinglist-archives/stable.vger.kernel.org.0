Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98049420CC7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhJDNJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235578AbhJDNIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E0E61B4E;
        Mon,  4 Oct 2021 13:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352550;
        bh=DJfgbm9xB9i2IFSMUDTQnZuSnBx6Si5bDVUPsVdUJuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yM3JG9TIy/xxDArEegiUjqX1mBKkjr3iOh3b3tPpV+TZDdESv+QJzVb5f+fPeO8Zm
         csV/B5vGJqi5fHCHOVaUjhbGrcWSF1pkhnpqzynkGE2HhyJG2URMf/rX2yI2Gh/Gpn
         VHtezYbCQM+JG8Q1mMQE+0Fq31/UZbsJ3+2fb2Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>, NeilBrown <neilb@suse.de>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/95] md: fix a lock order reversal in md_alloc
Date:   Mon,  4 Oct 2021 14:52:01 +0200
Message-Id: <20211004125034.583541154@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index fae6a983ceee..7e0477e883c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5401,10 +5401,6 @@ static int md_alloc(dev_t dev, char *name)
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	mddev->gendisk = disk;
-	/* As soon as we call add_disk(), another thread could get
-	 * through to md_open, so make sure it doesn't get too far
-	 */
-	mutex_lock(&mddev->open_mutex);
 	add_disk(disk);
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
@@ -5419,7 +5415,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
-	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
-- 
2.33.0



