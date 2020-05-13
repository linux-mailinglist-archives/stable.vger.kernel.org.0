Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818D21D0ED4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgEMKCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733265AbgEMJtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F1C20740;
        Wed, 13 May 2020 09:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363375;
        bh=eYBhrqBBMHguvSuJAyZXGOMVPTy3KnSYq6ZPfIEPdAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpTIlMD3FtjEH4OkQ1kZux9ftC/+167RsI9k76Vl98cPn8kc4UmAFddtuyGpr3xIi
         z1FZPMrs9vwpVYU8Q1lNEjYQb7I1jOcKkt+Lz6yUuK5twgwlGIeZqQusdzLYqNgq7v
         k7bpi3FJzHQLXv1qPAQn+v122RGzTb7a+HvPlq74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 49/90] tracing: Add a vmalloc_sync_mappings() for safe measure
Date:   Wed, 13 May 2020 11:44:45 +0200
Message-Id: <20200513094414.002896061@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 11f5efc3ab66284f7aaacc926e9351d658e2577b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8318,6 +8318,19 @@ static int allocate_trace_buffers(struct
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
 


