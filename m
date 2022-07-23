Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90757EDD7
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiGWKDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiGWKDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A1868DC8;
        Sat, 23 Jul 2022 02:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F5B7B82C1A;
        Sat, 23 Jul 2022 09:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688F3C341C0;
        Sat, 23 Jul 2022 09:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570349;
        bh=7U7iZoqe4+dtDPPJp4LSzYXjPFIQ+BxwPO0m8HF420E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+IoxH5m5EwraZAcSHtxAIAdOkGMuO1M04bacNnNAA1b6QzEaqZP1tJ3uj6l9JTuS
         El9JPhBrQXE3kX/fKnJj23wcdPnnvifediS9UOKmBxKZ98mtHOAkLrUj+CZoxsCEYd
         2ybrtZ+lIt6h9dwQ83OrRXWvDv8wMLdikYGzrY7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 056/148] x86/alternative: Handle Jcc __x86_indirect_thunk_\reg
Date:   Sat, 23 Jul 2022 11:54:28 +0200
Message-Id: <20220723095239.974816312@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -548,7 +548,8 @@ static int emit_indirect(int op, int reg
 static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 {
 	retpoline_thunk_t *target;
-	int reg, i = 0;
+	int reg, ret, i = 0;
+	u8 op, cc;
 
 	target = addr + insn->length + insn->immediate.value;
 	reg = target - __x86_indirect_thunk_array;
@@ -562,9 +563,36 @@ static int patch_retpoline(void *addr, s
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
 		bytes[i++] = 0x90;
@@ -598,6 +626,10 @@ void __init_or_module noinline apply_ret
 		case JMP32_INSN_OPCODE:
 			break;
 
+		case 0x0f: /* escape */
+			if (op2 >= 0x80 && op2 <= 0x8f)
+				break;
+			fallthrough;
 		default:
 			WARN_ON_ONCE(1);
 			continue;


