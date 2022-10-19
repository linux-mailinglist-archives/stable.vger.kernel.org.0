Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053876041A9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiJSKrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiJSKpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:45:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DF211D99E;
        Wed, 19 Oct 2022 03:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E376B82324;
        Wed, 19 Oct 2022 08:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E713FC4314E;
        Wed, 19 Oct 2022 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169302;
        bh=2eafooLCWzYB3jrawTGKwYMxHojxlE96ckfg/2CLZiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmS35ZbmV9I0KbiFZU06/eh+K1Jk+YSccScUaqgJ9coNpuYhycQheLvnAzbCDjqvf
         1RMmUWyDM7h52ZqIlnHiw4Tsnl0STUAOKSMuP28tKyY9TdIteBNxsooqp+yuKD8tYw
         XAvA92NDM06P7UXItWZL+ti79rIDGTkCvwGcyMow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bill Wendling <morbo@google.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.0 226/862] x86/paravirt: add extra clobbers with ZERO_CALL_USED_REGS enabled
Date:   Wed, 19 Oct 2022 10:25:13 +0200
Message-Id: <20221019083300.040763886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bill Wendling <morbo@google.com>

[ Upstream commit 8c86f29bfb18465d15b05cfd26a6454ec787b793 ]

The ZERO_CALL_USED_REGS feature may zero out caller-saved registers
before returning.

In spurious_kernel_fault(), the "pte_offset_kernel()" call results in
this assembly code:

.Ltmp151:
        #APP
        # ALT: oldnstr
.Ltmp152:
.Ltmp153:
.Ltmp154:
        .section        .discard.retpoline_safe,"",@progbits
        .quad   .Ltmp154
        .text

        callq   *pv_ops+536(%rip)

.Ltmp155:
        .section        .parainstructions,"a",@progbits
        .p2align        3, 0x0
        .quad   .Ltmp153
        .byte   67
        .byte   .Ltmp155-.Ltmp153
        .short  1
        .text
.Ltmp156:
        # ALT: padding
        .zero   (-(((.Ltmp157-.Ltmp158)-(.Ltmp156-.Ltmp152))>0))*((.Ltmp157-.Ltmp158)-(.Ltmp156-.Ltmp152)),144
.Ltmp159:
        .section        .altinstructions,"a",@progbits
.Ltmp160:
        .long   .Ltmp152-.Ltmp160
.Ltmp161:
        .long   .Ltmp158-.Ltmp161
        .short  33040
        .byte   .Ltmp159-.Ltmp152
        .byte   .Ltmp157-.Ltmp158
        .text

        .section        .altinstr_replacement,"ax",@progbits
        # ALT: replacement 1
.Ltmp158:
        movq    %rdi, %rax
.Ltmp157:
        .text
        #NO_APP
.Ltmp162:
        testb   $-128, %dil

The "testb" here is using %dil, but the %rdi register was cleared before
returning from "callq *pv_ops+536(%rip)". Adding the proper constraints
results in the use of a different register:

        movq    %r11, %rdi

        # Similar to above.

        testb   $-128, %r11b

Link: https://github.com/KSPP/linux/issues/192
Signed-off-by: Bill Wendling <morbo@google.com>
Reported-and-tested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/lkml/fa6df43b-8a1a-8ad1-0236-94d2a0b588fa@suse.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220902213750.1124421-3-morbo@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/paravirt_types.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 89df6c6617f5..bc2e1b67319d 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -414,8 +414,17 @@ int paravirt_disable_iospace(void);
 				"=c" (__ecx)
 #define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
 
-/* void functions are still allowed [re]ax for scratch */
+/*
+ * void functions are still allowed [re]ax for scratch.
+ *
+ * The ZERO_CALL_USED REGS feature may end up zeroing out callee-saved
+ * registers. Make sure we model this with the appropriate clobbers.
+ */
+#ifdef CONFIG_ZERO_CALL_USED_REGS
+#define PVOP_VCALLEE_CLOBBERS	"=a" (__eax), PVOP_VCALL_CLOBBERS
+#else
 #define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
+#endif
 #define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
 
 #define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
-- 
2.35.1



