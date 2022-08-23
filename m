Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1559D42D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbiHWIMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242069AbiHWIKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2F7BE31;
        Tue, 23 Aug 2022 01:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B5916125A;
        Tue, 23 Aug 2022 08:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA30C433C1;
        Tue, 23 Aug 2022 08:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242049;
        bh=KKuGSI4SgGNc1dasDJ1YuPWISY/G6x4JFnBEck3BOuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vh9idbg8qmDB+MWHkKrd1bTW+cK8+93FOs9xr8oB9WLizC/DcMEGdjOgUHbZMLwQ6
         WD/8lsGe7CIDmbivtRu6X2MPBU/Nk8s+2BdHdZRS1W5NIOEmQBIqjVS/I0/PRnjJar
         uk1jxb3wXQpnfOqceQrBn+6iTeJuvu075X1OgjWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 034/365] tracing/eprobes: Have event probes be consistent with kprobes and uprobes
Date:   Tue, 23 Aug 2022 09:58:55 +0200
Message-Id: <20220823080119.637084607@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit 6a832ec3d680b3a4f4fad5752672827d71bae501 upstream.

Currently, if a symbol "@" is attempted to be used with an event probe
(eprobes), it will cause a NULL pointer dereference crash.

Both kprobes and uprobes can reference data other than the main registers.
Such as immediate address, symbols and the current task name. Have eprobes
do the same thing.

For "comm", if "comm" is used and the event being attached to does not
have the "comm" field, then make it the "$comm" that kprobes has. This is
consistent to the way histograms and filters work.

Link: https://lkml.kernel.org/r/20220820134401.136924220@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   70 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -226,6 +226,7 @@ static int trace_eprobe_tp_arg_update(st
 	struct probe_arg *parg = &ep->tp.args[i];
 	struct ftrace_event_field *field;
 	struct list_head *head;
+	int ret = -ENOENT;
 
 	head = trace_get_fields(ep->event);
 	list_for_each_entry(field, head, link) {
@@ -235,9 +236,20 @@ static int trace_eprobe_tp_arg_update(st
 			return 0;
 		}
 	}
+
+	/*
+	 * Argument not found on event. But allow for comm and COMM
+	 * to be used to get the current->comm.
+	 */
+	if (strcmp(parg->code->data, "COMM") == 0 ||
+	    strcmp(parg->code->data, "comm") == 0) {
+		parg->code->op = FETCH_OP_COMM;
+		ret = 0;
+	}
+
 	kfree(parg->code->data);
 	parg->code->data = NULL;
-	return -ENOENT;
+	return ret;
 }
 
 static int eprobe_event_define_fields(struct trace_event_call *event_call)
@@ -362,16 +374,38 @@ static unsigned long get_event_field(str
 
 static int get_eprobe_size(struct trace_probe *tp, void *rec)
 {
+	struct fetch_insn *code;
 	struct probe_arg *arg;
 	int i, len, ret = 0;
 
 	for (i = 0; i < tp->nr_args; i++) {
 		arg = tp->args + i;
-		if (unlikely(arg->dynamic)) {
+		if (arg->dynamic) {
 			unsigned long val;
 
-			val = get_event_field(arg->code, rec);
-			len = process_fetch_insn_bottom(arg->code + 1, val, NULL, NULL);
+			code = arg->code;
+ retry:
+			switch (code->op) {
+			case FETCH_OP_TP_ARG:
+				val = get_event_field(code, rec);
+				break;
+			case FETCH_OP_IMM:
+				val = code->immediate;
+				break;
+			case FETCH_OP_COMM:
+				val = (unsigned long)current->comm;
+				break;
+			case FETCH_OP_DATA:
+				val = (unsigned long)code->data;
+				break;
+			case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
+				code++;
+				goto retry;
+			default:
+				continue;
+			}
+			code++;
+			len = process_fetch_insn_bottom(code, val, NULL, NULL);
 			if (len > 0)
 				ret += len;
 		}
@@ -389,8 +423,28 @@ process_fetch_insn(struct fetch_insn *co
 {
 	unsigned long val;
 
-	val = get_event_field(code, rec);
-	return process_fetch_insn_bottom(code + 1, val, dest, base);
+ retry:
+	switch (code->op) {
+	case FETCH_OP_TP_ARG:
+		val = get_event_field(code, rec);
+		break;
+	case FETCH_OP_IMM:
+		val = code->immediate;
+		break;
+	case FETCH_OP_COMM:
+		val = (unsigned long)current->comm;
+		break;
+	case FETCH_OP_DATA:
+		val = (unsigned long)code->data;
+		break;
+	case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
+		code++;
+		goto retry;
+	default:
+		return -EILSEQ;
+	}
+	code++;
+	return process_fetch_insn_bottom(code, val, dest, base);
 }
 NOKPROBE_SYMBOL(process_fetch_insn)
 
@@ -862,6 +916,10 @@ static int trace_eprobe_tp_update_arg(st
 	if (ep->tp.args[i].code->op == FETCH_OP_TP_ARG)
 		ret = trace_eprobe_tp_arg_update(ep, i);
 
+	/* Handle symbols "@" */
+	if (!ret)
+		ret = traceprobe_update_arg(&ep->tp.args[i]);
+
 	return ret;
 }
 


