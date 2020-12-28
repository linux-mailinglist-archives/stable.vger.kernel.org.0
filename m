Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4EC2E6621
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393539AbgL1QJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393535AbgL1QJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 11:09:24 -0500
X-Greylist: delayed 121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Dec 2020 08:08:43 PST
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F08FC061794;
        Mon, 28 Dec 2020 08:08:43 -0800 (PST)
Received: from geronimo.kostuchna.emnet (unknown [127.0.0.1])
        by shrek.podlesie.net (Postfix) with ESMTP id 9119E1636;
        Mon, 28 Dec 2020 16:06:40 +0000 (UTC)
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>, stable@vger.kernel.org
Subject: [PATCH] x86/lib: don't use MMX before FPU initialization
Date:   Mon, 28 Dec 2020 17:06:31 +0100
Message-Id: <20201228160631.32732-1-krzysiek@podlesie.net>
X-Mailer: git-send-email 2.27.0.rc1.207.gb85828341f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When enabled, the MMX 3DNow! optimized memcpy() is used very early,
even before FPU is initialized. It worked fine, but commit
7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
to default in kernel_fpu_begin()") broke that. After that commit
the kernel crashes just after "Booting the kernel." message.
It affects all kernels with CONFIG_X86_USE_3DNOW=y (enabled when
some AMD/Cyrix processors are selected). So, enable MMX 3DNow!
optimized memcpy() later.

Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
Hi,

this patch fixes a kernel crash during boot observed on AMD Athlon XP
(with CONFIG_MK7=y).

The static key adds 5 byte NOP in the "fast" path. The 3DNow! usage
can be enabled earlier, but arch_initcall should be ok.
The static_cpu_has() does not work because the kernel with
CONFIG_X86_USE_3DNOW=y assumes that 3DNOW! is available,
so a static key is used instead. "Alternatives" should
also work, as long they not assume that required features
(REQUIRED_MASK*) are available early.

Similar bugs are possible. For easier debugging, maybe
kernel_fpu_begin() should catch such cases and print something?

Thanks,
Krzysiek

 arch/x86/lib/mmx_32.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index 4321fa02e18d..375bf0798993 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -26,12 +26,14 @@
 #include <asm/fpu/api.h>
 #include <asm/asm.h>
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_mmx);
+
 void *_mmx_memcpy(void *to, const void *from, size_t len)
 {
 	void *p;
 	int i;
 
-	if (unlikely(in_interrupt()))
+	if (unlikely(in_interrupt()) || !static_branch_likely(&use_mmx))
 		return __memcpy(to, from, len);
 
 	p = to;
@@ -376,3 +378,11 @@ void mmx_copy_page(void *to, void *from)
 		fast_copy_page(to, from);
 }
 EXPORT_SYMBOL(mmx_copy_page);
+
+static int __init mmx_32_init(void)
+{
+	static_branch_enable(&use_mmx);
+	return 0;
+}
+
+arch_initcall(mmx_32_init);
-- 
2.27.0.rc1.207.gb85828341f

