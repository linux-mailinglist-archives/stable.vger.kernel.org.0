Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC86526485
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381007AbiEMObt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381198AbiEMObK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A0985B0;
        Fri, 13 May 2022 07:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 192EECE3237;
        Fri, 13 May 2022 14:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274EEC36AF2;
        Fri, 13 May 2022 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452118;
        bh=VkPUj72UpbJFCY22ks6F56UqOwRU9wtq4zC3+pJvIkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx5aNeJVZeHXIUwxHEksjaepFAIWmBSsQ0/qtuhqyxm2A+A4XQetsgdY/q899uylz
         AcokfPIrS2Jb1z3uZfXA3b9WWJYKrWK0CQ8XYF0N13eEyoZDh7/YVailUAuvOqtsbD
         HQ5YpYnR9FXCSwyOfvfbH9zZmOqTA5bYCUG0rdl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/21] x86/alternative: Relax text_poke_bp() constraint
Date:   Fri, 13 May 2022 16:23:47 +0200
Message-Id: <20220513142230.035244880@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 26c44b776dba4ac692a0bf5a3836feb8a63fea6b ]

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
---
 arch/x86/kernel/alternative.c |   49 +++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -930,10 +930,13 @@ void text_poke_sync(void)
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
 
@@ -948,7 +951,8 @@ static struct bp_patching_desc *bp_desc;
 static __always_inline
 struct bp_patching_desc *try_get_desc(struct bp_patching_desc **descp)
 {
-	struct bp_patching_desc *desc = __READ_ONCE(*descp); /* rcu_dereference */
+	/* rcu_dereference */
+	struct bp_patching_desc *desc = __READ_ONCE(*descp);
 
 	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
 		return NULL;
@@ -982,7 +986,7 @@ noinstr int poke_int3_handler(struct pt_
 {
 	struct bp_patching_desc *desc;
 	struct text_poke_loc *tp;
-	int len, ret = 0;
+	int ret = 0;
 	void *ip;
 
 	if (user_mode(regs))
@@ -1022,8 +1026,7 @@ noinstr int poke_int3_handler(struct pt_
 			goto out_put;
 	}
 
-	len = text_opcode_size(tp->opcode);
-	ip += len;
+	ip += tp->len;
 
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
@@ -1038,12 +1041,12 @@ noinstr int poke_int3_handler(struct pt_
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
@@ -1118,7 +1121,7 @@ static void text_poke_bp_batch(struct te
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
 		u8 old[POKE_MAX_OPCODE_SIZE] = { tp[i].old, };
-		int len = text_opcode_size(tp[i].opcode);
+		int len = tp[i].len;
 
 		if (len - INT3_INSN_SIZE > 0) {
 			memcpy(old + INT3_INSN_SIZE,
@@ -1195,21 +1198,37 @@ static void text_poke_loc_init(struct te
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
@@ -1217,7 +1236,7 @@ static void text_poke_loc_init(struct te
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
-		tp->rel32 = insn.immediate.value;
+		tp->disp = insn.immediate.value;
 		break;
 
 	default: /* assume NOP */
@@ -1225,13 +1244,13 @@ static void text_poke_loc_init(struct te
 		case 2: /* NOP2 -- emulate as JMP8+0 */
 			BUG_ON(memcmp(emulate, x86_nops[len], len));
 			tp->opcode = JMP8_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		case 5: /* NOP5 -- emulate as JMP32+0 */
 			BUG_ON(memcmp(emulate, x86_nops[len], len));
 			tp->opcode = JMP32_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		default: /* unknown instruction */


