Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F5F57232C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiGLSnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiGLSmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9814CD915D;
        Tue, 12 Jul 2022 11:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C004AB81BAC;
        Tue, 12 Jul 2022 18:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12576C3411C;
        Tue, 12 Jul 2022 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651307;
        bh=J1SCdMjT+p5aK9/SabHy6rOQb3kdXulj/Hyw//Dih+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHD4K8cknqjQj+JN6lHQqJMtUrAyvL2EHMI36VPh78xP14keq56hOm6wbFjbqrtAx
         DTExiY5FAjuLbwFusyyFxlrTkkijpAzfA6+FQWuwIXWTVqIwnxYDFzSpDKiq6KRWTV
         o6H12xY24D+Vlh6Qxj59PbU2SyxOr63XB2JW8d0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Narron <richard@aaazen.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 036/130] x86/alternative: Optimize single-byte NOPs at an arbitrary position
Date:   Tue, 12 Jul 2022 20:38:02 +0200
Message-Id: <20220712183248.066028724@linuxfoundation.org>
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

commit 2b31e8ed96b260ce2c22bd62ecbb9458399e3b62 upstream.

Up until now the assumption was that an alternative patching site would
have some instructions at the beginning and trailing single-byte NOPs
(0x90) padding. Therefore, the patching machinery would go and optimize
those single-byte NOPs into longer ones.

However, this assumption is broken on 32-bit when code like
hv_do_hypercall() in hyperv_init() would use the ratpoline speculation
killer CALL_NOSPEC. The 32-bit version of that macro would align certain
insns to 16 bytes, leading to the compiler issuing a one or more
single-byte NOPs, depending on the holes it needs to fill for alignment.

That would lead to the warning in optimize_nops() to fire:

  ------------[ cut here ]------------
  Not a NOP at 0xc27fb598
   WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:211 optimize_nops.isra.13

due to that function verifying whether all of the following bytes really
are single-byte NOPs.

Therefore, carve out the NOP padding into a separate function and call
it for each NOP range beginning with a single-byte NOP.

Fixes: 23c1ad538f4f ("x86/alternatives: Optimize optimize_nops()")
Reported-by: Richard Narron <richard@aaazen.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213301
Link: https://lkml.kernel.org/r/20210601212125.17145-1-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   64 ++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 18 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -338,41 +338,69 @@ done:
 }
 
 /*
+ * optimize_nops_range() - Optimize a sequence of single byte NOPs (0x90)
+ *
+ * @instr: instruction byte stream
+ * @instrlen: length of the above
+ * @off: offset within @instr where the first NOP has been detected
+ *
+ * Return: number of NOPs found (and replaced).
+ */
+static __always_inline int optimize_nops_range(u8 *instr, u8 instrlen, int off)
+{
+	unsigned long flags;
+	int i = off, nnops;
+
+	while (i < instrlen) {
+		if (instr[i] != 0x90)
+			break;
+
+		i++;
+	}
+
+	nnops = i - off;
+
+	if (nnops <= 1)
+		return nnops;
+
+	local_irq_save(flags);
+	add_nops(instr + off, nnops);
+	local_irq_restore(flags);
+
+	DUMP_BYTES(instr, instrlen, "%px: [%d:%d) optimized NOPs: ", instr, off, i);
+
+	return nnops;
+}
+
+/*
  * "noinline" to cause control flow change and thus invalidate I$ and
  * cause refetch after modification.
  */
 static void __init_or_module noinline optimize_nops(struct alt_instr *a, u8 *instr)
 {
-	unsigned long flags;
 	struct insn insn;
-	int nop, i = 0;
+	int i = 0;
 
 	/*
-	 * Jump over the non-NOP insns, the remaining bytes must be single-byte
-	 * NOPs, optimize them.
+	 * Jump over the non-NOP insns and optimize single-byte NOPs into bigger
+	 * ones.
 	 */
 	for (;;) {
 		if (insn_decode_kernel(&insn, &instr[i]))
 			return;
 
+		/*
+		 * See if this and any potentially following NOPs can be
+		 * optimized.
+		 */
 		if (insn.length == 1 && insn.opcode.bytes[0] == 0x90)
-			break;
+			i += optimize_nops_range(instr, a->instrlen, i);
+		else
+			i += insn.length;
 
-		if ((i += insn.length) >= a->instrlen)
+		if (i >= a->instrlen)
 			return;
 	}
-
-	for (nop = i; i < a->instrlen; i++) {
-		if (WARN_ONCE(instr[i] != 0x90, "Not a NOP at 0x%px\n", &instr[i]))
-			return;
-	}
-
-	local_irq_save(flags);
-	add_nops(instr + nop, i - nop);
-	local_irq_restore(flags);
-
-	DUMP_BYTES(instr, a->instrlen, "%px: [%d:%d) optimized NOPs: ",
-		   instr, nop, a->instrlen);
 }
 
 /*


