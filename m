Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E303427CA04
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbgI2MPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgI2LhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0773F23ED0;
        Tue, 29 Sep 2020 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379171;
        bh=jwTC5H8TW23aEKAnWNTc27pi/TPAGsWxcsEqs/NdVLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZi2lU3Xok/n8SNHGTSvqD6ogzkcBmJFOErHNFyCwZ126oNNHSfrnlGO/JHHhffXr
         jJauDmHsIHzuP4rykhl8aduYNxg42u0rYB4RXp8pAW0aEAeJuncsv+Svh3FwnMs5Dm
         FtMcV8FLpYZVQjo3J8YRrRa8BJFebWobfXOdhuds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Borislav Petkov <bp@suse.de>, bhe@redhat.com,
        Dave Young <dyoung@redhat.com>, d.hatayama@fujitsu.com,
        dhowells@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?J=C3=BCrgen=20Gross?= <jgross@suse.com>,
        kexec@lists.infradead.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, vgoyal@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/388] x86/kdump: Always reserve the low 1M when the crashkernel option is specified
Date:   Tue, 29 Sep 2020 12:56:15 +0200
Message-Id: <20200929110012.622682029@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lianbo Jiang <lijiang@redhat.com>

[ Upstream commit 6f599d84231fd27e42f4ca2a786a6641e8cddf00 ]

On x86, purgatory() copies the first 640K of memory to a backup region
because the kernel needs those first 640K for the real mode trampoline
during boot, among others.

However, when SME is enabled, the kernel cannot properly copy the old
memory to the backup area but reads only its encrypted contents. The
result is that the crash tool gets invalid pointers when parsing vmcore:

  crash> kmem -s|grep -i invalid
  kmem: dma-kmalloc-512: slab:ffffd77680001c00 invalid freepointer:a6086ac099f0c5a4
  kmem: dma-kmalloc-512: slab:ffffd77680001c00 invalid freepointer:a6086ac099f0c5a4
  crash>

So reserve the remaining low 1M memory when the crashkernel option is
specified (after reserving real mode memory) so that allocated memory
does not fall into the low 1M area and thus the copying of the contents
of the first 640k to a backup region in purgatory() can be avoided
altogether.

This way, it does not need to be included in crash dumps or used for
anything except the trampolines that must live in the low 1M.

 [ bp: Heavily rewrite commit message, flip check logic in
   crash_reserve_low_1M().]

Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: bhe@redhat.com
Cc: Dave Young <dyoung@redhat.com>
Cc: d.hatayama@fujitsu.com
Cc: dhowells@redhat.com
Cc: ebiederm@xmission.com
Cc: horms@verge.net.au
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jürgen Gross <jgross@suse.com>
Cc: kexec@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: vgoyal@redhat.com
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191108090027.11082-2-lijiang@redhat.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204793
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/crash.h |  6 ++++++
 arch/x86/kernel/crash.c      | 15 +++++++++++++++
 arch/x86/realmode/init.c     |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
index ef5638f641f2b..88eadd08ad708 100644
--- a/arch/x86/include/asm/crash.h
+++ b/arch/x86/include/asm/crash.h
@@ -10,4 +10,10 @@ int crash_setup_memmap_entries(struct kimage *image,
 		struct boot_params *params);
 void crash_smp_send_stop(void);
 
+#ifdef CONFIG_KEXEC_CORE
+void __init crash_reserve_low_1M(void);
+#else
+static inline void __init crash_reserve_low_1M(void) { }
+#endif
+
 #endif /* _ASM_X86_CRASH_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index eb651fbde92ac..ff25a2ea271cf 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/memblock.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -39,6 +40,7 @@
 #include <asm/virtext.h>
 #include <asm/intel_pt.h>
 #include <asm/crash.h>
+#include <asm/cmdline.h>
 
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
@@ -68,6 +70,19 @@ static inline void cpu_crash_vmclear_loaded_vmcss(void)
 	rcu_read_unlock();
 }
 
+/*
+ * When the crashkernel option is specified, only use the low
+ * 1M for the real mode trampoline.
+ */
+void __init crash_reserve_low_1M(void)
+{
+	if (cmdline_find_option(boot_command_line, "crashkernel", NULL, 0) < 0)
+		return;
+
+	memblock_reserve(0, 1<<20);
+	pr_info("Reserving the low 1M of memory for crashkernel\n");
+}
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 7dce39c8c034a..262f83cad3551 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -8,6 +8,7 @@
 #include <asm/pgtable.h>
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
+#include <asm/crash.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -34,6 +35,7 @@ void __init reserve_real_mode(void)
 
 	memblock_reserve(mem, size);
 	set_real_mode_mem(mem);
+	crash_reserve_low_1M();
 }
 
 static void __init setup_real_mode(void)
-- 
2.25.1



