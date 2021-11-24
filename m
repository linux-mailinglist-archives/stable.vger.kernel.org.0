Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712B445C36B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352814AbhKXNiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352462AbhKXNgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF0261373;
        Wed, 24 Nov 2021 12:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758496;
        bh=yJG8SUzlK8MQeZ0ZqUHBMQvIQAKWXmQAACiojp/WX8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xwo8t9P9pxS+8fVXMFjIr9Pf2tYJJHlkLUWS/eBveO/3oLRQl0Y8VsqUzopcQT1Tn
         5pedzRM8BVlN+pmNf0TkE3kWk0SglAepbC7ACFodywwhDFKD52hu4cfChHPSOz2X30
         v27rj60ItQ+ClEALO8ddBIdCAb7LAAwdac8qn074=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/154] tracing: Add length protection to histogram string copies
Date:   Wed, 24 Nov 2021 12:57:48 +0100
Message-Id: <20211124115704.654987613@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 938aa33f14657c9ed9deea348b7d6f14b6d69cb7 ]

The string copies to the histogram storage has a max size of 256 bytes
(defined by MAX_FILTER_STR_VAL). Only the string size of the event field
needs to be copied to the event storage, but no more than what is in the
event storage. Although nothing should be bigger than 256 bytes, there's
no protection against overwriting of the storage if one day there is.

Copy no more than the destination size, and enforce it.

Also had to turn MAX_FILTER_STR_VAL into an unsigned int, to keep the
min() comparison of the string sizes of comparable types.

Link: https://lore.kernel.org/all/CAHk-=wjREUihCGrtRBwfX47y_KrLCGjiq3t6QtoNJpmVrAEb1w@mail.gmail.com/
Link: https://lkml.kernel.org/r/20211114132834.183429a4@rorschach.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 63f84ae6b82b ("tracing/histogram: Do not copy the fixed-size char array field over the field size")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h     | 2 +-
 kernel/trace/trace_events_hist.c | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index d321fe5ad1a14..c57b79301a75e 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -571,7 +571,7 @@ struct trace_event_file {
 
 #define PERF_MAX_TRACE_SIZE	2048
 
-#define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
+#define MAX_FILTER_STR_VAL	256U	/* Should handle KSYM_SYMBOL_LEN */
 
 enum event_trigger_type {
 	ETT_NONE		= (0),
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 642e4645f6406..c2ec467a5766b 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2624,8 +2624,10 @@ static inline void __update_field_vars(struct tracing_map_elt *elt,
 		if (val->flags & HIST_FIELD_FL_STRING) {
 			char *str = elt_data->field_var_str[j++];
 			char *val_str = (char *)(uintptr_t)var_val;
+			unsigned int size;
 
-			strscpy(str, val_str, val->size);
+			size = min(val->size, STR_VAR_LEN_MAX);
+			strscpy(str, val_str, size);
 			var_val = (u64)(uintptr_t)str;
 		}
 		tracing_map_set_var(elt, var_idx, var_val);
@@ -4465,6 +4467,7 @@ static void hist_trigger_elt_update(struct hist_trigger_data *hist_data,
 			if (hist_field->flags & HIST_FIELD_FL_STRING) {
 				unsigned int str_start, var_str_idx, idx;
 				char *str, *val_str;
+				unsigned int size;
 
 				str_start = hist_data->n_field_var_str +
 					hist_data->n_save_var_str;
@@ -4473,7 +4476,9 @@ static void hist_trigger_elt_update(struct hist_trigger_data *hist_data,
 
 				str = elt_data->field_var_str[idx];
 				val_str = (char *)(uintptr_t)hist_val;
-				strscpy(str, val_str, hist_field->size);
+
+				size = min(hist_field->size, STR_VAR_LEN_MAX);
+				strscpy(str, val_str, size);
 
 				hist_val = (u64)(uintptr_t)str;
 			}
-- 
2.33.0



