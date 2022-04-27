Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE36511F4C
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbiD0P5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240576AbiD0P5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:57:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB0703EF;
        Wed, 27 Apr 2022 08:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0CB0612B9;
        Wed, 27 Apr 2022 15:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0256AC385B5;
        Wed, 27 Apr 2022 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074861;
        bh=84Cf+kNuFriqtENNa1ezqce+lu2J/desx9OHStUV0J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsoK44cM4UC9zyIBtDhZbpBrRE6Ary41dNMMdw5OU1Ngbdexs0a1v32oK769WwbPd
         +lU3TQ0OB8X+I0Xrp1Elf0y9g1Bf1KeihXWHhqhrR9W3mZSz1tv7f+Hewz/6HMlx0Y
         vy4PhNrTTFAl99cJo8N5m3blUDgOAu6838D0Ky6BT3UvrRlqD6spiRdLqFITsJyCQD
         UgNQcjVvP5zmjTOTACW3jQfe4ZbZc4X3EHGpWgk07vt5ukSFs8FSfOx1c8ZwlRxVnP
         S7+F3cSCNPfxLw1J3ev/AnKCwGFPbXnK7GZBmh0XwEng3eTLtYhLBH6Zf7Ec8b4gQM
         RPeNN4t77jL4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 4/7] KVM: x86: Do not change ICR on write to APIC_SELF_IPI
Date:   Wed, 27 Apr 2022 11:54:00 -0400
Message-Id: <20220427155408.19352-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
References: <20220427155408.19352-1-sashal@kernel.org>
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
index 2a10d0033c96..6b6f9359d29e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2125,10 +2125,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
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

