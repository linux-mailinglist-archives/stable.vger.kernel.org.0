Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9E6A09EA
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjBWNLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbjBWNLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1317A57089
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7C86616E9
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A8EC433D2;
        Thu, 23 Feb 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157852;
        bh=ANBeCaIw0mP+OnWa8o0zKE4h4qXfE5jsF01SGT/TLto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqOVeqTTa21HZlG18oK2LYs31Nr7eRIMxwPQjUo84jX3rUvnNxnJnNRfl+7gJed6/
         G5TUo6IkG48CeO0aX+J35Se8v/n5Un2jJP06NH0UYwmfMcVaQk/2XJuORAYzFM+YL2
         IBs5aBCDltQeGZ2gI1Ih2lWRdjRCyQ80B/WyW1YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/18] KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
Date:   Thu, 23 Feb 2023 14:06:53 +0100
Message-Id: <20230223130426.011201019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 17122c06b86c9f77f45b86b8e62c3ed440847a59 ]

Treat any exception during instruction decode for EMULTYPE_SKIP as a
"full" emulation failure, i.e. signal failure instead of queuing the
exception.  When decoding purely to skip an instruction, KVM and/or the
CPU has already done some amount of emulation that cannot be unwound,
e.g. on an EPT misconfig VM-Exit KVM has already processeed the emulated
MMIO.  KVM already does this if a #UD is encountered, but not for other
exceptions, e.g. if a #PF is encountered during fetch.

In SVM's soft-injection use case, queueing the exception is particularly
problematic as queueing exceptions while injecting events can put KVM
into an infinite loop due to bailing from VM-Enter to service the newly
pending exception.  E.g. multiple warnings to detect such behavior fire:

  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 1017 at arch/x86/kvm/x86.c:9873 kvm_arch_vcpu_ioctl_run+0x1de5/0x20a0 [kvm]
  Modules linked in: kvm_amd ccp kvm irqbypass
  CPU: 3 PID: 1017 Comm: svm_nested_soft Not tainted 6.0.0-rc1+ #220
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x1de5/0x20a0 [kvm]
  Call Trace:
   kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
   __x64_sys_ioctl+0x85/0xc0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  ---[ end trace 0000000000000000 ]---
  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 1017 at arch/x86/kvm/x86.c:9987 kvm_arch_vcpu_ioctl_run+0x12a3/0x20a0 [kvm]
  Modules linked in: kvm_amd ccp kvm irqbypass
  CPU: 3 PID: 1017 Comm: svm_nested_soft Tainted: G        W          6.0.0-rc1+ #220
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x12a3/0x20a0 [kvm]
  Call Trace:
   kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
   __x64_sys_ioctl+0x85/0xc0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  ---[ end trace 0000000000000000 ]---

Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220930233632.1725475-1-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf37a61729972..f5e9590a8f311 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6787,7 +6787,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
-			if (ctxt->have_exception) {
+
+			if (ctxt->have_exception &&
+			    !(emulation_type & EMULTYPE_SKIP)) {
 				/*
 				 * #UD should result in just EMULATION_FAILED, and trap-like
 				 * exception should not be encountered during decode.
-- 
2.39.0



