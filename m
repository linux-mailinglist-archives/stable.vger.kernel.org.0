Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66D59B267
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiHUHBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiHUHAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3362A974
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 00:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DB960CF5
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A658C433C1;
        Sun, 21 Aug 2022 07:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065230;
        bh=mG+7KJekbk+ND9fGKO4xB910gh4wJUFDg76xcYXS7e4=;
        h=Subject:To:Cc:From:Date:From;
        b=z/BSjwkmHy8K9aKmE+MQ9Bki1bEbPdDkLecMl7CLh+MY7T/sOkdFcWubBerA7D8Y4
         CVYPIJ376SjwECllkRVgDXrYF+QAtAq8wAAE6hHlp6IC9DIzV+joaXJi2GPrz6aSOp
         33kvQATIJWMFpbe5e303utw6tW/zdNrLocHWdUXM=
Subject: FAILED: patch "[PATCH] kexec_file: drop weak attribute from functions" failed to apply to 5.15-stable tree
To:     naveen.n.rao@linux.vnet.ibm.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Aug 2022 20:20:35 +0200
Message-ID: <16610196352176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65d9a9a60fd71be964effb2e94747a6acb6e7015 Mon Sep 17 00:00:00 2001
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Fri, 1 Jul 2022 13:04:04 +0530
Subject: [PATCH] kexec_file: drop weak attribute from functions

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

diff --git a/arch/arm64/include/asm/kexec.h b/arch/arm64/include/asm/kexec.h
index 9839bfc163d7..78d272b26ebd 100644
--- a/arch/arm64/include/asm/kexec.h
+++ b/arch/arm64/include/asm/kexec.h
@@ -115,7 +115,9 @@ extern const struct kexec_file_ops kexec_image_ops;
 
 struct kimage;
 
-extern int arch_kimage_file_post_load_cleanup(struct kimage *image);
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
+
 extern int load_other_segments(struct kimage *image,
 		unsigned long kernel_load_addr, unsigned long kernel_size,
 		char *initrd, unsigned long initrd_len,
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index 2aefe14e1442..1e5e9b6ec78d 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -120,6 +120,15 @@ int setup_purgatory(struct kimage *image, const void *slave_code,
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
index 649ecdcc8734..8886aadc11a3 100644
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
index 6ad8d946cd3e..5ec359c1b50c 100644
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
index 475683cd67f1..6958c6b471f4 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -188,21 +188,53 @@ int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
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
index f9261c07b048..0c27c81351ee 100644
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
@@ -621,19 +603,6 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
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

