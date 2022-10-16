Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD96000BB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJPPft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJPPfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:35:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD2C2CDC3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 840C7B80C8C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45A8C433D6;
        Sun, 16 Oct 2022 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665934545;
        bh=w/KKkNa94X7WgAZblv7esHoVg/KErqpBPQiF3Kk0vE4=;
        h=Subject:To:Cc:From:Date:From;
        b=KRW8rFfkUy57VNUu23jfM14Er8ddamYuCEWwuV8spaQxiWwcCxYE/gv8dXX4HgRmA
         4KINzKzBjS8Mj4ybWsFFqeiHeU/+/waSFFfi+mY/PpKVW98zCbZGmWdAyiZd6OyP6p
         4SBbes0PJ4yRcyQLf+IjawF5MKPNy5Cwvo8wmGX0=
Subject: FAILED: patch "[PATCH] tracing: Fix reading strings from synthetic events" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:36:31 +0200
Message-ID: <1665934591170142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0934ae9977c2 ("tracing: Fix reading strings from synthetic events")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0934ae9977c27133449b6dd8c6213970e7eece38 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 12 Oct 2022 06:40:58 -0400
Subject: [PATCH] tracing: Fix reading strings from synthetic events

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

Now the above can show:

     packagekitd-1721    [000] ...2.   104.597170: open: file=/usr/lib/rpm/fileattrs/cmake.attr
    in:imjournal-978     [006] ...2.   104.599642: open: file=/var/lib/rsyslog/imjournal.state.tmp
     packagekitd-1721    [000] ...2.   104.626308: open: file=/usr/lib/rpm/fileattrs/debuginfo.attr

Link: https://lkml.kernel.org/r/20221012104534.826549315@goodmis.org

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Fixes: bd82631d7ccdc ("tracing: Add support for dynamic strings to synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 5e8c07aef071..e310052dc83c 100644
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
@@ -417,19 +420,27 @@ static unsigned int trace_string(struct synth_trace_event *entry,
 		data_offset += event->n_u64 * sizeof(u64);
 		data_offset += data_size;
 
-		str_field = (char *)entry + data_offset;
-
-		len = strlen(str_val) + 1;
-		strscpy(str_field, str_val, len);
+		len = kern_fetch_store_strlen((unsigned long)str_val);
 
 		data_offset |= len << 16;
 		*(u32 *)&entry->fields[*n_u64] = data_offset;
 
+		ret = kern_fetch_store_string((unsigned long)str_val, &entry->fields[*n_u64], entry);
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
+			strcpy(str_field, FAULT_STRING);
+
 		(*n_u64) += STR_VAR_LEN_MAX / sizeof(u64);
 	}
 
@@ -462,7 +473,7 @@ static notrace void trace_event_raw_event_synth(void *__data,
 		val_idx = var_ref_idx[field_pos];
 		str_val = (char *)(long)var_ref_vals[val_idx];
 
-		len = strlen(str_val) + 1;
+		len = kern_fetch_store_strlen((unsigned long)str_val);
 
 		fields_size += len;
 	}

