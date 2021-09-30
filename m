Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1202D41E3F7
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 00:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhI3Wc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 18:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhI3Wc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 18:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D44F361881;
        Thu, 30 Sep 2021 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041045;
        bh=+EX9VfKKSCzzbFHjEueLvJAebkCEDwVb/N+qK6OHbT4=;
        h=Date:From:To:Subject:From;
        b=mSPEfaqx6J8ANxumYYjldTe5QF92WzC8BT5ZS1zs3VeKMbbwa4JAcqp0VGgbF7Qp9
         bOLz8G2LTPXAc6zB6Pxn3W5pVMak2cjth14hgU5/MTkHHnRk5poPFeTYycG3VDWrE2
         AGqYLbeMwm9dALc0izWBvf7e6s0HHtVy4eUbrVf4=
Date:   Thu, 30 Sep 2021 15:30:44 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, vvidic@valentin-vidic.from.hr
Subject:  + ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch
 added to -mm tree
Message-ID: <20210930223044.KchedDq_r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: mount fails with buffer overflow in strlen
has been added to the -mm tree.  Its filename is
     ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: ocfs2: mount fails with buffer overflow in strlen

Starting with kernel 5.11 built with CONFIG_FORTIFY_SOURCE mouting an
ocfs2 filesystem with either o2cb or pcmk cluster stack fails with the
trace below.  Problem seems to be that strings for cluster stack and
cluster name are not guaranteed to be null terminated in the disk
representation, while strlcpy assumes that the source string is always
null terminated.  This causes a read outside of the source string
triggering the buffer overflow detection.

detected buffer overflow in strlen
------------[ cut here ]------------
kernel BUG at lib/string.c:1149!
invalid opcode: 0000 [#1] SMP PTI
CPU: 1 PID: 910 Comm: mount.ocfs2 Not tainted 5.14.0-1-amd64 #1
  Debian 5.14.6-2
RIP: 0010:fortify_panic+0xf/0x11
...
Call Trace:
 ocfs2_initialize_super.isra.0.cold+0xc/0x18 [ocfs2]
 ocfs2_fill_super+0x359/0x19b0 [ocfs2]
 mount_bdev+0x185/0x1b0
 ? ocfs2_remount+0x440/0x440 [ocfs2]
 legacy_get_tree+0x27/0x40
 vfs_get_tree+0x25/0xb0
 path_mount+0x454/0xa20
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x3b/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Link: https://lkml.kernel.org/r/20210929180654.32460-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-mount-fails-with-buffer-overflow-in-strlen
+++ a/fs/ocfs2/super.c
@@ -2167,11 +2167,17 @@ static int ocfs2_initialize_super(struct
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
+		/*
+		 * ci_stack and ci_cluster in ocfs2_cluster_info may not be null
+		 * terminated, so make sure no overflow happens here by using
+		 * memcpy. Destination strings will always be null terminated
+		 * because osb is allocated using kzalloc.
+		 */
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		strlcpy(osb->osb_cluster_stack,
+		memcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN + 1);
+		       OCFS2_STACK_LABEL_LEN);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2180,9 +2186,9 @@ static int ocfs2_initialize_super(struct
 			status = -EINVAL;
 			goto bail;
 		}
-		strlcpy(osb->osb_cluster_name,
+		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
-			OCFS2_CLUSTER_NAME_LEN + 1);
+			OCFS2_CLUSTER_NAME_LEN);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
_

Patches currently in -mm which might be from vvidic@valentin-vidic.from.hr are

ocfs2-mount-fails-with-buffer-overflow-in-strlen.patch

