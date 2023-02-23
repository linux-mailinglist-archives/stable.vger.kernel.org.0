Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606756A09BA
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbjBWNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjBWNJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D555FDD
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2D30CE1FEB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAE7C4339C;
        Thu, 23 Feb 2023 13:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157769;
        bh=dRZCnNtvwKEt8C+vjNI/er/QcjBov6VYOw+7CSl5K0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU2Owwgc8hVmcv71JKXAjKU/JX3UEbX+hGFNtizTTzUmq6tiiuva8iuU3QngOQK00
         15/brELhvCdeXO7gX22NHa+N8iKrWHgU/ZKoxHkObRtYTwAw3LquAn6eXyzahRn3sa
         6vhD0FC2jkyG5B01LyTm7e82XD3swUf01S0hX7pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 31/46] x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions
Date:   Thu, 23 Feb 2023 14:06:38 +0100
Message-Id: <20230223130433.029351046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit ac0ee0a9560c97fa5fe1409e450c2425d4ebd17a upstream.

In order to re-write Jcc.d32 instructions text_poke_bp() needs to be
taught about them.

The biggest hurdle is that the whole machinery is currently made for 5
byte instructions and extending this would grow struct text_poke_loc
which is currently a nice 16 bytes and used in an array.

However, since text_poke_loc contains a full copy of the (s32)
displacement, it is possible to map the Jcc.d32 2 byte opcodes to
Jcc.d8 1 byte opcode for the int3 emulation.

This then leaves the replacement bytes; fudge that by only storing the
last 5 bytes and adding the rule that 'length == 6' instruction will
be prefixed with a 0x0f byte.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20230123210607.115718513@infradead.org
[nathan: Introduce is_jcc32() as part of this change; upstream
         introduced it in 3b6c1747da48]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   59 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -339,6 +339,12 @@ next:
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
@@ -427,8 +433,7 @@ static int patch_retpoline(void *addr, s
 	 *   [ NOP ]
 	 * 1:
 	 */
-	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
-	if (op == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80) {
+	if (is_jcc32(insn)) {
 		cc = insn->opcode.bytes[1] & 0xf;
 		cc ^= 1; /* invert condition */
 
@@ -1311,6 +1316,11 @@ void text_poke_sync(void)
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
@@ -1432,6 +1442,10 @@ noinstr int poke_int3_handler(struct pt_
 		int3_emulate_jmp(regs, (long)ip + tp->disp);
 		break;
 
+	case 0x70 ... 0x7f: /* Jcc */
+		int3_emulate_jcc(regs, tp->opcode & 0xf, (long)ip, tp->disp);
+		break;
+
 	default:
 		BUG();
 	}
@@ -1505,16 +1519,26 @@ static void text_poke_bp_batch(struct te
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
 
@@ -1542,8 +1566,7 @@ static void text_poke_bp_batch(struct te
 		 * The old instruction is recorded so that the event can be
 		 * processed forwards or backwards.
 		 */
-		perf_event_text_poke(text_poke_addr(&tp[i]), old, len,
-				     tp[i].text, len);
+		perf_event_text_poke(text_poke_addr(&tp[i]), old, len, new, len);
 	}
 
 	if (do_sync) {
@@ -1560,10 +1583,15 @@ static void text_poke_bp_batch(struct te
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
 
@@ -1581,9 +1609,11 @@ static void text_poke_loc_init(struct te
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
 
@@ -1594,6 +1624,13 @@ static void text_poke_loc_init(struct te
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
@@ -1610,7 +1647,6 @@ static void text_poke_loc_init(struct te
 		BUG_ON(len != insn.length);
 	};
 
-
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
 	case RET_INSN_OPCODE:
@@ -1619,6 +1655,7 @@ static void text_poke_loc_init(struct te
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
+	case 0x70 ... 0x7f: /* Jcc */
 		tp->disp = insn.immediate.value;
 		break;
 


