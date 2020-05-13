Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E11D0E39
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgEMJyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbgEMJyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C1E20575;
        Wed, 13 May 2020 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363656;
        bh=gHD1HELgNrGSh+O8ifb9VkNxa3bf9AhqZWNDoQTBo14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6P7auL7SCnOmRrmtqJiaes/13wR8vcSb/8C21GnSSKmTcu5oxUEPUz6RloI6Rb9j
         HqUtnFYEaqYjFiccwM0sA/aletYMhrn5C95q4wQSCpHPvmGDCzVnD3yLGTMpN65BGp
         mopxe7vyMbbCmv6nH9hw8AYr5Mp0NaHMm3u30MSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.6 065/118] tracing/boottime: Fix kprobe event API usage
Date:   Wed, 13 May 2020 11:44:44 +0200
Message-Id: <20200513094423.643780287@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit da0f1f4167e3af69e1d8b32d6d65195ddd2bfb64 upstream.

Fix boottime kprobe events to use API correctly for
multiple events.

For example, when we set a multiprobe kprobe events in
bootconfig like below,

  ftrace.event.kprobes.myevent {
  	probes = "vfs_read $arg1 $arg2", "vfs_write $arg1 $arg2"
  }

This cause an error;

  trace_boot: Failed to add probe: p:kprobes/myevent (null)  vfs_read $arg1 $arg2  vfs_write $arg1 $arg2

This shows the 1st argument becomes NULL and multiprobes
are merged to 1 probe.

Link: http://lkml.kernel.org/r/158779375766.6082.201939936008972838.stgit@devnote2

Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 29a154810546 ("tracing: Change trace_boot to use kprobe_event interface")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_boot.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -95,24 +95,20 @@ trace_boot_add_kprobe_event(struct xbc_n
 	struct xbc_node *anode;
 	char buf[MAX_BUF_LEN];
 	const char *val;
-	int ret;
+	int ret = 0;
 
-	kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
+	xbc_node_for_each_array_value(node, "probes", anode, val) {
+		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
-	ret = kprobe_event_gen_cmd_start(&cmd, event, NULL);
-	if (ret)
-		return ret;
+		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
+		if (ret)
+			break;
 
-	xbc_node_for_each_array_value(node, "probes", anode, val) {
-		ret = kprobe_event_add_field(&cmd, val);
+		ret = kprobe_event_gen_cmd_end(&cmd);
 		if (ret)
-			return ret;
+			pr_err("Failed to add probe: %s\n", buf);
 	}
 
-	ret = kprobe_event_gen_cmd_end(&cmd);
-	if (ret)
-		pr_err("Failed to add probe: %s\n", buf);
-
 	return ret;
 }
 #else


