Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADFA4F108C
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241492AbiDDIMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbiDDIMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 04:12:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2322FFEE
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 01:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEE76113A
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 08:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8289BC2BBE4;
        Mon,  4 Apr 2022 08:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649059842;
        bh=2rhRtDLEhLbxPuCIltXG57oFyXdqGIPZxBMZNHKrrvM=;
        h=Subject:To:Cc:From:Date:From;
        b=RCnGMIWYSUDAtUK46nxoght2xI85AvBrRbyakk7bnhvsVjtg/2k9hz0wA241xvrXc
         H9SoQZtyCE9OPEjcR7XH6SKScrxYAneU8zKcGrUZXVcW+q8+gJVd6VZK7HGuYNcUCg
         yHZwOzb+HDnzVgi6nmVHm7dt4pxMPMPjQPFeZaBw=
Subject: FAILED: patch "[PATCH] tracing: Have type enum modifications copy the strings" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, maz@kernel.org, svens@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 10:10:39 +0200
Message-ID: <16490598398133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 795301d3c28996219d555023ac6863401b6076bc Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Fri, 18 Mar 2022 15:34:32 -0400
Subject: [PATCH] tracing: Have type enum modifications copy the strings

When an enum is used in the visible parts of a trace event that is
exported to user space, the user space applications like perf and
trace-cmd do not have a way to know what the value of the enum is. To
solve this, at boot up (or module load) the printk formats are modified to
replace the enum with their numeric value in the string output.

Array fields of the event are defined by [<nr-elements>] in the type
portion of the format file so that the user space parsers can correctly
parse the array into the appropriate size chunks. But in some trace
events, an enum is used in defining the size of the array, which once
again breaks the parsing of user space tooling.

This was solved the same way as the print formats were, but it modified
the type strings of the trace event. This caused crashes in some
architectures because, as supposed to the print string, is a const string
value. This was not detected on x86, as it appears that const strings are
still writable (at least in boot up), but other architectures this is not
the case, and writing to a const string will cause a kernel fault.

To fix this, use kstrdup() to copy the type before modifying it. If the
trace event is for the core kernel there's no need to free it because the
string will be in use for the life of the machine being on line. For
modules, create a link list to store all the strings being allocated for
modules and when the module is removed, free them.

Link: https://lore.kernel.org/all/yt9dr1706b4i.fsf@linux.ibm.com/
Link: https://lkml.kernel.org/r/20220318153432.3984b871@gandalf.local.home

Tested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Fixes: b3bc8547d3be ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ae9a3b8481f5..0d91152172c9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -40,6 +40,14 @@ static LIST_HEAD(ftrace_generic_fields);
 static LIST_HEAD(ftrace_common_fields);
 static bool eventdir_initialized;
 
+static LIST_HEAD(module_strings);
+
+struct module_string {
+	struct list_head	next;
+	struct module		*module;
+	char			*str;
+};
+
 #define GFP_TRACE (GFP_KERNEL | __GFP_ZERO)
 
 static struct kmem_cache *field_cachep;
@@ -2633,14 +2641,40 @@ static void update_event_printk(struct trace_event_call *call,
 	}
 }
 
+static void add_str_to_module(struct module *module, char *str)
+{
+	struct module_string *modstr;
+
+	modstr = kmalloc(sizeof(*modstr), GFP_KERNEL);
+
+	/*
+	 * If we failed to allocate memory here, then we'll just
+	 * let the str memory leak when the module is removed.
+	 * If this fails to allocate, there's worse problems than
+	 * a leaked string on module removal.
+	 */
+	if (WARN_ON_ONCE(!modstr))
+		return;
+
+	modstr->module = module;
+	modstr->str = str;
+
+	list_add(&modstr->next, &module_strings);
+}
+
 static void update_event_fields(struct trace_event_call *call,
 				struct trace_eval_map *map)
 {
 	struct ftrace_event_field *field;
 	struct list_head *head;
 	char *ptr;
+	char *str;
 	int len = strlen(map->eval_string);
 
+	/* Dynamic events should never have field maps */
+	if (WARN_ON_ONCE(call->flags & TRACE_EVENT_FL_DYNAMIC))
+		return;
+
 	head = trace_get_fields(call);
 	list_for_each_entry(field, head, link) {
 		ptr = strchr(field->type, '[');
@@ -2654,9 +2688,26 @@ static void update_event_fields(struct trace_event_call *call,
 		if (strncmp(map->eval_string, ptr, len) != 0)
 			continue;
 
+		str = kstrdup(field->type, GFP_KERNEL);
+		if (WARN_ON_ONCE(!str))
+			return;
+		ptr = str + (ptr - field->type);
 		ptr = eval_replace(ptr, map, len);
 		/* enum/sizeof string smaller than value */
-		WARN_ON_ONCE(!ptr);
+		if (WARN_ON_ONCE(!ptr)) {
+			kfree(str);
+			continue;
+		}
+
+		/*
+		 * If the event is part of a module, then we need to free the string
+		 * when the module is removed. Otherwise, it will stay allocated
+		 * until a reboot.
+		 */
+		if (call->module)
+			add_str_to_module(call->module, str);
+
+		field->type = str;
 	}
 }
 
@@ -2883,6 +2934,7 @@ static void trace_module_add_events(struct module *mod)
 static void trace_module_remove_events(struct module *mod)
 {
 	struct trace_event_call *call, *p;
+	struct module_string *modstr, *m;
 
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
@@ -2891,6 +2943,14 @@ static void trace_module_remove_events(struct module *mod)
 		if (call->module == mod)
 			__trace_remove_event_call(call);
 	}
+	/* Check for any strings allocade for this module */
+	list_for_each_entry_safe(modstr, m, &module_strings, next) {
+		if (modstr->module != mod)
+			continue;
+		list_del(&modstr->next);
+		kfree(modstr->str);
+		kfree(modstr);
+	}
 	up_write(&trace_event_sem);
 
 	/*

