Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD821B8DE6
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 10:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDZI23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 04:28:29 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60548 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726108AbgDZI22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 04:28:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tuquanhuang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Twfm6jD_1587889684;
Received: from localhost(mailfrom:tuquanhuang@linux.alibaba.com fp:SMTPD_---0Twfm6jD_1587889684)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Apr 2020 16:28:25 +0800
From:   TuQuan <tuquanhuang@linux.alibaba.com>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     TuQuan <tuquanhuang@linux.alibaba.com>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] propogate_mnt: Handle the first propogated copy being a slave
Date:   Sun, 26 Apr 2020 16:28:01 +0800
Message-Id: <20200426082801.10275-1-tuquanhuang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5ec0811d30378ae104f250bfc9b3640242d81e3f upstream

When the first propgated copy was a slave the following oops would
result:
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
> IP: [<ffffffff811fba4e>] propagate_one+0xbe/0x1c0
> PGD bacd4067 PUD bac66067 PMD 0
> Oops: 0000 [#1] SMP
> Modules linked in:
> CPU: 1 PID: 824 Comm: mount Not tainted 4.6.0-rc5userns+ #1523
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> task: ffff8800bb0a8000 ti: ffff8800bac3c000 task.ti: ffff8800bac3c000
> RIP: 0010:[<ffffffff811fba4e>]  [<ffffffff811fba4e>]
> propagate_one+0xbe/0x1c0
> RSP: 0018:ffff8800bac3fd38  EFLAGS: 00010283
> RAX: 0000000000000000 RBX: ffff8800bb77ec00 RCX: 0000000000000010
> RDX: 0000000000000000 RSI: ffff8800bb58c000 RDI: ffff8800bb58c480
> RBP: ffff8800bac3fd48 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000001ca1 R11: 0000000000001c9d R12: 0000000000000000
> R13: ffff8800ba713800 R14: ffff8800bac3fda0 R15: ffff8800bb77ec00
> FS:  00007f3c0cd9b7e0(0000) GS:ffff8800bfb00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 00000000bb79d000 CR4: 00000000000006e0
> Stack:
>  ffff8800bb77ec00 0000000000000000 ffff8800bac3fd88 ffffffff811fbf85
>  ffff8800bac3fd98 ffff8800bb77f080 ffff8800ba713800 ffff8800bb262b40
>  0000000000000000 0000000000000000 ffff8800bac3fdd8 ffffffff811f1da0
> Call Trace:
>  [<ffffffff811fbf85>] propagate_mnt+0x105/0x140
>  [<ffffffff811f1da0>] attach_recursive_mnt+0x120/0x1e0
>  [<ffffffff811f1ec3>] graft_tree+0x63/0x70
>  [<ffffffff811f1f6b>] do_add_mount+0x9b/0x100
>  [<ffffffff811f2c1a>] do_mount+0x2aa/0xdf0
>  [<ffffffff8117efbe>] ? strndup_user+0x4e/0x70
>  [<ffffffff811f3a45>] SyS_mount+0x75/0xc0
>  [<ffffffff8100242b>] do_syscall_64+0x4b/0xa0
>  [<ffffffff81988f3c>] entry_SYSCALL64_slow_path+0x25/0x25
> Code: 00 00 75 ec 48 89 0d 02 22 22 01 8b 89 10 01 00 00 48 89 05 fd
> 21 22 01 39 8e 10 01 00 00 0f 84 e0 00 00 00 48 8b 80 d8 00 00 00 <48>
> 8b 50 10 48 89 05 df 21 22 01 48 89 15 d0 21 22 01 8b 53 30
> RIP  [<ffffffff811fba4e>] propagate_one+0xbe/0x1c0
>  RSP <ffff8800bac3fd38>
> CR2: 0000000000000010
> ---[ end trace 2725ecd95164f217 ]---

This oops happens with the namespace_sem held and can be triggered by
non-root users.  An all around not pleasant experience.

To avoid this scenario when finding the appropriate source mount to
copy stop the walk up the mnt_master chain when the first source mount
is encountered.

Further rewrite the walk up the last_source mnt_master chain so that
it is clear what is going on.

The reason why the first source mount is special is that it it's
mnt_parent is not a mount in the dest_mnt propagation tree, and as
such termination conditions based up on the dest_mnt mount propgation
tree do not make sense.

To avoid other kinds of confusion last_dest is not changed when
computing last_source.  last_dest is only used once in propagate_one
and that is above the point of the code being modified, so changing
the global variable is meaningless and confusing.

Cc: stable@vger.kernel.org
fixes: f2ebb3a921c1ca1e2ddd9242e95a1989a50c4c68 ("smarter
propagate_mnt()")
Reported-by: Tycho Andersen <tycho.andersen@canonical.com>
Reviewed-by: Seth Forshee <seth.forshee@canonical.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 7u/fs/pnode.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/7u/fs/pnode.c b/7u/fs/pnode.c
index 30d9a548d..52c262e71 100644
--- a/7u/fs/pnode.c
+++ b/7u/fs/pnode.c
@@ -198,10 +198,15 @@ static struct mount *next_group(struct mount *m, struct mount *origin)
 
 /* all accesses are serialized by namespace_sem */
 static struct user_namespace *user_ns;
-static struct mount *last_dest, *last_source, *dest_master;
+static struct mount *last_dest, *first_source, *last_source, *dest_master;
 static struct mountpoint *mp;
 static struct list_head *list;
 
+static inline bool peers(struct mount *m1, struct mount *m2)
+{
+	return m1->mnt_group_id == m2->mnt_group_id && m1->mnt_group_id;
+}
+
 static int propagate_one(struct mount *m)
 {
 	struct mount *child;
@@ -212,24 +217,26 @@ static int propagate_one(struct mount *m)
 	/* skip if mountpoint isn't covered by it */
 	if (!is_subdir(mp->m_dentry, m->mnt.mnt_root))
 		return 0;
-	if (m->mnt_group_id == last_dest->mnt_group_id) {
+	if (peers(m, last_dest)) {
 		type = CL_MAKE_SHARED;
 	} else {
 		struct mount *n, *p;
+		bool done;
 		for (n = m; ; n = p) {
 			p = n->mnt_master;
-			if (p == dest_master || IS_MNT_MARKED(p)) {
-				while (last_dest->mnt_master != p) {
-					last_source = last_source->mnt_master;
-					last_dest = last_source->mnt_parent;
-				}
-				if (n->mnt_group_id != last_dest->mnt_group_id) {
-					last_source = last_source->mnt_master;
-					last_dest = last_source->mnt_parent;
-				}
+			if (p == dest_master || IS_MNT_MARKED(p))
 				break;
-			}
 		}
+		do {
+			struct mount *parent = last_source->mnt_parent;
+			if (last_source == first_source)
+				break;
+			done = parent->mnt_master == p;
+			if (done && peers(n, parent))
+				break;
+			last_source = last_source->mnt_master;
+		} while (!done);
+
 		type = CL_SLAVE;
 		/* beginning of peer group among the slaves? */
 		if (IS_MNT_SHARED(m))
@@ -280,6 +287,7 @@ int propagate_mnt(struct mount *dest_mnt, struct mountpoint *dest_mp,
 	 */
 	user_ns = current->nsproxy->mnt_ns->user_ns;
 	last_dest = dest_mnt;
+	first_source = source_mnt;
 	last_source = source_mnt;
 	mp = dest_mp;
 	list = tree_list;
-- 
2.14.4.44.g2045bb6

