Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6F220C14
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfEPQBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42870 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727014AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006zC-Re; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001OC-4m; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Mike Galbraith" <efault@gmx.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Jiri Olsa" <jolsa@redhat.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Vince Weaver" <vincent.weaver@maine.edu>, rostedt@goodmis.org,
        "Stephane Eranian" <eranian@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.467416823@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 23/86] x86/headers: Don't include asm/processor.h in
 asm/atomic.h
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 153a4334c439cfb62e1d31cee0c790ba4157813d upstream.

asm/atomic.h doesn't really need asm/processor.h anymore. Everything
it uses has moved to other header files. So remove that include.

processor.h is a nasty header that includes lots of
other headers and makes it prone to include loops. Removing the
include here makes asm/atomic.h a "leaf" header that can
be safely included in most other headers.

The only fallout is in the lib/atomic tester which relied on
this implicit include. Give it an explicit include.
(the include is in ifdef because the user is also in ifdef)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: rostedt@goodmis.org
Link: http://lkml.kernel.org/r/1449018060-1742-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 to avoid a dependency loop; adjusted context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/atomic.h      | 1 -
 arch/x86/include/asm/atomic64_32.h | 1 -
 lib/atomic64_test.c                | 4 ++++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -3,7 +3,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 #include <asm/rmwcc.h>
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -3,7 +3,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/processor.h>
 //#include <asm/cmpxchg.h>
 
 /* An 64bit atomic type */
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -16,6 +16,10 @@
 #include <linux/kernel.h>
 #include <linux/atomic.h>
 
+#ifdef CONFIG_X86
+#include <asm/processor.h>	/* for boot_cpu_has below */
+#endif
+
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
 static __init int test_atomic64(void)
 {

