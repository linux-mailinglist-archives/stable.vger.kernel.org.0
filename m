Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470A657EDE9
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiGWKEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbiGWKEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C318798226;
        Sat, 23 Jul 2022 02:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21102B82C23;
        Sat, 23 Jul 2022 09:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB43C341C0;
        Sat, 23 Jul 2022 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570375;
        bh=jXkipwUJuN5Bshbw5oq+n7KCie4OGQQnZ71o0LvNP0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QidTTwuaWvFVwebTQ+XjKGywWd3WhpF3bYKdI98lzHFHd4eYL16j8Qln6Fw1Hkxjz
         lNaG5GUBOPtr+8nDW1xKfmp2DgptCZfjfhI8oLi7KL2gpXuZfGQm8MbCRT5dkEqiCi
         KPdIMkbDE930ROoN9H002f3SZscfD/ZeV32nPhLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 064/148] x86/alternative: Relax text_poke_bp() constraint
Date:   Sat, 23 Jul 2022 11:54:36 +0200
Message-Id: <20220723095242.224281086@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 26c44b776dba4ac692a0bf5a3836feb8a63fea6b upstream.

Currently, text_poke_bp() is very strict to only allow patching a
single instruction; however with straight-line-speculation it will be
required to patch: ret; int3, which is two instructions.

As such, relax the constraints a little to allow int3 padding for all
instructions that do not imply the execution of the next instruction,
ie: RET, JMP.d8 and JMP.d32.

While there, rename the text_poke_loc::rel32 field to ::disp.

Note: this fills up the text_poke_loc structure which is now a round
  16 bytes big.

  [ bp: Put comments ontop instead of on the side. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134908.082342723@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   49 +++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1243,10 +1243,13 @@ void text_poke_sync(void)
 }
 
 struct text_poke_loc {
-	s32 rel_addr; /* addr := _stext + rel_addr */
-	s32 rel32;
+	/* addr := _stext + rel_addr */
+	s32 rel_addr;
+	s32 disp;
+	u8 len;
 	u8 opcode;
 	const u8 text[POKE_MAX_OPCODE_SIZE];
+	/* see text_poke_bp_batch() */
 	u8 old;
 };
 
@@ -1261,7 +1264,8 @@ static struct bp_patching_desc *bp_desc;
 static __always_inline
 struct bp_patching_desc *try_get_desc(struct bp_patching_desc **descp)
 {
-	struct bp_patching_desc *desc = __READ_ONCE(*descp); /* rcu_dereference */
+	/* rcu_dereference */
+	struct bp_patching_desc *desc = __READ_ONCE(*descp);
 
 	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
 		return NULL;
@@ -1295,7 +1299,7 @@ noinstr int poke_int3_handler(struct pt_
 {
 	struct bp_patching_desc *desc;
 	struct text_poke_loc *tp;
-	int len, ret = 0;
+	int ret = 0;
 	void *ip;
 
 	if (user_mode(regs))
@@ -1335,8 +1339,7 @@ noinstr int poke_int3_handler(struct pt_
 			goto out_put;
 	}
 
-	len = text_opcode_size(tp->opcode);
-	ip += len;
+	ip += tp->len;
 
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
@@ -1351,12 +1354,12 @@ noinstr int poke_int3_handler(struct pt_
 		break;
 
 	case CALL_INSN_OPCODE:
-		int3_emulate_call(regs, (long)ip + tp->rel32);
+		int3_emulate_call(regs, (long)ip + tp->disp);
 		break;
 
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
-		int3_emulate_jmp(regs, (long)ip + tp->rel32);
+		int3_emulate_jmp(regs, (long)ip + tp->disp);
 		break;
 
 	default:
@@ -1431,7 +1434,7 @@ static void text_poke_bp_batch(struct te
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
 		u8 old[POKE_MAX_OPCODE_SIZE] = { tp[i].old, };
-		int len = text_opcode_size(tp[i].opcode);
+		int len = tp[i].len;
 
 		if (len - INT3_INSN_SIZE > 0) {
 			memcpy(old + INT3_INSN_SIZE,
@@ -1508,21 +1511,37 @@ static void text_poke_loc_init(struct te
 			       const void *opcode, size_t len, const void *emulate)
 {
 	struct insn insn;
-	int ret;
+	int ret, i;
 
 	memcpy((void *)tp->text, opcode, len);
 	if (!emulate)
 		emulate = opcode;
 
 	ret = insn_decode_kernel(&insn, emulate);
-
 	BUG_ON(ret < 0);
-	BUG_ON(len != insn.length);
 
 	tp->rel_addr = addr - (void *)_stext;
+	tp->len = len;
 	tp->opcode = insn.opcode.bytes[0];
 
 	switch (tp->opcode) {
+	case RET_INSN_OPCODE:
+	case JMP32_INSN_OPCODE:
+	case JMP8_INSN_OPCODE:
+		/*
+		 * Control flow instructions without implied execution of the
+		 * next instruction can be padded with INT3.
+		 */
+		for (i = insn.length; i < len; i++)
+			BUG_ON(tp->text[i] != INT3_INSN_OPCODE);
+		break;
+
+	default:
+		BUG_ON(len != insn.length);
+	};
+
+
+	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
 	case RET_INSN_OPCODE:
 		break;
@@ -1530,7 +1549,7 @@ static void text_poke_loc_init(struct te
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
-		tp->rel32 = insn.immediate.value;
+		tp->disp = insn.immediate.value;
 		break;
 
 	default: /* assume NOP */
@@ -1538,13 +1557,13 @@ static void text_poke_loc_init(struct te
 		case 2: /* NOP2 -- emulate as JMP8+0 */
 			BUG_ON(memcmp(emulate, ideal_nops[len], len));
 			tp->opcode = JMP8_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		case 5: /* NOP5 -- emulate as JMP32+0 */
 			BUG_ON(memcmp(emulate, ideal_nops[NOP_ATOMIC5], len));
 			tp->opcode = JMP32_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		default: /* unknown instruction */


