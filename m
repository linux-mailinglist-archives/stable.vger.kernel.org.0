Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C14417229
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343820AbhIXMqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343600AbhIXMqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 928236124C;
        Fri, 24 Sep 2021 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487470;
        bh=xXnzvx7OFzD6jG4NKJatbdRpBTvNsLVByywVPSjGvFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myAH8giosTNS0AlLC6NyUj127JhqRE6jS73nK5MrpGoGFQHGw73Nbkw88ZW7ChQvY
         j+nxNKeD1GzbQRKyi4EBYUIn2K8kLYqt1zhbXSU4IenFpw8zfBYC6JZWs6rWsA5/aW
         +7gO2OCoZuU+M9tJCkob3LGG7LPKlhirDwpQfHqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/23] nilfs2: fix memory leak in nilfs_sysfs_create_device_group
Date:   Fri, 24 Sep 2021 14:43:56 +0200
Message-Id: <20210924124328.311971742@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit 5f5dec07aca7067216ed4c1342e464e7307a9197 ]

Patch series "nilfs2: fix incorrect usage of kobject".

This patchset from Nanyong Sun fixes memory leak issues and a NULL
pointer dereference issue caused by incorrect usage of kboject in nilfs2
sysfs implementation.

This patch (of 6):

Reported by syzkaller:

  BUG: memory leak
  unreferenced object 0xffff888100ca8988 (size 8):
  comm "syz-executor.1", pid 1930, jiffies 4294745569 (age 18.052s)
  hex dump (first 8 bytes):
  6c 6f 6f 70 31 00 ff ff loop1...
  backtrace:
    kstrdup+0x36/0x70 mm/util.c:60
    kstrdup_const+0x35/0x60 mm/util.c:83
    kvasprintf_const+0xf1/0x180 lib/kasprintf.c:48
    kobject_set_name_vargs+0x56/0x150 lib/kobject.c:289
    kobject_add_varg lib/kobject.c:384 [inline]
    kobject_init_and_add+0xc9/0x150 lib/kobject.c:473
    nilfs_sysfs_create_device_group+0x150/0x7d0 fs/nilfs2/sysfs.c:986
    init_nilfs+0xa21/0xea0 fs/nilfs2/the_nilfs.c:637
    nilfs_fill_super fs/nilfs2/super.c:1046 [inline]
    nilfs_mount+0x7b4/0xe80 fs/nilfs2/super.c:1316
    legacy_get_tree+0x105/0x210 fs/fs_context.c:592
    vfs_get_tree+0x8e/0x2d0 fs/super.c:1498
    do_new_mount fs/namespace.c:2905 [inline]
    path_mount+0xf9b/0x1990 fs/namespace.c:3235
    do_mount+0xea/0x100 fs/namespace.c:3248
    __do_sys_mount fs/namespace.c:3456 [inline]
    __se_sys_mount fs/namespace.c:3433 [inline]
    __x64_sys_mount+0x14b/0x1f0 fs/namespace.c:3433
    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
    entry_SYSCALL_64_after_hwframe+0x44/0xae

If kobject_init_and_add return with error, then the cleanup of kobject
is needed because memory may be allocated in kobject_init_and_add
without freeing.

And the place of cleanup_dev_kobject should use kobject_put to free the
memory associated with the kobject.  As the section "Kobject removal" of
"Documentation/core-api/kobject.rst" says, kobject_del() just makes the
kobject "invisible", but it is not cleaned up.  And no more cleanup will
do after cleanup_dev_kobject, so kobject_put is needed here.

Link: https://lkml.kernel.org/r/1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/1625651306-10829-2-git-send-email-konishi.ryusuke@gmail.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Link: https://lkml.kernel.org/r/20210629022556.3985106-2-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index c3b629eec294..69a8f302170e 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1008,7 +1008,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
 	if (err)
-		goto free_dev_subgroups;
+		goto cleanup_dev_kobject;
 
 	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
@@ -1045,9 +1045,7 @@ delete_mounted_snapshots_group:
 	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
 
 cleanup_dev_kobject:
-	kobject_del(&nilfs->ns_dev_kobj);
-
-free_dev_subgroups:
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 
 failed_create_device_group:
-- 
2.33.0



