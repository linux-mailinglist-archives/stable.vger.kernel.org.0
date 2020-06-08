Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBD41F1A3A
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgFHNku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgFHNkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 09:40:49 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBF3C08C5C2
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 06:40:49 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id y7so15493206qti.8
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mdIufafxfrrN5p97gfztvM+9hSR3y2gR4LCb968Y1MQ=;
        b=vfFfuKk/I1t3OBBfnlUqXqVDJd7Ev54XpJ2HYXKe35Zz0K6k7tkdmNjZcmYRV+4JJJ
         ZOKiiNC+uB6qm1DxudDToCs74ExaLLm40Hf/oEkRCPs89jexvDvVUBMHNXiXrNg9Jtsc
         W2rrHaCJuuTsixfvNbJzwy1UD57BCvIlht4yeCtSr+SyI2mTX9eR4UoJ5X8bzsq16gJe
         iDb9xWNfCdjANKMaVrr9vfoESWoElX9wyl74gunnO1w1rY70SQRJqaUnTxnvwx/FP9FV
         DBiiOPUI4RaXAG7i4ckgUD2QdKbYz5gfs06m1Gt0d4c/8Ijrj4SZr6Ci4OH8f9FWj20B
         9JYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mdIufafxfrrN5p97gfztvM+9hSR3y2gR4LCb968Y1MQ=;
        b=qqhx8nuyY3m/O92vObQSe/cBCSAWMgpitTdYtq19gliy6PRYUBl7HlWe+OW9LOxeaD
         xndjuoohvFJ3r5kjwKadocwaOC4FCXDUVdAcLhuBea3WiNpYGKzT6LR7eAShThpThHTo
         dKMmiOk4P1LdktXnjCkEUW5Hd4zbKxuMK80zhNVXr5dTKeXm9XZAmwcI83sM7oPuNYzN
         CmpPGLu4fdcdPvDGgq6bCJIozwlFd8SAKC5LxIW/Hi0dIiDBU/b54ZBP7IQH7QXbzWLm
         2QR8jKpjo2kkiTeSSui8B8JhZfey8HE7keCu68bs7yMjD4Fj4gBWQa/7imGC9Vgkc/uA
         qFTg==
X-Gm-Message-State: AOAM530hxtTZBHHOZzeRt+dEDHAsauBYy+ObkCZWpXgXmTHT+w9Jt/m7
        eHNQecD0xI8e8ypCOfTYQFxmuxdzHl8tZMwXBqiCs5EjsUVoqspagtntZd+HRHcjc1oaYKR7e+B
        d6t6MHtBDDh+IQ9eW9o59Lw7FhoWvqZyj0Gd2cEc5MGtyfrZfqFSxBdoJUhjgP0+r0dY=
X-Google-Smtp-Source: ABdhPJwLNU3ymgsYXVRJM1llnASREqqoSd8JvQ67LZEDhepUSaN/pYdvxhlZMkvUV6ogILOfvQWUadDwCwE2ZA==
X-Received: by 2002:ad4:50c8:: with SMTP id e8mr9014540qvq.98.1591623648283;
 Mon, 08 Jun 2020 06:40:48 -0700 (PDT)
Date:   Mon,  8 Jun 2020 13:39:59 +0000
Message-Id: <20200608133959.97810-1-teguiani@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH] bpf: Support llvm-objcopy for vmlinux BTF
From:   Maria Teguiani <teguiani@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Maria Teguiani <teguiani@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

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
(cherry picked from commit 90ceddcb495008ac8ba7a3dce297841efcd7d584)
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Maria Teguiani <teguiani@google.com>
---
 arch/powerpc/kernel/vmlinux.lds.S |  6 ------
 include/asm-generic/vmlinux.lds.h | 22 +++++++++++++++++++---
 kernel/bpf/sysfs_btf.c            | 11 +++++------
 scripts/link-vmlinux.sh           | 24 ++++++++++--------------
 4 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4638d2863388..060a1acd7c6d 100644
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
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index dae64600ccbf..b6d7347ccda7 100644
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
@@ -588,6 +590,20 @@
 		__stop___ex_table = .;					\
 	}
 
+/*
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
 /*
  * Init task
  */
diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 7ae5dddd1fe6..3b495773de5a 100644
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
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index aa1386079f0c..8b6325c2dfc5 100755
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
-- 
2.27.0.278.ge193c7cf3a9-goog

