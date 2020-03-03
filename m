Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72666177F0D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgCCRs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgCCRs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38767208C3;
        Tue,  3 Mar 2020 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257705;
        bh=/fUNwf/vztwTSEohLnloV9eTLI537OBCYIVodXwIu6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMPuKDTNZTR9o+IXEIcVcUXx06DdoKL4iKr3Tz4ld2fhGqCQKJLM5Xaqy+Z7WkKSR
         zJo7sfA8Wxkapkz5v5COv/TQ7hxurlNX7OpCjng7DvmBjazTfMyy6JIzzbyrZ1dRee
         YMz5fNeXDjmHX44kNymiJ7vXlFbTmJQfSzhVtbhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.5 097/176] tracing: Disable trace_printk() on post poned tests
Date:   Tue,  3 Mar 2020 18:42:41 +0100
Message-Id: <20200303174316.051529563@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -1827,6 +1827,7 @@ static __init int init_trace_selftests(v
 
 	pr_info("Running postponed tracer tests:\n");
 
+	tracing_selftest_running = true;
 	list_for_each_entry_safe(p, n, &postponed_selftests, list) {
 		/* This loop can take minutes when sanitizers are enabled, so
 		 * lets make sure we allow RCU processing.
@@ -1849,6 +1850,7 @@ static __init int init_trace_selftests(v
 		list_del(&p->list);
 		kfree(p);
 	}
+	tracing_selftest_running = false;
 
  out:
 	mutex_unlock(&trace_types_lock);


