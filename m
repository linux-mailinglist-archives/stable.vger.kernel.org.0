Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A111D0E1E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbgEMJys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbgEMJyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AE120575;
        Wed, 13 May 2020 09:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363683;
        bh=D/OHGjWG5iBia2GQ7cUm3S82dMNWM303D0Udw57Ir4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6YqttVILTRXLUyb5dpvpaCjLwJ/yD4k+EieWIZNjMs+XSesZhorg8z0PhqqaSr4v
         wFvOid1zvfbJdQElbyOIePZmr0Qo6KSsf0A+NUds/A3CSz5suMFlq6+V+NhYStO4Vr
         bgmf8bJCjNSpNCjKpgzf1aXEjRPOhjrpbkBuuXL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.6 066/118] tracing/kprobes: Reject new event if loc is NULL
Date:   Wed, 13 May 2020 11:44:45 +0200
Message-Id: <20200513094423.696834738@linuxfoundation.org>
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

commit 5b4dcd2d201a395ad4054067bfae4a07554fbd65 upstream.

Reject the new event which has NULL location for kprobes.
For kprobes, user must specify at least the location.

Link: http://lkml.kernel.org/r/158779376597.6082.1411212055469099461.stgit@devnote2

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 2a588dd1d5d6 ("tracing: Add kprobe event command generation functions")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_kprobe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -940,6 +940,9 @@ EXPORT_SYMBOL_GPL(kprobe_event_cmd_init)
  * complete command or only the first part of it; in the latter case,
  * kprobe_event_add_fields() can be used to add more fields following this.
  *
+ * Unlikely the synth_event_gen_cmd_start(), @loc must be specified. This
+ * returns -EINVAL if @loc == NULL.
+ *
  * Return: 0 if successful, error otherwise.
  */
 int __kprobe_event_gen_cmd_start(struct dynevent_cmd *cmd, bool kretprobe,
@@ -953,6 +956,9 @@ int __kprobe_event_gen_cmd_start(struct
 	if (cmd->type != DYNEVENT_TYPE_KPROBE)
 		return -EINVAL;
 
+	if (!loc)
+		return -EINVAL;
+
 	if (kretprobe)
 		snprintf(buf, MAX_EVENT_NAME_LEN, "r:kprobes/%s", name);
 	else


