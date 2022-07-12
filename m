Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DEF57249C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiGLTCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbiGLTCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE4660C6;
        Tue, 12 Jul 2022 11:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25DF361123;
        Tue, 12 Jul 2022 18:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F353C3411C;
        Tue, 12 Jul 2022 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651757;
        bh=+24eNmj7JBW2Luyx+OMFPP6OZKm+EOiinyIhDs6ctw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdgOqtGQoEEVcL/eB/6JLQsv4BxQtX7ej1hqTogaM7ezqr8SJWjDRWesnbJzZujj4
         n73ZqTkbPzZJUm6bGH1dytCPtGysOG1uoQPkFDK6m77VNSCfy0gX/uM7cTDimnJnBP
         WacG3gRxeo/BHWZUYNDmQ7FBBHOBGnkXtpkVZaqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 16/78] x86/alternative: Handle Jcc __x86_indirect_thunk_\reg
Date:   Tue, 12 Jul 2022 20:38:46 +0200
Message-Id: <20220712183239.505639145@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

commit 2f0cbb2a8e5bbf101e9de118fc0eb168111a5e1e upstream.

Handle the rare cases where the compiler (clang) does an indirect
conditional tail-call using:

  Jcc __x86_indirect_thunk_\reg

For the !RETPOLINE case this can be rewritten to fit the original (6
byte) instruction like:

  Jncc.d8	1f
  JMP		*%\reg
  NOP
1:

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.296470217@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -393,7 +393,8 @@ static int emit_indirect(int op, int reg
 static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 {
 	retpoline_thunk_t *target;
-	int reg, i = 0;
+	int reg, ret, i = 0;
+	u8 op, cc;
 
 	target = addr + insn->length + insn->immediate.value;
 	reg = target - __x86_indirect_thunk_array;
@@ -407,9 +408,36 @@ static int patch_retpoline(void *addr, s
 	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE))
 		return -1;
 
-	i = emit_indirect(insn->opcode.bytes[0], reg, bytes);
-	if (i < 0)
-		return i;
+	op = insn->opcode.bytes[0];
+
+	/*
+	 * Convert:
+	 *
+	 *   Jcc.d32 __x86_indirect_thunk_\reg
+	 *
+	 * into:
+	 *
+	 *   Jncc.d8 1f
+	 *   JMP *%\reg
+	 *   NOP
+	 * 1:
+	 */
+	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
+	if (op == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80) {
+		cc = insn->opcode.bytes[1] & 0xf;
+		cc ^= 1; /* invert condition */
+
+		bytes[i++] = 0x70 + cc;        /* Jcc.d8 */
+		bytes[i++] = insn->length - 2; /* sizeof(Jcc.d8) == 2 */
+
+		/* Continue as if: JMP.d32 __x86_indirect_thunk_\reg */
+		op = JMP32_INSN_OPCODE;
+	}
+
+	ret = emit_indirect(op, reg, bytes + i);
+	if (ret < 0)
+		return ret;
+	i += ret;
 
 	for (; i < insn->length;)
 		bytes[i++] = BYTES_NOP1;
@@ -443,6 +471,10 @@ void __init_or_module noinline apply_ret
 		case JMP32_INSN_OPCODE:
 			break;
 
+		case 0x0f: /* escape */
+			if (op2 >= 0x80 && op2 <= 0x8f)
+				break;
+			fallthrough;
 		default:
 			WARN_ON_ONCE(1);
 			continue;


