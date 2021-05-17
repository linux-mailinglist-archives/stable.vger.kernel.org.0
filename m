Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C33837A7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbhEQPqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343854AbhEQPnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E53D61D01;
        Mon, 17 May 2021 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262564;
        bh=EAfkBS4b60opCiLOVlnBupkfa4IP9sMSU+ZZMIUm5Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ys/G1FLCr5LZ/axYjM5tTaC82diiNYxhrrDF66sRz5TFer6YfGYPpRIhTIyYUC9Uw
         T8UfZbDIGrCTZTEn9Czr+1FGLxA5cYkhbls6yPCLEpWZ2KXoWRh1ezHOXMbjNS0LJE
         Heg/XbV3ZT7SKaPsxO7nllfq/YyMhc7YBu6xRBU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 197/289] powerpc/64s: Fix crashes when toggling stf barrier
Date:   Mon, 17 May 2021 16:02:02 +0200
Message-Id: <20210517140311.743968416@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8ec7791bae1327b1c279c5cd6e929c3b12daaf0a upstream.

The STF (store-to-load forwarding) barrier mitigation can be
enabled/disabled at runtime via a debugfs file (stf_barrier), which
causes the kernel to patch itself to enable/disable the relevant
mitigations.

However depending on which mitigation we're using, it may not be safe to
do that patching while other CPUs are active. For example the following
crash:

  User access of kernel address (c00000003fff5af0) - exploit attempt? (uid: 0)
  segfault (11) at c00000003fff5af0 nip 7fff8ad12198 lr 7fff8ad121f8 code 1
  code: 40820128 e93c00d0 e9290058 7c292840 40810058 38600000 4bfd9a81 e8410018
  code: 2c030006 41810154 3860ffb6 e9210098 <e94d8ff0> 7d295279 39400000 40820a3c

Shows that we returned to userspace without restoring the user r13
value, due to executing the partially patched STF exit code.

Fix it by doing the patching under stop machine. The CPUs that aren't
doing the patching will be spinning in the core of the stop machine
logic. That is currently sufficient for our purposes, because none of
the patching we do is to that code or anywhere in the vicinity.

Fixes: a048a07d7f45 ("powerpc/64s: Add support for a store forwarding barrier at kernel entry/exit")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210506044959.1298123-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/feature-fixups.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/sched/mm.h>
+#include <linux/stop_machine.h>
 #include <asm/cputable.h>
 #include <asm/code-patching.h>
 #include <asm/page.h>
@@ -227,11 +228,25 @@ static void do_stf_exit_barrier_fixups(e
 		                                           : "unknown");
 }
 
+static int __do_stf_barrier_fixups(void *data)
+{
+	enum stf_barrier_type *types = data;
+
+	do_stf_entry_barrier_fixups(*types);
+	do_stf_exit_barrier_fixups(*types);
+
+	return 0;
+}
 
 void do_stf_barrier_fixups(enum stf_barrier_type types)
 {
-	do_stf_entry_barrier_fixups(types);
-	do_stf_exit_barrier_fixups(types);
+	/*
+	 * The call to the fallback entry flush, and the fallback/sync-ori exit
+	 * flush can not be safely patched in/out while other CPUs are executing
+	 * them. So call __do_stf_barrier_fixups() on one CPU while all other CPUs
+	 * spin in the stop machine core with interrupts hard disabled.
+	 */
+	stop_machine(__do_stf_barrier_fixups, &types, NULL);
 }
 
 void do_uaccess_flush_fixups(enum l1d_flush_type types)


