Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE4C4F02FD
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiDBNus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355820AbiDBNud (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:50:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3BC271E
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B91AFB80885
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D50EC340EE;
        Sat,  2 Apr 2022 13:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648907318;
        bh=mCpqM9el2OYFNzE8jimHzNwZzpZ7Cq7nNeR/LmlsQkk=;
        h=Subject:To:Cc:From:Date:From;
        b=pyUlsb2xDUkXTdwrzSJenEoe+lhHDhtj9jMw/ZumleJiIy6cmbGEJZMa8rNjey37V
         f7Ngv8KItwXzpdpAx0jyDhpWcFft9RQ76xWezA58Yf6HWKf2Wz8ncPp47n0Ln9LpOB
         LcCMlgTvDhbNk5awyl9MRJy93ff/lnUV4gcSihrE=
Subject: FAILED: patch "[PATCH] KVM: x86: Reinitialize context if host userspace toggles" failed to apply to 4.14-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:48:27 +0200
Message-ID: <16489073072182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d6174299365ddbbf491620c0b8c5ca1a6ef2eea5 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 9 Feb 2022 04:56:05 -0500
Subject: [PATCH] KVM: x86: Reinitialize context if host userspace toggles
 EFER.LME

While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and
therefore EFER.NX is the only bit that can affect the MMU role.  However,
set_efer accepts a host-initiated change to EFER.LME even with CR0.PG=1.
In that case, the MMU has to be reset.

Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 51faa2c76ca5..a5a50cfeffff 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -48,6 +48,7 @@
 			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
+#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
 
 static __always_inline u64 rsvd_bits(int s, int e)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b95c379e234..b724273493d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1648,8 +1648,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return r;
 	}
 
-	/* Update reserved bits */
-	if ((efer ^ old_efer) & EFER_NX)
+	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
 	return 0;

