Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865452B612A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgKQNQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgKQNQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:16:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7354E206D5;
        Tue, 17 Nov 2020 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618981;
        bh=RQ1kzh+Mlqyc2N2MBby52SnnpV173ppyW1s2kdtnH4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ey7CQmpddw3J2mGx3Nez+az9oRPoJ5u5ppxmgwNRjsfWfs2DsH3QsRNuCGiz4ippl
         LMPXL2Vc30nMggI4gEj52PlisLDqPcvPzpWHd8OKH+Ct9LNHYaZ5JoMhMIMEd4D6k0
         zxFD3aQb+Odxjyn7o35cp38wfO97GUONL0kmGyOE=
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
Subject: [PATCH 4.14 66/85] perf/core: Fix bad use of igrab()
Date:   Tue, 17 Nov 2020 14:05:35 +0100
Message-Id: <20201117122114.261555116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    4 ++--
 include/linux/perf_event.h |    2 +-
 kernel/events/core.c       |   21 +++++++++------------
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1190,7 +1190,7 @@ static int pt_event_addr_filters_validat
 		if (!filter->range || !filter->size)
 			return -EOPNOTSUPP;
 
-		if (!filter->inode) {
+		if (!filter->path.dentry) {
 			if (!valid_kernel_ip(filter->offset))
 				return -EINVAL;
 
@@ -1217,7 +1217,7 @@ static void pt_event_addr_filters_sync(s
 		return;
 
 	list_for_each_entry(filter, &head->list, entry) {
-		if (filter->inode && !offs[range]) {
+		if (filter->path.dentry && !offs[range]) {
 			msr_a = msr_b = 0;
 		} else {
 			/* apply the offset */
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -466,7 +466,7 @@ struct pmu {
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
@@ -6450,7 +6450,7 @@ static void perf_event_addr_filters_exec
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		if (filter->inode) {
+		if (filter->path.dentry) {
 			event->addr_filters_offs[count] = 0;
 			restart++;
 		}
@@ -7124,7 +7124,7 @@ static bool perf_addr_filter_match(struc
 				     struct file *file, unsigned long offset,
 				     unsigned long size)
 {
-	if (filter->inode != file_inode(file))
+	if (d_inode(filter->path.dentry) != file_inode(file))
 		return false;
 
 	if (filter->offset > offset + size)
@@ -8345,8 +8345,7 @@ static void free_filters_list(struct lis
 	struct perf_addr_filter *filter, *iter;
 
 	list_for_each_entry_safe(filter, iter, filters, entry) {
-		if (filter->inode)
-			iput(filter->inode);
+		path_put(&filter->path);
 		list_del(&filter->entry);
 		kfree(filter);
 	}
@@ -8443,7 +8442,7 @@ static void perf_event_addr_filters_appl
 		 * Adjust base offset if the filter is associated to a binary
 		 * that needs to be mapped:
 		 */
-		if (filter->inode)
+		if (filter->path.dentry)
 			event->addr_filters_offs[count] =
 				perf_addr_filter_apply(filter, mm);
 
@@ -8516,7 +8515,6 @@ perf_event_parse_addr_filter(struct perf
 {
 	struct perf_addr_filter *filter = NULL;
 	char *start, *orig, *filename = NULL;
-	struct path path;
 	substring_t args[MAX_OPT_ARGS];
 	int state = IF_STATE_ACTION, token;
 	unsigned int kernel = 0;
@@ -8620,19 +8618,18 @@ perf_event_parse_addr_filter(struct perf
 					goto fail_free_name;
 
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
 
 				event->addr_filters.nr_file_filters++;


