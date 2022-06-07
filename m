Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E7C54065B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347204AbiFGRen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347980AbiFGRb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0004511CB5C;
        Tue,  7 Jun 2022 10:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C95614B5;
        Tue,  7 Jun 2022 17:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CA7C385A5;
        Tue,  7 Jun 2022 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622938;
        bh=2Qc9siteuDU6ClyMBhuUsDmfs1KGs1gijiCPeQIQ06s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMO+XxiUQ+ftDLwIdRhDT6zvVYC89AIh9Zkx1fHwvbErlhQzCTt5M9IJ+3hQ5j9+M
         KCeiSno7bU90Ei7fbmMKSkPfEGVSBaSEn2qBLtabZnBP0kraMx58LAH/WDRSbZWyVe
         BYw4wedbj39nPzY95TCSZZdNzsVdvyDsLKjfQ+A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/452] x86/sev: Annotate stack change in the #VC handler
Date:   Tue,  7 Jun 2022 19:01:33 +0200
Message-Id: <20220607164915.593019876@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index a24ce5905ab8..2f2d52729e17 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -500,6 +500,7 @@ SYM_CODE_START(\asmsym)
 	call	vc_switch_off_ist
 	movq	%rax, %rsp		/* Switch to new stack */
 
+	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
 	/* Update pt_regs */
-- 
2.35.1



