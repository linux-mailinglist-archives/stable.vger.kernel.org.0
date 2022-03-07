Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DAD4CF70A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiCGJoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240364AbiCGJk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15E12D1D5;
        Mon,  7 Mar 2022 01:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCCF60F63;
        Mon,  7 Mar 2022 09:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0729EC340E9;
        Mon,  7 Mar 2022 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645852;
        bh=UMz2txwKo30Dyf7QnStl7t4dAxLp9RmLZ4ZsAfzY8d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS15UwDrFAU+y2WXNOjLV2+SYWBhc8wC/T+6LmDXSaXtkkO4L/4RyCeQzdEr17lJ6
         xEkRw6bXXRD2KgecKvszsfMQQfYMpZKSFjiSxSee0rqP3X4bbrz6JuCSE1RigQCJB5
         d1o/Tt/pUDPdxZ+yEMOguO+YRq9fEN4G1uNCmWyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/262] KVM: VMX: Read Posted Interrupt "control" exactly once per loop iteration
Date:   Mon,  7 Mar 2022 10:16:41 +0100
Message-Id: <20220307091704.121672878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cfb0e1306a3790eb055ebf7cdb7b0ee8a23e9b6e ]

Use READ_ONCE() when loading the posted interrupt descriptor control
field to ensure "old" and "new" have the same base value.  If the
compiler emits separate loads, and loads into "new" before "old", KVM
could theoretically drop the ON bit if it were set between the loads.

Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009021236.4122790-27-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 696ad48ab5daa..46fb83d6a286e 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -51,7 +51,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* The full case.  */
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		dest = cpu_physical_id(cpu);
 
@@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	unsigned int dest;
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
 		     "Wakeup handler not enabled while the VCPU is blocked\n");
 
@@ -163,7 +163,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	}
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		WARN((pi_desc->sn == 1),
 		     "Warning: SN field of posted-interrupts "
-- 
2.34.1



