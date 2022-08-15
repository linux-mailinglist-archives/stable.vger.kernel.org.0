Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7796E593D9F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345612AbiHOTyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345339AbiHOTxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B92A45988;
        Mon, 15 Aug 2022 11:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 042FEB81057;
        Mon, 15 Aug 2022 18:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FB6C433D7;
        Mon, 15 Aug 2022 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589503;
        bh=p/uunIcwHwU9V4FTm8SLUQ3eqGXCzIV40IeJ/52XdO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kl9037RHxhDU7+dtP0gnkI7IqVkhMJpbzvjTMVW5QzMoJOMs61CHeDe50nUQlXFfE
         j2T5RDvhbAkP734uHHV7CrLodGyOvs56P8H7nleYjLHr/B/E69En9xUIaZUzhYl2/H
         Cykj5r8A0QGWLGHDn/DLO37MTzaYwCMEEVmGXPf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beau Belgrave <beaub@linux.microsoft.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 739/779] tracing: Add __rel_loc using trace event macros
Date:   Mon, 15 Aug 2022 20:06:23 +0200
Message-Id: <20220815180409.037077480@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 55de2c0b5610cba5a5a93c0788031133c457e689 ]

Add '__rel_loc' using trace event macros. These macros are usually
not used in the kernel, except for testing purpose.
This also add "rel_" variant of macros for dynamic_array string,
and bitmask.

Link: https://lkml.kernel.org/r/163757342119.510314.816029622439099016.stgit@devnote2

Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/bpf_probe.h    |  16 +++++
 include/trace/perf.h         |  16 +++++
 include/trace/trace_events.h | 120 ++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h         |   3 +
 4 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index a23be89119aa..04939b2d2f19 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -21,6 +21,22 @@
 #undef __get_bitmask
 #define __get_bitmask(field) (char *)__get_dynamic_array(field)
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
 #undef __perf_count
 #define __perf_count(c)	(c)
 
diff --git a/include/trace/perf.h b/include/trace/perf.h
index dbc6c74defc3..ea4405de175a 100644
--- a/include/trace/perf.h
+++ b/include/trace/perf.h
@@ -21,6 +21,22 @@
 #undef __get_bitmask
 #define __get_bitmask(field) (char *)__get_dynamic_array(field)
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
 #undef __perf_count
 #define __perf_count(c)	(__count = (c))
 
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 08810a463880..8c6f7c433518 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -108,6 +108,18 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(char, item, -1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len) u32 __rel_loc_##item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(char, item, -1)
+
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
@@ -200,11 +212,23 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
-#undef __bitmask
-#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)	u32 item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -293,6 +317,19 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __get_str
 #define __get_str(field) ((char *)__get_dynamic_array(field))
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
 #undef __get_bitmask
 #define __get_bitmask(field)						\
 	({								\
@@ -302,6 +339,15 @@ TRACE_MAKE_SYSTEM_STR();
 		trace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
 	})
 
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field)						\
+	({								\
+		void *__bitmask = __get_rel_dynamic_array(field);		\
+		unsigned int __bitmask_size;				\
+		__bitmask_size = __get_rel_dynamic_array_len(field);	\
+		trace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
+	})
+
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
@@ -471,6 +517,21 @@ static struct trace_event_functions trace_event_type_funcs_##call = {	\
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(_type, _item, _len) {			\
+	.type = "__rel_loc " #_type "[]", .name = #_item,		\
+	.size = 4, .align = 4,						\
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static struct trace_event_fields trace_event_fields_##call[] = {	\
@@ -519,6 +580,22 @@ static struct trace_event_fields trace_event_fields_##call[] = {	\
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, (len) + 1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)				\
+	__item_length = (len) * sizeof(type);				\
+	__data_offsets->item = __data_size +				\
+			       offsetof(typeof(*entry), __data) -	\
+			       offsetof(typeof(*entry), __rel_loc_##item) -	\
+			       sizeof(u32);				\
+	__data_offsets->item |= __item_length << 16;			\
+	__data_size += __item_length;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item,			\
+		    strlen((src) ? (const char *)(src) : "(null)") + 1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, (len) + 1)
 /*
  * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
  * num_possible_cpus().
@@ -542,6 +619,10 @@ static struct trace_event_fields trace_event_fields_##call[] = {	\
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item,	\
 					 __bitmask_size_in_longs(nr_bits))
 
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item,	\
+					 __bitmask_size_in_longs(nr_bits))
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static inline notrace int trace_event_get_offsets_##call(		\
@@ -706,6 +787,37 @@ static inline notrace int trace_event_get_offsets_##call(		\
 #define __assign_bitmask(dst, src, nr_bits)					\
 	memcpy(__get_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)				\
+	__entry->__rel_loc_##item = __data_offsets.item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __assign_rel_str
+#define __assign_rel_str(dst, src)					\
+	strcpy(__get_rel_str(dst), (src) ? (const char *)(src) : "(null)");
+
+#undef __assign_rel_str_len
+#define __assign_rel_str_len(dst, src, len)				\
+	do {								\
+		memcpy(__get_rel_str(dst), (src), (len));		\
+		__get_rel_str(dst)[len] = '\0';				\
+	} while (0)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
+#undef __assign_rel_bitmask
+#define __assign_rel_bitmask(dst, src, nr_bits)					\
+	memcpy(__get_rel_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
+
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
@@ -770,6 +882,10 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
+#undef __get_rel_dynamic_array
+#undef __get_rel_dynamic_array_len
+#undef __get_rel_str
+#undef __get_rel_bitmask
 #undef __print_array
 #undef __print_hex_dump
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d6763366a320..28ea6c0be495 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -83,6 +83,9 @@ enum trace_type {
 #undef __dynamic_array
 #define __dynamic_array(type, item)	type	item[];
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item)	type	item[];
+
 #undef F_STRUCT
 #define F_STRUCT(args...)		args
 
-- 
2.35.1



