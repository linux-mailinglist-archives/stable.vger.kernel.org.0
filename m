Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2F0541468
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358429AbiFGURw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376366AbiFGUQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBB9171254;
        Tue,  7 Jun 2022 11:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9392612F2;
        Tue,  7 Jun 2022 18:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416AC385A5;
        Tue,  7 Jun 2022 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626537;
        bh=VJQquPIPYZ6yFXJBhAUOmY7ZAz7z9OOhBUNAi50Ygew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbDVJKf4GTPi/O8bQQGhE/hNxDJXjbwboLpHAoX20fKTK+y8fM+wMCnxbORP39TGu
         IkPi5dh/1W4EWjUz+AzlNR2ytUglSMCk4VmxKCDwHlRQ4nMisnDjR2R/eBnOxbM0uv
         FIxKQa2hIFtFkurXNdt1CTWXGgr6BYTyr+asApnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 413/772] x86/sev: Annotate stack change in the #VC handler
Date:   Tue,  7 Jun 2022 19:00:05 +0200
Message-Id: <20220607165001.178122877@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit c42b145181aafd59ed31ccd879493389e3ea5a08 ]

In idtentry_vc(), vc_switch_off_ist() determines a safe stack to
switch to, off of the IST stack. Annotate the new stack switch with
ENCODE_FRAME_POINTER in case UNWINDER_FRAME_POINTER is used.

A stack walk before looks like this:

  CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0-rc7+ #2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl
   dump_stack
   kernel_exc_vmm_communication
   asm_exc_vmm_communication
   ? native_read_msr
   ? __x2apic_disable.part.0
   ? x2apic_setup
   ? cpu_init
   ? trap_init
   ? start_kernel
   ? x86_64_start_reservations
   ? x86_64_start_kernel
   ? secondary_startup_64_no_verify
   </TASK>

and with the fix, the stack dump is exact:

  CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0-rc7+ #3
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl
   dump_stack
   kernel_exc_vmm_communication
   asm_exc_vmm_communication
  RIP: 0010:native_read_msr
  Code: ...
  < snipped regs >
   ? __x2apic_disable.part.0
   x2apic_setup
   cpu_init
   trap_init
   start_kernel
   x86_64_start_reservations
   x86_64_start_kernel
   secondary_startup_64_no_verify
   </TASK>

  [ bp: Test in a SEV-ES guest and rewrite the commit message to
    explain what exactly this does. ]

Fixes: a13644f3a53d ("x86/entry/64: Add entry code for #VC handler")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220316041612.71357-1-jiangshanlai@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 466df3e50276..f7a0cc261b14 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -499,6 +499,7 @@ SYM_CODE_START(\asmsym)
 	call	vc_switch_off_ist
 	movq	%rax, %rsp		/* Switch to new stack */
 
+	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
 	/* Update pt_regs */
-- 
2.35.1



