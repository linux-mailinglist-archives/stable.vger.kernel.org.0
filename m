Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E405A593C27
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345686AbiHOT6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346109AbiHOT5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CC7785A3;
        Mon, 15 Aug 2022 11:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0815B611ED;
        Mon, 15 Aug 2022 18:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB991C433C1;
        Mon, 15 Aug 2022 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589575;
        bh=zm5yPCSka08KCN9psAi49vcukmwi+nuzh5ZWb1E34GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOXhaAMsxTcUB3DUPgaPMgfEkfdfMHAXOozOQTXdzilp8tLCzOVsLeWz4XSfKDBLy
         QFhqMPSfct3lfbOIISnPC5DXQkeCiZXXJkEI69rXr8Tt6TFCyi5LJi8k+zWtBeNVL6
         jnf5OloM7SesjNP+2IAwx9k/AKO3h4bZY0pcRgG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 760/779] tracing: Use a struct alignof to determine trace event field alignment
Date:   Mon, 15 Aug 2022 20:06:44 +0200
Message-Id: <20220815180409.926703705@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 4c3d2f9388d36eb28640a220a6f908328442d873 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/trace_events.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -479,16 +479,18 @@ static struct trace_event_functions trac
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
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
@@ -500,7 +502,7 @@ static struct trace_event_functions trac
 #undef __array
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
-	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
+	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
 	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
 
 #undef __dynamic_array


