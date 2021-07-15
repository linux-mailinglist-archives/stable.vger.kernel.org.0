Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE33CAB81
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244902AbhGOTU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245059AbhGOTTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:19:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FA361424;
        Thu, 15 Jul 2021 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376440;
        bh=eJrqTpZB7MccQSEJ6opiOVavQKwiB4rEjfRrhrDO7Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3ViFOn2pJOFNrB5pue+tS9QFE3R8YhuZC5CULK8TOHNhcnzGN6n7uoJkmSfT6bmE
         KIa5nxbqdHOUGbjzBr4qNKUIQigMOeJOyVi0p40EPO1K6OG8NMngcsZOdE4bVEAYw+
         OHs2vr7WCzNnTcsCA/OkFQTHwycxADrvRzb7DqWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.13 257/266] s390/vdso: add minimal compat vdso
Date:   Thu, 15 Jul 2021 20:40:12 +0200
Message-Id: <20210715182652.761086942@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 779df2248739b6308c03b354c99e4c352141e3bc upstream.

Add a small vdso for 31 bit compat application that provides
trampolines for calls to sigreturn,rt_sigreturn,syscall_restart.
This is requird for moving these syscalls away from the signal
frame to the vdso. Note that this patch effectively disables
CONFIG_COMPAT when using clang to compile the kernel. clang
doesn't support 31 bit mode.

We want to redirect sigreturn and restart_syscall to the vdso. However,
the kernel cannot parse the ELF vdso file, so we need to generate header
files which contain the offsets of the syscall instructions in the vdso
page.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig                           |    1 
 arch/s390/Makefile                          |   13 ++
 arch/s390/include/asm/elf.h                 |    2 
 arch/s390/include/asm/vdso.h                |   27 +++--
 arch/s390/include/asm/vdso/gettimeofday.h   |    1 
 arch/s390/kernel/Makefile                   |    1 
 arch/s390/kernel/vdso.c                     |   50 ++++++---
 arch/s390/kernel/vdso32/.gitignore          |    2 
 arch/s390/kernel/vdso32/Makefile            |   75 ++++++++++++++
 arch/s390/kernel/vdso32/gen_vdso_offsets.sh |   15 ++
 arch/s390/kernel/vdso32/note.S              |   13 ++
 arch/s390/kernel/vdso32/vdso32.lds.S        |  141 ++++++++++++++++++++++++++++
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |   15 ++
 arch/s390/kernel/vdso32/vdso_user_wrapper.S |   21 ++++
 arch/s390/kernel/vdso64/Makefile            |    8 +
 arch/s390/kernel/vdso64/gen_vdso_offsets.sh |   15 ++
 16 files changed, 373 insertions(+), 27 deletions(-)
 create mode 100644 arch/s390/kernel/vdso32/.gitignore
 create mode 100644 arch/s390/kernel/vdso32/Makefile
 create mode 100755 arch/s390/kernel/vdso32/gen_vdso_offsets.sh
 create mode 100644 arch/s390/kernel/vdso32/note.S
 create mode 100644 arch/s390/kernel/vdso32/vdso32.lds.S
 create mode 100644 arch/s390/kernel/vdso32/vdso32_wrapper.S
 create mode 100644 arch/s390/kernel/vdso32/vdso_user_wrapper.S
 create mode 100755 arch/s390/kernel/vdso64/gen_vdso_offsets.sh

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -438,6 +438,7 @@ config COMPAT
 	select COMPAT_OLD_SIGACTION
 	select HAVE_UID16
 	depends on MULTIUSER
+	depends on !CC_IS_CLANG
 	help
 	  Select this option if you want to enable your system kernel to
 	  handle system-calls from ELF binaries for 31 bit ESA.  This option
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -165,6 +165,19 @@ archheaders:
 archprepare:
 	$(Q)$(MAKE) $(build)=$(syscalls) kapi
 	$(Q)$(MAKE) $(build)=$(tools) kapi
+ifeq ($(KBUILD_EXTMOD),)
+# We need to generate vdso-offsets.h before compiling certain files in kernel/.
+# In order to do that, we should use the archprepare target, but we can't since
+# asm-offsets.h is included in some files used to generate vdso-offsets.h, and
+# asm-offsets.h is built in prepare0, for which archprepare is a dependency.
+# Therefore we need to generate the header after prepare0 has been made, hence
+# this hack.
+prepare: vdso_prepare
+vdso_prepare: prepare0
+	$(Q)$(MAKE) $(build)=arch/s390/kernel/vdso64 include/generated/vdso64-offsets.h
+	$(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
+		$(build)=arch/s390/kernel/vdso32 include/generated/vdso32-offsets.h)
+endif
 
 # Don't use tabs in echo arguments
 define archhelp
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -144,8 +144,6 @@ typedef s390_compat_regs compat_elf_greg
 #include <linux/sched/mm.h>	/* for task_struct */
 #include <asm/mmu_context.h>
 
-#include <asm/vdso.h>
-
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -4,18 +4,31 @@
 
 #include <vdso/datapage.h>
 
-/* Default link address for the vDSO */
-#define VDSO_LBASE	0
-
-#define __VVAR_PAGES	2
-
-#define VDSO_VERSION_STRING	LINUX_2.6.29
-
 #ifndef __ASSEMBLY__
 
+#include <generated/vdso64-offsets.h>
+#ifdef CONFIG_COMPAT
+#include <generated/vdso32-offsets.h>
+#endif
+
+#define VDSO64_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
+#ifdef CONFIG_COMPAT
+#define VDSO32_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso32_offset_##name))
+#else
+#define VDSO32_SYMBOL(tsk, name) (-1UL)
+#endif
+
 extern struct vdso_data *vdso_data;
 
 int vdso_getcpu_init(void);
 
 #endif /* __ASSEMBLY__ */
+
+/* Default link address for the vDSO */
+#define VDSO_LBASE	0
+
+#define __VVAR_PAGES	2
+
+#define VDSO_VERSION_STRING	LINUX_2.6.29
+
 #endif /* __S390_VDSO_H__ */
--- a/arch/s390/include/asm/vdso/gettimeofday.h
+++ b/arch/s390/include/asm/vdso/gettimeofday.h
@@ -8,7 +8,6 @@
 
 #include <asm/timex.h>
 #include <asm/unistd.h>
-#include <asm/vdso.h>
 #include <linux/compiler.h>
 
 #define vdso_calc_delta __arch_vdso_calc_delta
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -78,3 +78,4 @@ obj-$(findstring y, $(CONFIG_PROTECTED_V
 
 # vdso
 obj-y				+= vdso64/
+obj-$(CONFIG_COMPAT)		+= vdso32/
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -20,7 +20,7 @@
 #include <asm/vdso.h>
 
 extern char vdso64_start[], vdso64_end[];
-static unsigned int vdso_pages;
+extern char vdso32_start[], vdso32_end[];
 
 static struct vm_special_mapping vvar_mapping;
 
@@ -143,7 +143,12 @@ static struct vm_special_mapping vvar_ma
 	.fault = vvar_fault,
 };
 
-static struct vm_special_mapping vdso_mapping = {
+static struct vm_special_mapping vdso64_mapping = {
+	.name = "[vdso]",
+	.mremap = vdso_mremap,
+};
+
+static struct vm_special_mapping vdso32_mapping = {
 	.name = "[vdso]",
 	.mremap = vdso_mremap,
 };
@@ -159,16 +164,22 @@ int arch_setup_additional_pages(struct l
 {
 	unsigned long vdso_text_len, vdso_mapping_len;
 	unsigned long vvar_start, vdso_text_start;
+	struct vm_special_mapping *vdso_mapping;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int rc;
 
 	BUILD_BUG_ON(VVAR_NR_PAGES != __VVAR_PAGES);
-	if (is_compat_task())
-		return 0;
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
-	vdso_text_len = vdso_pages << PAGE_SHIFT;
+
+	if (is_compat_task()) {
+		vdso_text_len = vdso32_end - vdso32_start;
+		vdso_mapping = &vdso32_mapping;
+	} else {
+		vdso_text_len = vdso64_end - vdso64_start;
+		vdso_mapping = &vdso64_mapping;
+	}
 	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE;
 	vvar_start = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
 	rc = vvar_start;
@@ -186,7 +197,7 @@ int arch_setup_additional_pages(struct l
 	vma = _install_special_mapping(mm, vdso_text_start, vdso_text_len,
 				       VM_READ|VM_EXEC|
 				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				       &vdso_mapping);
+				       vdso_mapping);
 	if (IS_ERR(vma)) {
 		do_munmap(mm, vvar_start, PAGE_SIZE, NULL);
 		rc = PTR_ERR(vma);
@@ -199,20 +210,25 @@ out:
 	return rc;
 }
 
-static int __init vdso_init(void)
+static struct page ** __init vdso_setup_pages(void *start, void *end)
 {
-	struct page **pages;
+	int pages = (end - start) >> PAGE_SHIFT;
+	struct page **pagelist;
 	int i;
 
-	vdso_pages = (vdso64_end - vdso64_start) >> PAGE_SHIFT;
-	pages = kcalloc(vdso_pages + 1, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		panic("failed to allocate VDSO pages");
-
-	for (i = 0; i < vdso_pages; i++)
-		pages[i] = virt_to_page(vdso64_start + i * PAGE_SIZE);
-	pages[vdso_pages] = NULL;
-	vdso_mapping.pages = pages;
+	pagelist = kcalloc(pages + 1, sizeof(struct page *), GFP_KERNEL);
+	if (!pagelist)
+		panic("%s: Cannot allocate page list for VDSO", __func__);
+	for (i = 0; i < pages; i++)
+		pagelist[i] = virt_to_page(start + i * PAGE_SIZE);
+	return pagelist;
+}
+
+static int __init vdso_init(void)
+{
+	vdso64_mapping.pages = vdso_setup_pages(vdso64_start, vdso64_end);
+	if (IS_ENABLED(CONFIG_COMPAT))
+		vdso32_mapping.pages = vdso_setup_pages(vdso32_start, vdso32_end);
 	return 0;
 }
 arch_initcall(vdso_init);
--- /dev/null
+++ b/arch/s390/kernel/vdso32/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+vdso32.lds
--- /dev/null
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: GPL-2.0
+# List of files in the vdso
+
+KCOV_INSTRUMENT := n
+ARCH_REL_TYPE_ABS := R_390_COPY|R_390_GLOB_DAT|R_390_JMP_SLOT|R_390_RELATIVE
+ARCH_REL_TYPE_ABS += R_390_GOT|R_390_PLT
+
+include $(srctree)/lib/vdso/Makefile
+obj-vdso32 = vdso_user_wrapper-32.o note-32.o
+
+# Build rules
+
+targets := $(obj-vdso32) vdso32.so vdso32.so.dbg
+obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
+
+KBUILD_AFLAGS += -DBUILD_VDSO
+KBUILD_CFLAGS += -DBUILD_VDSO -DDISABLE_BRANCH_PROFILING
+
+KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
+KBUILD_AFLAGS_32 += -m31 -s
+
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
+
+LDFLAGS_vdso32.so.dbg += -fPIC -shared -nostdlib -soname=linux-vdso32.so.1 \
+	--hash-style=both --build-id=sha1 -melf_s390 -T
+
+$(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+$(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
+
+obj-y += vdso32_wrapper.o
+CPPFLAGS_vdso32.lds += -P -C -U$(ARCH)
+
+# Disable gcov profiling, ubsan and kasan for VDSO code
+GCOV_PROFILE := n
+UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
+
+# Force dependency (incbin is bad)
+$(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
+
+$(obj)/vdso32.so.dbg: $(src)/vdso32.lds $(obj-vdso32) FORCE
+	$(call if_changed,ld)
+
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+$(obj-vdso32): %-32.o: %.S FORCE
+	$(call if_changed_dep,vdso32as)
+
+# actual build commands
+quiet_cmd_vdso32as = VDSO32A $@
+      cmd_vdso32as = $(CC) $(a_flags) -c -o $@ $<
+quiet_cmd_vdso32cc = VDSO32C $@
+      cmd_vdso32cc = $(CC) $(c_flags) -c -o $@ $<
+
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso32.so: $(obj)/vdso32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso32.so
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
+
+include/generated/vdso32-offsets.h: $(obj)/vdso32.so.dbg FORCE
+	$(call if_changed,vdsosym)
--- /dev/null
+++ b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
@@ -0,0 +1,15 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+#
+# Match symbols in the DSO that look like VDSO_*; produce a header file
+# of constant offsets into the shared object.
+#
+# Doing this inside the Makefile will break the $(filter-out) function,
+# causing Kbuild to rebuild the vdso-offsets header file every time.
+#
+# Inspired by arm64 version.
+#
+
+LC_ALL=C
+sed -n 's/\([0-9a-f]*\) . __kernel_compat_\(.*\)/\#define vdso32_offset_\2\t0x\1/p'
--- /dev/null
+++ b/arch/s390/kernel/vdso32/note.S
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
+ * Here we can supply some information useful to userland.
+ */
+
+#include <linux/uts.h>
+#include <linux/version.h>
+#include <linux/elfnote.h>
+
+ELFNOTE_START(Linux, 0, "a")
+	.long LINUX_VERSION_CODE
+ELFNOTE_END
--- /dev/null
+++ b/arch/s390/kernel/vdso32/vdso32.lds.S
@@ -0,0 +1,141 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This is the infamous ld script for the 64 bits vdso
+ * library
+ */
+
+#include <asm/page.h>
+#include <asm/vdso.h>
+
+OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
+OUTPUT_ARCH(s390:31-bit)
+ENTRY(_start)
+
+SECTIONS
+{
+	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
+#ifdef CONFIG_TIME_NS
+	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
+#endif
+	. = VDSO_LBASE + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+	.text		: {
+		*(.text .stub .text.* .gnu.linkonce.t.*)
+	} :text
+	PROVIDE(__etext = .);
+	PROVIDE(_etext = .);
+	PROVIDE(etext = .);
+
+	/*
+	 * Other stuff is appended to the text segment:
+	 */
+	.rodata		: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
+	.rodata1	: { *(.rodata1) }
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	.gcc_except_table : { *(.gcc_except_table .gcc_except_table.*) }
+
+	.rela.dyn ALIGN(8) : { *(.rela.dyn) }
+	.got ALIGN(8)	: { *(.got .toc) }
+
+	_end = .;
+	PROVIDE(end = .);
+
+	/*
+	 * Stabs debugging sections are here too.
+	 */
+	.stab	       0 : { *(.stab) }
+	.stabstr       0 : { *(.stabstr) }
+	.stab.excl     0 : { *(.stab.excl) }
+	.stab.exclstr  0 : { *(.stab.exclstr) }
+	.stab.index    0 : { *(.stab.index) }
+	.stab.indexstr 0 : { *(.stab.indexstr) }
+	.comment       0 : { *(.comment) }
+
+	/*
+	 * DWARF debug sections.
+	 * Symbols in the DWARF debugging sections are relative to the
+	 * beginning of the section so we begin them at 0.
+	 */
+	/* DWARF 1 */
+	.debug		0 : { *(.debug) }
+	.line		0 : { *(.line) }
+	/* GNU DWARF 1 extensions */
+	.debug_srcinfo	0 : { *(.debug_srcinfo) }
+	.debug_sfnames	0 : { *(.debug_sfnames) }
+	/* DWARF 1.1 and DWARF 2 */
+	.debug_aranges	0 : { *(.debug_aranges) }
+	.debug_pubnames 0 : { *(.debug_pubnames) }
+	/* DWARF 2 */
+	.debug_info	0 : { *(.debug_info .gnu.linkonce.wi.*) }
+	.debug_abbrev	0 : { *(.debug_abbrev) }
+	.debug_line	0 : { *(.debug_line) }
+	.debug_frame	0 : { *(.debug_frame) }
+	.debug_str	0 : { *(.debug_str) }
+	.debug_loc	0 : { *(.debug_loc) }
+	.debug_macinfo	0 : { *(.debug_macinfo) }
+	/* SGI/MIPS DWARF 2 extensions */
+	.debug_weaknames 0 : { *(.debug_weaknames) }
+	.debug_funcnames 0 : { *(.debug_funcnames) }
+	.debug_typenames 0 : { *(.debug_typenames) }
+	.debug_varnames  0 : { *(.debug_varnames) }
+	/* DWARF 3 */
+	.debug_pubtypes 0 : { *(.debug_pubtypes) }
+	.debug_ranges	0 : { *(.debug_ranges) }
+	.gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.branch_lt)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
+}
+
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD FILEHDR PHDRS FLAGS(5);	/* PF_R|PF_X */
+	dynamic		PT_DYNAMIC FLAGS(4);		/* PF_R */
+	note		PT_NOTE FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+	VDSO_VERSION_STRING {
+	global:
+		/*
+		 * Has to be there for the kernel to find
+		 */
+		__kernel_compat_restart_syscall;
+		__kernel_compat_rt_sigreturn;
+		__kernel_compat_sigreturn;
+	local: *;
+	};
+}
--- /dev/null
+++ b/arch/s390/kernel/vdso32/vdso32_wrapper.S
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.globl vdso32_start, vdso32_end
+	.balign PAGE_SIZE
+vdso32_start:
+	.incbin "arch/s390/kernel/vdso32/vdso32.so"
+	.balign PAGE_SIZE
+vdso32_end:
+
+	.previous
--- /dev/null
+++ b/arch/s390/kernel/vdso32/vdso_user_wrapper.S
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm/unistd.h>
+#include <asm/dwarf.h>
+
+.macro vdso_syscall func,syscall
+	.globl __kernel_compat_\func
+	.type  __kernel_compat_\func,@function
+	.align 8
+__kernel_compat_\func:
+	CFI_STARTPROC
+	svc	\syscall
+	/* Make sure we notice when a syscall returns, which shouldn't happen */
+	.word	0
+	CFI_ENDPROC
+	.size	__kernel_compat_\func,.-__kernel_compat_\func
+.endm
+
+vdso_syscall restart_syscall,__NR_restart_syscall
+vdso_syscall sigreturn,__NR_sigreturn
+vdso_syscall rt_sigreturn,__NR_rt_sigreturn
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -74,3 +74,11 @@ vdso64.so: $(obj)/vdso64.so.dbg
 	$(call cmd,vdso_install)
 
 vdso_install: vdso64.so
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
+
+include/generated/vdso64-offsets.h: $(obj)/vdso64.so.dbg FORCE
+	$(call if_changed,vdsosym)
--- /dev/null
+++ b/arch/s390/kernel/vdso64/gen_vdso_offsets.sh
@@ -0,0 +1,15 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+#
+# Match symbols in the DSO that look like VDSO_*; produce a header file
+# of constant offsets into the shared object.
+#
+# Doing this inside the Makefile will break the $(filter-out) function,
+# causing Kbuild to rebuild the vdso-offsets header file every time.
+#
+# Inspired by arm64 version.
+#
+
+LC_ALL=C
+sed -n 's/\([0-9a-f]*\) . __kernel_\(.*\)/\#define vdso64_offset_\2\t0x\1/p'


