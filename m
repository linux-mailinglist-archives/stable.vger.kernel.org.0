Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590C2511D28
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbiD0P6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiD0P6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:58:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3728703D6;
        Wed, 27 Apr 2022 08:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C2EFB8287D;
        Wed, 27 Apr 2022 15:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336C6C385B0;
        Wed, 27 Apr 2022 15:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074877;
        bh=dhkW1ASMyZWLN/zK5ccMxBpm7mwVmOaNbaYYAvXnbn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpNQCdbuOS7xe43lJpT7YJaM+/Y3kjCcdYUm6Ipphx336FXJygrzF37UieG8lawa4
         NY+737P2qtHnovgJEnz+XRIm93tnV63FDECJmDNhlSoXmIeJahnguL8PaVbATDixHX
         eGGs3TiCDyXULbXY+mod+iN55pYVaDE7mIiy+Vu4oyEjRq61wETSHFakVp80yXzVtv
         QfeueOFZ+9sWCTGkD14WWGYzJZK3x721KPavSO4a6IHclgNL/t54beO0LMwgnZCYp9
         gShVhp6EOrnuResyYkftVMRb92tUw21tu9qAJC6CC1Zbd+pCW9U8VdQvZV7dW3ELuu
         uyERlr2FYkOLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 2/4] KVM: x86: Do not change ICR on write to APIC_SELF_IPI
Date:   Wed, 27 Apr 2022 11:54:33 -0400
Message-Id: <20220427155435.19554-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155435.19554-1-sashal@kernel.org>
References: <20220427155435.19554-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit d22a81b304a27fca6124174a8e842e826c193466 ]

Emulating writes to SELF_IPI with a write to ICR has an unwanted side effect:
the value of ICR in vAPIC page gets changed.  The lists SELF_IPI as write-only,
with no associated MMIO offset, so any write should have no visible side
effect in the vAPIC page.

Reported-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index de11149e28e0..e45ebf0870b6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2106,10 +2106,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
-			kvm_lapic_reg_write(apic, APIC_ICR,
-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
-		} else
+		if (apic_x2apic_mode(apic))
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
+		else
 			ret = 1;
 		break;
 	default:
-- 
2.35.1

