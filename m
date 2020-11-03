Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC732A50C2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgKCUNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgKCUNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 15:13:52 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9F6C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 12:13:50 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 13so15258615pfy.4
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 12:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iY26nL+9rKEWM0m+3lcxk7+Si62rVJe06Mcu42M6bNU=;
        b=eLps2WPRfz+UhZMN+rFlFEz/QpJyAuk8NikrNmy+Uac2l/kduJHngw5wklm60V7Rk5
         skpT2065abhdrZOb+hzvc/8TpjDB8qNYqntbu4QZDkYx2Kz1BAYwSHrNUo4WF2eW0df9
         E5kA7WnKapMrZjqBRq6CnHXYYGIJ5K+zvHfwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iY26nL+9rKEWM0m+3lcxk7+Si62rVJe06Mcu42M6bNU=;
        b=t8mSx4FRgRvMh5bxrO+2+NGQXsEirmtyYsTL+eiOWq5V/LRq3Cl9XBDotkb6s6YNlc
         Xn+WobZcp/MAk+5cN6hF1UbdjXHZEuIcGCdO2jXmqb65bc4cWrRYnj2BDxn72vRMRWK7
         t288Q6Ckz26brmEfVM2U8q1yBvtfrR5mgIp2UYkSCx3nx1+t/Il0QfYNYFQzeijuqlLE
         KBxXU9YfmSDQVrEtnQoijENKV2qwt6ZHL4R2q5JrWCZzBhxESCKn/eEPK5P1xXrqgnRk
         DODF0BTwRHN0vhKjZEzfYoHwKvbMDHqo/jLfb2uaYWveT7HAfbPpgNq+3/T+E+sCmaBo
         GKKg==
X-Gm-Message-State: AOAM531uwEoF0rzKpIAo55vGd+am8BVHS1qMCUdEZfFM/CQHhCfX+qt9
        0zkGap066SUeOinPrYtwDF5jf5BhzQE1aA==
X-Google-Smtp-Source: ABdhPJwNYtsd3305IATRHfux5291SeUk86YsRXGwGoMu6xiGVy+o0U44zhE3ifbVx40ASduNSPGJOg==
X-Received: by 2002:a62:fb12:0:b029:160:4c48:b9e1 with SMTP id x18-20020a62fb120000b02901604c48b9e1mr26086509pfm.8.1604434429988;
        Tue, 03 Nov 2020 12:13:49 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id y5sm11622919pfc.165.2020.11.03.12.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:13:49 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH stable 5.4] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
Date:   Tue,  3 Nov 2020 12:13:48 -0800
Message-Id: <20201103201348.371557-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 include/linux/arm-smccc.h | 2 ++
 virt/kvm/arm/psci.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 080012a6f025..157e4a6a83f6 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -76,6 +76,8 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 87927f7e1ee7..48fde38d64c3 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -408,7 +408,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				val = SMCCC_RET_SUCCESS;
 				break;
 			case KVM_BP_HARDEN_NOT_REQUIRED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
-- 
Sent by a computer, using git, on the internet

