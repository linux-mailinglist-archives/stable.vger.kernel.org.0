Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1857EDD3
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiGWKDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbiGWKCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA83B3C8D7;
        Sat, 23 Jul 2022 02:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31275611BD;
        Sat, 23 Jul 2022 09:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D495C341C0;
        Sat, 23 Jul 2022 09:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570352;
        bh=OqfwUX60UBlfoRQ1m3NNXPSM4sIy5u0tsQRZI9rcZ6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raggF41zeXAY5aBCegC/3QrHiBfZflCpT6bVEWWEPu9r9f6ZO2WUW1dZayABIJ9iT
         tO/E+d1+W4Wo+odK755rTW4tz+37i/SZRyDk3HGNaRg/h+XN7exVK29FvxcJoiqYVN
         KlskujkLvr5K8JfqpXKA7ARVBmtiaUYp0Btp25pc=
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
Subject: [PATCH 5.10 057/148] x86/alternative: Try inline spectre_v2=retpoline,amd
Date:   Sat, 23 Jul 2022 11:54:29 +0200
Message-Id: <20220723095240.221456201@linuxfoundation.org>
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

commit bbe2df3f6b6da7848398d55b1311d58a16ec21e4 upstream.

Try and replace retpoline thunk calls with:

  LFENCE
  CALL    *%\reg

for spectre_v2=retpoline,amd.

Specifically, the sequence above is 5 bytes for the low 8 registers,
but 6 bytes for the high 8 registers. This means that unless the
compilers prefix stuff the call with higher registers this replacement
will fail.

Luckily GCC strongly favours RAX for the indirect calls and most (95%+
for defconfig-x86_64) will be converted. OTOH clang strongly favours
R11 and almost nothing gets converted.

Note: it will also generate a correct replacement for the Jcc.d32
case, except unless the compilers start to prefix stuff that, it'll
never fit. Specifically:

  Jncc.d8 1f
  LFENCE
  JMP     *%\reg
1:

is 7-8 bytes long, where the original instruction in unpadded form is
only 6 bytes.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.359986601@infradead.org
[cascardo: RETPOLINE_AMD was renamed to RETPOLINE_LFENCE]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -544,6 +544,7 @@ static int emit_indirect(int op, int reg
  *
  *   CALL *%\reg
  *
+ * It also tries to inline spectre_v2=retpoline,amd when size permits.
  */
 static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 {
@@ -560,7 +561,8 @@ static int patch_retpoline(void *addr, s
 	/* If anyone ever does: CALL/JMP *%rsp, we're in deep trouble. */
 	BUG_ON(reg == 4);
 
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE))
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE) &&
+	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE))
 		return -1;
 
 	op = insn->opcode.bytes[0];
@@ -573,8 +575,9 @@ static int patch_retpoline(void *addr, s
 	 * into:
 	 *
 	 *   Jncc.d8 1f
+	 *   [ LFENCE ]
 	 *   JMP *%\reg
-	 *   NOP
+	 *   [ NOP ]
 	 * 1:
 	 */
 	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
@@ -589,6 +592,15 @@ static int patch_retpoline(void *addr, s
 		op = JMP32_INSN_OPCODE;
 	}
 
+	/*
+	 * For RETPOLINE_AMD: prepend the indirect CALL/JMP with an LFENCE.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
+		bytes[i++] = 0x0f;
+		bytes[i++] = 0xae;
+		bytes[i++] = 0xe8; /* LFENCE */
+	}
+
 	ret = emit_indirect(op, reg, bytes + i);
 	if (ret < 0)
 		return ret;


