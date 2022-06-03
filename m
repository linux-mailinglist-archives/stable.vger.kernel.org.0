Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF2A53CC70
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbiFCPk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243997AbiFCPk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C841C4ECE4
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:40:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140C2618CC
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC54C385A9;
        Fri,  3 Jun 2022 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654270853;
        bh=OB6pKmBn0Nr+DFEufwOqOnxq5QzNAGFu2hAzK6wV1nM=;
        h=Subject:To:Cc:From:Date:From;
        b=PCttwG9KOvKxLPllroy2DZpyrJkhiIaqc/vsmpQCGRodPQShjJtJaA0OWIdlX7cqS
         9tUQDp5Flu/UaUOjFu3Dx0PA5E1rUe8PW2hFcZMqOav38LAkoeJbhmX0AfkzvHfMwf
         Os5Kpxwm5ZQUbUj2dHFmVIFXF5b3SuqjybF2GlCY=
Subject: FAILED: patch "[PATCH] KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 17:40:50 +0200
Message-ID: <165427085010417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c2361f667f3648855ceae25f1332c18413fdb9f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 2 Feb 2022 00:49:44 +0000
Subject: [PATCH] KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses

Use the recently introduce __try_cmpxchg_user() to emulate atomic guest
accesses via the associated userspace address instead of mapping the
backing pfn into kernel address space.  Using kvm_vcpu_map() is unsafe as
it does not coordinate with KVM's mmu_notifier to ensure the hva=>pfn
translation isn't changed/unmapped in the memremap() path, i.e. when
there's no struct page and thus no elevated refcount.

Fixes: 42e35f8072c3 ("KVM/X86: Use kvm_vcpu_map in emulator_cmpxchg_emulated")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb8153d584c8..e5b0dd24b200 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7257,15 +7257,8 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 				   exception, &write_emultor);
 }
 
-#define CMPXCHG_TYPE(t, ptr, old, new) \
-	(cmpxchg((t *)(ptr), *(t *)(old), *(t *)(new)) == *(t *)(old))
-
-#ifdef CONFIG_X86_64
-#  define CMPXCHG64(ptr, old, new) CMPXCHG_TYPE(u64, ptr, old, new)
-#else
-#  define CMPXCHG64(ptr, old, new) \
-	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
-#endif
+#define emulator_try_cmpxchg_user(t, ptr, old, new) \
+	(__try_cmpxchg_user((t __user *)(ptr), (t *)(old), *(t *)(new), efault ## t))
 
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
@@ -7274,12 +7267,11 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned int bytes,
 				     struct x86_exception *exception)
 {
-	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u64 page_line_mask;
+	unsigned long hva;
 	gpa_t gpa;
-	char *kaddr;
-	bool exchanged;
+	int r;
 
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes > 8 || (bytes & (bytes - 1)))
@@ -7303,31 +7295,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
+	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
+	if (kvm_is_error_hva(addr))
 		goto emul_write;
 
-	kaddr = map.hva + offset_in_page(gpa);
+	hva += offset_in_page(gpa);
 
 	switch (bytes) {
 	case 1:
-		exchanged = CMPXCHG_TYPE(u8, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u8, hva, old, new);
 		break;
 	case 2:
-		exchanged = CMPXCHG_TYPE(u16, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u16, hva, old, new);
 		break;
 	case 4:
-		exchanged = CMPXCHG_TYPE(u32, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u32, hva, old, new);
 		break;
 	case 8:
-		exchanged = CMPXCHG64(kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u64, hva, old, new);
 		break;
 	default:
 		BUG();
 	}
 
-	kvm_vcpu_unmap(vcpu, &map, true);
-
-	if (!exchanged)
+	if (r < 0)
+		goto emul_write;
+	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
 	kvm_page_track_write(vcpu, gpa, new, bytes);

