Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC2865D306
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjADMt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjADMt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:49:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B7C1868D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:49:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91513B81642
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0325C433D2;
        Wed,  4 Jan 2023 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836594;
        bh=iPjUPswC5C/b4xIf2PLU+awUDvN87eScl1CxhV+sWso=;
        h=Subject:To:Cc:From:Date:From;
        b=r13VA+o8u56vhmd6Se0JTWUl8tYYbMIvvN3N90F73pK2i2zi3us+cHPDqOTPxR9RS
         /nPtG9AozKUEu/sdfLKy9cE1LHfFhjzfEYxFteqqvT/i/jd/DYsMjRsyKVAkFVzvkM
         LMzgqW70Euj1eKTMeTw6kdGfQ3J0yW44coMtdo9Y=
Subject: FAILED: patch "[PATCH] jbd2: use the correct print format" failed to apply to 4.14-stable tree
To:     cuibixuan@linux.alibaba.com, tytso@mit.edu, yanaijie@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:49:47 +0100
Message-ID: <167283658758230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d87a7b4c77a9 ("jbd2: use the correct print format")
0094f981bbac ("jbd2: Provide trace event for handle restarts")
fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")
ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
a9a8344ee171 ("ext4, jbd2: Provide accessor function for handle credits")
a413036791d0 ("ext4: Provide function to handle transaction restarts")
538bcaa6261b ("jbd2: fix race when writing superblock")
32ea275008d8 ("jbd2: update locking documentation for transaction_t")
0b02f4c0d6d9 ("ext4: fix reserved cluster accounting at delayed write time")
1dc0aa46e74a ("ext4: add new pending reservation mechanism")
ad431025aecd ("ext4: generalize extents status tree search functions")
fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer")
a6d9946bb925 ("ext4: eliminate sleep from shutdown ioctl")
f69120ce6c02 ("jbd2: fix sphinx kernel-doc build warnings")
d77147ff443b ("ext4: add support for online resizing with bigalloc")
545052e9e35a ("ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA")
19fe5f643f89 ("iomap: Switch from blkno to disk offset")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d87a7b4c77a997d5388566dd511ca8e6b8e8a0a8 Mon Sep 17 00:00:00 2001
From: Bixuan Cui <cuibixuan@linux.alibaba.com>
Date: Tue, 11 Oct 2022 19:33:44 +0800
Subject: [PATCH] jbd2: use the correct print format

The print format error was found when using ftrace event:
    <...>-1406 [000] .... 23599442.895823: jbd2_end_commit: dev 252,8 transaction -1866216965 sync 0 head -1866217368
    <...>-1406 [000] .... 23599442.896299: jbd2_start_commit: dev 252,8 transaction -1866216964 sync 0

Use the correct print format for transaction, head and tid.

Fixes: 879c5e6b7cb4 ('jbd2: convert instrumentation from markers to tracepoints')
Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/1665488024-95172-1-git-send-email-cuibixuan@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 99f783c384bb..8f5ee380d309 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
+		__field(	tid_t,	transaction		  )
 	),
 
 	TP_fast_assign(
@@ -49,7 +49,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %u sync %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit)
 );
@@ -97,8 +97,8 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-		__field(	int,	head		  	  )
+		__field(	tid_t,	transaction		  )
+		__field(	tid_t,	head		  	  )
 	),
 
 	TP_fast_assign(
@@ -108,7 +108,7 @@ TRACE_EVENT(jbd2_end_commit,
 		__entry->head		= journal->j_tail_sequence;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d head %d",
+	TP_printk("dev %d,%d transaction %u sync %d head %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit, __entry->head)
 );
@@ -134,14 +134,14 @@ TRACE_EVENT(jbd2_submit_inode_data,
 );
 
 DECLARE_EVENT_CLASS(jbd2_handle_start_class,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	requested_blocks)
@@ -155,28 +155,28 @@ DECLARE_EVENT_CLASS(jbd2_handle_start_class,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_start,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_restart,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 TRACE_EVENT(jbd2_handle_extend,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int buffer_credits,
 		 int requested_blocks),
 
@@ -184,7 +184,7 @@ TRACE_EVENT(jbd2_handle_extend,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	buffer_credits  )
@@ -200,7 +200,7 @@ TRACE_EVENT(jbd2_handle_extend,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "buffer_credits %d requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->buffer_credits,
@@ -208,7 +208,7 @@ TRACE_EVENT(jbd2_handle_extend,
 );
 
 TRACE_EVENT(jbd2_handle_stats,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int interval, int sync,
 		 int requested_blocks, int dirtied_blocks),
 
@@ -217,7 +217,7 @@ TRACE_EVENT(jbd2_handle_stats,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	interval	)
@@ -237,7 +237,7 @@ TRACE_EVENT(jbd2_handle_stats,
 		__entry->dirtied_blocks	  = dirtied_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u interval %d "
+	TP_printk("dev %d,%d tid %u type %u line_no %u interval %d "
 		  "sync %d requested_blocks %d dirtied_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->interval,
@@ -246,14 +246,14 @@ TRACE_EVENT(jbd2_handle_stats,
 );
 
 TRACE_EVENT(jbd2_run_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_run_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	wait		)
 		__field(	unsigned long,	request_delay	)
 		__field(	unsigned long,	running		)
@@ -279,7 +279,7 @@ TRACE_EVENT(jbd2_run_stats,
 		__entry->blocks_logged	= stats->rs_blocks_logged;
 	),
 
-	TP_printk("dev %d,%d tid %lu wait %u request_delay %u running %u "
+	TP_printk("dev %d,%d tid %u wait %u request_delay %u running %u "
 		  "locked %u flushing %u logging %u handle_count %u "
 		  "blocks %u blocks_logged %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
@@ -294,14 +294,14 @@ TRACE_EVENT(jbd2_run_stats,
 );
 
 TRACE_EVENT(jbd2_checkpoint_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_chp_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	chp_time	)
 		__field(		__u32,	forced_to_close	)
 		__field(		__u32,	written		)
@@ -317,7 +317,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		__entry->dropped	= stats->cs_dropped;
 	),
 
-	TP_printk("dev %d,%d tid %lu chp_time %u forced_to_close %u "
+	TP_printk("dev %d,%d tid %u chp_time %u forced_to_close %u "
 		  "written %u dropped %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),

