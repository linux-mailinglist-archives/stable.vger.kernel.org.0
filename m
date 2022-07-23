Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4957EDE3
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbiGWKEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiGWKEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350709368D;
        Sat, 23 Jul 2022 02:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B65B82C1B;
        Sat, 23 Jul 2022 09:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB24C341C0;
        Sat, 23 Jul 2022 09:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570387;
        bh=NTrzfJvQ19VyAP61TafzQNav55FmjRegdN7rwksTswA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4SJ6ZB7pfTJHLGWUkDWwIVKCb3oz6+r+jzqw2wZvQkpPl7PCBcRvfZWk4+uQNxE7
         l5aIoQPW8CjWVEyI78X10b/UMj5cn10rP4fzZzpLKoW/SdIIoRHVWSCxPDVkneX06l
         5C15pTWmo+jU60rYq39RKGe7sr1GA5Dgsyx1K06k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Heilman <jamie@audible.transient.net>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 068/148] kvm/emulate: Fix SETcc emulation function offsets with SLS
Date:   Sat, 23 Jul 2022 11:54:40 +0200
Message-Id: <20220723095243.324774965@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit fe83f5eae432ccc8e90082d6ed506d5233547473 upstream.

The commit in Fixes started adding INT3 after RETs as a mitigation
against straight-line speculation.

The fastop SETcc implementation in kvm's insn emulator uses macro magic
to generate all possible SETcc functions and to jump to them when
emulating the respective instruction.

However, it hardcodes the size and alignment of those functions to 4: a
three-byte SETcc insn and a single-byte RET. BUT, with SLS, there's an
INT3 that gets slapped after the RET, which brings the whole scheme out
of alignment:

  15:   0f 90 c0                seto   %al
  18:   c3                      ret
  19:   cc                      int3
  1a:   0f 1f 00                nopl   (%rax)
  1d:   0f 91 c0                setno  %al
  20:   c3                      ret
  21:   cc                      int3
  22:   0f 1f 00                nopl   (%rax)
  25:   0f 92 c0                setb   %al
  28:   c3                      ret
  29:   cc                      int3

and this explodes like this:

  int3: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 2435 Comm: qemu-system-x86 Not tainted 5.17.0-rc8-sls #1
  Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
  RIP: 0010:setc+0x5/0x8 [kvm]
  Code: 00 00 0f 1f 00 0f b6 05 43 24 06 00 c3 cc 0f 1f 80 00 00 00 00 0f 90 c0 c3 cc 0f \
	  1f 00 0f 91 c0 c3 cc 0f 1f 00 0f 92 c0 c3 cc <0f> 1f 00 0f 93 c0 c3 cc 0f 1f 00 \
	  0f 94 c0 c3 cc 0f 1f 00 0f 95 c0
  Call Trace:
   <TASK>
   ? x86_emulate_insn [kvm]
   ? x86_emulate_instruction [kvm]
   ? vmx_handle_exit [kvm_intel]
   ? kvm_arch_vcpu_ioctl_run [kvm]
   ? kvm_vcpu_ioctl [kvm]
   ? __x64_sys_ioctl
   ? do_syscall_64
   ? entry_SYSCALL_64_after_hwframe
   </TASK>

Raise the alignment value when SLS is enabled and use a macro for that
instead of hard-coding naked numbers.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jamie Heilman <jamie@audible.transient.net>
Link: https://lore.kernel.org/r/YjGzJwjrvxg5YZ0Z@audible.transient.net
[Add a comment and a bit of safety checking, since this is going to be changed
 again for IBT support. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -428,8 +428,23 @@ static int fastop(struct x86_emulate_ctx
 	FOP_END
 
 /* Special case for SETcc - 1 instruction per cc */
+
+/*
+ * Depending on .config the SETcc functions look like:
+ *
+ * SETcc %al   [3 bytes]
+ * RET         [1 byte]
+ * INT3        [1 byte; CONFIG_SLS]
+ *
+ * Which gives possible sizes 4 or 5.  When rounded up to the
+ * next power-of-two alignment they become 4 or 8.
+ */
+#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
+#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
+static_assert(SETCC_LENGTH <= SETCC_ALIGN);
+
 #define FOP_SETCC(op) \
-	".align 4 \n\t" \
+	".align " __stringify(SETCC_ALIGN) " \n\t" \
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
@@ -1055,7 +1070,7 @@ static int em_bsr_c(struct x86_emulate_c
 static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
 {
 	u8 rc;
-	void (*fop)(void) = (void *)em_setcc + 4 * (condition & 0xf);
+	void (*fop)(void) = (void *)em_setcc + SETCC_ALIGN * (condition & 0xf);
 
 	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
 	asm("push %[flags]; popf; " CALL_NOSPEC


