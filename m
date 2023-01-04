Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB4765D930
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239814AbjADQWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240025AbjADQWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6423B1A048
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F383A617AA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B03C433D2;
        Wed,  4 Jan 2023 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849331;
        bh=T/oSwq7vcyHMbOqR61vspwQkm7VFDreupelvS11/Irw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGMtRiTfP5VBueHGKx0CeQK4NrPOq1DaQg99f9CbWpIl0h5pjIWzHku6RgDDqbBgC
         omYATZpRQD5snxAqqvFwMszs1kVTkKFEfjS1qLpsnkMn8+WoXmGXKIiz0PbffcNBsq
         TcDfd6AwuNxEHsbd7th7ISSguv4yJx4AslQUVIa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Huafei <lihuafei1@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Liao Chang <liaochang1@huawei.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 104/177] RISC-V: kexec: Fix memory leak of fdt buffer
Date:   Wed,  4 Jan 2023 17:06:35 +0100
Message-Id: <20230104160510.799099802@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

commit 96df59b1ae23f5c11698c3c2159aeb2ecd4944a4 upstream.

This is reported by kmemleak detector:

unreferenced object 0xff60000082864000 (size 9588):
  comm "kexec", pid 146, jiffies 4294900634 (age 64.788s)
  hex dump (first 32 bytes):
    d0 0d fe ed 00 00 12 ed 00 00 00 48 00 00 11 40  ...........H...@
    00 00 00 28 00 00 00 11 00 00 00 02 00 00 00 00  ...(............
  backtrace:
    [<00000000f95b17c4>] kmemleak_alloc+0x34/0x3e
    [<00000000b9ec8e3e>] kmalloc_order+0x9c/0xc4
    [<00000000a95cf02e>] kmalloc_order_trace+0x34/0xb6
    [<00000000f01e68b4>] __kmalloc+0x5c2/0x62a
    [<000000002bd497b2>] kvmalloc_node+0x66/0xd6
    [<00000000906542fa>] of_kexec_alloc_and_setup_fdt+0xa6/0x6ea
    [<00000000e1166bde>] elf_kexec_load+0x206/0x4ec
    [<0000000036548e09>] kexec_image_load_default+0x40/0x4c
    [<0000000079fbe1b4>] sys_kexec_file_load+0x1c4/0x322
    [<0000000040c62c03>] ret_from_syscall+0x0/0x2

In elf_kexec_load(), a buffer is allocated via kvmalloc() to store fdt.
While it's not freed back to system when kexec kernel is reloaded or
unloaded.  Then memory leak is caused.  Fix it by introducing riscv
specific function arch_kimage_file_post_load_cleanup(), and freeing the
buffer there.

Fixes: 6261586e0c91 ("RISC-V: Add kexec_file support")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Liao Chang <liaochang1@huawei.com>
Link: https://lore.kernel.org/r/20221104095658.141222-1-lihuafei1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/kexec.h |  5 +++++
 arch/riscv/kernel/elf_kexec.c  | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/kexec.h b/arch/riscv/include/asm/kexec.h
index eee260e8ab30..2b56769cb530 100644
--- a/arch/riscv/include/asm/kexec.h
+++ b/arch/riscv/include/asm/kexec.h
@@ -39,6 +39,7 @@ crash_setup_regs(struct pt_regs *newregs,
 #define ARCH_HAS_KIMAGE_ARCH
 
 struct kimage_arch {
+	void *fdt; /* For CONFIG_KEXEC_FILE */
 	unsigned long fdt_addr;
 };
 
@@ -62,6 +63,10 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+struct kimage;
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 
 #endif
diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index 0cb94992c15b..ff30fcb43f47 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -21,6 +21,14 @@
 #include <linux/memblock.h>
 #include <asm/setup.h>
 
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	kvfree(image->arch.fdt);
+	image->arch.fdt = NULL;
+
+	return kexec_image_post_load_cleanup_default(image);
+}
+
 static int riscv_kexec_elf_load(struct kimage *image, struct elfhdr *ehdr,
 				struct kexec_elf_info *elf_info, unsigned long old_pbase,
 				unsigned long new_pbase)
@@ -298,6 +306,8 @@ static void *elf_kexec_load(struct kimage *image, char *kernel_buf,
 		pr_err("Error add DTB kbuf ret=%d\n", ret);
 		goto out_free_fdt;
 	}
+	/* Cache the fdt buffer address for memory cleanup */
+	image->arch.fdt = fdt;
 	pr_notice("Loaded device tree at 0x%lx\n", kbuf.mem);
 	goto out;
 
-- 
2.39.0



