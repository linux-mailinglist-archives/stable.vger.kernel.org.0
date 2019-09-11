Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CD2AFEF5
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfIKOkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbfIKOkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 10:40:36 -0400
Received: from X1 (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAFA2053B;
        Wed, 11 Sep 2019 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568212834;
        bh=7+lVFYbRktVQI+z/QVJmU6+lRbjrBmADarr84olHN4M=;
        h=Date:From:To:Subject:From;
        b=RnVsyfPzmxcPETO67LfPudE1yxPBDrx+7KGKALZ7ueOvtT99PDLPF7v4kYWxp9url
         dL7Pet0X+vnxcsXBfH/HUg2/ZzeRPIXzQ3+G0ucng1enIftoZjFspcQFIqK/LZti+o
         /cWfMCGnC9tRVgLivm53GcWEj1o+uQ1//5z/K5MQ=
Date:   Wed, 11 Sep 2019 07:40:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        thomas.lindroth@gmail.com, stable@vger.kernel.org,
        shakeelb@google.com, penguin-kernel@i-love.sakura.ne.jp,
        hannes@cmpxchg.org, aryabinin@virtuozzo.com, mhocko@suse.com
Subject:  + memcg-kmem-do-not-fail-__gfp_nofail-charges.patch added
 to -mm tree
Message-ID: <20190911144030.qkDA_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: memcg, kmem: do not fail __GFP_NOFAIL charges
has been added to the -mm tree.  Its filename is
     memcg-kmem-do-not-fail-__gfp_nofail-charges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-kmem-do-not-fail-__gfp_nofail-charges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-kmem-do-not-fail-__gfp_nofail-charges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg, kmem: do not fail __GFP_NOFAIL charges

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
---

 mm/memcontrol.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memcontrol.c~memcg-kmem-do-not-fail-__gfp_nofail-charges
+++ a/mm/memcontrol.c
@@ -2821,6 +2821,16 @@ int __memcg_kmem_charge_memcg(struct pag
 
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
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-kmem-do-not-fail-__gfp_nofail-charges.patch
mm-oom-consider-present-pages-for-the-node-size.patch

