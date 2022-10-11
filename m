Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354055FBCE4
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiJKV1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 17:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJKV05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 17:26:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298569AFBF;
        Tue, 11 Oct 2022 14:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBE87B81714;
        Tue, 11 Oct 2022 21:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F8BC43470;
        Tue, 11 Oct 2022 21:26:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oiMmE-003PxL-1E;
        Tue, 11 Oct 2022 17:27:02 -0400
Message-ID: <20221011212702.220048293@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 11 Oct 2022 17:25:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] tracing: Fix reading strings from synthetic events
References: <20221011212501.773319898@goodmis.org>
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

The follow commands caused a crash:

  # cd /sys/kernel/tracing
  # echo 's:open char file[]' > dynamic_events
  # echo 'hist:keys=common_pid:file=filename:onchange($file).trace(open,$file)' > events/syscalls/sys_enter_openat/trigger'
  # echo 1 > events/synthetic/open/enable

BOOM!

The problem is that the synthetic event field "char file[]" will read
the value given to it as a string without any memory checks to make sure
the address is valid. The above example will pass in the user space
address and the sythetic event code will happily call strlen() on it
and then strscpy() where either one will cause an oops when accessing
user space addresses.

Use the helper functions from trace_kprobe and trace_eprobe that can
read strings safely (and actually succeed when the address is from user
space and the memory is mapped in).

Cc: stable@vger.kernel.org
Fixes: bd82631d7ccdc ("tracing: Add support for dynamic strings to synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_synth.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 5e8c07aef071..eae15bde883d 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -17,6 +17,8 @@
 /* for gfp flag names */
 #include <linux/trace_events.h>
 #include <trace/events/mmflags.h>
+#include "trace_probe.h"
+#include "trace_probe_kernel.h"
 
 #include "trace_synth.h"
 
@@ -409,6 +411,7 @@ static unsigned int trace_string(struct synth_trace_event *entry,
 {
 	unsigned int len = 0;
 	char *str_field;
+	int ret;
 
 	if (is_dynamic) {
 		u32 data_offset;
@@ -417,19 +420,28 @@ static unsigned int trace_string(struct synth_trace_event *entry,
 		data_offset += event->n_u64 * sizeof(u64);
 		data_offset += data_size;
 
-		str_field = (char *)entry + data_offset;
-
-		len = strlen(str_val) + 1;
-		strscpy(str_field, str_val, len);
-
+		len = kern_fetch_store_strlen(str_val) + 1;
+		if (len == 1)
+			len = strlen("fault") + 1;
 		data_offset |= len << 16;
 		*(u32 *)&entry->fields[*n_u64] = data_offset;
 
+		kern_fetch_store_string((unsigned long)str_val, &entry->fields[*n_u64], entry);
+
 		(*n_u64)++;
 	} else {
 		str_field = (char *)&entry->fields[*n_u64];
 
-		strscpy(str_field, str_val, STR_VAR_LEN_MAX);
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+		if ((unsigned long)str_val < TASK_SIZE)
+			ret = strncpy_from_user_nofault(str_field, str_val, STR_VAR_LEN_MAX);
+		else
+#endif
+			ret = strncpy_from_kernel_nofault(str_field, str_val, STR_VAR_LEN_MAX);
+
+		if (ret < 0)
+			strcpy(str_field, "(fault)");
+
 		(*n_u64) += STR_VAR_LEN_MAX / sizeof(u64);
 	}
 
@@ -462,7 +474,9 @@ static notrace void trace_event_raw_event_synth(void *__data,
 		val_idx = var_ref_idx[field_pos];
 		str_val = (char *)(long)var_ref_vals[val_idx];
 
-		len = strlen(str_val) + 1;
+		len = kern_fetch_store_strlen(str_val) + 1;
+		if (len == 1)
+			len = strlen("(fault)") + 1;
 
 		fields_size += len;
 	}
-- 
2.35.1
