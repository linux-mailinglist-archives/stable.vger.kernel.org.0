Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53626ACA7A
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjCFRaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjCFRaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23328211F1
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:29:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B0561058
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A215C433EF;
        Mon,  6 Mar 2023 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678123457;
        bh=wQ7YJGbzFa+TQ5Ouimdv92i8O/41GHt3aRsciCs21NA=;
        h=Subject:To:Cc:From:Date:From;
        b=KOrn3eckM1NYpHdUgqxZuGR7ROnEWRpBBa7bHnaVF+wkY/SihCImAS3bTjACQHy37
         p8B/F+BAjGu42YMD1kTXiUPCmnrLdzt4nQpMVrm4Uhb1dbRljOQt0v/VerLLylxq5V
         FyOM1lRMK0n4ee4DNUNid6CNiv+0CuzM3CMVjdnM=
Subject: FAILED: patch "[PATCH] KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits" failed to apply to 5.15-stable tree
To:     seanjc@google.com, marcorr@google.com, mlevitsk@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:24:14 +0100
Message-ID: <167812345411383@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x ab52be1b310bcb39e6745d34a8f0e8475d67381a
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812345411383@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

ab52be1b310b ("KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32")
a57a31684d7b ("KVM: x86: Treat x2APIC's ICR as a 64-bit register, not two 32-bit regs")
5429478d038f ("KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab52be1b310bcb39e6745d34a8f0e8475d67381a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 7 Jan 2023 01:10:21 +0000
Subject: [PATCH] KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits
 63:32

Reject attempts to set bits 63:32 for 32-bit x2APIC registers, i.e. all
x2APIC registers except ICR.  Per Intel's SDM:

  Non-zero writes (by WRMSR instruction) to reserved bits to these
  registers will raise a general protection fault exception

Opportunistically fix a typo in a nearby comment.

Reported-by: Marc Orr <marcorr@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20230107011025.565472-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9aca006b2d22..814b65106057 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3114,13 +3114,17 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
 {
 	/*
-	 * ICR is a 64-bit register in x2APIC mode (and Hyper'v PV vAPIC) and
+	 * ICR is a 64-bit register in x2APIC mode (and Hyper-V PV vAPIC) and
 	 * can be written as such, all other registers remain accessible only
 	 * through 32-bit reads/writes.
 	 */
 	if (reg == APIC_ICR)
 		return kvm_x2apic_icr_write(apic, data);
 
+	/* Bits 63:32 are reserved in all other registers. */
+	if (data >> 32)
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 

