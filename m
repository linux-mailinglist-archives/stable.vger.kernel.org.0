Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF9858608F
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbiGaTE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 15:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiGaTEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 15:04:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A09D10567;
        Sun, 31 Jul 2022 12:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48AFFCE0FA6;
        Sun, 31 Jul 2022 19:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5CCC4314C;
        Sun, 31 Jul 2022 19:04:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oIEEt-007GDP-2V;
        Sun, 31 Jul 2022 15:04:35 -0400
Message-ID: <20220731190435.611455708@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 31 Jul 2022 15:03:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [for-next][PATCH 21/21] tracing: Use a struct alignof to determine trace event field
 alignment
References: <20220731190329.641602282@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

alignof() gives an alignment of types as they would be as standalone
variables. But alignment in structures might be different, and when
building the fields of events, the alignment must be the actual
alignment otherwise the field offsets may not match what they actually
are.

This caused trace-cmd to crash, as libtraceevent did not check if the
field offset was bigger than the event. The write_msr and read_msr
events on 32 bit had their fields incorrect, because it had a u64 field
between two ints. alignof(u64) would give 8, but the u64 field was at a
4 byte alignment.

Define a macro as:

   ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))

which gives the actual alignment of types in a structure.

Link: https://lkml.kernel.org/r/20220731015928.7ab3a154@rorschach.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 04ae87a52074e ("ftrace: Rework event_create_dir()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace/stages/stage4_event_fields.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
index c3790ec7a453..80d34f396555 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -2,16 +2,18 @@
 
 /* Stage 4 definitions for creating trace events */
 
+#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\
 	.type = #_type, .name = #_item,					\
-	.size = sizeof(_type), .align = __alignof__(_type),		\
+	.size = sizeof(_type), .align = ALIGN_STRUCTFIELD(_type),	\
 	.is_signed = is_signed_type(_type), .filter_type = _filter_type },
 
 #undef __field_struct_ext
 #define __field_struct_ext(_type, _item, _filter_type) {		\
 	.type = #_type, .name = #_item,					\
-	.size = sizeof(_type), .align = __alignof__(_type),		\
+	.size = sizeof(_type), .align = ALIGN_STRUCTFIELD(_type),	\
 	0, .filter_type = _filter_type },
 
 #undef __field
@@ -23,7 +25,7 @@
 #undef __array
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
-	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
+	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
 	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
 
 #undef __dynamic_array
-- 
2.35.1
