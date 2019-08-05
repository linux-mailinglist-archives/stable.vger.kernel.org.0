Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC481C61
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfHENWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfHENWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348CD2075B;
        Mon,  5 Aug 2019 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011369;
        bh=tM9JJYBevCVFOkuEE+m3YuMQNE7scBYocu8jryTC9bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5qsxElLvPdvVUSDz570MJ7puzT/3JrvindXJKdkG5W4eVyqihvmenznRHccgAuQj
         TM62+UXwzzy1Q8M+jpcVrDsIQthJkSqJqZpvsAKBdQ/IIkgCTU6AZTRGdnP/er1Cbv
         n8sl0qAlsLYGZK/OH3bmQhK3bi1HQpl5rV1uLg/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 067/131] xen/pv: Fix a boot up hang revealed by int3 self test
Date:   Mon,  5 Aug 2019 15:02:34 +0200
Message-Id: <20190805124955.972111089@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b23e5844dfe78a80ba672793187d3f52e4b528d7 ]

Commit 7457c0da024b ("x86/alternatives: Add int3_emulate_call()
selftest") is used to ensure there is a gap setup in int3 exception stack
which could be used for inserting call return address.

This gap is missed in XEN PV int3 exception entry path, then below panic
triggered:

[    0.772876] general protection fault: 0000 [#1] SMP NOPTI
[    0.772886] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.2.0+ #11
[    0.772893] RIP: e030:int3_magic+0x0/0x7
[    0.772905] RSP: 3507:ffffffff82203e98 EFLAGS: 00000246
[    0.773334] Call Trace:
[    0.773334]  alternative_instructions+0x3d/0x12e
[    0.773334]  check_bugs+0x7c9/0x887
[    0.773334]  ? __get_locked_pte+0x178/0x1f0
[    0.773334]  start_kernel+0x4ff/0x535
[    0.773334]  ? set_init_arg+0x55/0x55
[    0.773334]  xen_start_kernel+0x571/0x57a

For 64bit PV guests, Xen's ABI enters the kernel with using SYSRET, with
%rcx/%r11 on the stack. To convert back to "normal" looking exceptions,
the xen thunks do 'xen_*: pop %rcx; pop %r11; jmp *'.

E.g. Extracting 'xen_pv_trap xenint3' we have:
xen_xenint3:
 pop %rcx;
 pop %r11;
 jmp xenint3

As xenint3 and int3 entry code are same except xenint3 doesn't generate
a gap, we can fix it by using int3 and drop useless xenint3.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S    | 1 -
 arch/x86/include/asm/traps.h | 2 +-
 arch/x86/xen/enlighten_pv.c  | 2 +-
 arch/x86/xen/xen-asm_64.S    | 1 -
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 8dbca86c249b8..5c033dc0c2c77 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1171,7 +1171,6 @@ idtentry stack_segment		do_stack_segment	has_error_code=1
 #ifdef CONFIG_XEN_PV
 idtentry xennmi			do_nmi			has_error_code=0
 idtentry xendebug		do_debug		has_error_code=0
-idtentry xenint3		do_int3			has_error_code=0
 #endif
 
 idtentry general_protection	do_general_protection	has_error_code=1
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 7d6f3f3fad786..f2bd284abc16d 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -40,7 +40,7 @@ asmlinkage void simd_coprocessor_error(void);
 asmlinkage void xen_divide_error(void);
 asmlinkage void xen_xennmi(void);
 asmlinkage void xen_xendebug(void);
-asmlinkage void xen_xenint3(void);
+asmlinkage void xen_int3(void);
 asmlinkage void xen_overflow(void);
 asmlinkage void xen_bounds(void);
 asmlinkage void xen_invalid_op(void);
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4722ba2966ac4..30c14cb343fc3 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -596,12 +596,12 @@ struct trap_array_entry {
 
 static struct trap_array_entry trap_array[] = {
 	{ debug,                       xen_xendebug,                    true },
-	{ int3,                        xen_xenint3,                     true },
 	{ double_fault,                xen_double_fault,                true },
 #ifdef CONFIG_X86_MCE
 	{ machine_check,               xen_machine_check,               true },
 #endif
 	{ nmi,                         xen_xennmi,                      true },
+	{ int3,                        xen_int3,                        false },
 	{ overflow,                    xen_overflow,                    false },
 #ifdef CONFIG_IA32_EMULATION
 	{ entry_INT80_compat,          xen_entry_INT80_compat,          false },
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 1e9ef0ba30a58..ebf610b49c068 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -32,7 +32,6 @@ xen_pv_trap divide_error
 xen_pv_trap debug
 xen_pv_trap xendebug
 xen_pv_trap int3
-xen_pv_trap xenint3
 xen_pv_trap xennmi
 xen_pv_trap overflow
 xen_pv_trap bounds
-- 
2.20.1



