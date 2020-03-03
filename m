Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01B17803B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732729AbgCCRzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732726AbgCCRzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FAA6214D8;
        Tue,  3 Mar 2020 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258131;
        bh=j97uCJQ9NGHO2e3d3Wo4LUPwE2bp4oAQuteoTsUP1p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYBqd+h3HeFWgUt3PUIdrOs0gPr02J/ntkpMxvm5shK1be0Vqcn8UITSJ1A+5WUDR
         x6VEEHyDuIdSrUebUn3Vbd7qyMd/dVemyoPAFhUSh9qB2EKbkke5MuG8+20mkyGCr3
         ndY7NRsV8Cfr1LKvpl+rssYCG0QTdmwP/769rpTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 082/152] tracing: Disable trace_printk() on post poned tests
Date:   Tue,  3 Mar 2020 18:43:00 +0100
Message-Id: <20200303174311.867738681@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
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
@@ -1743,6 +1743,7 @@ static __init int init_trace_selftests(v
 
 	pr_info("Running postponed tracer tests:\n");
 
+	tracing_selftest_running = true;
 	list_for_each_entry_safe(p, n, &postponed_selftests, list) {
 		/* This loop can take minutes when sanitizers are enabled, so
 		 * lets make sure we allow RCU processing.
@@ -1765,6 +1766,7 @@ static __init int init_trace_selftests(v
 		list_del(&p->list);
 		kfree(p);
 	}
+	tracing_selftest_running = false;
 
  out:
 	mutex_unlock(&trace_types_lock);


