Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422FB4EE87A
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242973AbiDAGlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245601AbiDAGkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE966262D45;
        Thu, 31 Mar 2022 23:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66385B823D9;
        Fri,  1 Apr 2022 06:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE068C340EE;
        Fri,  1 Apr 2022 06:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795051;
        bh=FPksi9QLZUz/hN/3Y5syOBRJqiWJzyPIOiHMjJvB1lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaw1pwRPjLP5yiVP+HeYGQI//UeM2jluS4S9BKSJfs0Giccplnt14l6005Yj10gOa
         LottrJ/AZssBtSy7VjuF4JfYpmgk59gg31G0gZsOb6BeN6jueTm05TK66I0Zr4pgKV
         yyvyCIGxwBQJLLdXoWDm5cTbl8xp+Al9I6S53sA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 25/27] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Fri,  1 Apr 2022 08:36:35 +0200
Message-Id: <20220401063624.945760820@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit a5905d6af492ee6a4a2205f0d550b3f931b03d03 upstream.

KVM allows the guest to discover whether the ARCH_WORKAROUND SMCCC are
implemented, and to preserve that state during migration through its
firmware register interface.

Add the necessary boiler plate for SMCCC_ARCH_WORKAROUND_3.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ kvm code moved to virt/kvm/arm, removed fw regs ABI. Added 32bit stub ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/kvm_host.h   |    6 ++++++
 arch/arm64/include/asm/kvm_host.h |    5 +++++
 virt/kvm/arm/psci.c               |   12 ++++++++++++
 3 files changed, 23 insertions(+)

--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 #include <asm/fpstate.h>
+#include <asm/spectre.h>
 #include <kvm/arm_arch_timer.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -324,4 +325,9 @@ static inline int kvm_arm_have_ssbd(void
 	return KVM_SSBD_UNKNOWN;
 }
 
+static inline int kvm_arm_get_spectre_bhb_state(void)
+{
+	/* 32bit guests don't need firmware for this */
+	return SPECTRE_VULNERABLE; /* aka SMCCC_RET_NOT_SUPPORTED */
+}
 #endif /* __ARM_KVM_HOST_H__ */
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -450,4 +450,9 @@ static inline int kvm_arm_have_ssbd(void
 	}
 }
 
+static inline enum mitigation_state kvm_arm_get_spectre_bhb_state(void)
+{
+	return arm64_get_spectre_bhb_state();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -433,6 +433,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (kvm_arm_get_spectre_bhb_state()) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
 		}
 		break;
 	default:


