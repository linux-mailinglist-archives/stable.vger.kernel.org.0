Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46802B6672
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgKQODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgKQNLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48791221EB;
        Tue, 17 Nov 2020 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618709;
        bh=BUclUuYgn4Y08iF/T/yjq2TNqKKw938+bWEZ7Ug7e0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4ZDYAYgu/hXaaLkqViOB/6FTOkGP4l6p9VxHRbz80dgCiS7LWWfD36palFCcbSAm
         7qNi5hzZcGozyLl5kW6+NbAUtbf8ULQPkCe3VG5aUoAoQP3LdmC7hnaDowNou9vGf3
         WZuRwXVH8wC+EAMHX6CSL5qwGPsrCnLFGI19na0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kernel-team@fb.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 59/78] perf/core: Fix bad use of igrab()
Date:   Tue, 17 Nov 2020 14:05:25 +0100
Message-Id: <20201117122111.996481401@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 9511bce9fe8e5e6c0f923c09243a713eba560141 upstream

As Miklos reported and suggested:

 "This pattern repeats two times in trace_uprobe.c and in
  kernel/events/core.c as well:

      ret = kern_path(filename, LOOKUP_FOLLOW, &path);
      if (ret)
          goto fail_address_parse;

      inode = igrab(d_inode(path.dentry));
      path_put(&path);

  And it's wrong.  You can only hold a reference to the inode if you
  have an active ref to the superblock as well (which is normally
  through path.mnt) or holding s_umount.

  This way unmounting the containing filesystem while the tracepoint is
  active will give you the "VFS: Busy inodes after unmount..." message
  and a crash when the inode is finally put.

  Solution: store path instead of inode."

This patch fixes the issue in kernel/event/core.c.

Reviewed-and-tested-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <kernel-team@fb.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Link: http://lkml.kernel.org/r/20180418062907.3210386-2-songliubraving@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[sudip: Backported to 4.9: use file_inode()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    4 ++--
 include/linux/perf_event.h |    2 +-
 kernel/events/core.c       |   21 +++++++++------------
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1117,7 +1117,7 @@ static int pt_event_addr_filters_validat
 		if (!filter->range || !filter->size)
 			return -EOPNOTSUPP;
 
-		if (!filter->inode) {
+		if (!filter->path.dentry) {
 			if (!valid_kernel_ip(filter->offset))
 				return -EINVAL;
 
@@ -1144,7 +1144,7 @@ static void pt_event_addr_filters_sync(s
 		return;
 
 	list_for_each_entry(filter, &head->list, entry) {
-		if (filter->inode && !offs[range]) {
+		if (filter->path.dentry && !offs[range]) {
 			msr_a = msr_b = 0;
 		} else {
 			/* apply the offset */
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -475,7 +475,7 @@ struct pmu {
  */
 struct perf_addr_filter {
 	struct list_head	entry;
-	struct inode		*inode;
+	struct path		path;
 	unsigned long		offset;
 	unsigned long		size;
 	unsigned int		range	: 1,
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6271,7 +6271,7 @@ static void perf_event_addr_filters_exec
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		if (filter->inode) {
+		if (filter->path.dentry) {
 			event->addr_filters_offs[count] = 0;
 			restart++;
 		}
@@ -6814,7 +6814,7 @@ static bool perf_addr_filter_match(struc
 				     struct file *file, unsigned long offset,
 				     unsigned long size)
 {
-	if (filter->inode != file->f_inode)
+	if (d_inode(filter->path.dentry) != file_inode(file))
 		return false;
 
 	if (filter->offset > offset + size)
@@ -8028,8 +8028,7 @@ static void free_filters_list(struct lis
 	struct perf_addr_filter *filter, *iter;
 
 	list_for_each_entry_safe(filter, iter, filters, entry) {
-		if (filter->inode)
-			iput(filter->inode);
+		path_put(&filter->path);
 		list_del(&filter->entry);
 		kfree(filter);
 	}
@@ -8123,7 +8122,7 @@ static void perf_event_addr_filters_appl
 		 * Adjust base offset if the filter is associated to a binary
 		 * that needs to be mapped:
 		 */
-		if (filter->inode)
+		if (filter->path.dentry)
 			event->addr_filters_offs[count] =
 				perf_addr_filter_apply(filter, mm);
 
@@ -8196,7 +8195,6 @@ perf_event_parse_addr_filter(struct perf
 {
 	struct perf_addr_filter *filter = NULL;
 	char *start, *orig, *filename = NULL;
-	struct path path;
 	substring_t args[MAX_OPT_ARGS];
 	int state = IF_STATE_ACTION, token;
 	unsigned int kernel = 0;
@@ -8287,19 +8285,18 @@ perf_event_parse_addr_filter(struct perf
 					goto fail;
 
 				/* look up the path and grab its inode */
-				ret = kern_path(filename, LOOKUP_FOLLOW, &path);
+				ret = kern_path(filename, LOOKUP_FOLLOW,
+						&filter->path);
 				if (ret)
 					goto fail_free_name;
 
-				filter->inode = igrab(d_inode(path.dentry));
-				path_put(&path);
 				kfree(filename);
 				filename = NULL;
 
 				ret = -EINVAL;
-				if (!filter->inode ||
-				    !S_ISREG(filter->inode->i_mode))
-					/* free_filters_list() will iput() */
+				if (!filter->path.dentry ||
+				    !S_ISREG(d_inode(filter->path.dentry)
+					     ->i_mode))
 					goto fail;
 			}
 


