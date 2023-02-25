Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7B66A291D
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBYKqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 05:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBYKqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 05:46:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B832DE70;
        Sat, 25 Feb 2023 02:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5718360AC7;
        Sat, 25 Feb 2023 10:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C06AC433EF;
        Sat, 25 Feb 2023 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677321995;
        bh=P2ILA+6P9Gv1Pdum2YyYiMLBEE2VGYCuSWxSei5+f+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkLBSL44vGH2ae6vu738RmQQWiRXklImlLDA6YG4Xlewxn+prl2FmVn+Yff1cQJoZ
         WGnaE25TiQA/RcUXaHX6uPUXMfHAthVJq8sEy3Lmax7UwPFi2CEmWOguRIxV5b61VT
         spaJC61O2zm7i+oJVlzM5Bo5wxk6FN8fgGHjDAQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.2.1
Date:   Sat, 25 Feb 2023 11:46:25 +0100
Message-Id: <16773219846962@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <16773219832135@kroah.com>
References: <16773219832135@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 135d93368d36..f77188f30210 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3515,7 +3515,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git
diff --git a/Makefile b/Makefile
index 3f6628780eb2..f26824f367a9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 2
-SUBLEVEL = 0
+SUBLEVEL = 1
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index f4b87f08f5c5..29832c338cdc 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -184,6 +184,37 @@ void int3_emulate_ret(struct pt_regs *regs)
 	unsigned long ip = int3_emulate_pop(regs);
 	int3_emulate_jmp(regs, ip);
 }
+
+static __always_inline
+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+{
+	static const unsigned long jcc_mask[6] = {
+		[0] = X86_EFLAGS_OF,
+		[1] = X86_EFLAGS_CF,
+		[2] = X86_EFLAGS_ZF,
+		[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
+		[4] = X86_EFLAGS_SF,
+		[5] = X86_EFLAGS_PF,
+	};
+
+	bool invert = cc & 1;
+	bool match;
+
+	if (cc < 0xc) {
+		match = regs->flags & jcc_mask[cc >> 1];
+	} else {
+		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
+			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
+		if (cc >= 0xe)
+			match = match || (regs->flags & X86_EFLAGS_ZF);
+	}
+
+	if ((match && !invert) || (!match && invert))
+		ip += disp;
+
+	int3_emulate_jmp(regs, ip);
+}
+
 #endif /* !CONFIG_UML_X86 */
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7d8c3cbde368..81381a0194f3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -340,6 +340,12 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 	}
 }
 
+static inline bool is_jcc32(struct insn *insn)
+{
+	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
+	return insn->opcode.bytes[0] == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80;
+}
+
 #if defined(CONFIG_RETPOLINE) && defined(CONFIG_OBJTOOL)
 
 /*
@@ -378,12 +384,6 @@ static int emit_indirect(int op, int reg, u8 *bytes)
 	return i;
 }
 
-static inline bool is_jcc32(struct insn *insn)
-{
-	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
-	return insn->opcode.bytes[0] == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80;
-}
-
 static int emit_call_track_retpoline(void *addr, struct insn *insn, int reg, u8 *bytes)
 {
 	u8 op = insn->opcode.bytes[0];
@@ -1772,6 +1772,11 @@ void text_poke_sync(void)
 	on_each_cpu(do_sync_core, NULL, 1);
 }
 
+/*
+ * NOTE: crazy scheme to allow patching Jcc.d32 but not increase the size of
+ * this thing. When len == 6 everything is prefixed with 0x0f and we map
+ * opcode to Jcc.d8, using len to distinguish.
+ */
 struct text_poke_loc {
 	/* addr := _stext + rel_addr */
 	s32 rel_addr;
@@ -1893,6 +1898,10 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 		int3_emulate_jmp(regs, (long)ip + tp->disp);
 		break;
 
+	case 0x70 ... 0x7f: /* Jcc */
+		int3_emulate_jcc(regs, tp->opcode & 0xf, (long)ip, tp->disp);
+		break;
+
 	default:
 		BUG();
 	}
@@ -1966,16 +1975,26 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 	 * Second step: update all but the first byte of the patched range.
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
-		u8 old[POKE_MAX_OPCODE_SIZE] = { tp[i].old, };
+		u8 old[POKE_MAX_OPCODE_SIZE+1] = { tp[i].old, };
+		u8 _new[POKE_MAX_OPCODE_SIZE+1];
+		const u8 *new = tp[i].text;
 		int len = tp[i].len;
 
 		if (len - INT3_INSN_SIZE > 0) {
 			memcpy(old + INT3_INSN_SIZE,
 			       text_poke_addr(&tp[i]) + INT3_INSN_SIZE,
 			       len - INT3_INSN_SIZE);
+
+			if (len == 6) {
+				_new[0] = 0x0f;
+				memcpy(_new + 1, new, 5);
+				new = _new;
+			}
+
 			text_poke(text_poke_addr(&tp[i]) + INT3_INSN_SIZE,
-				  (const char *)tp[i].text + INT3_INSN_SIZE,
+				  new + INT3_INSN_SIZE,
 				  len - INT3_INSN_SIZE);
+
 			do_sync++;
 		}
 
@@ -2003,8 +2022,7 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 		 * The old instruction is recorded so that the event can be
 		 * processed forwards or backwards.
 		 */
-		perf_event_text_poke(text_poke_addr(&tp[i]), old, len,
-				     tp[i].text, len);
+		perf_event_text_poke(text_poke_addr(&tp[i]), old, len, new, len);
 	}
 
 	if (do_sync) {
@@ -2021,10 +2039,15 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 	 * replacing opcode.
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
-		if (tp[i].text[0] == INT3_INSN_OPCODE)
+		u8 byte = tp[i].text[0];
+
+		if (tp[i].len == 6)
+			byte = 0x0f;
+
+		if (byte == INT3_INSN_OPCODE)
 			continue;
 
-		text_poke(text_poke_addr(&tp[i]), tp[i].text, INT3_INSN_SIZE);
+		text_poke(text_poke_addr(&tp[i]), &byte, INT3_INSN_SIZE);
 		do_sync++;
 	}
 
@@ -2042,9 +2065,11 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 			       const void *opcode, size_t len, const void *emulate)
 {
 	struct insn insn;
-	int ret, i;
+	int ret, i = 0;
 
-	memcpy((void *)tp->text, opcode, len);
+	if (len == 6)
+		i = 1;
+	memcpy((void *)tp->text, opcode+i, len-i);
 	if (!emulate)
 		emulate = opcode;
 
@@ -2055,6 +2080,13 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	tp->len = len;
 	tp->opcode = insn.opcode.bytes[0];
 
+	if (is_jcc32(&insn)) {
+		/*
+		 * Map Jcc.d32 onto Jcc.d8 and use len to distinguish.
+		 */
+		tp->opcode = insn.opcode.bytes[1] - 0x10;
+	}
+
 	switch (tp->opcode) {
 	case RET_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
@@ -2071,7 +2103,6 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 		BUG_ON(len != insn.length);
 	}
 
-
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
 	case RET_INSN_OPCODE:
@@ -2080,6 +2111,7 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
+	case 0x70 ... 0x7f: /* Jcc */
 		tp->disp = insn.immediate.value;
 		break;
 
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 695873c0f50b..0ce969ae250f 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -464,50 +464,26 @@ static void kprobe_emulate_call(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(kprobe_emulate_call);
 
-static nokprobe_inline
-void __kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs, bool cond)
+static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
 {
 	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (cond)
-		ip += p->ainsn.rel32;
+	ip += p->ainsn.rel32;
 	int3_emulate_jmp(regs, ip);
 }
-
-static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
-{
-	__kprobe_emulate_jmp(p, regs, true);
-}
 NOKPROBE_SYMBOL(kprobe_emulate_jmp);
 
-static const unsigned long jcc_mask[6] = {
-	[0] = X86_EFLAGS_OF,
-	[1] = X86_EFLAGS_CF,
-	[2] = X86_EFLAGS_ZF,
-	[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
-	[4] = X86_EFLAGS_SF,
-	[5] = X86_EFLAGS_PF,
-};
-
 static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 {
-	bool invert = p->ainsn.jcc.type & 1;
-	bool match;
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (p->ainsn.jcc.type < 0xc) {
-		match = regs->flags & jcc_mask[p->ainsn.jcc.type >> 1];
-	} else {
-		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
-			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
-		if (p->ainsn.jcc.type >= 0xe)
-			match = match || (regs->flags & X86_EFLAGS_ZF);
-	}
-	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
+	int3_emulate_jcc(regs, p->ainsn.jcc.type, ip, p->ainsn.rel32);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_jcc);
 
 static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 {
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 	bool match;
 
 	if (p->ainsn.loop.type != 3) {	/* LOOP* */
@@ -535,7 +511,9 @@ static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 	else if (p->ainsn.loop.type == 1)	/* LOOPE */
 		match = match && (regs->flags & X86_EFLAGS_ZF);
 
-	__kprobe_emulate_jmp(p, regs, match);
+	if (match)
+		ip += p->ainsn.rel32;
+	int3_emulate_jmp(regs, ip);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_loop);
 
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index 2ebc338980bc..b70670a98597 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -9,6 +9,7 @@ enum insn_type {
 	NOP = 1,  /* site cond-call */
 	JMP = 2,  /* tramp / site tail-call */
 	RET = 3,  /* tramp / site cond-tail-call */
+	JCC = 4,
 };
 
 /*
@@ -25,12 +26,40 @@ static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
+static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */
+{
+	u8 ret = 0;
+
+	if (insn[0] == 0x0f) {
+		u8 tmp = insn[1];
+		if ((tmp & 0xf0) == 0x80)
+			ret = tmp;
+	}
+
+	return ret;
+}
+
+extern void __static_call_return(void);
+
+asm (".global __static_call_return\n\t"
+     ".type __static_call_return, @function\n\t"
+     ASM_FUNC_ALIGN "\n\t"
+     "__static_call_return:\n\t"
+     ANNOTATE_NOENDBR
+     ANNOTATE_RETPOLINE_SAFE
+     "ret; int3\n\t"
+     ".size __static_call_return, . - __static_call_return \n\t");
+
 static void __ref __static_call_transform(void *insn, enum insn_type type,
 					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
 	const void *code;
+	u8 op, buf[6];
+
+	if ((type == JMP || type == RET) && (op = __is_Jcc(insn)))
+		type = JCC;
 
 	switch (type) {
 	case CALL:
@@ -57,6 +86,20 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 		else
 			code = &retinsn;
 		break;
+
+	case JCC:
+		if (!func) {
+			func = __static_call_return;
+			if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+				func = x86_return_thunk;
+		}
+
+		buf[0] = 0x0f;
+		__text_gen_insn(buf+1, op, insn+1, func, 5);
+		code = buf;
+		size = 6;
+
+		break;
 	}
 
 	if (memcmp(insn, code, size) == 0)
@@ -68,9 +111,9 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 	text_poke_bp(insn, code, size, emulate);
 }
 
-static void __static_call_validate(void *insn, bool tail, bool tramp)
+static void __static_call_validate(u8 *insn, bool tail, bool tramp)
 {
-	u8 opcode = *(u8 *)insn;
+	u8 opcode = insn[0];
 
 	if (tramp && memcmp(insn+5, tramp_ud, 3)) {
 		pr_err("trampoline signature fail");
@@ -79,7 +122,8 @@ static void __static_call_validate(void *insn, bool tail, bool tramp)
 
 	if (tail) {
 		if (opcode == JMP32_INSN_OPCODE ||
-		    opcode == RET_INSN_OPCODE)
+		    opcode == RET_INSN_OPCODE ||
+		    __is_Jcc(insn))
 			return;
 	} else {
 		if (opcode == CALL_INSN_OPCODE ||
diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index e61dd039354b..f74a977cf8f8 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -922,6 +922,9 @@ static void mcp2221_hid_unregister(void *ptr)
 /* This is needed to be sure hid_hw_stop() isn't called twice by the subsystem */
 static void mcp2221_remove(struct hid_device *hdev)
 {
+	struct mcp2221 *mcp = hid_get_drvdata(hdev);
+
+	cancel_delayed_work_sync(&mcp->init_work);
 }
 
 #if IS_REACHABLE(CONFIG_IIO)
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index b8dc3b5c9ad9..9f506efa5370 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -480,6 +480,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }
diff --git a/drivers/platform/x86/amd/pmf/Kconfig b/drivers/platform/x86/amd/pmf/Kconfig
index c375498c4071..6d89528c3177 100644
--- a/drivers/platform/x86/amd/pmf/Kconfig
+++ b/drivers/platform/x86/amd/pmf/Kconfig
@@ -6,6 +6,7 @@
 config AMD_PMF
 	tristate "AMD Platform Management Framework"
 	depends on ACPI && PCI
+	depends on POWER_SUPPLY
 	select ACPI_PLATFORM_PROFILE
 	help
 	  This driver provides support for the AMD Platform Management Framework.
diff --git a/drivers/platform/x86/nvidia-wmi-ec-backlight.c b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
index baccdf658538..1b572c90c76e 100644
--- a/drivers/platform/x86/nvidia-wmi-ec-backlight.c
+++ b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
@@ -12,6 +12,10 @@
 #include <linux/wmi.h>
 #include <acpi/video.h>
 
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force loading (disable acpi_backlight=xxx checks");
+
 /**
  * wmi_brightness_notify() - helper function for calling WMI-wrapped ACPI method
  * @w:    Pointer to the struct wmi_device identified by %WMI_BRIGHTNESS_GUID
@@ -91,7 +95,7 @@ static int nvidia_wmi_ec_backlight_probe(struct wmi_device *wdev, const void *ct
 	int ret;
 
 	/* drivers/acpi/video_detect.c also checks that SOURCE == EC */
-	if (acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
+	if (!force && acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
 		return -ENODEV;
 
 	/*
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d233c24ea342..e2b8b3437c58 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -491,6 +491,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -505,7 +510,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..9f0af4f116d9 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -11,6 +11,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ba3fff17e2f9..f9c3b1033ec3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -34,6 +34,7 @@
 #include <linux/log2.h>
 #include <linux/bpf_verifier.h>
 #include <linux/nodemask.h>
+#include <linux/nospec.h>
 #include <linux/bpf_mem_alloc.h>
 
 #include <asm/barrier.h>
@@ -1910,9 +1911,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 1505a52f23a0..d29fe29c6849 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -3,6 +3,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -12,6 +13,12 @@ unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		instrument_copy_from_user_before(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 		instrument_copy_from_user_after(to, from, n, res);
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 53baa95cb644..0f295961e773 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -281,6 +281,9 @@ endmenu
 
 config CC_HAS_RANDSTRUCT
 	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
+	# Randstruct was first added in Clang 15, but it isn't safe to use until
+	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
 
 choice
 	prompt "Randomize layout of sensitive kernel structures"
