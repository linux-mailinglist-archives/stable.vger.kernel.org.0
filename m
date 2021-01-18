Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94742FA915
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393676AbhARSmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390700AbhARLlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F40221EC;
        Mon, 18 Jan 2021 11:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970056;
        bh=N0idFLhhtuXYx1g+3ajW0yihg9PuvTpfOzIBb+UDUfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbBfqy8mzsYMv5HOSAfEl+1WUmTG1xOXx6/qOkPqc9y2cDhLP9SNpb3ktNpu7NjVs
         ZK2R8/gVDmutujR/BuGqEuWaOnmTOe60TkYwEqIgu0Iqi9bW0aGFssVtD5uEJQm92m
         Ruun7oY3KFJWt+hE/mkl5V/cSbR3KpsCtTBxFS8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 019/152] tools/bootconfig: Add tracing_on support to helper scripts
Date:   Mon, 18 Jan 2021 12:33:14 +0100
Message-Id: <20210118113353.693360776@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 55ed4560774d81d7343223b8fd2784c530a9c6c1 upstream.

Add ftrace.instance.INSTANCE.tracing_on support to ftrace2bconf.sh
and bconf2ftrace.sh.

commit 8490db06f914 ("tracing/boot: Add per-instance tracing_on
option support") added the per-instance tracing_on option,
but forgot to update the helper scripts.

Link: https://lkml.kernel.org/r/160749166410.3497930.14204335886811029800.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 8490db06f914 ("tracing/boot: Add per-instance tracing_on option support")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/bootconfig/scripts/bconf2ftrace.sh |    1 +
 tools/bootconfig/scripts/ftrace2bconf.sh |    4 ++++
 2 files changed, 5 insertions(+)

--- a/tools/bootconfig/scripts/bconf2ftrace.sh
+++ b/tools/bootconfig/scripts/bconf2ftrace.sh
@@ -152,6 +152,7 @@ setup_instance() { # [instance]
 	set_array_of ${instance}.options ${instancedir}/trace_options
 	set_value_of ${instance}.trace_clock ${instancedir}/trace_clock
 	set_value_of ${instance}.cpumask ${instancedir}/tracing_cpumask
+	set_value_of ${instance}.tracing_on ${instancedir}/tracing_on
 	set_value_of ${instance}.tracer ${instancedir}/current_tracer
 	set_array_of ${instance}.ftrace.filters \
 		${instancedir}/set_ftrace_filter
--- a/tools/bootconfig/scripts/ftrace2bconf.sh
+++ b/tools/bootconfig/scripts/ftrace2bconf.sh
@@ -221,6 +221,10 @@ instance_options() { # [instance-name]
 	if [ `echo $val | sed -e s/f//g`x != x ]; then
 		emit_kv $PREFIX.cpumask = $val
 	fi
+	val=`cat $INSTANCE/tracing_on`
+	if [ `echo $val | sed -e s/f//g`x != x ]; then
+		emit_kv $PREFIX.tracing_on = $val
+	fi
 
 	val=
 	for i in `cat $INSTANCE/set_event`; do


