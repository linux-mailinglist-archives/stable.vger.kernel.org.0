Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDA761FA8A
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiKGQvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiKGQvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:51:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D02181F
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:51:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7A01CE1167
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7109EC433B5;
        Mon,  7 Nov 2022 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839897;
        bh=K/22hS+vn0Dzk6i58CsXsax9VPo5+27verciPwYYGj4=;
        h=Subject:To:Cc:From:Date:From;
        b=qp4AYoTAqhAneQ3hgOzAcRTQ0n/cGC8qDm/GjEjZhE4VYDZorFmjFgrT7LxDdIrNo
         MC8uG6A3MqP1EpsbTKev+JKGRqjKn2VY2uCzKo9OwV30w0Jsd/EWd2pc78E6/EVXoq
         uKX6x97At9yGRK4T25h9wE0zKlPrx6yzwyKAtDMM=
Subject: FAILED: patch "[PATCH] KVM: x86: emulator: update the emulation mode after rsm" failed to apply to 4.19-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:51:26 +0100
Message-ID: <166783988622470@kroah.com>
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

055f37f84e30 ("KVM: x86: emulator: update the emulation mode after rsm")
0128116550ac ("KVM: x86: Drop .post_leave_smm(), i.e. the manual post-RSM MMU reset")
fa75e08bbe4f ("KVM: x86: Invoke kvm_smm_changed() immediately after clearing SMM flag")
edce46548b70 ("KVM: x86: Replace .set_hflags() with dedicated .exiting_smm() helper")
25b17226cd9a ("KVM: x86: Emulate triple fault shutdown if RSM emulation fails")
78fcb2c91adf ("KVM: x86: Immediately reset the MMU context when the SMM flag is cleared")
02d4160fbd76 ("x86: KVM: add xsetbv to the emulator")
9ec19493fb86 ("KVM: x86: clear SMM flags before loading state while leaving SMM")
c5833c7a43a6 ("KVM: x86: Open code kvm_set_hflags")
ed19321fb657 ("KVM: x86: Load SMRAM in a single shot when leaving SMM")
a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")
a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into nested_vmx_enter_non_root_mode()")
7671ce21b13b ("KVM: nVMX: move check_vmentry_postreqs() call to nested_vmx_enter_non_root_mode()")
d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to nested_vmx_enter_non_root_mode")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 055f37f84e304e59c046d1accfd8f08462f52c4c Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Tue, 25 Oct 2022 15:47:30 +0300
Subject: [PATCH] KVM: x86: emulator: update the emulation mode after rsm

Update the emulation mode after RSM so that RIP will be correctly
written back, because the RSM instruction can switch the CPU mode from
32 bit (or less) to 64 bit.

This fixes a guest crash in case the #SMI is received while the guest
runs a code from an address > 32 bit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-13-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e5522a23d985..33385ebae100 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2662,7 +2662,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	 * those side effects need to be explicitly handled for both success
 	 * and shutdown.
 	 */
-	return X86EMUL_CONTINUE;
+	return emulator_recalc_and_set_mode(ctxt);
 
 emulate_shutdown:
 	ctxt->ops->triple_fault(ctxt);

