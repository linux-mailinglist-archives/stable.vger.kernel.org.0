Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B5817811A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgCCSAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387806AbgCCSAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892AD206D5;
        Tue,  3 Mar 2020 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258435;
        bh=385P4NgndTaCvuQzX1IJ4OHtNQLxnwiU995960d8V9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIPG9btH7ppgG/wdgXmWdI1/CSXWWtFgKZwVVtsuOY5PN8Re75c0qRloXNzD8qVRY
         sYVSvCO/d/z2LkWI1briUqIhLoZCJsKkpTXSC3GK1kd+RZagM+PD4wgAi2goKPsCQ2
         OzHf1X+Ht+YYBdnVWc5i+Da4k27N/2D2pvhmj/6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 48/87] tracing: Disable trace_printk() on post poned tests
Date:   Tue,  3 Mar 2020 18:43:39 +0100
Message-Id: <20200303174354.661433779@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 78041c0c9e935d9ce4086feeff6c569ed88ddfd4 upstream.

The tracing seftests checks various aspects of the tracing infrastructure,
and one is filtering. If trace_printk() is active during a self test, it can
cause the filtering to fail, which will disable that part of the trace.

To keep the selftests from failing because of trace_printk() calls,
trace_printk() checks the variable tracing_selftest_running, and if set, it
does not write to the tracing buffer.

As some tracers were registered earlier in boot, the selftest they triggered
would fail because not all the infrastructure was set up for the full
selftest. Thus, some of the tests were post poned to when their
infrastructure was ready (namely file system code). The postpone code did
not set the tracing_seftest_running variable, and could fail if a
trace_printk() was added and executed during their run.

Cc: stable@vger.kernel.org
Fixes: 9afecfbb95198 ("tracing: Postpone tracer start-up tests till the system is more robust")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1549,6 +1549,7 @@ static __init int init_trace_selftests(v
 
 	pr_info("Running postponed tracer tests:\n");
 
+	tracing_selftest_running = true;
 	list_for_each_entry_safe(p, n, &postponed_selftests, list) {
 		ret = run_tracer_selftest(p->type);
 		/* If the test fails, then warn and remove from available_tracers */
@@ -1567,6 +1568,7 @@ static __init int init_trace_selftests(v
 		list_del(&p->list);
 		kfree(p);
 	}
+	tracing_selftest_running = false;
 
  out:
 	mutex_unlock(&trace_types_lock);


