Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57EA582B32
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiG0Q3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbiG0Q3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E5050712;
        Wed, 27 Jul 2022 09:24:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35CF2619C4;
        Wed, 27 Jul 2022 16:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E543C433C1;
        Wed, 27 Jul 2022 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939074;
        bh=Uknuv9wcc8IRez0QgrQGlZ4g7bk5i/d5XmE7lyLMh9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHiGViKde1acfJd0tIoVBrtilOs/s0/vOwhZF+vi4fIIdJfwTx6CAusQt2Szf1/Ur
         VvTzwakIexrR+WTTwTnMx2NgXDCsCojYpON4y1kyTdZftuND4L7rdpRFDaJxUS29oE
         FnTh4SdRjxEPCmG8CB7WS0tIeZpUvH0hxjQGVrso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Cheng <wanngchenng@gmail.com>,
        syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 16/37] mm/mempolicy: fix uninit-value in mpol_rebind_policy()
Date:   Wed, 27 Jul 2022 18:10:42 +0200
Message-Id: <20220727161001.510305892@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Cheng <wanngchenng@gmail.com>

commit 018160ad314d75b1409129b2247b614a9f35894c upstream.

mpol_set_nodemask()(mm/mempolicy.c) does not set up nodemask when
pol->mode is MPOL_LOCAL.  Check pol->mode before access
pol->w.cpuset_mems_allowed in mpol_rebind_policy()(mm/mempolicy.c).

BUG: KMSAN: uninit-value in mpol_rebind_policy mm/mempolicy.c:352 [inline]
BUG: KMSAN: uninit-value in mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
 mpol_rebind_policy mm/mempolicy.c:352 [inline]
 mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
 cpuset_change_task_nodemask kernel/cgroup/cpuset.c:1711 [inline]
 cpuset_attach+0x787/0x15e0 kernel/cgroup/cpuset.c:2278
 cgroup_migrate_execute+0x1023/0x1d20 kernel/cgroup/cgroup.c:2515
 cgroup_migrate kernel/cgroup/cgroup.c:2771 [inline]
 cgroup_attach_task+0x540/0x8b0 kernel/cgroup/cgroup.c:2804
 __cgroup1_procs_write+0x5cc/0x7a0 kernel/cgroup/cgroup-v1.c:520
 cgroup1_tasks_write+0x94/0xb0 kernel/cgroup/cgroup-v1.c:539
 cgroup_file_write+0x4c2/0x9e0 kernel/cgroup/cgroup.c:3852
 kernfs_fop_write_iter+0x66a/0x9f0 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0x1318/0x2030 fs/read_write.c:590
 ksys_write+0x28b/0x510 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0xdb/0x120 fs/read_write.c:652
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 slab_alloc mm/slub.c:3259 [inline]
 kmem_cache_alloc+0x902/0x11c0 mm/slub.c:3264
 mpol_new mm/mempolicy.c:293 [inline]
 do_set_mempolicy+0x421/0xb70 mm/mempolicy.c:853
 kernel_set_mempolicy mm/mempolicy.c:1504 [inline]
 __do_sys_set_mempolicy mm/mempolicy.c:1510 [inline]
 __se_sys_set_mempolicy+0x44c/0xb60 mm/mempolicy.c:1507
 __x64_sys_set_mempolicy+0xd8/0x110 mm/mempolicy.c:1507
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

KMSAN: uninit-value in mpol_rebind_task (2)
https://syzkaller.appspot.com/bug?id=d6eb90f952c2a5de9ea718a1b873c55cb13b59dc

This patch seems to fix below bug too.
KMSAN: uninit-value in mpol_rebind_mm (2)
https://syzkaller.appspot.com/bug?id=f2fecd0d7013f54ec4162f60743a2b28df40926b

The uninit-value is pol->w.cpuset_mems_allowed in mpol_rebind_policy().
When syzkaller reproducer runs to the beginning of mpol_new(),

	    mpol_new() mm/mempolicy.c
	  do_mbind() mm/mempolicy.c
	kernel_mbind() mm/mempolicy.c

`mode` is 1(MPOL_PREFERRED), nodes_empty(*nodes) is `true` and `flags`
is 0. Then

	mode = MPOL_LOCAL;
	...
	policy->mode = mode;
	policy->flags = flags;

will be executed. So in mpol_set_nodemask(),

	    mpol_set_nodemask() mm/mempolicy.c
	  do_mbind()
	kernel_mbind()

pol->mode is 4 (MPOL_LOCAL), that `nodemask` in `pol` is not initialized,
which will be accessed in mpol_rebind_policy().

Link: https://lkml.kernel.org/r/20220512123428.fq3wofedp6oiotd4@ppc.localdomain
Signed-off-by: Wang Cheng <wanngchenng@gmail.com>
Reported-by: <syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com>
Tested-by: <syzbot+217f792c92599518a2ab@syzkaller.appspotmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -347,7 +347,7 @@ static void mpol_rebind_preferred(struct
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
-	if (!pol)
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
 	if (!mpol_store_user_nodemask(pol) && !(pol->flags & MPOL_F_LOCAL) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))


