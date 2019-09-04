Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C468A8F36
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387793AbfIDSC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388043AbfIDSC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6752A22CF5;
        Wed,  4 Sep 2019 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620148;
        bh=Rpw3jVIJFk1mEw6Dx+d2pKKY1La6zHw2ZjaW5cgoeE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pcmE3DVAEX7pFI2VtVH5EFQP4wOnJJTvh9xKypm0eZoobDsyPnII5p7N0zM/BK3K
         KUruFONsOE52UwHz410xNB7qnU+luF7JvBBLQZSx9fLmKFCx7QF3ljPt/3Z5tmohZq
         SSSpcYRz+7Bn8LI4O4SC52AvFj0N6IVa1DRytVKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        ricardo.neri@intel.com, Adrian Hunter <adrian.hunter@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Rui <ray.huang@amd.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Chris Metcalf <cmetcalf@mellanox.com>,
        Brian Gerst <brgerst@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Chen Yucong <slaoub@gmail.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Garnier <thgarnie@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 72/83] ptrace,x86: Make user_64bit_mode() available to 32-bit builds
Date:   Wed,  4 Sep 2019 19:54:04 +0200
Message-Id: <20190904175309.942046596@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e27c310af5c05cf876d9cad006928076c27f54d4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ptrace.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 2b5d686ea9f37..ea78a8438a8af 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -115,9 +115,9 @@ static inline int v8086_mode(struct pt_regs *regs)
 #endif
 }
 
-#ifdef CONFIG_X86_64
 static inline bool user_64bit_mode(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
 #ifndef CONFIG_PARAVIRT
 	/*
 	 * On non-paravirt systems, this is the only long mode CPL 3
@@ -128,8 +128,12 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
 	/* Headers are too twisted for this to go in paravirt.h. */
 	return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
 #endif
+#else /* !CONFIG_X86_64 */
+	return false;
+#endif
 }
 
+#ifdef CONFIG_X86_64
 #define current_user_stack_pointer()	current_pt_regs()->sp
 #define compat_user_stack_pointer()	current_pt_regs()->sp
 #endif
-- 
2.20.1



