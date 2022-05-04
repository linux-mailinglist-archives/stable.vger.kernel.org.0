Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91351AA0B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356087AbiEDRU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358092AbiEDRPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171A5641D;
        Wed,  4 May 2022 09:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B8761896;
        Wed,  4 May 2022 16:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81476C385B6;
        Wed,  4 May 2022 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683562;
        bh=yKnOWtATY4DC16zZlNMNi4Gw/btx9FKJS1E7Qi4z6wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhUHrOdtDLvxorn4qc1MVFhI/CxqWL4m8JZxrnxvaPEgGN4hwCsYBT4ViZvb7lbWY
         bxIP7fZU1LyzUxk4K03xS2kCFOhQKmi40RLEPgIrydR5NfblUEfcFb0egPtQdwJNHL
         tKc/GPD1s/sQtG4JUIqEbY1ObR7VDoCy6jEfnmMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.17 225/225] powerpc/64: Add UADDR64 relocation support
Date:   Wed,  4 May 2022 18:47:43 +0200
Message-Id: <20220504153129.910469913@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit d799769188529abc6cbf035a10087a51f7832b6b upstream.

When ld detects unaligned relocations, it emits R_PPC64_UADDR64
relocations instead of R_PPC64_RELATIVE. Currently R_PPC64_UADDR64 are
detected by arch/powerpc/tools/relocs_check.sh and expected not to work.
Below is a simple chunk to trigger this behaviour (this disables
optimization for the demonstration purposes only, this also happens with
-O1/-O2 when CONFIG_PRINTK_INDEX=y, for example):

  \#pragma GCC push_options
  \#pragma GCC optimize ("O0")
  struct entry {
          const char *file;
          int line;
  } __attribute__((packed));
  static const struct entry e1 = { .file = __FILE__, .line = __LINE__ };
  static const struct entry e2 = { .file = __FILE__, .line = __LINE__ };
  ...
  prom_printf("e1=%s %lx %lx\n", e1.file, (unsigned long) e1.file, mfmsr());
  prom_printf("e2=%s %lx\n", e2.file, (unsigned long) e2.file);
  \#pragma GCC pop_options

This adds support for UADDR64 for 64bit. This reuses __dynamic_symtab
from the 32bit code which supports more relocation types already.

Because RELACOUNT includes only R_PPC64_RELATIVE, this replaces it with
RELASZ which is the size of all relocation records.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220309061822.168173-1-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/reloc_64.S     |   67 +++++++++++++++++++++++++------------
 arch/powerpc/kernel/vmlinux.lds.S  |    2 -
 arch/powerpc/tools/relocs_check.sh |    7 ---
 3 files changed, 48 insertions(+), 28 deletions(-)

--- a/arch/powerpc/kernel/reloc_64.S
+++ b/arch/powerpc/kernel/reloc_64.S
@@ -8,8 +8,10 @@
 #include <asm/ppc_asm.h>
 
 RELA = 7
-RELACOUNT = 0x6ffffff9
+RELASZ = 8
+RELAENT = 9
 R_PPC64_RELATIVE = 22
+R_PPC64_UADDR64 = 43
 
 /*
  * r3 = desired final address of kernel
@@ -25,29 +27,38 @@ _GLOBAL(relocate)
 	add	r9,r9,r12	/* r9 has runtime addr of .rela.dyn section */
 	ld	r10,(p_st - 0b)(r12)
 	add	r10,r10,r12	/* r10 has runtime addr of _stext */
+	ld	r13,(p_sym - 0b)(r12)
+	add	r13,r13,r12	/* r13 has runtime addr of .dynsym */
 
 	/*
-	 * Scan the dynamic section for the RELA and RELACOUNT entries.
+	 * Scan the dynamic section for the RELA, RELASZ and RELAENT entries.
 	 */
 	li	r7,0
 	li	r8,0
-1:	ld	r6,0(r11)	/* get tag */
+.Ltags:
+	ld	r6,0(r11)	/* get tag */
 	cmpdi	r6,0
-	beq	4f		/* end of list */
+	beq	.Lend_of_list		/* end of list */
 	cmpdi	r6,RELA
 	bne	2f
 	ld	r7,8(r11)	/* get RELA pointer in r7 */
-	b	3f
-2:	addis	r6,r6,(-RELACOUNT)@ha
-	cmpdi	r6,RELACOUNT@l
+	b	4f
+2:	cmpdi	r6,RELASZ
 	bne	3f
-	ld	r8,8(r11)	/* get RELACOUNT value in r8 */
-3:	addi	r11,r11,16
-	b	1b
-4:	cmpdi	r7,0		/* check we have both RELA and RELACOUNT */
+	ld	r8,8(r11)	/* get RELASZ value in r8 */
+	b	4f
+3:	cmpdi	r6,RELAENT
+	bne	4f
+	ld	r12,8(r11)	/* get RELAENT value in r12 */
+4:	addi	r11,r11,16
+	b	.Ltags
+.Lend_of_list:
+	cmpdi	r7,0		/* check we have RELA, RELASZ, RELAENT */
 	cmpdi	cr1,r8,0
-	beq	6f
-	beq	cr1,6f
+	beq	.Lout
+	beq	cr1,.Lout
+	cmpdi	r12,0
+	beq	.Lout
 
 	/*
 	 * Work out linktime address of _stext and hence the
@@ -62,23 +73,39 @@ _GLOBAL(relocate)
 
 	/*
 	 * Run through the list of relocations and process the
-	 * R_PPC64_RELATIVE ones.
+	 * R_PPC64_RELATIVE and R_PPC64_UADDR64 ones.
 	 */
+	divd	r8,r8,r12	/* RELASZ / RELAENT */
 	mtctr	r8
-5:	ld	r0,8(9)		/* ELF64_R_TYPE(reloc->r_info) */
+.Lrels:	ld	r0,8(r9)		/* ELF64_R_TYPE(reloc->r_info) */
 	cmpdi	r0,R_PPC64_RELATIVE
-	bne	6f
+	bne	.Luaddr64
 	ld	r6,0(r9)	/* reloc->r_offset */
 	ld	r0,16(r9)	/* reloc->r_addend */
+	b	.Lstore
+.Luaddr64:
+	srdi	r14,r0,32	/* ELF64_R_SYM(reloc->r_info) */
+	clrldi	r0,r0,32
+	cmpdi	r0,R_PPC64_UADDR64
+	bne	.Lnext
+	ld	r6,0(r9)
+	ld	r0,16(r9)
+	mulli	r14,r14,24	/* 24 == sizeof(elf64_sym) */
+	add	r14,r14,r13	/* elf64_sym[ELF64_R_SYM] */
+	ld	r14,8(r14)
+	add	r0,r0,r14
+.Lstore:
 	add	r0,r0,r3
 	stdx	r0,r7,r6
-	addi	r9,r9,24
-	bdnz	5b
-
-6:	blr
+.Lnext:
+	add	r9,r9,r12
+	bdnz	.Lrels
+.Lout:
+	blr
 
 .balign 8
 p_dyn:	.8byte	__dynamic_start - 0b
 p_rela:	.8byte	__rela_dyn_start - 0b
+p_sym:		.8byte __dynamic_symtab - 0b
 p_st:	.8byte	_stext - 0b
 
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -281,9 +281,7 @@ SECTIONS
 	. = ALIGN(8);
 	.dynsym : AT(ADDR(.dynsym) - LOAD_OFFSET)
 	{
-#ifdef CONFIG_PPC32
 		__dynamic_symtab = .;
-#endif
 		*(.dynsym)
 	}
 	.dynstr : AT(ADDR(.dynstr) - LOAD_OFFSET) { *(.dynstr) }
--- a/arch/powerpc/tools/relocs_check.sh
+++ b/arch/powerpc/tools/relocs_check.sh
@@ -39,6 +39,7 @@ $objdump -R "$vmlinux" |
 	#	R_PPC_NONE
 	grep -F -w -v 'R_PPC64_RELATIVE
 R_PPC64_NONE
+R_PPC64_UADDR64
 R_PPC_ADDR16_LO
 R_PPC_ADDR16_HI
 R_PPC_ADDR16_HA
@@ -54,9 +55,3 @@ fi
 num_bad=$(echo "$bad_relocs" | wc -l)
 echo "WARNING: $num_bad bad relocations"
 echo "$bad_relocs"
-
-# If we see this type of relocation it's an idication that
-# we /may/ be using an old version of binutils.
-if echo "$bad_relocs" | grep -q -F -w R_PPC64_UADDR64; then
-	echo "WARNING: You need at least binutils >= 2.19 to build a CONFIG_RELOCATABLE kernel"
-fi


