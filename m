Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34E5E8070
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiIWRKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiIWRKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:10:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E211D607;
        Fri, 23 Sep 2022 10:10:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 55B881F88D;
        Fri, 23 Sep 2022 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663953047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZ/YYHNzdKPwO2QBOPiFCZwcjPwHWC0adPlN029tkmU=;
        b=nIDionofPDQgJxiYQ0Pk4pEtgPRoGNy4FZ3o1D13hyrwpLj9M4szj8/2AnmK/U8EAxk6Hu
        UzGmk+tW22YOJQs9p3CEUTSy4OpUDa6NHKtcmMVKSAwZxJOqM6gRfmwSHJSdnhGEYivlVV
        MVIK+CNLF0UWle1ojTxKSf2yD7hpJMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663953047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZ/YYHNzdKPwO2QBOPiFCZwcjPwHWC0adPlN029tkmU=;
        b=TWbQblKX0kI2H5b/OGyX+Vi8p0K3NUf2RfRz65l5J1qILsJcTRJUvbi6ZLgYdcjb6nHLoZ
        zhe9FhIbISUvcPDw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id D6B562C15D;
        Fri, 23 Sep 2022 17:10:46 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baoquan He <bhe@redhat.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)), linux-s390@vger.kernel.org (open list:S390),
        kexec@lists.infradead.org (open list:KEXEC)
Subject: [PATCH 5.15 2/6] kexec_file: drop weak attribute from functions
Date:   Fri, 23 Sep 2022 19:10:30 +0200
Message-Id: <d02bd8aa5bb98d7e6e40454cda91c0eb07a3e0d7.1663951201.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1663951201.git.msuchanek@suse.de>
References: <cover.1663951201.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

commit 65d9a9a60fd71be964effb2e94747a6acb6e7015 upstream.

As requested
(http://lkml.kernel.org/r/87ee0q7b92.fsf@email.froward.int.ebiederm.org),
this series converts weak functions in kexec to use the #ifdef approach.

Quoting the 3e35142ef99fe ("kexec_file: drop weak attribute from
arch_kexec_apply_relocations[_add]") changelog:

: Since commit d1bcae833b32f1 ("ELF: Don't generate unused section symbols")
: [1], binutils (v2.36+) started dropping section symbols that it thought
: were unused.  This isn't an issue in general, but with kexec_file.c, gcc
: is placing kexec_arch_apply_relocations[_add] into a separate
: .text.unlikely section and the section symbol ".text.unlikely" is being
: dropped.  Due to this, recordmcount is unable to find a non-weak symbol in
: .text.unlikely to generate a relocation record against.

This patch (of 2);

Drop __weak attribute from functions in kexec_file.c:
- arch_kexec_kernel_image_probe()
- arch_kimage_file_post_load_cleanup()
- arch_kexec_kernel_image_load()
- arch_kexec_locate_mem_hole()
- arch_kexec_kernel_verify_sig()

arch_kexec_kernel_image_load() calls into kexec_image_load_default(), so
drop the static attribute for the latter.

arch_kexec_kernel_verify_sig() is not overridden by any architecture, so
drop the __weak attribute.

Link: https://lkml.kernel.org/r/cover.1656659357.git.naveen.n.rao@linux.vnet.ibm.com
Link: https://lkml.kernel.org/r/2cd7ca1fe4d6bb6ca38e3283c717878388ed6788.1656659357.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Suggested-by: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/arm64/include/asm/kexec.h   |  4 ++-
 arch/powerpc/include/asm/kexec.h |  9 +++++++
 arch/s390/include/asm/kexec.h    |  3 +++
 arch/x86/include/asm/kexec.h     |  6 +++++
 include/linux/kexec.h            | 44 +++++++++++++++++++++++++++-----
 kernel/kexec_file.c              | 35 ++-----------------------
 6 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/kexec.h b/arch/arm64/include/asm/kexec.h
index 00dbcc71aeb2..91d81824f869 100644
--- a/arch/arm64/include/asm/kexec.h
+++ b/arch/arm64/include/asm/kexec.h
@@ -103,7 +103,9 @@ extern const struct kexec_file_ops kexec_image_ops;
 
 struct kimage;
 
-extern int arch_kimage_file_post_load_cleanup(struct kimage *image);
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
+
 extern int load_other_segments(struct kimage *image,
 		unsigned long kernel_load_addr, unsigned long kernel_size,
 		char *initrd, unsigned long initrd_len,
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 88d0d7cf3a79..6152fa220054 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -119,6 +119,15 @@ int setup_purgatory(struct kimage *image, const void *slave_code,
 #ifdef CONFIG_PPC64
 struct kexec_buf;
 
+int arch_kexec_kernel_image_probe(struct kimage *image, void *buf, unsigned long buf_len);
+#define arch_kexec_kernel_image_probe arch_kexec_kernel_image_probe
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
+
+int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
+#define arch_kexec_locate_mem_hole arch_kexec_locate_mem_hole
+
 int load_crashdump_segments_ppc64(struct kimage *image,
 				  struct kexec_buf *kbuf);
 int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 63098df81c9f..d13bd221cd37 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -92,5 +92,8 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 #endif /*_S390_KEXEC_H */
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index c7c924e15011..5b6e2ae54906 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -193,6 +193,12 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+void *arch_kexec_kernel_image_load(struct kimage *image);
+#define arch_kexec_kernel_image_load arch_kexec_kernel_image_load
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 #endif
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index cf042d41c87b..f1e5327a7bf8 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -182,21 +182,53 @@ int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
 				   void *buf, unsigned int size,
 				   bool get_value);
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name);
+void *kexec_image_load_default(struct kimage *image);
+
+#ifndef arch_kexec_kernel_image_probe
+static inline int
+arch_kexec_kernel_image_probe(struct kimage *image, void *buf, unsigned long buf_len)
+{
+	return kexec_image_probe_default(image, buf, buf_len);
+}
+#endif
+
+#ifndef arch_kimage_file_post_load_cleanup
+static inline int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	return kexec_image_post_load_cleanup_default(image);
+}
+#endif
+
+#ifndef arch_kexec_kernel_image_load
+static inline void *arch_kexec_kernel_image_load(struct kimage *image)
+{
+	return kexec_image_load_default(image);
+}
+#endif
 
-/* Architectures may override the below functions */
-int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
-				  unsigned long buf_len);
-void *arch_kexec_kernel_image_load(struct kimage *image);
-int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #ifdef CONFIG_KEXEC_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 				 unsigned long buf_len);
 #endif
-int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 
+#ifndef arch_kexec_locate_mem_hole
+/**
+ * arch_kexec_locate_mem_hole - Find free memory to place the segments.
+ * @kbuf:                       Parameters for the memory search.
+ *
+ * On success, kbuf->mem will have the start address of the memory region found.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
+{
+	return kexec_locate_mem_hole(kbuf);
+}
+#endif
+
 /* Alignment required for elf header segment */
 #define ELF_CORE_HEADER_ALIGN   4096
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f7a4fd4d243f..620021679405 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -62,14 +62,7 @@ int kexec_image_probe_default(struct kimage *image, void *buf,
 	return ret;
 }
 
-/* Architectures can provide this probe function */
-int __weak arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
-					 unsigned long buf_len)
-{
-	return kexec_image_probe_default(image, buf, buf_len);
-}
-
-static void *kexec_image_load_default(struct kimage *image)
+void *kexec_image_load_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
@@ -80,11 +73,6 @@ static void *kexec_image_load_default(struct kimage *image)
 				 image->cmdline_buf_len);
 }
 
-void * __weak arch_kexec_kernel_image_load(struct kimage *image)
-{
-	return kexec_image_load_default(image);
-}
-
 int kexec_image_post_load_cleanup_default(struct kimage *image)
 {
 	if (!image->fops || !image->fops->cleanup)
@@ -93,11 +81,6 @@ int kexec_image_post_load_cleanup_default(struct kimage *image)
 	return image->fops->cleanup(image->image_loader_data);
 }
 
-int __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
-{
-	return kexec_image_post_load_cleanup_default(image);
-}
-
 #ifdef CONFIG_KEXEC_SIG
 static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
 					  unsigned long buf_len)
@@ -110,8 +93,7 @@ static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
 	return image->fops->verify_sig(buf, buf_len);
 }
 
-int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
-					unsigned long buf_len)
+int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf, unsigned long buf_len)
 {
 	return kexec_image_verify_sig_default(image, buf, buf_len);
 }
@@ -616,19 +598,6 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }
 
-/**
- * arch_kexec_locate_mem_hole - Find free memory to place the segments.
- * @kbuf:                       Parameters for the memory search.
- *
- * On success, kbuf->mem will have the start address of the memory region found.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
-{
-	return kexec_locate_mem_hole(kbuf);
-}
-
 /**
  * kexec_add_buffer - place a buffer in a kexec segment
  * @kbuf:	Buffer contents and memory parameters.
-- 
2.35.3

