Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A608C321772
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBVMso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhBVMoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E201864E41;
        Mon, 22 Feb 2021 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997692;
        bh=JPZprT87LOh4bLuxjdeghrHlfEaA/7LUcZfziS9BAVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb/bKfp/vXJAQHb6TuuI5FTEQz3cSsOTm0jaUEaWyT+VpXMbI2vbmgEy/bHNlmYq8
         +KkpsJnZEZ/nx/Z8hzzBe3KHqrsx0XbIMbmIUU5QT497T9tQL7wDP8X5p0sK0VU1gI
         G16tPvxqixxmQ+r6uW1YvIaz7sAXjJjY7fqEi+Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Jan Kara <jack@suse.cz>, "Tobin C. Harding" <tobin@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Nitin Gote <nitin.r.gote@intel.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Stephen Kitt <steve@sk2.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/49] include/trace/events/writeback.h: fix -Wstringop-truncation warnings
Date:   Mon, 22 Feb 2021 13:36:09 +0100
Message-Id: <20210222121025.372271178@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit d1a445d3b86c9341ce7a0954c23be0edb5c9bec5 ]

There are many of those warnings.

In file included from ./arch/powerpc/include/asm/paca.h:15,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/thread_info.h:21,
                 from ./include/asm-generic/preempt.h:5,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:51,
                 from fs/fs-writeback.c:19:
In function 'strncpy',
    inlined from 'perf_trace_writeback_page_template' at
./include/trace/events/writeback.h:56:1:
./include/linux/string.h:260:9: warning: '__builtin_strncpy' specified
bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by using the new strscpy_pad() which was introduced in "lib/string:
Add strscpy_pad() function" and will always be NUL-terminated instead of
strncpy().  Also, change strlcpy() to use strscpy_pad() in this file for
consistency.

Link: http://lkml.kernel.org/r/1564075099-27750-1-git-send-email-cai@lca.pw
Fixes: 455b2864686d ("writeback: Initial tracing support")
Fixes: 028c2dd184c0 ("writeback: Add tracing to balance_dirty_pages")
Fixes: e84d0a4f8e39 ("writeback: trace event writeback_queue_io")
Fixes: b48c104d2211 ("writeback: trace event bdi_dirty_ratelimit")
Fixes: cc1676d917f3 ("writeback: Move requeueing when I_SYNC set to writeback_sb_inodes()")
Fixes: 9fb0a7da0c52 ("writeback: add more tracepoints")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nitin Gote <nitin.r.gote@intel.com>
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc: Stephen Kitt <steve@sk2.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/writeback.h | 38 +++++++++++++++++---------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index ec964a924cd2f..c6cea40e6e6fc 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -65,8 +65,9 @@ TRACE_EVENT(writeback_dirty_page,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,
-			mapping ? dev_name(inode_to_bdi(mapping->host)->dev) : "(unknown)", 32);
+		strscpy_pad(__entry->name,
+			    mapping ? dev_name(inode_to_bdi(mapping->host)->dev) : "(unknown)",
+			    32);
 		__entry->ino = mapping ? mapping->host->i_ino : 0;
 		__entry->index = page->index;
 	),
@@ -95,8 +96,8 @@ DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 
 		/* may be called for files on pseudo FSes w/ unregistered bdi */
-		strncpy(__entry->name,
-			bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
+		strscpy_pad(__entry->name,
+			    bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->flags		= flags;
@@ -175,8 +176,8 @@ DECLARE_EVENT_CLASS(writeback_write_inode_template,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,
-			dev_name(inode_to_bdi(inode)->dev), 32);
+		strscpy_pad(__entry->name,
+			    dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
@@ -219,8 +220,9 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__field(unsigned int, cgroup_ino)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name,
-			wb->bdi->dev ? dev_name(wb->bdi->dev) : "(unknown)", 32);
+		strscpy_pad(__entry->name,
+			    wb->bdi->dev ? dev_name(wb->bdi->dev) :
+			    "(unknown)", 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
 		__entry->sync_mode = work->sync_mode;
@@ -273,7 +275,7 @@ DECLARE_EVENT_CLASS(writeback_class,
 		__field(unsigned int, cgroup_ino)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
 		__entry->cgroup_ino = __trace_wb_assign_cgroup(wb);
 	),
 	TP_printk("bdi %s: cgroup_ino=%u",
@@ -296,7 +298,7 @@ TRACE_EVENT(writeback_bdi_register,
 		__array(char, name, 32)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
 	),
 	TP_printk("bdi %s",
 		__entry->name
@@ -321,7 +323,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		strscpy_pad(__entry->name, dev_name(bdi->dev), 32);
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->sync_mode	= wbc->sync_mode;
@@ -372,7 +374,7 @@ TRACE_EVENT(writeback_queue_io,
 		__field(unsigned int,	cgroup_ino)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
+		strncpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
 		__entry->older	= dirtied_before;
 		__entry->age	= (jiffies - dirtied_before) * 1000 / HZ;
 		__entry->moved	= moved;
@@ -457,7 +459,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 	),
 
 	TP_fast_assign(
-		strlcpy(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
 		__entry->write_bw	= KBps(wb->write_bandwidth);
 		__entry->avg_write_bw	= KBps(wb->avg_write_bandwidth);
 		__entry->dirty_rate	= KBps(dirty_rate);
@@ -522,7 +524,7 @@ TRACE_EVENT(balance_dirty_pages,
 
 	TP_fast_assign(
 		unsigned long freerun = (thresh + bg_thresh) / 2;
-		strlcpy(__entry->bdi, dev_name(wb->bdi->dev), 32);
+		strscpy_pad(__entry->bdi, dev_name(wb->bdi->dev), 32);
 
 		__entry->limit		= global_wb_domain.dirty_limit;
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
@@ -582,8 +584,8 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,
-		        dev_name(inode_to_bdi(inode)->dev), 32);
+		strscpy_pad(__entry->name,
+			    dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
@@ -656,8 +658,8 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,
-			dev_name(inode_to_bdi(inode)->dev), 32);
+		strscpy_pad(__entry->name,
+			    dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
-- 
2.27.0



