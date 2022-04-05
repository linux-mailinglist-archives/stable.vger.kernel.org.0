Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317E04F3026
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbiDEIov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241183AbiDEIcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7711705F;
        Tue,  5 Apr 2022 01:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DACA609D0;
        Tue,  5 Apr 2022 08:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB57C385A4;
        Tue,  5 Apr 2022 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147348;
        bh=NbhZxulE4dNDdM0dc5jITvejFZIK3spTYPiD1mxRs+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9oXcp0bwRqnovLEo/9S5DT2BUrIl+8qv8FFAV3IJWAC6IXQ0fqxxR5N3sR21U9mI
         gfGd+FTow+iBCX7j7gUgtLRNaTYPfKZort1y74IFBQUDu5BYYCF2AtostTXLfV+MjQ
         NmAq5+UuVbjeiskeTPVul3gjse28rdvj7Q3tnKZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Eugene Loh <eugene.loh@oracle.com>
Subject: [PATCH 5.17 1085/1126] bpf: Adjust BPF stack helper functions to accommodate skip > 0
Date:   Tue,  5 Apr 2022 09:30:32 +0200
Message-Id: <20220405070439.298622313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

commit ee2a098851bfbe8bcdd964c0121f4246f00ff41e upstream.

Let's say that the caller has storage for num_elem stack frames.  Then,
the BPF stack helper functions walk the stack for only num_elem frames.
This means that if skip > 0, one keeps only 'num_elem - skip' frames.

This is because it sets init_nr in the perf_callchain_entry to the end
of the buffer to save num_elem entries only.  I believe it was because
the perf callchain code unwound the stack frames until it reached the
global max size (sysctl_perf_event_max_stack).

However it now has perf_callchain_entry_ctx.max_stack to limit the
iteration locally.  This simplifies the code to handle init_nr in the
BPF callstack entries and removes the confusion with the perf_event's
__PERF_SAMPLE_CALLCHAIN_EARLY which sets init_nr to 0.

Also change the comment on bpf_get_stack() in the header file to be
more explicit what the return value means.

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com
Link: https://lore.kernel.org/bpf/20220314182042.71025-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Based-on-patch-by: Eugene Loh <eugene.loh@oracle.com>
---
 include/uapi/linux/bpf.h |    8 +++---
 kernel/bpf/stackmap.c    |   56 ++++++++++++++++++++---------------------------
 2 files changed, 28 insertions(+), 36 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2975,8 +2975,8 @@ union bpf_attr {
  *
  * 			# sysctl kernel.perf_event_max_stack=<new value>
  * 	Return
- * 		A non-negative value equal to or less than *size* on success,
- * 		or a negative error in case of failure.
+ * 		The non-negative copied *buf* length equal to or less than
+ * 		*size* on success, or a negative error in case of failure.
  *
  * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
  * 	Description
@@ -4279,8 +4279,8 @@ union bpf_attr {
  *
  *			# sysctl kernel.perf_event_max_stack=<new value>
  *	Return
- *		A non-negative value equal to or less than *size* on success,
- *		or a negative error in case of failure.
+ * 		The non-negative copied *buf* length equal to or less than
+ * 		*size* on success, or a negative error in case of failure.
  *
  * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res, u32 len, u64 flags)
  *	Description
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -166,7 +166,7 @@ static void stack_map_get_build_id_offse
 }
 
 static struct perf_callchain_entry *
-get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
+get_callchain_entry_for_task(struct task_struct *task, u32 max_depth)
 {
 #ifdef CONFIG_STACKTRACE
 	struct perf_callchain_entry *entry;
@@ -177,9 +177,8 @@ get_callchain_entry_for_task(struct task
 	if (!entry)
 		return NULL;
 
-	entry->nr = init_nr +
-		stack_trace_save_tsk(task, (unsigned long *)(entry->ip + init_nr),
-				     sysctl_perf_event_max_stack - init_nr, 0);
+	entry->nr = stack_trace_save_tsk(task, (unsigned long *)entry->ip,
+					 max_depth, 0);
 
 	/* stack_trace_save_tsk() works on unsigned long array, while
 	 * perf_callchain_entry uses u64 array. For 32-bit systems, it is
@@ -191,7 +190,7 @@ get_callchain_entry_for_task(struct task
 		int i;
 
 		/* copy data from the end to avoid using extra buffer */
-		for (i = entry->nr - 1; i >= (int)init_nr; i--)
+		for (i = entry->nr - 1; i >= 0; i--)
 			to[i] = (u64)(from[i]);
 	}
 
@@ -208,27 +207,19 @@ static long __bpf_get_stackid(struct bpf
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *bucket, *new_bucket, *old_bucket;
-	u32 max_depth = map->value_size / stack_map_data_size(map);
-	/* stack_map_alloc() checks that max_depth <= sysctl_perf_event_max_stack */
-	u32 init_nr = sysctl_perf_event_max_stack - max_depth;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	u32 hash, id, trace_nr, trace_len;
 	bool user = flags & BPF_F_USER_STACK;
 	u64 *ips;
 	bool hash_matches;
 
-	/* get_perf_callchain() guarantees that trace->nr >= init_nr
-	 * and trace-nr <= sysctl_perf_event_max_stack, so trace_nr <= max_depth
-	 */
-	trace_nr = trace->nr - init_nr;
-
-	if (trace_nr <= skip)
+	if (trace->nr <= skip)
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
-	trace_nr -= skip;
+	trace_nr = trace->nr - skip;
 	trace_len = trace_nr * sizeof(u64);
-	ips = trace->ip + skip + init_nr;
+	ips = trace->ip + skip;
 	hash = jhash2((u32 *)ips, trace_len / sizeof(u32), 0);
 	id = hash & (smap->n_buckets - 1);
 	bucket = READ_ONCE(smap->buckets[id]);
@@ -285,8 +276,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 	   u64, flags)
 {
 	u32 max_depth = map->value_size / stack_map_data_size(map);
-	/* stack_map_alloc() checks that max_depth <= sysctl_perf_event_max_stack */
-	u32 init_nr = sysctl_perf_event_max_stack - max_depth;
+	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
@@ -295,8 +285,12 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
 		return -EINVAL;
 
-	trace = get_perf_callchain(regs, init_nr, kernel, user,
-				   sysctl_perf_event_max_stack, false, false);
+	max_depth += skip;
+	if (max_depth > sysctl_perf_event_max_stack)
+		max_depth = sysctl_perf_event_max_stack;
+
+	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
+				   false, false);
 
 	if (unlikely(!trace))
 		/* couldn't fetch the stack trace */
@@ -387,7 +381,7 @@ static long __bpf_get_stack(struct pt_re
 			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags)
 {
-	u32 init_nr, trace_nr, copy_len, elem_size, num_elem;
+	u32 trace_nr, copy_len, elem_size, num_elem, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
@@ -412,30 +406,28 @@ static long __bpf_get_stack(struct pt_re
 		goto err_fault;
 
 	num_elem = size / elem_size;
-	if (sysctl_perf_event_max_stack < num_elem)
-		init_nr = 0;
-	else
-		init_nr = sysctl_perf_event_max_stack - num_elem;
+	max_depth = num_elem + skip;
+	if (sysctl_perf_event_max_stack < max_depth)
+		max_depth = sysctl_perf_event_max_stack;
 
 	if (trace_in)
 		trace = trace_in;
 	else if (kernel && task)
-		trace = get_callchain_entry_for_task(task, init_nr);
+		trace = get_callchain_entry_for_task(task, max_depth);
 	else
-		trace = get_perf_callchain(regs, init_nr, kernel, user,
-					   sysctl_perf_event_max_stack,
+		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
 					   false, false);
 	if (unlikely(!trace))
 		goto err_fault;
 
-	trace_nr = trace->nr - init_nr;
-	if (trace_nr < skip)
+	if (trace->nr < skip)
 		goto err_fault;
 
-	trace_nr -= skip;
+	trace_nr = trace->nr - skip;
 	trace_nr = (trace_nr <= num_elem) ? trace_nr : num_elem;
 	copy_len = trace_nr * elem_size;
-	ips = trace->ip + skip + init_nr;
+
+	ips = trace->ip + skip;
 	if (user && user_build_id)
 		stack_map_get_build_id_offset(buf, ips, trace_nr, user);
 	else


