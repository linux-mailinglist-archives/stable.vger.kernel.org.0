Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554DD61FA87
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiKGQvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiKGQve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:51:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F922528
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0778CB815A0
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B24AC433D7;
        Mon,  7 Nov 2022 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839890;
        bh=FipgHP9JEckK61JtRxqBYHIRWUb5mbogfc+aErpWnBo=;
        h=Subject:To:Cc:From:Date:From;
        b=wZ4GjRswS1DwJnb6eRruzBBWgfi8KuXe6zGndzo5OLzDirO++TRSzwq47xHDgLtMn
         wvTIQTmuoPBTeLEo+ieS1zS96aOTYYhwUjHq7tsSJelyFOCm4ruUoMiZfY6VQZgD0T
         628QCjJsNA0yBTKFX/KzPPqMpcje+AxRqOPch+qA=
Subject: FAILED: patch "[PATCH] KVM: x86: emulator: update the emulation mode after rsm" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:51:25 +0100
Message-ID: <166783988517653@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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

