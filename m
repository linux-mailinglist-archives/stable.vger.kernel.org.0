Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAED4CF6B4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiCGJmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbiCGJky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58BB6D3A2;
        Mon,  7 Mar 2022 01:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20875B810D2;
        Mon,  7 Mar 2022 09:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9B3C340E9;
        Mon,  7 Mar 2022 09:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645845;
        bh=+IC5SxFlPCTwimrhYxrbf0C6EBpcKCzs3MZ8Q9Z5Lf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU3sqPlBCvv42D/BPPJITwOio0kWb/XTz04BSIaPABiinhefGRJhjQh8SBmFmzZ0/
         2WgnuvnpYHjlr2jykGR/3ydE1GZ54IZ/Lbzu8L5pcuGsETJfqDqdAuh6FPDH8o8WgF
         KdLQYAdY4vikcrLr9ydEyKkurIWl6XAGYzIwrocM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/262] KVM: VMX: Dont unblock vCPU w/ Posted IRQ if IRQs are disabled in guest
Date:   Mon,  7 Mar 2022 10:16:39 +0100
Message-Id: <20220307091704.067414668@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 1831fa44df743a7cdffdf1c12c799bf6f3c12b8c ]

Don't configure the wakeup handler when a vCPU is blocking with IRQs
disabled, in which case any IRQ, posted or otherwise, should not be
recognized and thus should not wake the vCPU.

Fixes: bf9f6ac8d749 ("KVM: Update Posted-Interrupts Descriptor when vCPU is blocked")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009021236.4122790-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 21ea58d25771f..696ad48ab5daa 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -147,7 +147,8 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm) ||
+	    vmx_interrupt_blocked(vcpu))
 		return 0;
 
 	WARN_ON(irqs_disabled());
-- 
2.34.1



