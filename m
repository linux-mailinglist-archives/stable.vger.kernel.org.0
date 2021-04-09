Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3BD3599F5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhDIJzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233060AbhDIJy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125996103E;
        Fri,  9 Apr 2021 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962084;
        bh=TM8BCZMEboIO7AG6IihOKSJ0I9UXln3Zgh6Nlyuj9y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrhgW60F8bMsjfk9RYGoyqoMo3+P4dyfWpYw8AQnq1aUGypQ+OroTtzVxS7Or7/5s
         EjXSoGYX3IU6A3A10TvfFzWl+EMwF9zgOyz0/POqtA0KlR/R2/vQaiXOEPznlQLAcH
         eBIEu4OI2y2MI2s+J224WqRmW5CNEr/PKlsq885M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 17/20] tracing: Add a vmalloc_sync_mappings() for safe measure
Date:   Fri,  9 Apr 2021 11:53:23 +0200
Message-Id: <20210409095300.501289932@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
References: <20210409095259.957388690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 11f5efc3ab66284f7aaacc926e9351d658e2577b upstream

x86_64 lazily maps in the vmalloc pages, and the way this works with per_cpu
areas can be complex, to say the least. Mappings may happen at boot up, and
if nothing synchronizes the page tables, those page mappings may not be
synced till they are used. This causes issues for anything that might touch
one of those mappings in the path of the page fault handler. When one of
those unmapped mappings is touched in the page fault handler, it will cause
another page fault, which in turn will cause a page fault, and leave us in
a loop of page faults.

Commit 763802b53a42 ("x86/mm: split vmalloc_sync_all()") split
vmalloc_sync_all() into vmalloc_sync_unmappings() and
vmalloc_sync_mappings(), as on system exit, it did not need to do a full
sync on x86_64 (although it still needed to be done on x86_32). By chance,
the vmalloc_sync_all() would synchronize the page mappings done at boot up
and prevent the per cpu area from being a problem for tracing in the page
fault handler. But when that synchronization in the exit of a task became a
nop, it caused the problem to appear.

Link: https://lore.kernel.org/r/20200429054857.66e8e333@oasis.local.home

Cc: stable@vger.kernel.org
Fixes: 737223fbca3b1 ("tracing: Consolidate buffer allocation code")
Reported-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Suggested-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[sudip: add header]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -26,6 +26,7 @@
 #include <linux/linkage.h>
 #include <linux/uaccess.h>
 #include <linux/kprobes.h>
+#include <linux/vmalloc.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
@@ -6626,6 +6627,19 @@ static int allocate_trace_buffers(struct
 	 */
 	allocate_snapshot = false;
 #endif
+
+	/*
+	 * Because of some magic with the way alloc_percpu() works on
+	 * x86_64, we need to synchronize the pgd of all the tables,
+	 * otherwise the trace events that happen in x86_64 page fault
+	 * handlers can't cope with accessing the chance that a
+	 * alloc_percpu()'d memory might be touched in the page fault trace
+	 * event. Oh, and we need to audit all other alloc_percpu() and vmalloc()
+	 * calls in tracing, because something might get triggered within a
+	 * page fault trace event!
+	 */
+	vmalloc_sync_mappings();
+
 	return 0;
 }
 


