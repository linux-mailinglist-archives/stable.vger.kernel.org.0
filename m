Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186324A2FCB
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345772AbiA2N2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346162AbiA2N2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B25C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 05:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F7D0B827C1
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23219C340E5;
        Sat, 29 Jan 2022 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643462896;
        bh=CQhohr8FohtIE10C3mnu8t6ho37Mfl9cYypYItodc9A=;
        h=Subject:To:Cc:From:Date:From;
        b=FmWbbIhKf0kV7TNttzmZYUd2Ilpw0QdSnhJu2ShXvSnSOQlJninyXdwvSSp1C3CLb
         Mw8G4vHgBq90Bm1nKlE07hbpm9FWzvKmhndUh/kZ5Qfsb6oK3OSp1vH9qnkH0Vuo2L
         4JGvYibZQL9GR9bAbtypOSAv3tp1unsb2OnXidfY=
Subject: FAILED: patch "[PATCH] KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any" failed to apply to 4.19-stable tree
To:     likexu@tencent.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:28:04 +0100
Message-ID: <16434628846184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05a9e065059e566f218f8778c4d17ee75db56c55 Mon Sep 17 00:00:00 2001
From: Like Xu <likexu@tencent.com>
Date: Wed, 26 Jan 2022 17:22:26 +0000
Subject: [PATCH] KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any
 time

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
also needs to update kvm_update_cpuid_runtime(). In the above cases, the
size in bytes of the XSAVE area containing all states enabled by XCR0 or
(XCRO | IA32_XSS) needs to be updated.

For simplicity and consistency, existing helpers are used to write values
and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Cc: stable@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220126172226.2298529-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c984eeed30c..5481d2259f02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11266,8 +11266,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
-		vcpu->arch.ia32_xss = 0;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
+		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */

