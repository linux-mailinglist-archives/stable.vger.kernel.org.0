Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D7C6D495F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjDCOhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjDCOhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E451517661
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8E261E73
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372F7C4339B;
        Mon,  3 Apr 2023 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532625;
        bh=j7Olql/pBMTxBnWXxPdBmoCP9e+t6SMG0F3pWTxdZgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybljk6vOD4l7aI06rsHztlce3wquVjktJcU4/Rff61hmXxdYo5CWb4/DcZsdVbd9E
         F1Qq33ucBPx8wW9fgLIrNdCDz1mR9AHu/dPYmiFRTvMXC7FSv9SD/iuMIN3qvI2ePO
         3wiULTls8nNWEd8rdp312Z5p93rKDpmKQ/aT4yt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/181] tracing: Add .percent suffix option to histogram values
Date:   Mon,  3 Apr 2023 16:07:40 +0200
Message-Id: <20230403140415.969533088@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit abaa5258ce5e5887a9de049f50a85dc023391a1c ]

Add .percent suffix option to show the histogram values in percentage.
This feature is useful when we need yo undersntand the overall trend
for the histograms of large values.
E.g. this shows the runtime percentage for each tasks.

------
  # cd /sys/kernel/debug/tracing/
  # echo hist:keys=pid:vals=hitcount,runtime.percent:sort=pid > \
    events/sched/sched_stat_runtime/trigger
  # sleep 10
  # cat events/sched/sched_stat_runtime/hist
 # event histogram
 #
 # trigger info: hist:keys=pid:vals=hitcount,runtime.percent:sort=pid:size=2048 [active]
 #

 { pid:          8 } hitcount:          7  runtime (%):   4.14
 { pid:         14 } hitcount:          5  runtime (%):   3.69
 { pid:         16 } hitcount:         11  runtime (%):   3.41
 { pid:         61 } hitcount:         41  runtime (%):  19.75
 { pid:         65 } hitcount:          4  runtime (%):   1.48
 { pid:         70 } hitcount:          6  runtime (%):   3.60
 { pid:         72 } hitcount:          2  runtime (%):   1.10
 { pid:        144 } hitcount:         10  runtime (%):  32.01
 { pid:        151 } hitcount:          8  runtime (%):  22.66
 { pid:        152 } hitcount:          2  runtime (%):   8.10

 Totals:
     Hits: 96
     Entries: 10
     Dropped: 0
-----

Link: https://lore.kernel.org/linux-trace-kernel/166610813077.56030.4238090506973562347.stgit@devnote2

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Stable-dep-of: e0213434fe3e ("tracing: Do not let histogram values have some modifiers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c             |  3 +-
 kernel/trace/trace_events_hist.c | 90 +++++++++++++++++++++++++++-----
 2 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 888980257340f..f714ed1f1c673 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5727,7 +5727,8 @@ static const char readme_msg[] =
 	"\t            .syscall    display a syscall id as a syscall name\n"
 	"\t            .log2       display log2 value rather than raw number\n"
 	"\t            .buckets=size  display values in groups of size rather than raw number\n"
-	"\t            .usecs      display a common_timestamp in microseconds\n\n"
+	"\t            .usecs      display a common_timestamp in microseconds\n"
+	"\t            .percent    display a number of percentage value\n\n"
 	"\t    The 'pause' parameter can be used to pause an existing hist\n"
 	"\t    trigger or to start a hist trigger but not log any events\n"
 	"\t    until told to do so.  'continue' can be used to start or\n"
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e3df03cdecbcb..1c207fbf5634f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -506,6 +506,7 @@ enum hist_field_flags {
 	HIST_FIELD_FL_ALIAS		= 1 << 16,
 	HIST_FIELD_FL_BUCKET		= 1 << 17,
 	HIST_FIELD_FL_CONST		= 1 << 18,
+	HIST_FIELD_FL_PERCENT		= 1 << 19,
 };
 
 struct var_defs {
@@ -1708,6 +1709,8 @@ static const char *get_hist_field_flags(struct hist_field *hist_field)
 		flags_str = "buckets";
 	else if (hist_field->flags & HIST_FIELD_FL_TIMESTAMP_USECS)
 		flags_str = "usecs";
+	else if (hist_field->flags & HIST_FIELD_FL_PERCENT)
+		flags_str = "percent";
 
 	return flags_str;
 }
@@ -2320,6 +2323,10 @@ parse_field(struct hist_trigger_data *hist_data, struct trace_event_file *file,
 			if (ret || !(*buckets))
 				goto error;
 			*flags |= HIST_FIELD_FL_BUCKET;
+		} else if (strncmp(modifier, "percent", 7) == 0) {
+			if (*flags & (HIST_FIELD_FL_VAR | HIST_FIELD_FL_KEY))
+				goto error;
+			*flags |= HIST_FIELD_FL_PERCENT;
 		} else {
  error:
 			hist_err(tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(modifier));
@@ -5297,33 +5304,69 @@ static void hist_trigger_print_key(struct seq_file *m,
 	seq_puts(m, "}");
 }
 
+/* Get the 100 times of the percentage of @val in @total */
+static inline unsigned int __get_percentage(u64 val, u64 total)
+{
+	if (!total)
+		goto div0;
+
+	if (val < (U64_MAX / 10000))
+		return (unsigned int)div64_ul(val * 10000, total);
+
+	total = div64_u64(total, 10000);
+	if (!total)
+		goto div0;
+
+	return (unsigned int)div64_ul(val, total);
+div0:
+	return val ? UINT_MAX : 0;
+}
+
+static void hist_trigger_print_val(struct seq_file *m, unsigned int idx,
+				   const char *field_name, unsigned long flags,
+				   u64 *totals, struct tracing_map_elt *elt)
+{
+	u64 val = tracing_map_read_sum(elt, idx);
+	unsigned int pc;
+
+	if (flags & HIST_FIELD_FL_PERCENT) {
+		pc = __get_percentage(val, totals[idx]);
+		if (pc == UINT_MAX)
+			seq_printf(m, " %s (%%):[ERROR]", field_name);
+		else
+			seq_printf(m, " %s (%%): %3u.%02u", field_name,
+					pc / 100, pc % 100);
+	} else if (flags & HIST_FIELD_FL_HEX) {
+		seq_printf(m, " %s: %10llx", field_name, val);
+	} else {
+		seq_printf(m, " %s: %10llu", field_name, val);
+	}
+}
+
 static void hist_trigger_entry_print(struct seq_file *m,
 				     struct hist_trigger_data *hist_data,
+				     u64 *totals,
 				     void *key,
 				     struct tracing_map_elt *elt)
 {
 	const char *field_name;
-	unsigned int i;
+	unsigned int i = HITCOUNT_IDX;
+	unsigned long flags;
 
 	hist_trigger_print_key(m, hist_data, key, elt);
 
-	seq_printf(m, " hitcount: %10llu",
-		   tracing_map_read_sum(elt, HITCOUNT_IDX));
+	/* At first, show the raw hitcount always */
+	hist_trigger_print_val(m, i, "hitcount", 0, totals, elt);
 
 	for (i = 1; i < hist_data->n_vals; i++) {
 		field_name = hist_field_name(hist_data->fields[i], 0);
+		flags = hist_data->fields[i]->flags;
 
-		if (hist_data->fields[i]->flags & HIST_FIELD_FL_VAR ||
-		    hist_data->fields[i]->flags & HIST_FIELD_FL_EXPR)
+		if (flags & HIST_FIELD_FL_VAR || flags & HIST_FIELD_FL_EXPR)
 			continue;
 
-		if (hist_data->fields[i]->flags & HIST_FIELD_FL_HEX) {
-			seq_printf(m, "  %s: %10llx", field_name,
-				   tracing_map_read_sum(elt, i));
-		} else {
-			seq_printf(m, "  %s: %10llu", field_name,
-				   tracing_map_read_sum(elt, i));
-		}
+		seq_puts(m, " ");
+		hist_trigger_print_val(m, i, field_name, flags, totals, elt);
 	}
 
 	print_actions(m, hist_data, elt);
@@ -5336,7 +5379,8 @@ static int print_entries(struct seq_file *m,
 {
 	struct tracing_map_sort_entry **sort_entries = NULL;
 	struct tracing_map *map = hist_data->map;
-	int i, n_entries;
+	int i, j, n_entries;
+	u64 *totals = NULL;
 
 	n_entries = tracing_map_sort_entries(map, hist_data->sort_keys,
 					     hist_data->n_sort_keys,
@@ -5344,11 +5388,29 @@ static int print_entries(struct seq_file *m,
 	if (n_entries < 0)
 		return n_entries;
 
+	for (j = 0; j < hist_data->n_vals; j++) {
+		if (!(hist_data->fields[j]->flags & HIST_FIELD_FL_PERCENT))
+			continue;
+		if (!totals) {
+			totals = kcalloc(hist_data->n_vals, sizeof(u64),
+					 GFP_KERNEL);
+			if (!totals) {
+				n_entries = -ENOMEM;
+				goto out;
+			}
+		}
+		for (i = 0; i < n_entries; i++)
+			totals[j] += tracing_map_read_sum(
+					sort_entries[i]->elt, j);
+	}
+
 	for (i = 0; i < n_entries; i++)
-		hist_trigger_entry_print(m, hist_data,
+		hist_trigger_entry_print(m, hist_data, totals,
 					 sort_entries[i]->key,
 					 sort_entries[i]->elt);
 
+	kfree(totals);
+out:
 	tracing_map_destroy_sort_entries(sort_entries, n_entries);
 
 	return n_entries;
-- 
2.39.2



