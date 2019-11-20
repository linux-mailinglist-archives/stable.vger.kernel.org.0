Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813CD103F13
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfKTPlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:41:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53398 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731915AbfKTPkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:25 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004ay-Oe; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004JM-Bl; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Garnier" <thgarnie@google.com>,
        "Dmitry Vyukov" <dvyukov@google.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Chen Yucong" <slaoub@gmail.com>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shuah Khan" <shuah@kernel.org>,
        "Chris Metcalf" <cmetcalf@mellanox.com>,
        "Ricardo Neri" <ricardo.neri-calderon@linux.intel.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        ricardo.neri@intel.com, "Kees Cook" <keescook@chromium.org>,
        "Adam Buchbinder" <adam.buchbinder@gmail.com>,
        "Colin Ian King" <colin.king@canonical.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Qiaowei Ren" <qiaowei.ren@intel.com>,
        "Brian Gerst" <brgerst@gmail.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Huang Rui" <ray.huang@amd.com>,
        "Lorenzo Stoakes" <lstoakes@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@suse.de>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        "Jiri Slaby" <jslaby@suse.cz>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Date:   Wed, 20 Nov 2019 15:37:59 +0000
Message-ID: <lsq.1574264230.800450209@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 49/83] ptrace,x86: Make user_64bit_mode() available
 to 32-bit builds
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

commit e27c310af5c05cf876d9cad006928076c27f54d4 upstream.

In its current form, user_64bit_mode() can only be used when CONFIG_X86_64
is selected. This implies that code built with CONFIG_X86_64=n cannot use
it. If a piece of code needs to be built for both CONFIG_X86_64=y and
CONFIG_X86_64=n and wants to use this function, it needs to wrap it in
an #ifdef/#endif; potentially, in multiple places.

This can be easily avoided with a single #ifdef/#endif pair within
user_64bit_mode() itself.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: ricardo.neri@intel.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Adam Buchbinder <adam.buchbinder@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Garnier <thgarnie@google.com>
Link: https://lkml.kernel.org/r/1509135945-13762-4-git-send-email-ricardo.neri-calderon@linux.intel.com
[bwh: Backported to 3.16 as dependency of "uprobes/x86: Fix detection of
 32-bit user mode":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/ptrace.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -118,9 +118,9 @@ static inline int v8086_mode(struct pt_r
 #endif
 }
 
-#ifdef CONFIG_X86_64
 static inline bool user_64bit_mode(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
 #ifndef CONFIG_PARAVIRT
 	/*
 	 * On non-paravirt systems, this is the only long mode CPL 3
@@ -131,8 +131,12 @@ static inline bool user_64bit_mode(struc
 	/* Headers are too twisted for this to go in paravirt.h. */
 	return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
 #endif
+#else /* !CONFIG_X86_64 */
+	return false;
+#endif
 }
 
+#ifdef CONFIG_X86_64
 #define current_user_stack_pointer()	this_cpu_read(old_rsp)
 /* ia32 vs. x32 difference */
 #define compat_user_stack_pointer()	\

