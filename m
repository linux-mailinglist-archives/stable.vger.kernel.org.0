Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1F31E4A
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfFANfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfFANXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67B2D2735B;
        Sat,  1 Jun 2019 13:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395397;
        bh=2BXINFisNjGG4bCPPmxzCmLnRNfSyhylNZnEtyPOFKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ7oZVRMUyjIAfzlDccPEHrs/P94dhNXe1YsvcCMEgVS84DE7BT2Ks294Zw+nxh5b
         PlHMO6XfuAeQtOlAJekh7CBERWvK6kuPDQA7QRyRFAjXGn94bxVucZtBW4F4R+p+ba
         8XczkjRXr5WyGX5DYEtlE/OjICk0PrNZRNJevBI0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 037/141] f2fs: fix to do sanity check on free nid
Date:   Sat,  1 Jun 2019 09:20:13 -0400
Message-Id: <20190601132158.25821-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 626bcf2b7ce87211dba565f2bfa7842ba5be5c1b ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203225

- Overview
When mounting the attached crafted image and unmounting it, following errors are reported.
Additionally, it hangs on sync after unmounting.

The image is intentionally fuzzed from a normal f2fs image for testing.
Compile options for F2FS are as follows.
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_CHECK_FS=y

- Reproduces
mkdir test
mount -t f2fs tmp.img test
touch test/t
umount test
sync

- Messages
 kernel BUG at fs/f2fs/node.c:3073!
 RIP: 0010:f2fs_destroy_node_manager+0x2f0/0x300
 Call Trace:
  f2fs_put_super+0xf4/0x270
  generic_shutdown_super+0x62/0x110
  kill_block_super+0x1c/0x50
  kill_f2fs_super+0xad/0xd0
  deactivate_locked_super+0x35/0x60
  cleanup_mnt+0x36/0x70
  task_work_run+0x75/0x90
  exit_to_usermode_loop+0x93/0xa0
  do_syscall_64+0xba/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0010:f2fs_destroy_node_manager+0x2f0/0x300

NAT table is corrupted, so reserved meta/node inode ids were added into
free list incorrectly, during file creation, since reserved id has cached
in inode hash, so it fails the creation and preallocated nid can not be
released later, result in kernel panic.

To fix this issue, let's do nid boundary check during free nid loading.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 807a77518a491..34c3f732601c3 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2079,6 +2079,9 @@ static bool add_free_nid(struct f2fs_sb_info *sbi,
 	if (unlikely(nid == 0))
 		return false;
 
+	if (unlikely(f2fs_check_nid_range(sbi, nid)))
+		return false;
+
 	i = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
 	i->nid = nid;
 	i->state = FREE_NID;
-- 
2.20.1

