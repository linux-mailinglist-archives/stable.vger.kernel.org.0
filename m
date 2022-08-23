Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1C59D689
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbiHWJLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348267AbiHWJKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:10:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC7D6CF44;
        Tue, 23 Aug 2022 01:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D358F614D3;
        Tue, 23 Aug 2022 08:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BFBC433D7;
        Tue, 23 Aug 2022 08:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243373;
        bh=g/+coOW5lUeirePAEayAtHU5SKrm1HBE7FI5NENdJmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZF5FqSXLCedANdPfH/PPxNcspqY3s4+xYRiUAOHx48f+Ip04H5UrPs01FmcntBNy
         WPznE1aUKmLGygBgAtiW0C4qoGiRqOzt/xkj0pu7ewcFkVvFHzn4u0kxkTWOtXhSqB
         OeRGaWYZ0n9Clw1lpkxKwYf0UHdJwNSCC5m3y2Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengfei Xu <pengfei.xu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.19 256/365] x86/kvm: Fix "missing ENDBR" BUG for fastop functions
Date:   Tue, 23 Aug 2022 10:02:37 +0200
Message-Id: <20220823080128.907850538@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 3d9606b0e0f3aed4dfb61d0853ebf432fead7bba ]

The following BUG was reported:

  traps: Missing ENDBR: andw_ax_dx+0x0/0x10 [kvm]
  ------------[ cut here ]------------
  kernel BUG at arch/x86/kernel/traps.c:253!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
   <TASK>
   asm_exc_control_protection+0x2b/0x30
  RIP: 0010:andw_ax_dx+0x0/0x10 [kvm]
  Code: c3 cc cc cc cc 0f 1f 44 00 00 66 0f 1f 00 48 19 d0 c3 cc cc cc
        cc 0f 1f 40 00 f3 0f 1e fa 20 d0 c3 cc cc cc cc 0f 1f 44 00 00
        <66> 0f 1f 00 66 21 d0 c3 cc cc cc cc 0f 1f 40 00 66 0f 1f 00 21
        d0

   ? andb_al_dl+0x10/0x10 [kvm]
   ? fastop+0x5d/0xa0 [kvm]
   x86_emulate_insn+0x822/0x1060 [kvm]
   x86_emulate_instruction+0x46f/0x750 [kvm]
   complete_emulated_mmio+0x216/0x2c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x604/0x650 [kvm]
   kvm_vcpu_ioctl+0x2f4/0x6b0 [kvm]
   ? wake_up_q+0xa0/0xa0

The BUG occurred because the ENDBR in the andw_ax_dx() fastop function
had been incorrectly "sealed" (converted to a NOP) by apply_ibt_endbr().

Objtool marked it to be sealed because KVM has no compile-time
references to the function.  Instead KVM calculates its address at
runtime.

Prevent objtool from annotating fastop functions as sealable by creating
throwaway dummy compile-time references to the functions.

Fixes: 6649fa876da4 ("x86/ibt,kvm: Add ENDBR to fastops")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Debugged-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Message-Id: <0d4116f90e9d0c1b754bb90c585e6f0415a1c508.1660837839.git.jpoimboe@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index aa907cec0918..09fa8a94807b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -316,7 +316,8 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	".align " __stringify(FASTOP_SIZE) " \n\t" \
 	".type " name ", @function \n\t" \
 	name ":\n\t" \
-	ASM_ENDBR
+	ASM_ENDBR \
+	IBT_NOSEAL(name)
 
 #define FOP_FUNC(name) \
 	__FOP_FUNC(#name)
-- 
2.35.1



