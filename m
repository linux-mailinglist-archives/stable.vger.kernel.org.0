Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F814527F
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfFNDNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41226 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id 83so668192pgg.8
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XnBFuCb0fKyphIKUBsr79RViQc3+zyureYjz7BI8VNo=;
        b=esT6yODHCOPamMcOEIHuIhACaeouPQ3yo/v5MBa40924SSSeJaG2ULGBQ/CLUoQbmw
         veg3oijobNEl2NP4ivxYvXTjcHUDYfsHGr/2+9D2GL74RWGecQ6ClJubOs+bsmrHIJoB
         VqxVAl3KoZgWOmmxvZyWzD+PZi6TQUV1y8FTil0oin6xyzux+Z8+C+N9YpzbMErJuWRd
         n6tm6Chwu6+Qgd1gO+m/36/+kfRl2mv6HvaLmDwJXCJGHEbqig9AEAm65vsz21clORkx
         yxQIP0PwTZ6U9Ik1AwiEpGGtOkI51snHExxKzeI47qdMhjoZNioe1PNPZPdOU+pf8B59
         cO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XnBFuCb0fKyphIKUBsr79RViQc3+zyureYjz7BI8VNo=;
        b=qA4u6ensNoQ/NSAISR9qyp0F07fyppozsbCsHKblTlNE6uJjKssU1jyfaaS7nEktL5
         dmTfRYfk6P6q3cbieMVYKe/TBS+UEQb877vrwVOtvQ3jfyl5TY0aV90YM2fJstL+b2wz
         l5Iku8xwRh9O1Sk4zgROQJGXirC8O9Qw9ujul2TJ8vXpH31omAhO2+PtwOPHMZpdvs3G
         9wedodVwMTr5+lyR51h3oTy1O2nbhskbIJulRhXGWDwgAwTagBTZekeV5YgqPS8CskV7
         QycoJIQVh/kqv8IlBhDETfdN8gR7NVE9PEh89Hr4qrJanGZDH99FKaSAo2OrEn5P0Dw3
         nTrQ==
X-Gm-Message-State: APjAAAXs+LIYT38mTWGP9lpJFd6C0z02JdvPDc7GsHXw62EJBZimCl1M
        jovh7Iyr0rhU1OFBorJX7/4Qzw==
X-Google-Smtp-Source: APXvYqzGyFNFadHEXKzMtqjaygO6x8Ag7dOxW984fCNT8u/vHzZybu7VHdmVBESXMTtFJcKLm5r0zw==
X-Received: by 2002:a62:7656:: with SMTP id r83mr70618823pfc.56.1560481996220;
        Thu, 13 Jun 2019 20:13:16 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id x7sm1023931pfm.82.2019.06.13.20.13.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:15 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 31/45] arm/arm64: KVM: Add PSCI_VERSION helper
Date:   Fri, 14 Jun 2019 08:38:14 +0530
Message-Id: <0a350c8f3ce33baae43c1c800ea9747e398ef0fe.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit d0a144f12a7ca8368933eae6583c096c363ec506 upstream.

As we're about to trigger a PSCI version explosion, it doesn't
hurt to introduce a PSCI_VERSION helper that is going to be
used everywhere.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kvm/psci.c       | 4 +---
 include/kvm/arm_psci.h    | 6 ++++--
 include/uapi/linux/psci.h | 3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index b4acfec9b459..edf3d7fdcbdb 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -25,8 +25,6 @@
 
 #include <kvm/arm_psci.h>
 
-#include <uapi/linux/psci.h>
-
 /*
  * This is an implementation of the Power State Coordination Interface
  * as described in ARM document number ARM DEN 0022A.
@@ -220,7 +218,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		 * Bits[31:16] = Major Version = 0
 		 * Bits[15:0] = Minor Version = 2
 		 */
-		val = 2;
+		val = KVM_ARM_PSCI_0_2;
 		break;
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 2042bb909474..5659343580a3 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -18,8 +18,10 @@
 #ifndef __KVM_ARM_PSCI_H__
 #define __KVM_ARM_PSCI_H__
 
-#define KVM_ARM_PSCI_0_1	1
-#define KVM_ARM_PSCI_0_2	2
+#include <uapi/linux/psci.h>
+
+#define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
+#define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 3d7a0fc021a7..39930ca998cd 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -87,6 +87,9 @@
 		(((ver) & PSCI_VERSION_MAJOR_MASK) >> PSCI_VERSION_MAJOR_SHIFT)
 #define PSCI_VERSION_MINOR(ver)			\
 		((ver) & PSCI_VERSION_MINOR_MASK)
+#define PSCI_VERSION(maj, min)						\
+	((((maj) << PSCI_VERSION_MAJOR_SHIFT) & PSCI_VERSION_MAJOR_MASK) | \
+	 ((min) & PSCI_VERSION_MINOR_MASK))
 
 /* PSCI features decoding (>=1.0) */
 #define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT	1
-- 
2.21.0.rc0.269.g1a574e7a288b

