Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03543A006
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhJYT0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhJYTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D54A960200;
        Mon, 25 Oct 2021 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189730;
        bh=3CXNiWXZKicjn6I5eOTCFAlVoSEwStlpntWx8CQTVFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dcs5xxpgcK1KJZ/P+KWFXmu8x5k6WBP4b0ltE7pPb8p6+MBhijwkMb6mbpU7F0CSg
         /SXpFs6fnZwvGelnB5NqCntBcqpF3dGqVgadc1v/nlybOuEf8r3TRIRgxLAab1AUWI
         H0Lw34rrtOOTX/7bZT4Ff3Y2P9dY07ZBwg0ILkVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 12/30] ocfs2: mount fails with buffer overflow in strlen
Date:   Mon, 25 Oct 2021 21:14:32 +0200
Message-Id: <20211025190925.922249522@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

commit b15fa9224e6e1239414525d8d556d824701849fc upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/super.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2188,11 +2188,17 @@ static int ocfs2_initialize_super(struct
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
@@ -2201,9 +2207,9 @@ static int ocfs2_initialize_super(struct
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


