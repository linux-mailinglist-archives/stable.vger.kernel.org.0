Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7FDF4BC2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKHMg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHMgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:25 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8C0222CE;
        Fri,  8 Nov 2019 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216585;
        bh=O3Df2egrqzPiGFuLv9Icx067z6DRVdx5E5+uXkzuBQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5KuRm2yEPH+KoabBEDtgYBV/Xk7mZFV5Qe5ui0HT1R3EJmxs6N4jCy3l2DdmOWIi
         6Keq67Ex9hQWkFkKzxEUqEZ5JvaSxAgrXxcoG674KpK+HtPuEtn+/3Ar/OyVUpT2gz
         ROgkWqgwkSaORbT4HimRnpYm630wwAOxRLfJFZv8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
Date:   Fri,  8 Nov 2019 13:35:12 +0100
Message-Id: <20191108123554.29004-9-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

From: Marc Zyngier <marc.zyngier@arm.com>

commit 09e6be12effdb33bf7210c8867bbd213b66a499e upstream.

The new SMC Calling Convention (v1.1) allows for a reduced overhead
when calling into the firmware, and provides a new feature discovery
mechanism.

Make it visible to KVM guests.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[v4.9: account for files moved to virt/ upstream]
Signed-off-by: Mark Rutland <mark.rutland@arm.com> [v4.9 backport]
Tested-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ardb: restrict to include/linux/arm-smccc.h, drop KVM bits]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/arm-smccc.h | 22 +++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index b5abfda80465..8bf047eab116 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -14,9 +14,6 @@
 #ifndef __LINUX_ARM_SMCCC_H
 #define __LINUX_ARM_SMCCC_H
 
-#include <linux/linkage.h>
-#include <linux/types.h>
-
 /*
  * This file provides common defines for ARM SMC Calling Convention as
  * specified in
@@ -60,6 +57,24 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/linkage.h>
+#include <linux/types.h>
+
 /**
  * struct arm_smccc_res - Result from SMC/HVC call
  * @a0-a3 result values from registers 0 to 3
@@ -101,4 +116,5 @@ asmlinkage void arm_smccc_hvc(unsigned long a0, unsigned long a1,
 			unsigned long a5, unsigned long a6, unsigned long a7,
 			struct arm_smccc_res *res);
 
+#endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.20.1

