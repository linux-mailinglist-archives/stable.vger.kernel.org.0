Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAAEB200B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388989AbfIMNOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388983AbfIMNOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:38 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DDB214D8;
        Fri, 13 Sep 2019 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380477;
        bh=OnKi+XjHkcxy4KMjehZd0bdHUy34p6CJx5mNPyTeRQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqSlGytgHGTcbA6QHRg9Em4DnJZt4G8gNZIw1/yDE6rPdTyvak1rpSldog/Jiyne0
         PZUZAO1uyOCDFtqyavYaT9U4HP6miUbp4FYLrLyUIpHuMd+3JiIiMdGDfP2HK+pzed
         1q7+NM+ZVrfOAWjntXSQLPrn5Dpx7zI4nXLy4IS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/190] IB/uverbs: Fix OOPs upon device disassociation
Date:   Fri, 13 Sep 2019 14:05:33 +0100
Message-Id: <20190913130605.747261224@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 425784aa5b029eeb80498c73a68f62c3ad1d3b3f ]

The async_file might be freed before the disassociation has been ended,
causing qp shutdown to use after free on it.

Since uverbs_destroy_ufile_hw is not a fence, it returns if a
disassociation is ongoing in another thread. It has to be written this way
to avoid deadlock. However this means that the ufile FD close cannot
destroy anything that may still be used by an active kref, such as the the
async_file.

To fix that move the kref_put() to be in ib_uverbs_release_file().

 BUG: unable to handle kernel paging request at ffffffffba682787
 PGD bc80e067 P4D bc80e067 PUD bc80f063 PMD 1313df163 PTE 80000000bc682061
 Oops: 0003 [#1] SMP PTI
 CPU: 1 PID: 32410 Comm: bash Tainted: G           OE 4.20.0-rc6+ #3
 Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
 RIP: 0010:__pv_queued_spin_lock_slowpath+0x1b3/0x2a0
 Code: 98 83 e2 60 49 89 df 48 8b 04 c5 80 18 72 ba 48 8d
		ba 80 32 02 00 ba 00 80 00 00 4c 8d 65 14 41 bd 01 00 00 00 48 01 c7 85
		d2 <48> 89 2f 48 89 fb 74 14 8b 45 08 85 c0 75 42 84 d2 74 6b f3 90 83
 RSP: 0018:ffffc1bbc064fb58 EFLAGS: 00010006
 RAX: ffffffffba65f4e7 RBX: ffff9f209c656c00 RCX: 0000000000000001
 RDX: 0000000000008000 RSI: 0000000000000000 RDI: ffffffffba682787
 RBP: ffff9f217bb23280 R08: 0000000000000001 R09: 0000000000000000
 R10: ffff9f209d2c7800 R11: ffffffffffffffe8 R12: ffff9f217bb23294
 R13: 0000000000000001 R14: 0000000000000000 R15: ffff9f209c656c00
 FS:  00007fac55aad740(0000) GS:ffff9f217bb00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffffba682787 CR3: 000000012f8e0000 CR4: 00000000000006e0
 Call Trace:
  _raw_spin_lock_irq+0x27/0x30
  ib_uverbs_release_uevent+0x1e/0xa0 [ib_uverbs]
  uverbs_free_qp+0x7e/0x90 [ib_uverbs]
  destroy_hw_idr_uobject+0x1c/0x50 [ib_uverbs]
  uverbs_destroy_uobject+0x2e/0x180 [ib_uverbs]
  __uverbs_cleanup_ufile+0x73/0x90 [ib_uverbs]
  uverbs_destroy_ufile_hw+0x5d/0x120 [ib_uverbs]
  ib_uverbs_remove_one+0xea/0x240 [ib_uverbs]
  ib_unregister_device+0xfb/0x200 [ib_core]
  mlx5_ib_remove+0x51/0xe0 [mlx5_ib]
  mlx5_remove_device+0xc1/0xd0 [mlx5_core]
  mlx5_unregister_device+0x3d/0xb0 [mlx5_core]
  remove_one+0x2a/0x90 [mlx5_core]
  pci_device_remove+0x3b/0xc0
  device_release_driver_internal+0x16d/0x240
  unbind_store+0xb2/0x100
  kernfs_fop_write+0x102/0x180
  __vfs_write+0x36/0x1a0
  ? __alloc_fd+0xa9/0x170
  ? set_close_on_exec+0x49/0x70
  vfs_write+0xad/0x1a0
  ksys_write+0x52/0xc0
  do_syscall_64+0x5b/0x180
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fac551aac60

Cc: <stable@vger.kernel.org> # 4.2
Fixes: 036b10635739 ("IB/uverbs: Enable device removal when there are active user space applications")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 50152c1b10045..357de3b4fdddf 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -265,6 +265,9 @@ void ib_uverbs_release_file(struct kref *ref)
 	if (atomic_dec_and_test(&file->device->refcount))
 		ib_uverbs_comp_dev(file->device);
 
+	if (file->async_file)
+		kref_put(&file->async_file->ref,
+			 ib_uverbs_release_async_event_file);
 	kobject_put(&file->device->kobj);
 	kfree(file);
 }
@@ -915,10 +918,6 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	}
 	mutex_unlock(&file->device->lists_mutex);
 
-	if (file->async_file)
-		kref_put(&file->async_file->ref,
-			 ib_uverbs_release_async_event_file);
-
 	kref_put(&file->ref, ib_uverbs_release_file);
 
 	return 0;
-- 
2.20.1



