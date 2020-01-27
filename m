Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8DC14A74E
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 16:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgA0PiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 10:38:00 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48551 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729085AbgA0Ph7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 10:37:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9E7A851A;
        Mon, 27 Jan 2020 10:37:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 Jan 2020 10:37:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XAyU6H
        iXlrZFIpVI7aCgl+1cTnYT5wubPnD36ClY3VI=; b=ez4M/OL9coZXXpkzc9dqjR
        dswE1PlSO+vhgoo+rh3kC6GYc1V9sIyAkRCjmZnGQsHyW3tmQeQqEbO/tZc3TXsm
        /DlkNaVxAoX4u0q/s6si10p+4fkWEzi1Lb+9K6XGFtzj7DgH23skaDMATbJaR4SJ
        ltO8FkcCTFVvbUygbjeKEvFSjYkaT3AfsPHu8YVefnGkq+Ph3LPEdyof6DWikSP/
        Ho7lerMFH4lPVGCvaSiafpMTLBf/qs2h8cR+qJ5bO+ihregS3GFh82xzBCjVGs2h
        2T3NBdGM0DlNgS2w1XyXekrYz0Ho1dTtvWGEq57vlf7trW2gvh139H3ewIZS+s4Q
        ==
X-ME-Sender: <xms:1gMvXuk33PNzhHOY9XRQR6Q9ed87rVBHZf2beNwhVkN6prPGndjc1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfedvgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1gMvXqEZ8OgT_sqwLgygUKIfgRVfkRYbvh3Z1CE8-tExx3fswqSoGQ>
    <xmx:1gMvXnp8WOVJSbbbJj4gx6NtGe5uNXt7us4BHborB7AELJ2E-72Dfw>
    <xmx:1gMvXm6l-cHlllyfulfjJzSWyiAfDtexKn90iv2Fq9sQAATkmKRTbg>
    <xmx:1gMvXm6Nh1Og925ahn5LqIR_ulPFlikaUuXx9BzXxmE5cj4LVnOCWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C101F328005A;
        Mon, 27 Jan 2020 10:37:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] tracing: Fix histogram code when expression has same var as" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jan 2020 16:37:54 +0100
Message-ID: <15801394743854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8bcebc77e85f3d7536f96845a0fe94b1dddb6af0 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 20 Jan 2020 13:07:31 -0500
Subject: [PATCH] tracing: Fix histogram code when expression has same var as
 value

While working on a tool to convert SQL syntex into the histogram language of
the kernel, I discovered the following bug:

 # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events
 # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger
 # echo 'hist:keys=next_pid:delta=common_timestamp-$start,start2=$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger

Would not display any histograms in the sched_switch histogram side.

But if I were to swap the location of

  "delta=common_timestamp-$start" with "start2=$start"

Such that the last line had:

 # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger

The histogram works as expected.

What I found out is that the expressions clear out the value once it is
resolved. As the variables are resolved in the order listed, when
processing:

  delta=common_timestamp-$start

The $start is cleared. When it gets to "start2=$start", it errors out with
"unresolved symbol" (which is silent as this happens at the location of the
trace), and the histogram is dropped.

When processing the histogram for variable references, instead of adding a
new reference for a variable used twice, use the same reference. That way,
not only is it more efficient, but the order will no longer matter in
processing of the variables.

From Tom Zanussi:

 "Just to clarify some more about what the problem was is that without
  your patch, we would have two separate references to the same variable,
  and during resolve_var_refs(), they'd both want to be resolved
  separately, so in this case, since the first reference to start wasn't
  part of an expression, it wouldn't get the read-once flag set, so would
  be read normally, and then the second reference would do the read-once
  read and also be read but using read-once.  So everything worked and
  you didn't see a problem:

   from: start2=$start,delta=common_timestamp-$start

  In the second case, when you switched them around, the first reference
  would be resolved by doing the read-once, and following that the second
  reference would try to resolve and see that the variable had already
  been read, so failed as unset, which caused it to short-circuit out and
  not do the trigger action to generate the synthetic event:

   to: delta=common_timestamp-$start,start2=$start

  With your patch, we only have the single resolution which happens
  correctly the one time it's resolved, so this can't happen."

Link: https://lore.kernel.org/r/20200116154216.58ca08eb@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f6 ("tracing: Add variable reference handling to hist triggers")
Reviewed-by: Tom Zanuss <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index d33b046f985a..6ac35b9e195d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -116,6 +116,7 @@ struct hist_field {
 	struct ftrace_event_field	*field;
 	unsigned long			flags;
 	hist_field_fn_t			fn;
+	unsigned int			ref;
 	unsigned int			size;
 	unsigned int			offset;
 	unsigned int                    is_signed;
@@ -2427,8 +2428,16 @@ static int contains_operator(char *str)
 	return field_op;
 }
 
+static void get_hist_field(struct hist_field *hist_field)
+{
+	hist_field->ref++;
+}
+
 static void __destroy_hist_field(struct hist_field *hist_field)
 {
+	if (--hist_field->ref > 1)
+		return;
+
 	kfree(hist_field->var.name);
 	kfree(hist_field->name);
 	kfree(hist_field->type);
@@ -2470,6 +2479,8 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 	if (!hist_field)
 		return NULL;
 
+	hist_field->ref = 1;
+
 	hist_field->hist_data = hist_data;
 
 	if (flags & HIST_FIELD_FL_EXPR || flags & HIST_FIELD_FL_ALIAS)
@@ -2665,6 +2676,17 @@ static struct hist_field *create_var_ref(struct hist_trigger_data *hist_data,
 {
 	unsigned long flags = HIST_FIELD_FL_VAR_REF;
 	struct hist_field *ref_field;
+	int i;
+
+	/* Check if the variable already exists */
+	for (i = 0; i < hist_data->n_var_refs; i++) {
+		ref_field = hist_data->var_refs[i];
+		if (ref_field->var.idx == var_field->var.idx &&
+		    ref_field->var.hist_data == var_field->hist_data) {
+			get_hist_field(ref_field);
+			return ref_field;
+		}
+	}
 
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {

