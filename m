Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEF82CE749
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 06:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgLDFHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 00:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgLDFHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 00:07:52 -0500
From:   Andy Lutomirski <luto@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 3/4] membarrier: Explicitly sync remote cores when SYNC_CORE is requested
Date:   Thu,  3 Dec 2020 21:07:05 -0800
Message-Id: <776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607058304.git.luto@kernel.org>
References: <cover.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

membarrier() does not explicitly sync_core() remote CPUs; instead, it
relies on the assumption that an IPI will result in a core sync.  On
x86, I think this may be true in practice, but it's not architecturally
reliable.  In particular, the SDM and APM do not appear to guarantee
that interrupt delivery is serializing.  While IRET does serialize, IPI
return can schedule, thereby switching to another task in the same mm
that was sleeping in a syscall.  The new task could then SYSRET back to
usermode without ever executing IRET.

Make this more robust by explicitly calling sync_core_before_usermode()
on remote cores.  (This also helps people who search the kernel tree for
instances of sync_core() and sync_core_before_usermode() -- one might be
surprised that the core membarrier code doesn't currently show up in a
such a search.)

Cc: stable@vger.kernel.org
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/sched/membarrier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 6251d3d12abe..01538b31f27e 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -166,6 +166,23 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static void ipi_sync_core(void *info)
+{
+	/*
+	 * The smp_mb() in membarrier after all the IPIs is supposed to
+	 * ensure that memory on remote CPUs that occur before the IPI
+	 * become visible to membarrier()'s caller -- see scenario B in
+	 * the big comment at the top of this file.
+	 *
+	 * A sync_core() would provide this guarantee, but
+	 * sync_core_before_usermode() might end up being deferred until
+	 * after membarrier()'s smp_mb().
+	 */
+	smp_mb();	/* IPIs should be serializing but paranoid. */
+
+	sync_core_before_usermode();
+}
+
 static void ipi_rseq(void *info)
 {
 	/*
@@ -301,6 +318,7 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
 			return -EPERM;
+		ipi_func = ipi_sync_core;
 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
 		if (!IS_ENABLED(CONFIG_RSEQ))
 			return -EINVAL;
-- 
2.28.0

