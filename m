Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFD463DFF2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiK3SwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiK3Svy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0056763D60
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892D461D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0B1C433D7;
        Wed, 30 Nov 2022 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834313;
        bh=yrVOYUEAuBF0vnK4lwFkV0EOV20fQAOkETOmt3GrOb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aS69ioiSnlyL38y5BFekIqYjCflWTtKRuHNjYSUJyhxL1IV0QxMDF2SHOOovECqs
         1Zq4H9S4meN/qmJiLxjLq6oqq4LzPr68jYzYr0G0zMYocB3QCRDvlySVTs2KlOuOJZ
         HQQGe45CCprBi2vPmpNf5W8OpuSHTSSsq1Q84XMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 208/289] KVM: x86: forcibly leave nested mode on vCPU reset
Date:   Wed, 30 Nov 2022 19:23:13 +0100
Message-Id: <20221130180548.835596925@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit ed129ec9057f89d615ba0c81a4984a90345a1684 upstream.

While not obivous, kvm_vcpu_reset() leaves the nested mode by clearing
'vcpu->arch.hflags' but it does so without all the required housekeeping.

On SVM,	it is possible to have a vCPU reset while in guest mode because
unlike VMX, on SVM, INIT's are not latched in SVM non root mode and in
addition to that L1 doesn't have to intercept triple fault, which should
also trigger L1's reset if happens in L2 while L1 didn't intercept it.

If one of the above conditions happen, KVM will	continue to use vmcb02
while not having in the guest mode.

Later the IA32_EFER will be cleared which will lead to freeing of the
nested guest state which will (correctly) free the vmcb02, but since
KVM still uses it (incorrectly) this will lead to a use after free
and kernel crash.

This issue is assigned CVE-2022-3344

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-5-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11789,8 +11789,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 	WARN_ON_ONCE(!init_event &&
 		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
 
+	/*
+	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+	 * bits), i.e. virtualization is disabled.
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
+	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
 
 	vcpu->arch.smi_pending = 0;


