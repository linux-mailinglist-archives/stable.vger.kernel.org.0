Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05F42972CF
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463306AbgJWPry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463578AbgJWPry (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 11:47:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A45C0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 08:47:53 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so1631799pfa.10
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Euid2rOIqVxU7BCKc29LGBrOY7GyDm6FtEEpwHglGRU=;
        b=M/GS969E9V3i09GCuC41mYN/VDUOQUKzlMSMBpISUGxrl8e0AnBOu62xTbAgpXkzbS
         5NLXBjzluFLSNZyvQWzcBuXc9alqLSImvHEoFLme/j0k89U1z+qsRc2m0IB+PsXamJf5
         k1wezWUJ+yz+ead4BL9mEB0rQpouYI/1056Hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Euid2rOIqVxU7BCKc29LGBrOY7GyDm6FtEEpwHglGRU=;
        b=HRJGuL2ZM1liBD9drasdBPdpTLiZS3zlZAlNSmas81STRP6jf8oqeJrFhbPUt9X+Kk
         CDMfK/msZKCfJs25nje97U662/13YQp/bp+Z3MUke06mpKDIt2ldfMSAjSsGtiKqXu5g
         tlhmAM5y/sYY53MM+7T00xpson8z/+MF0dUnlzE+pJKdkpd6XMfHISyzDTCKwVC46+Fe
         oxluMAtKC2bkxvaHRhJOWGAy3uzrZaWwpqghqBxBtee2ZeIIecMoJVaPwsAS4kJ/O3Mf
         tuA6Ba2C4qU+MR+EvdeJ08W4hcDaSTXJTTg843cmNF9bclWhMwYg+IqWoDDq9GMiT6tA
         kHLQ==
X-Gm-Message-State: AOAM531I3VF9/DHc/uPS/MaiZj5bvu8v1eJ77XE7/5lWHRlKOV+utAsA
        jsFDdD2/lXRNtg1TyOJePlsRpw==
X-Google-Smtp-Source: ABdhPJzYLUg/ViEmI70rBqC4Esx7lIduLkcNso4qinU5LfKpUejh1bMzhBnu8IwRnHgAqpvsWGhV+A==
X-Received: by 2002:a62:7cd4:0:b029:154:f9ee:320b with SMTP id x203-20020a627cd40000b0290154f9ee320bmr2955753pfc.26.1603468073137;
        Fri, 23 Oct 2020 08:47:53 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id t6sm2532576pfl.50.2020.10.23.08.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 08:47:52 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
Date:   Fri, 23 Oct 2020 08:47:50 -0700
Message-Id: <20201023154751.1973872-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://developer.arm.com/documentation/den0028/latest [1]
Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I see that before commit c118bbb52743 ("arm64: KVM: Propagate full
Spectre v2 workaround state to KVM guests") we had this mapping:

 0 is SPECTRE_MITIGATED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

so the return value '1' wasn't there then. Once the commit was merged we
introduced the notion of NOT_REQUIRED here when it shouldn't have been
introduced.

Changes from v2:
 * Moved define to header file and used it

Changes from v1:
 * Way longer commit text, more background (sorry)
 * Dropped proton-pack part because it was wrong
 * Rebased onto other patch accepted upstream

 arch/arm64/kernel/proton-pack.c | 2 --
 arch/arm64/kvm/hypercalls.c     | 2 +-
 include/linux/arm-smccc.h       | 2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 25f3c80b5ffe..c18eb7d41274 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -135,8 +135,6 @@ static enum mitigation_state spectre_v2_get_cpu_hw_mitigation_state(void)
 	return SPECTRE_VULNERABLE;
 }
 
-#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	(1)
-
 static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
 {
 	int ret;
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 9824025ccc5c..25ea4ecb6449 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				val = SMCCC_RET_SUCCESS;
 				break;
 			case SPECTRE_UNAFFECTED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 15c706fb0a37..0e50ba3e88d7 100644
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

base-commit: 66dd3474702aa98d5844367e1577cdad78ef7c65
-- 
Sent by a computer, using git, on the internet

