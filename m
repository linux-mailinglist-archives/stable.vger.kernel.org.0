Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F45CA33F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387554AbfJCQNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388428AbfJCQNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B98BE2054F;
        Thu,  3 Oct 2019 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119225;
        bh=wUMArCMv44sCYJ2XlCuHiE1HYCGfrF9Ws9YvNxtn1Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AceQm3x+y5rP0nLERWsmw8zmK3IEx/qCRpq0JkdZ/CKo5S9kzGxQULb9JrejvgkVK
         qiCYwbgFTY4x8HEJ3XHX0iZ69BVLmGk5vJQ598Zbrm8x6TF+4YSgUunDjaa6TbuXxG
         VWJU2pvxQw7EZSTu7pXB7sSPOyWeNp7Q9Yh3kuhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Thomas Lindroth <thomas.lindroth@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: [PATCH 4.14 165/185] memcg, kmem: do not fail __GFP_NOFAIL charges
Date:   Thu,  3 Oct 2019 17:54:03 +0200
Message-Id: <20191003154516.701606823@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit e55d9d9bfb69405bd7615c0f8d229d8fafb3e9b8 upstream.

Thomas has noticed the following NULL ptr dereference when using cgroup
v1 kmem limit:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
PGD 0
P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 3 PID: 16923 Comm: gtk-update-icon Not tainted 4.19.51 #42
Hardware name: Gigabyte Technology Co., Ltd. Z97X-Gaming G1/Z97X-Gaming G1, BIOS F9 07/31/2015
RIP: 0010:create_empty_buffers+0x24/0x100
Code: cd 0f 1f 44 00 00 0f 1f 44 00 00 41 54 49 89 d4 ba 01 00 00 00 55 53 48 89 fb e8 97 fe ff ff 48 89 c5 48 89 c2 eb 03 48 89 ca <48> 8b 4a 08 4c 09 22 48 85 c9 75 f1 48 89 6a 08 48 8b 43 18 48 8d
RSP: 0018:ffff927ac1b37bf8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: fffff2d4429fd740 RCX: 0000000100097149
RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff9075a99fbe00
RBP: 0000000000000000 R08: fffff2d440949cc8 R09: 00000000000960c0
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
R13: ffff907601f18360 R14: 0000000000002000 R15: 0000000000001000
FS:  00007fb55b288bc0(0000) GS:ffff90761f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 000000007aebc002 CR4: 00000000001606e0
Call Trace:
 create_page_buffers+0x4d/0x60
 __block_write_begin_int+0x8e/0x5a0
 ? ext4_inode_attach_jinode.part.82+0xb0/0xb0
 ? jbd2__journal_start+0xd7/0x1f0
 ext4_da_write_begin+0x112/0x3d0
 generic_perform_write+0xf1/0x1b0
 ? file_update_time+0x70/0x140
 __generic_file_write_iter+0x141/0x1a0
 ext4_file_write_iter+0xef/0x3b0
 __vfs_write+0x17e/0x1e0
 vfs_write+0xa5/0x1a0
 ksys_write+0x57/0xd0
 do_syscall_64+0x55/0x160
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Tetsuo then noticed that this is because the __memcg_kmem_charge_memcg
fails __GFP_NOFAIL charge when the kmem limit is reached.  This is a wrong
behavior because nofail allocations are not allowed to fail.  Normal
charge path simply forces the charge even if that means to cross the
limit.  Kmem accounting should be doing the same.

Link: http://lkml.kernel.org/r/20190906125608.32129-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Debugged-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2352,6 +2352,16 @@ int memcg_kmem_charge_memcg(struct page
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
+
+		/*
+		 * Enforce __GFP_NOFAIL allocation because callers are not
+		 * prepared to see failures and likely do not have any failure
+		 * handling code.
+		 */
+		if (gfp & __GFP_NOFAIL) {
+			page_counter_charge(&memcg->kmem, nr_pages);
+			return 0;
+		}
 		cancel_charge(memcg, nr_pages);
 		return -ENOMEM;
 	}


