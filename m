Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797C61FB65A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgFPPg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbgFPPg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC3520B1F;
        Tue, 16 Jun 2020 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321785;
        bh=xMDz6SQSPtfKU/lZT9ySa1YMh2Q5E7v4to60fHvQga0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm2wk5AubcmDbrcPYEB/2Dg8X4luapuskWStE/ykfdGe3uWjX5pmIVIvaA+9N8oKG
         rrTH2t2eHJarw5W75a4FUeNCeoSsx2qzX7BMZFES2nI7qg0f5Gr5+N7H+aRNdmID32
         7FY6cDS9ciobHXeQn5sD2Yj/JnZuc0jbDT9BLGb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Maria Teguiani <teguiani@google.com>,
        Matthias Maennich <maennich@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 007/134] bpf: Support llvm-objcopy for vmlinux BTF
Date:   Tue, 16 Jun 2020 17:33:11 +0200
Message-Id: <20200616153101.024401350@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit 90ceddcb495008ac8ba7a3dce297841efcd7d584 upstream.

Simplify gen_btf logic to make it work with llvm-objcopy. The existing
'file format' and 'architecture' parsing logic is brittle and does not
work with llvm-objcopy/llvm-objdump.

'file format' output of llvm-objdump>=11 will match GNU objdump, but
'architecture' (bfdarch) may not.

.BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
because it is part of vmlinux image used for introspection. C code
can reference the section via linker script defined __start_BTF and
__stop_BTF. This fixes a small problem that previous .BTF had the
SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).

Additionally, `objcopy -I binary` synthesized symbols
_binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
used elsewhere) are replaced with more commonplace __start_BTF and
__stop_BTF.

Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
"empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"

We use a dd command to change the e_type field in the ELF header from
ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
ET_EXEC as an input file is an extremely rare GNU ld feature that lld
does not intend to support, because this is error-prone.

The output section description .BTF in include/asm-generic/vmlinux.lds.h
avoids potential subtle orphan section placement issues and suppresses
--orphan-handling=warn warnings.

Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Stanislav Fomichev <sdf@google.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Link: https://github.com/ClangBuiltLinux/linux/issues/871
Link: https://lore.kernel.org/bpf/20200318222746.173648-1-maskray@google.com
Signed-off-by: Maria Teguiani <teguiani@google.com>
Tested-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vmlinux.lds.S |    6 ------
 include/asm-generic/vmlinux.lds.h |   22 +++++++++++++++++++---
 kernel/bpf/sysfs_btf.c            |   11 +++++------
 scripts/link-vmlinux.sh           |   24 ++++++++++--------------
 4 files changed, 34 insertions(+), 29 deletions(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -326,12 +326,6 @@ SECTIONS
 		*(.branch_lt)
 	}
 
-#ifdef CONFIG_DEBUG_INFO_BTF
-	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {
-		*(.BTF)
-	}
-#endif
-
 	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
 		__start_opd = .;
 		KEEP(*(.opd))
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -496,10 +496,12 @@
 		__start___modver = .;					\
 		KEEP(*(__modver))					\
 		__stop___modver = .;					\
-		. = ALIGN((align));					\
-		__end_rodata = .;					\
 	}								\
-	. = ALIGN((align));
+									\
+	BTF								\
+									\
+	. = ALIGN((align));						\
+	__end_rodata = .;
 
 /* RODATA & RO_DATA provided for backward compatibility.
  * All archs are supposed to use RO_DATA() */
@@ -589,6 +591,20 @@
 	}
 
 /*
+ * .BTF
+ */
+#ifdef CONFIG_DEBUG_INFO_BTF
+#define BTF								\
+	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
+		__start_BTF = .;					\
+		*(.BTF)							\
+		__stop_BTF = .;						\
+	}
+#else
+#define BTF
+#endif
+
+/*
  * Init task
  */
 #define INIT_TASK_DATA_SECTION(align)					\
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -9,15 +9,15 @@
 #include <linux/sysfs.h>
 
 /* See scripts/link-vmlinux.sh, gen_btf() func for details */
-extern char __weak _binary__btf_vmlinux_bin_start[];
-extern char __weak _binary__btf_vmlinux_bin_end[];
+extern char __weak __start_BTF[];
+extern char __weak __stop_BTF[];
 
 static ssize_t
 btf_vmlinux_read(struct file *file, struct kobject *kobj,
 		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t len)
 {
-	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
+	memcpy(buf, __start_BTF + off, len);
 	return len;
 }
 
@@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
 
 static int __init btf_vmlinux_init(void)
 {
-	if (!_binary__btf_vmlinux_bin_start)
+	if (!__start_BTF)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
 	if (!btf_kobj)
 		return -ENOMEM;
 
-	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
-				    _binary__btf_vmlinux_bin_start;
+	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
 
 	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
 }
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -113,9 +113,6 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
-	local bin_arch
-	local bin_format
-	local bin_file
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -133,17 +130,16 @@ gen_btf()
 	info "BTF" ${2}
 	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
 
-	# dump .BTF section into raw binary file to link with final vmlinux
-	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
-		cut -d, -f1 | cut -d' ' -f2)
-	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
-		awk '{print $4}')
-	bin_file=.btf.vmlinux.bin
-	${OBJCOPY} --change-section-address .BTF=0 \
-		--set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} $bin_file
-	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
-		--rename-section .data=.BTF $bin_file ${2}
+	# Create ${2} which contains just .BTF section but no symbols. Add
+	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
+	# deletes all symbols including __start_BTF and __stop_BTF, which will
+	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
+	# objcopy warnings: "empty loadable segment detected at ..."
+	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
+		--strip-all ${1} ${2} 2>/dev/null
+	# Change e_type to ET_REL so that it can be used to link final vmlinux.
+	# Unlike GNU ld, lld does not allow an ET_EXEC input.
+	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
 }
 
 # Create ${2} .o file with all symbols from the ${1} object file


