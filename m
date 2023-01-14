Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AEE66AAAD
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjANJsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjANJsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:48:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59EF172F
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D552CE0949
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEFC433EF;
        Sat, 14 Jan 2023 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689696;
        bh=/nfElhVSyWVOOrrsKqe6lmfPUGWY6kn1I9CJreL7Aak=;
        h=Subject:To:Cc:From:Date:From;
        b=sYMlr5rNiXm/BY6j7cKNxo4GOVgIEGwG3BGNyMZWevCnU5U8j9UahSlZ841FF1S36
         EW8Nz3neZBoIOWnDFGLaD/JzfKLZv7Dz109PGTZn+vHzROl4jylPeqs2kOHORrSl1u
         J7X2Mfb0XN9iRn4Yu5OxeNYfdVw8ZX+RJSd81qXQ=
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix S1PTW handling on RO memslots" failed to apply to 4.19-stable tree
To:     maz@kernel.org, ardb@kernel.org, oliver.upton@linux.dev
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:48:13 +0100
Message-ID: <16736896939065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
16314874b12b ("Merge branch 'kvm-arm64/misc-5.9' into kvmarm-master/next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 406504c7b0405d74d74c15a667cd4c4620c3e7a9 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Tue, 20 Dec 2022 14:03:52 +0000
Subject: [PATCH] KVM: arm64: Fix S1PTW handling on RO memslots

A recent development on the EFI front has resulted in guests having
their page tables baked in the firmware binary, and mapped into the
IPA space as part of a read-only memslot. Not only is this legitimate,
but it also results in added security, so thumbs up.

It is possible to take an S1PTW translation fault if the S1 PTs are
unmapped at stage-2. However, KVM unconditionally treats S1PTW as a
write to correctly handle hardware AF/DB updates to the S1 PTs.
Furthermore, KVM injects an exception into the guest for S1PTW writes.
In the aforementioned case this results in the guest taking an abort
it won't recover from, as the S1 PTs mapping the vectors suffer from
the same problem.

So clearly our handling is... wrong.

Instead, switch to a two-pronged approach:

- On S1PTW translation fault, handle the fault as a read

- On S1PTW permission fault, handle the fault as a write

This is of no consequence to SW that *writes* to its PTs (the write
will trigger a non-S1PTW fault), and SW that uses RO PTs will not
use HW-assisted AF/DB anyway, as that'd be wrong.

Only in the case described in c4ad98e4b72c ("KVM: arm64: Assume write
fault on S1PTW permission fault on instruction fetch") do we end-up
with two back-to-back faults (page being evicted and faulted back).
I don't think this is a case worth optimising for.

Fixes: c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Regression-tested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9bdba47f7e14..0d40c48d8132 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -373,8 +373,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu))
-		return true;
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		/*
+		 * Only a permission fault on a S1PTW should be
+		 * considered as a write. Otherwise, page tables baked
+		 * in a read-only memslot will result in an exception
+		 * being delivered in the guest.
+		 *
+		 * The drawback is that we end-up faulting twice if the
+		 * guest is using any of HW AF/DB: a translation fault
+		 * to map the page containing the PT (read only at
+		 * first), then a permission fault to allow the flags
+		 * to be set.
+		 */
+		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+		case ESR_ELx_FSC_PERM:
+			return true;
+		default:
+			return false;
+		}
+	}
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;

