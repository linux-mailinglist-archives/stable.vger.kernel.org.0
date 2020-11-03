Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAFE2A57B7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgKCUw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732188AbgKCUw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9EC22226;
        Tue,  3 Nov 2020 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436777;
        bh=Z7u4DeqB7QCV5KZvXxOUrK0fAzca6+jDtEsbbSUfQR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlwo94cOKMfhJ/jbcaF5FnJDBBSSTFeCX7NK8EMVuOKFZ/e9+aFi/WM9lsphepc8d
         WIowGQU53ac5jk2TN4J01pgeCJBqzk1vWNgjo1H9KN6CdMbMPf6+JIOvzvvq7J3nhf
         AlgpZ91mgf4FbSW7RVtP5wm+VdNUrEbXmp6zBX2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.9 391/391] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesnt return SMCCC_RET_NOT_REQUIRED
Date:   Tue,  3 Nov 2020 21:37:22 +0100
Message-Id: <20201103203413.547890667@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 1de111b51b829bcf01d2e57971f8fd07a665fa3f upstream.

According to the SMCCC spec[1](7.5.2 Discovery) the
ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
SMCCC_RET_NOT_SUPPORTED.

 0 is "workaround required and safe to call this function"
 1 is "workaround not required but safe to call this function"
 SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"

SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, except
calling this function may not work because it isn't implemented in some
cases". Wonderful. We map this SMC call to

 0 is SPECTRE_MITIGATED
 1 is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

For KVM hypercalls (hvc), we've implemented this function id to return
SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
isn't supposed to be there. Per the code we call
arm64_get_spectre_v2_state() to figure out what to return for this
feature discovery call.

 0 is SPECTRE_MITIGATED
 SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

Let's clean this up so that KVM tells the guest this mapping:

 0 is SPECTRE_MITIGATED
 1 is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

Note: SMCCC_RET_NOT_AFFECTED is 1 but isn't part of the SMCCC spec

Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://developer.arm.com/documentation/den0028/latest [1]
Link: https://lore.kernel.org/r/20201023154751.1973872-1-swboyd@chromium.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hypercalls.c |    2 +-
 include/linux/arm-smccc.h   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu
 				val = SMCCC_RET_SUCCESS;
 				break;
 			case KVM_BP_HARDEN_NOT_REQUIRED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -86,6 +86,8 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\


