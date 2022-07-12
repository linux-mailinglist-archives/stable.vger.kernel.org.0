Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972F55722DF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiGLSlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiGLSk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:40:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFFCD31F0;
        Tue, 12 Jul 2022 11:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B1E61AC9;
        Tue, 12 Jul 2022 18:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30BEC341C0;
        Tue, 12 Jul 2022 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651242;
        bh=d/Fe/oadpda4DuQ7wRcCWPnk9oSwr0PlrqLD2dd/tC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo3EAMLwHK7jUzqKnM/nztYTCHAA6z9VqQlPILkd2smO75eYqOAOnY9+zGh3xGz1p
         DVWKAh4Jn70Rxv9CNuQREYyFKuT4uXBO6gVcXIbindR6mS7ixJBriDPdQYJ/xxo4t1
         wkA9v8CHgmE9n+c/5Vv5VAAGi/5NKntpqUMb5J9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 017/130] x86/insn: Add an insn_decode() API
Date:   Tue, 12 Jul 2022 20:37:43 +0200
Message-Id: <20220712183247.196840353@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit 93281c4a96572a34504244969b938e035204778d upstream.

Users of the instruction decoder should use this to decode instruction
bytes. For that, have insn*() helpers return an int value to denote
success/failure. When there's an error fetching the next insn byte and
the insn falls short, return -ENODATA to denote that.

While at it, make insn_get_opcode() more stricter as to whether what has
seen so far is a valid insn and if not.

Copy linux/kconfig.h for the tools-version of the decoder so that it can
use IS_ENABLED().

Also, cast the INSN_MODE_KERN dummy define value to (enum insn_mode)
for tools use of the decoder because perf tool builds with -Werror and
errors out with -Werror=sign-compare otherwise.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lkml.kernel.org/r/20210304174237.31945-5-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn.h       |   24 ++--
 arch/x86/lib/insn.c               |  216 +++++++++++++++++++++++++++++-------
 tools/arch/x86/include/asm/insn.h |   24 ++--
 tools/arch/x86/lib/insn.c         |  222 +++++++++++++++++++++++++++++---------
 tools/include/linux/kconfig.h     |   73 ++++++++++++
 5 files changed, 452 insertions(+), 107 deletions(-)
 create mode 100644 tools/include/linux/kconfig.h

--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -87,13 +87,23 @@ struct insn {
 #define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
 
 extern void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64);
-extern void insn_get_prefixes(struct insn *insn);
-extern void insn_get_opcode(struct insn *insn);
-extern void insn_get_modrm(struct insn *insn);
-extern void insn_get_sib(struct insn *insn);
-extern void insn_get_displacement(struct insn *insn);
-extern void insn_get_immediate(struct insn *insn);
-extern void insn_get_length(struct insn *insn);
+extern int insn_get_prefixes(struct insn *insn);
+extern int insn_get_opcode(struct insn *insn);
+extern int insn_get_modrm(struct insn *insn);
+extern int insn_get_sib(struct insn *insn);
+extern int insn_get_displacement(struct insn *insn);
+extern int insn_get_immediate(struct insn *insn);
+extern int insn_get_length(struct insn *insn);
+
+enum insn_mode {
+	INSN_MODE_32,
+	INSN_MODE_64,
+	/* Mode is determined by the current kernel build. */
+	INSN_MODE_KERN,
+	INSN_NUM_MODES,
+};
+
+extern int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m);
 
 /* Attribute will be determined after getting ModRM (for opcode groups) */
 static inline void insn_get_attribute(struct insn *insn)
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -13,6 +13,9 @@
 #include <asm/inat.h> /*__ignore_sync_check__ */
 #include <asm/insn.h> /* __ignore_sync_check__ */
 
+#include <linux/errno.h>
+#include <linux/kconfig.h>
+
 #include <asm/emulate_prefix.h> /* __ignore_sync_check__ */
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
@@ -97,8 +100,12 @@ static void insn_get_emulate_prefix(stru
  * Populates the @insn->prefixes bitmap, and updates @insn->next_byte
  * to point to the (first) opcode.  No effect if @insn->prefixes.got
  * is already set.
+ *
+ * * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_prefixes(struct insn *insn)
+int insn_get_prefixes(struct insn *insn)
 {
 	struct insn_field *prefixes = &insn->prefixes;
 	insn_attr_t attr;
@@ -106,7 +113,7 @@ void insn_get_prefixes(struct insn *insn
 	int i, nb;
 
 	if (prefixes->got)
-		return;
+		return 0;
 
 	insn_get_emulate_prefix(insn);
 
@@ -217,8 +224,10 @@ vex_end:
 
 	prefixes->got = 1;
 
+	return 0;
+
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -230,16 +239,25 @@ err_out:
  * If necessary, first collects any preceding (prefix) bytes.
  * Sets @insn->opcode.value = opcode1.  No effect if @insn->opcode.got
  * is already 1.
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_opcode(struct insn *insn)
+int insn_get_opcode(struct insn *insn)
 {
 	struct insn_field *opcode = &insn->opcode;
+	int pfx_id, ret;
 	insn_byte_t op;
-	int pfx_id;
+
 	if (opcode->got)
-		return;
-	if (!insn->prefixes.got)
-		insn_get_prefixes(insn);
+		return 0;
+
+	if (!insn->prefixes.got) {
+		ret = insn_get_prefixes(insn);
+		if (ret)
+			return ret;
+	}
 
 	/* Get first opcode */
 	op = get_next(insn_byte_t, insn);
@@ -254,9 +272,13 @@ void insn_get_opcode(struct insn *insn)
 		insn->attr = inat_get_avx_attribute(op, m, p);
 		if ((inat_must_evex(insn->attr) && !insn_is_evex(insn)) ||
 		    (!inat_accept_vex(insn->attr) &&
-		     !inat_is_group(insn->attr)))
-			insn->attr = 0;	/* This instruction is bad */
-		goto end;	/* VEX has only 1 byte for opcode */
+		     !inat_is_group(insn->attr))) {
+			/* This instruction is bad */
+			insn->attr = 0;
+			return -EINVAL;
+		}
+		/* VEX has only 1 byte for opcode */
+		goto end;
 	}
 
 	insn->attr = inat_get_opcode_attribute(op);
@@ -267,13 +289,18 @@ void insn_get_opcode(struct insn *insn)
 		pfx_id = insn_last_prefix_id(insn);
 		insn->attr = inat_get_escape_attribute(op, pfx_id, insn->attr);
 	}
-	if (inat_must_vex(insn->attr))
-		insn->attr = 0;	/* This instruction is bad */
+
+	if (inat_must_vex(insn->attr)) {
+		/* This instruction is bad */
+		insn->attr = 0;
+		return -EINVAL;
+	}
 end:
 	opcode->got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -283,15 +310,25 @@ err_out:
  * Populates @insn->modrm and updates @insn->next_byte to point past the
  * ModRM byte, if any.  If necessary, first collects the preceding bytes
  * (prefixes and opcode(s)).  No effect if @insn->modrm.got is already 1.
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_modrm(struct insn *insn)
+int insn_get_modrm(struct insn *insn)
 {
 	struct insn_field *modrm = &insn->modrm;
 	insn_byte_t pfx_id, mod;
+	int ret;
+
 	if (modrm->got)
-		return;
-	if (!insn->opcode.got)
-		insn_get_opcode(insn);
+		return 0;
+
+	if (!insn->opcode.got) {
+		ret = insn_get_opcode(insn);
+		if (ret)
+			return ret;
+	}
 
 	if (inat_has_modrm(insn->attr)) {
 		mod = get_next(insn_byte_t, insn);
@@ -301,17 +338,22 @@ void insn_get_modrm(struct insn *insn)
 			pfx_id = insn_last_prefix_id(insn);
 			insn->attr = inat_get_group_attribute(mod, pfx_id,
 							      insn->attr);
-			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr))
-				insn->attr = 0;	/* This is bad */
+			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr)) {
+				/* Bad insn */
+				insn->attr = 0;
+				return -EINVAL;
+			}
 		}
 	}
 
 	if (insn->x86_64 && inat_is_force64(insn->attr))
 		insn->opnd_bytes = 8;
+
 	modrm->got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 
@@ -325,11 +367,16 @@ err_out:
 int insn_rip_relative(struct insn *insn)
 {
 	struct insn_field *modrm = &insn->modrm;
+	int ret;
 
 	if (!insn->x86_64)
 		return 0;
-	if (!modrm->got)
-		insn_get_modrm(insn);
+
+	if (!modrm->got) {
+		ret = insn_get_modrm(insn);
+		if (ret)
+			return 0;
+	}
 	/*
 	 * For rip-relative instructions, the mod field (top 2 bits)
 	 * is zero and the r/m field (bottom 3 bits) is 0x5.
@@ -343,15 +390,25 @@ int insn_rip_relative(struct insn *insn)
  *
  * If necessary, first collects the instruction up to and including the
  * ModRM byte.
+ *
+ * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
  */
-void insn_get_sib(struct insn *insn)
+int insn_get_sib(struct insn *insn)
 {
 	insn_byte_t modrm;
+	int ret;
 
 	if (insn->sib.got)
-		return;
-	if (!insn->modrm.got)
-		insn_get_modrm(insn);
+		return 0;
+
+	if (!insn->modrm.got) {
+		ret = insn_get_modrm(insn);
+		if (ret)
+			return ret;
+	}
+
 	if (insn->modrm.nbytes) {
 		modrm = (insn_byte_t)insn->modrm.value;
 		if (insn->addr_bytes != 2 &&
@@ -362,8 +419,10 @@ void insn_get_sib(struct insn *insn)
 	}
 	insn->sib.got = 1;
 
+	return 0;
+
 err_out:
-	return;
+	return -ENODATA;
 }
 
 
@@ -374,15 +433,25 @@ err_out:
  * If necessary, first collects the instruction up to and including the
  * SIB byte.
  * Displacement value is sign-expanded.
+ *
+ * * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
  */
-void insn_get_displacement(struct insn *insn)
+int insn_get_displacement(struct insn *insn)
 {
 	insn_byte_t mod, rm, base;
+	int ret;
 
 	if (insn->displacement.got)
-		return;
-	if (!insn->sib.got)
-		insn_get_sib(insn);
+		return 0;
+
+	if (!insn->sib.got) {
+		ret = insn_get_sib(insn);
+		if (ret)
+			return ret;
+	}
+
 	if (insn->modrm.nbytes) {
 		/*
 		 * Interpreting the modrm byte:
@@ -425,9 +494,10 @@ void insn_get_displacement(struct insn *
 	}
 out:
 	insn->displacement.got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /* Decode moffset16/32/64. Return 0 if failed */
@@ -538,20 +608,30 @@ err_out:
 }
 
 /**
- * insn_get_immediate() - Get the immediates of instruction
+ * insn_get_immediate() - Get the immediate in an instruction
  * @insn:	&struct insn containing instruction
  *
  * If necessary, first collects the instruction up to and including the
  * displacement bytes.
  * Basically, most of immediates are sign-expanded. Unsigned-value can be
- * get by bit masking with ((1 << (nbytes * 8)) - 1)
+ * computed by bit masking with ((1 << (nbytes * 8)) - 1)
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_immediate(struct insn *insn)
+int insn_get_immediate(struct insn *insn)
 {
+	int ret;
+
 	if (insn->immediate.got)
-		return;
-	if (!insn->displacement.got)
-		insn_get_displacement(insn);
+		return 0;
+
+	if (!insn->displacement.got) {
+		ret = insn_get_displacement(insn);
+		if (ret)
+			return ret;
+	}
 
 	if (inat_has_moffset(insn->attr)) {
 		if (!__get_moffset(insn))
@@ -604,9 +684,10 @@ void insn_get_immediate(struct insn *ins
 	}
 done:
 	insn->immediate.got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -615,13 +696,58 @@ err_out:
  *
  * If necessary, first collects the instruction up to and including the
  * immediates bytes.
- */
-void insn_get_length(struct insn *insn)
+ *
+ * Returns:
+ *  - 0 on success
+ *  - < 0 on error
+*/
+int insn_get_length(struct insn *insn)
 {
+	int ret;
+
 	if (insn->length)
-		return;
-	if (!insn->immediate.got)
-		insn_get_immediate(insn);
+		return 0;
+
+	if (!insn->immediate.got) {
+		ret = insn_get_immediate(insn);
+		if (ret)
+			return ret;
+	}
+
 	insn->length = (unsigned char)((unsigned long)insn->next_byte
 				     - (unsigned long)insn->kaddr);
+
+	return 0;
+}
+
+/**
+ * insn_decode() - Decode an x86 instruction
+ * @insn:	&struct insn to be initialized
+ * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
+ * @buf_len:	length of the insn buffer at @kaddr
+ * @m:		insn mode, see enum insn_mode
+ *
+ * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
+ */
+int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m)
+{
+	int ret;
+
+/* #define INSN_MODE_KERN	-1 __ignore_sync_check__ mode is only valid in the kernel */
+
+	if (m == INSN_MODE_KERN)
+		insn_init(insn, kaddr, buf_len, IS_ENABLED(CONFIG_X86_64));
+	else
+		insn_init(insn, kaddr, buf_len, m == INSN_MODE_64);
+
+	ret = insn_get_length(insn);
+	if (ret)
+		return ret;
+
+	if (insn_complete(insn))
+		return 0;
+
+	return -EINVAL;
 }
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -87,13 +87,23 @@ struct insn {
 #define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
 
 extern void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64);
-extern void insn_get_prefixes(struct insn *insn);
-extern void insn_get_opcode(struct insn *insn);
-extern void insn_get_modrm(struct insn *insn);
-extern void insn_get_sib(struct insn *insn);
-extern void insn_get_displacement(struct insn *insn);
-extern void insn_get_immediate(struct insn *insn);
-extern void insn_get_length(struct insn *insn);
+extern int insn_get_prefixes(struct insn *insn);
+extern int insn_get_opcode(struct insn *insn);
+extern int insn_get_modrm(struct insn *insn);
+extern int insn_get_sib(struct insn *insn);
+extern int insn_get_displacement(struct insn *insn);
+extern int insn_get_immediate(struct insn *insn);
+extern int insn_get_length(struct insn *insn);
+
+enum insn_mode {
+	INSN_MODE_32,
+	INSN_MODE_64,
+	/* Mode is determined by the current kernel build. */
+	INSN_MODE_KERN,
+	INSN_NUM_MODES,
+};
+
+extern int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m);
 
 /* Attribute will be determined after getting ModRM (for opcode groups) */
 static inline void insn_get_attribute(struct insn *insn)
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -10,10 +10,13 @@
 #else
 #include <string.h>
 #endif
-#include "../include/asm/inat.h" /* __ignore_sync_check__ */
-#include "../include/asm/insn.h" /* __ignore_sync_check__ */
+#include <asm/inat.h> /* __ignore_sync_check__ */
+#include <asm/insn.h> /* __ignore_sync_check__ */
 
-#include "../include/asm/emulate_prefix.h" /* __ignore_sync_check__ */
+#include <linux/errno.h>
+#include <linux/kconfig.h>
+
+#include <asm/emulate_prefix.h> /* __ignore_sync_check__ */
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
@@ -97,8 +100,12 @@ static void insn_get_emulate_prefix(stru
  * Populates the @insn->prefixes bitmap, and updates @insn->next_byte
  * to point to the (first) opcode.  No effect if @insn->prefixes.got
  * is already set.
+ *
+ * * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_prefixes(struct insn *insn)
+int insn_get_prefixes(struct insn *insn)
 {
 	struct insn_field *prefixes = &insn->prefixes;
 	insn_attr_t attr;
@@ -106,7 +113,7 @@ void insn_get_prefixes(struct insn *insn
 	int i, nb;
 
 	if (prefixes->got)
-		return;
+		return 0;
 
 	insn_get_emulate_prefix(insn);
 
@@ -217,8 +224,10 @@ vex_end:
 
 	prefixes->got = 1;
 
+	return 0;
+
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -230,16 +239,25 @@ err_out:
  * If necessary, first collects any preceding (prefix) bytes.
  * Sets @insn->opcode.value = opcode1.  No effect if @insn->opcode.got
  * is already 1.
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_opcode(struct insn *insn)
+int insn_get_opcode(struct insn *insn)
 {
 	struct insn_field *opcode = &insn->opcode;
+	int pfx_id, ret;
 	insn_byte_t op;
-	int pfx_id;
+
 	if (opcode->got)
-		return;
-	if (!insn->prefixes.got)
-		insn_get_prefixes(insn);
+		return 0;
+
+	if (!insn->prefixes.got) {
+		ret = insn_get_prefixes(insn);
+		if (ret)
+			return ret;
+	}
 
 	/* Get first opcode */
 	op = get_next(insn_byte_t, insn);
@@ -254,9 +272,13 @@ void insn_get_opcode(struct insn *insn)
 		insn->attr = inat_get_avx_attribute(op, m, p);
 		if ((inat_must_evex(insn->attr) && !insn_is_evex(insn)) ||
 		    (!inat_accept_vex(insn->attr) &&
-		     !inat_is_group(insn->attr)))
-			insn->attr = 0;	/* This instruction is bad */
-		goto end;	/* VEX has only 1 byte for opcode */
+		     !inat_is_group(insn->attr))) {
+			/* This instruction is bad */
+			insn->attr = 0;
+			return -EINVAL;
+		}
+		/* VEX has only 1 byte for opcode */
+		goto end;
 	}
 
 	insn->attr = inat_get_opcode_attribute(op);
@@ -267,13 +289,18 @@ void insn_get_opcode(struct insn *insn)
 		pfx_id = insn_last_prefix_id(insn);
 		insn->attr = inat_get_escape_attribute(op, pfx_id, insn->attr);
 	}
-	if (inat_must_vex(insn->attr))
-		insn->attr = 0;	/* This instruction is bad */
+
+	if (inat_must_vex(insn->attr)) {
+		/* This instruction is bad */
+		insn->attr = 0;
+		return -EINVAL;
+	}
 end:
 	opcode->got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -283,15 +310,25 @@ err_out:
  * Populates @insn->modrm and updates @insn->next_byte to point past the
  * ModRM byte, if any.  If necessary, first collects the preceding bytes
  * (prefixes and opcode(s)).  No effect if @insn->modrm.got is already 1.
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_modrm(struct insn *insn)
+int insn_get_modrm(struct insn *insn)
 {
 	struct insn_field *modrm = &insn->modrm;
 	insn_byte_t pfx_id, mod;
+	int ret;
+
 	if (modrm->got)
-		return;
-	if (!insn->opcode.got)
-		insn_get_opcode(insn);
+		return 0;
+
+	if (!insn->opcode.got) {
+		ret = insn_get_opcode(insn);
+		if (ret)
+			return ret;
+	}
 
 	if (inat_has_modrm(insn->attr)) {
 		mod = get_next(insn_byte_t, insn);
@@ -301,17 +338,22 @@ void insn_get_modrm(struct insn *insn)
 			pfx_id = insn_last_prefix_id(insn);
 			insn->attr = inat_get_group_attribute(mod, pfx_id,
 							      insn->attr);
-			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr))
-				insn->attr = 0;	/* This is bad */
+			if (insn_is_avx(insn) && !inat_accept_vex(insn->attr)) {
+				/* Bad insn */
+				insn->attr = 0;
+				return -EINVAL;
+			}
 		}
 	}
 
 	if (insn->x86_64 && inat_is_force64(insn->attr))
 		insn->opnd_bytes = 8;
+
 	modrm->got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 
@@ -325,11 +367,16 @@ err_out:
 int insn_rip_relative(struct insn *insn)
 {
 	struct insn_field *modrm = &insn->modrm;
+	int ret;
 
 	if (!insn->x86_64)
 		return 0;
-	if (!modrm->got)
-		insn_get_modrm(insn);
+
+	if (!modrm->got) {
+		ret = insn_get_modrm(insn);
+		if (ret)
+			return 0;
+	}
 	/*
 	 * For rip-relative instructions, the mod field (top 2 bits)
 	 * is zero and the r/m field (bottom 3 bits) is 0x5.
@@ -343,15 +390,25 @@ int insn_rip_relative(struct insn *insn)
  *
  * If necessary, first collects the instruction up to and including the
  * ModRM byte.
+ *
+ * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
  */
-void insn_get_sib(struct insn *insn)
+int insn_get_sib(struct insn *insn)
 {
 	insn_byte_t modrm;
+	int ret;
 
 	if (insn->sib.got)
-		return;
-	if (!insn->modrm.got)
-		insn_get_modrm(insn);
+		return 0;
+
+	if (!insn->modrm.got) {
+		ret = insn_get_modrm(insn);
+		if (ret)
+			return ret;
+	}
+
 	if (insn->modrm.nbytes) {
 		modrm = (insn_byte_t)insn->modrm.value;
 		if (insn->addr_bytes != 2 &&
@@ -362,8 +419,10 @@ void insn_get_sib(struct insn *insn)
 	}
 	insn->sib.got = 1;
 
+	return 0;
+
 err_out:
-	return;
+	return -ENODATA;
 }
 
 
@@ -374,15 +433,25 @@ err_out:
  * If necessary, first collects the instruction up to and including the
  * SIB byte.
  * Displacement value is sign-expanded.
+ *
+ * * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
  */
-void insn_get_displacement(struct insn *insn)
+int insn_get_displacement(struct insn *insn)
 {
 	insn_byte_t mod, rm, base;
+	int ret;
 
 	if (insn->displacement.got)
-		return;
-	if (!insn->sib.got)
-		insn_get_sib(insn);
+		return 0;
+
+	if (!insn->sib.got) {
+		ret = insn_get_sib(insn);
+		if (ret)
+			return ret;
+	}
+
 	if (insn->modrm.nbytes) {
 		/*
 		 * Interpreting the modrm byte:
@@ -425,9 +494,10 @@ void insn_get_displacement(struct insn *
 	}
 out:
 	insn->displacement.got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /* Decode moffset16/32/64. Return 0 if failed */
@@ -538,20 +608,30 @@ err_out:
 }
 
 /**
- * insn_get_immediate() - Get the immediates of instruction
+ * insn_get_immediate() - Get the immediate in an instruction
  * @insn:	&struct insn containing instruction
  *
  * If necessary, first collects the instruction up to and including the
  * displacement bytes.
  * Basically, most of immediates are sign-expanded. Unsigned-value can be
- * get by bit masking with ((1 << (nbytes * 8)) - 1)
+ * computed by bit masking with ((1 << (nbytes * 8)) - 1)
+ *
+ * Returns:
+ * 0:  on success
+ * < 0: on error
  */
-void insn_get_immediate(struct insn *insn)
+int insn_get_immediate(struct insn *insn)
 {
+	int ret;
+
 	if (insn->immediate.got)
-		return;
-	if (!insn->displacement.got)
-		insn_get_displacement(insn);
+		return 0;
+
+	if (!insn->displacement.got) {
+		ret = insn_get_displacement(insn);
+		if (ret)
+			return ret;
+	}
 
 	if (inat_has_moffset(insn->attr)) {
 		if (!__get_moffset(insn))
@@ -604,9 +684,10 @@ void insn_get_immediate(struct insn *ins
 	}
 done:
 	insn->immediate.got = 1;
+	return 0;
 
 err_out:
-	return;
+	return -ENODATA;
 }
 
 /**
@@ -615,13 +696,58 @@ err_out:
  *
  * If necessary, first collects the instruction up to and including the
  * immediates bytes.
- */
-void insn_get_length(struct insn *insn)
+ *
+ * Returns:
+ *  - 0 on success
+ *  - < 0 on error
+*/
+int insn_get_length(struct insn *insn)
 {
+	int ret;
+
 	if (insn->length)
-		return;
-	if (!insn->immediate.got)
-		insn_get_immediate(insn);
+		return 0;
+
+	if (!insn->immediate.got) {
+		ret = insn_get_immediate(insn);
+		if (ret)
+			return ret;
+	}
+
 	insn->length = (unsigned char)((unsigned long)insn->next_byte
 				     - (unsigned long)insn->kaddr);
+
+	return 0;
+}
+
+/**
+ * insn_decode() - Decode an x86 instruction
+ * @insn:	&struct insn to be initialized
+ * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
+ * @buf_len:	length of the insn buffer at @kaddr
+ * @m:		insn mode, see enum insn_mode
+ *
+ * Returns:
+ * 0: if decoding succeeded
+ * < 0: otherwise.
+ */
+int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m)
+{
+	int ret;
+
+#define INSN_MODE_KERN (enum insn_mode)-1 /* __ignore_sync_check__ mode is only valid in the kernel */
+
+	if (m == INSN_MODE_KERN)
+		insn_init(insn, kaddr, buf_len, IS_ENABLED(CONFIG_X86_64));
+	else
+		insn_init(insn, kaddr, buf_len, m == INSN_MODE_64);
+
+	ret = insn_get_length(insn);
+	if (ret)
+		return ret;
+
+	if (insn_complete(insn))
+		return 0;
+
+	return -EINVAL;
 }
--- /dev/null
+++ b/tools/include/linux/kconfig.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_KCONFIG_H
+#define _TOOLS_LINUX_KCONFIG_H
+
+/* CONFIG_CC_VERSION_TEXT (Do not delete this comment. See help in Kconfig) */
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define __BIG_ENDIAN 4321
+#else
+#define __LITTLE_ENDIAN 1234
+#endif
+
+#define __ARG_PLACEHOLDER_1 0,
+#define __take_second_arg(__ignored, val, ...) val
+
+/*
+ * The use of "&&" / "||" is limited in certain expressions.
+ * The following enable to calculate "and" / "or" with macro expansion only.
+ */
+#define __and(x, y)			___and(x, y)
+#define ___and(x, y)			____and(__ARG_PLACEHOLDER_##x, y)
+#define ____and(arg1_or_junk, y)	__take_second_arg(arg1_or_junk y, 0)
+
+#define __or(x, y)			___or(x, y)
+#define ___or(x, y)			____or(__ARG_PLACEHOLDER_##x, y)
+#define ____or(arg1_or_junk, y)		__take_second_arg(arg1_or_junk 1, y)
+
+/*
+ * Helper macros to use CONFIG_ options in C/CPP expressions. Note that
+ * these only work with boolean and tristate options.
+ */
+
+/*
+ * Getting something that works in C and CPP for an arg that may or may
+ * not be defined is tricky.  Here, if we have "#define CONFIG_BOOGER 1"
+ * we match on the placeholder define, insert the "0," for arg1 and generate
+ * the triplet (0, 1, 0).  Then the last step cherry picks the 2nd arg (a one).
+ * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
+ * the last step cherry picks the 2nd arg, we get a zero.
+ */
+#define __is_defined(x)			___is_defined(x)
+#define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
+#define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
+
+/*
+ * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
+ * otherwise. For boolean options, this is equivalent to
+ * IS_ENABLED(CONFIG_FOO).
+ */
+#define IS_BUILTIN(option) __is_defined(option)
+
+/*
+ * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
+ * otherwise.
+ */
+#define IS_MODULE(option) __is_defined(option##_MODULE)
+
+/*
+ * IS_REACHABLE(CONFIG_FOO) evaluates to 1 if the currently compiled
+ * code can call a function defined in code compiled based on CONFIG_FOO.
+ * This is similar to IS_ENABLED(), but returns false when invoked from
+ * built-in code when CONFIG_FOO is set to 'm'.
+ */
+#define IS_REACHABLE(option) __or(IS_BUILTIN(option), \
+				__and(IS_MODULE(option), __is_defined(MODULE)))
+
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * 0 otherwise.
+ */
+#define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))
+
+#endif /* _TOOLS_LINUX_KCONFIG_H */


