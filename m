Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250863B62DF
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhF1OuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhF1OrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A2561CE2;
        Mon, 28 Jun 2021 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890880;
        bh=8GILtwPw9SY5KSXWs9PP9JaBn0w5UiKs54Z1ljDwbVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YR1GazZdkFOd13Np71O5vX8mz5i4MUPN+w2I1Bqjzk4pZayrSqauKRnDLagaD0hAu
         TTkEESW5dBTsZy2JVGVNKmMU0CHmy2borGbRIqW4zlq4En9K56Qfbtty1I23NbkVcS
         YATLs4jFzDGeI9mUVDmWPjx8iGiKcAr7tth3sOqeNZrZSWRW8JDQhQLwyNfnQ4eOkm
         86HxLOVQeAraQi3Ae1m8eI3yBm/vX1YGm00vYgcqHhTch/paKqaDcuNMZuZo+BO9g9
         65qUCydd7WYTolqp/QqLcEBj3ikL5RdiKKToyJvt2ZzDYWgjpvYjX0i0Ilq+ir8eb8
         yhwhdUjw79SzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Michael L . Semon" <mlsemon35@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/109] nilfs2: fix memory leak in nilfs_sysfs_delete_device_group
Date:   Mon, 28 Jun 2021 10:33:03 -0400
Message-Id: <20210628143305.32978-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 8fd0c1b0647a6bda4067ee0cd61e8395954b6f28 ]

My local syzbot instance hit memory leak in nilfs2.  The problem was in
missing kobject_put() in nilfs_sysfs_delete_device_group().

kobject_del() does not call kobject_cleanup() for passed kobject and it
leads to leaking duped kobject name if kobject_put() was not called.

Fail log:

  BUG: memory leak
  unreferenced object 0xffff8880596171e0 (size 8):
  comm "syz-executor379", pid 8381, jiffies 4294980258 (age 21.100s)
  hex dump (first 8 bytes):
    6c 6f 6f 70 30 00 00 00                          loop0...
  backtrace:
     kstrdup+0x36/0x70 mm/util.c:60
     kstrdup_const+0x53/0x80 mm/util.c:83
     kvasprintf_const+0x108/0x190 lib/kasprintf.c:48
     kobject_set_name_vargs+0x56/0x150 lib/kobject.c:289
     kobject_add_varg lib/kobject.c:384 [inline]
     kobject_init_and_add+0xc9/0x160 lib/kobject.c:473
     nilfs_sysfs_create_device_group+0x150/0x800 fs/nilfs2/sysfs.c:999
     init_nilfs+0xe26/0x12b0 fs/nilfs2/the_nilfs.c:637

Link: https://lkml.kernel.org/r/20210612140559.20022-1-paskripkin@gmail.com
Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e60be7bb55b0..c6c8a33c81d5 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1054,6 +1054,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
 
-- 
2.30.2

