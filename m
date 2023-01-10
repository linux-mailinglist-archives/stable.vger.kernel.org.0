Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD8664A31
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjAJSbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbjAJSac (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9B192370
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E25F61871
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D0C433EF;
        Tue, 10 Jan 2023 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375110;
        bh=ElH7abeN3VMb2QlXL88KTZ/TYWYmzKyL5+4uahvfH+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/VhzCMECTVTZ3g0TlubZDxjBLohm9ocivySkdwuxghPG5IaLKChZyv7nt7JzTY7y
         FLh9mtQ4/PdnweSsbkK3QmSkwEiu7IhpIKZWm4OqY9O9YePfez7qBZiOXLfK3wDD1Q
         gqa7gmXGhk5ixV2PrDC9oP7t0WW7PTmfccO6A4I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Jason Yan <yanaijie@huawei.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.15 064/290] jbd2: use the correct print format
Date:   Tue, 10 Jan 2023 19:02:36 +0100
Message-Id: <20230110180033.845135942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@linux.alibaba.com>

commit d87a7b4c77a997d5388566dd511ca8e6b8e8a0a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/jbd2.h |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

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
@@ -155,28 +155,28 @@ DECLARE_EVENT_CLASS(jbd2_handle_start_cl
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


