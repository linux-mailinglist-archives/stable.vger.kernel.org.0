Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E5B6EBA28
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDVQFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVQFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C680B1736
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614C260C34
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6EEC433EF;
        Sat, 22 Apr 2023 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682179521;
        bh=8S8O25fFkFkrTirrBp702S1p4sgxNSHZOj9kqnmtcvg=;
        h=Subject:To:Cc:From:Date:From;
        b=H9OpDAehfqdMruP8G8rAParM8ruHp3tmLz9Eio8Gs0dFK81rftN2TkD2NbHuZIlVq
         MsBZyua6dikLzT9zMqocrvwvNI0DnbGjz5xBMIFh8/KNmE5RrLjUhexrSujaPpic5K
         rrR37DrFIbHjl+JObvZR88cb0KJks0ukkZexBLdM=
Subject: FAILED: patch "[PATCH] LoongArch: Make WriteCombine configurable for ioremap()" failed to apply to 6.2-stable tree
To:     chenhuacai@kernel.org, chenhuacai@loongson.cn, kernel@xen0n.name
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:05:13 +0200
Message-ID: <2023042213-overbid-jitters-7a29@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 16c52e503043aed1e2a2ce38d9249de5936c1f6b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042213-overbid-jitters-7a29@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

16c52e503043 ("LoongArch: Make WriteCombine configurable for ioremap()")
41596803302d ("LoongArch: Make -mstrict-align configurable")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 16c52e503043aed1e2a2ce38d9249de5936c1f6b Mon Sep 17 00:00:00 2001
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 18 Apr 2023 19:38:58 +0800
Subject: [PATCH] LoongArch: Make WriteCombine configurable for ioremap()

LoongArch maintains cache coherency in hardware, but when paired with
LS7A chipsets the WUC attribute (Weak-ordered UnCached, which is similar
to WriteCombine) is out of the scope of cache coherency machanism for
PCIe devices (this is a PCIe protocol violation, which may be fixed in
newer chipsets).

This means WUC can only used for write-only memory regions now, so this
option is disabled by default, making WUC silently fallback to SUC for
ioremap(). You can enable this option if the kernel is ensured to run on
hardware without this bug.

Kernel parameter writecombine=on/off can be used to override the Kconfig
option.

Cc: stable@vger.kernel.org
Suggested-by: WANG Xuerui <kernel@xen0n.name>
Reviewed-by: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 19600c50277b..6ae5f129fbca 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -128,6 +128,7 @@ parameter is applicable::
 	KVM	Kernel Virtual Machine support is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
+	LOONGARCH LoongArch architecture is enabled.
 	LOOP	Loopback device support is enabled.
 	M68k	M68k architecture is enabled.
 			These options have more detailed description inside of
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6221a1d057dd..7016cb12dc4e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6933,6 +6933,12 @@
 			When enabled, memory and cache locality will be
 			impacted.
 
+	writecombine=	[LOONGARCH] Control the MAT (Memory Access Type) of
+			ioremap_wc().
+
+			on   - Enable writecombine, use WUC for ioremap_wc()
+			off  - Disable writecombine, use SUC for ioremap_wc()
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 7fd51257e0ed..3ddde336e6a5 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -447,6 +447,22 @@ config ARCH_IOREMAP
 	  protection support. However, you can enable LoongArch DMW-based
 	  ioremap() for better performance.
 
+config ARCH_WRITECOMBINE
+	bool "Enable WriteCombine (WUC) for ioremap()"
+	help
+	  LoongArch maintains cache coherency in hardware, but when paired
+	  with LS7A chipsets the WUC attribute (Weak-ordered UnCached, which
+	  is similar to WriteCombine) is out of the scope of cache coherency
+	  machanism for PCIe devices (this is a PCIe protocol violation, which
+	  may be fixed in newer chipsets).
+
+	  This means WUC can only used for write-only memory regions now, so
+	  this option is disabled by default, making WUC silently fallback to
+	  SUC for ioremap(). You can enable this option if the kernel is ensured
+	  to run on hardware without this bug.
+
+	  You can override this setting via writecombine=on/off boot parameter.
+
 config ARCH_STRICT_ALIGN
 	bool "Enable -mstrict-align to prevent unaligned accesses" if EXPERT
 	default y
diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index 402a7d9e3a53..545e2708fbf7 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -54,8 +54,10 @@ static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  */
+extern pgprot_t pgprot_wc;
+
 #define ioremap_wc(offset, size)	\
-	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL_WUC))
+	ioremap_prot((offset), (size), pgprot_val(pgprot_wc))
 
 #define ioremap_cache(offset, size)	\
 	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL))
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index bae84ccf6d36..27f71f9531e1 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -160,6 +160,27 @@ static void __init smbios_parse(void)
 	dmi_walk(find_tokens, NULL);
 }
 
+#ifdef CONFIG_ARCH_WRITECOMBINE
+pgprot_t pgprot_wc = PAGE_KERNEL_WUC;
+#else
+pgprot_t pgprot_wc = PAGE_KERNEL_SUC;
+#endif
+
+EXPORT_SYMBOL(pgprot_wc);
+
+static int __init setup_writecombine(char *p)
+{
+	if (!strcmp(p, "on"))
+		pgprot_wc = PAGE_KERNEL_WUC;
+	else if (!strcmp(p, "off"))
+		pgprot_wc = PAGE_KERNEL_SUC;
+	else
+		pr_warn("Unknown writecombine setting \"%s\".\n", p);
+
+	return 0;
+}
+early_param("writecombine", setup_writecombine);
+
 static int usermem __initdata;
 
 static int __init early_parse_mem(char *p)

