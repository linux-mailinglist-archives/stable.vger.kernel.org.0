Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF985A18E0
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfH2Lg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37625 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfH2Lg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id bj8so1453326plb.4
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yC2M+WqtpDn8WEqkn0+0Dw3Z53HTrfg3c6ZZe0WXdnU=;
        b=GxHvDA/6fmrmac7D30qhXaKJnx1ZeBV+vKF0Tl5JzbIvDOFX05R94gDcyfHQmLOLs1
         plEfoetXfkZlVD6jwNSSr7oRBDMLpXF1WXjHaM6r3KZ6yR/NLXnK/9xdwHwCJR6SrOI9
         Uh9KgJGdolnR8ogY8td4UHSXUXFbzv1+d2SksDGk/S1Uor4QDfVW4f15kIW/7Wnk90pV
         uLJVdO2pxy5/65zcH+bHojgJlKtkGrGb5anNzESVrsYjfXpk2M2brqhZOJXeGljU7Asi
         QiAmassVz/TKw/MKJQpLE7lUihCvmP7XSrpvpfsVaJlL1bQ+U+GUOVqgJ1LhBGmXRvvq
         Nh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yC2M+WqtpDn8WEqkn0+0Dw3Z53HTrfg3c6ZZe0WXdnU=;
        b=WO57AleN+qfWAXSXf9uQVh22JTwr0IdaQ+c3vydK/KMmxL4lfGrYL7C2NbvXwdUaTx
         T9YsEMYM1RIn17k8BI+bcDv6vuqX3FO99wU9bXl9uExi4oN90feOgt05oJqmU7VQCQGk
         F3peUqu4bO9XDxUlERl7cyH8P0P8BWOd7YqsTOqL8g1lFFYdnuDoLsQ4uTo3GlhLgvr+
         rexdvE9RuzpXuFfTwkV1D6Nt8CcFAdwTKG4MAFoUszbe1NCEKvBeDwMJfjWBx0TAu+fi
         kWio+9CKm360m2omFrs1qdMHdbWVWsw+p1IqkpKdKI9kMEchapRwbqFieI9Jot4gMdJC
         sYbg==
X-Gm-Message-State: APjAAAXZv1KiHVnv84pOKFFNfODWBklc9C9YaH7p6nndIJDtKxmkfeTD
        UUL6DiAcrwM0sGnGjfOstjkkemhhmOY=
X-Google-Smtp-Source: APXvYqx5d8XrcYQBxr7D45ys1DAr/pGsT/J8kM7yADQ1DxFf0pEobIAS1VJ1XjYoThFKRBwqHif4Lg==
X-Received: by 2002:a17:902:f30e:: with SMTP id gb14mr9461817plb.32.1567078585655;
        Thu, 29 Aug 2019 04:36:25 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id w2sm2198815pjr.27.2019.08.29.04.36.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:25 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 35/44] ARM: 8478/2: arm/arm64: add arm-smccc
Date:   Thu, 29 Aug 2019 17:04:20 +0530
Message-Id: <d3d100c6b807463c10962da5d0232cd965a47900.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

commit 98dd64f34f47ce19b388d9015f767f48393a81eb upstream.

Adds helpers to do SMC and HVC based on ARM SMC Calling Convention.
CONFIG_HAVE_ARM_SMCCC is enabled for architectures that may support the
SMC or HVC instruction. It's the responsibility of the caller to know if
the SMC instruction is supported by the platform.

This patch doesn't provide an implementation of the declared functions.
Later patches will bring in implementations and set
CONFIG_HAVE_ARM_SMCCC for ARM and ARM64 respectively.

Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ v4.4: Added #ifndef __ASSEMBLY__ section to fix compilation issues ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/firmware/Kconfig  |   3 ++
 include/linux/arm-smccc.h | 107 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 include/linux/arm-smccc.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index cf478fe6b335..49a3a1185bb6 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -173,6 +173,9 @@ config QCOM_SCM_64
 	def_bool y
 	depends on QCOM_SCM && ARM64
 
+config HAVE_ARM_SMCCC
+	bool
+
 source "drivers/firmware/broadcom/Kconfig"
 source "drivers/firmware/google/Kconfig"
 source "drivers/firmware/efi/Kconfig"
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
new file mode 100644
index 000000000000..611d10580340
--- /dev/null
+++ b/include/linux/arm-smccc.h
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2015, Linaro Limited
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __LINUX_ARM_SMCCC_H
+#define __LINUX_ARM_SMCCC_H
+
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+/*
+ * This file provides common defines for ARM SMC Calling Convention as
+ * specified in
+ * http://infocenter.arm.com/help/topic/com.arm.doc.den0028a/index.html
+ */
+
+#define ARM_SMCCC_STD_CALL		0
+#define ARM_SMCCC_FAST_CALL		1
+#define ARM_SMCCC_TYPE_SHIFT		31
+
+#define ARM_SMCCC_SMC_32		0
+#define ARM_SMCCC_SMC_64		1
+#define ARM_SMCCC_CALL_CONV_SHIFT	30
+
+#define ARM_SMCCC_OWNER_MASK		0x3F
+#define ARM_SMCCC_OWNER_SHIFT		24
+
+#define ARM_SMCCC_FUNC_MASK		0xFFFF
+
+#define ARM_SMCCC_IS_FAST_CALL(smc_val)	\
+	((smc_val) & (ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT))
+#define ARM_SMCCC_IS_64(smc_val) \
+	((smc_val) & (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT))
+#define ARM_SMCCC_FUNC_NUM(smc_val)	((smc_val) & ARM_SMCCC_FUNC_MASK)
+#define ARM_SMCCC_OWNER_NUM(smc_val) \
+	(((smc_val) >> ARM_SMCCC_OWNER_SHIFT) & ARM_SMCCC_OWNER_MASK)
+
+#define ARM_SMCCC_CALL_VAL(type, calling_convention, owner, func_num) \
+	(((type) << ARM_SMCCC_TYPE_SHIFT) | \
+	((calling_convention) << ARM_SMCCC_CALL_CONV_SHIFT) | \
+	(((owner) & ARM_SMCCC_OWNER_MASK) << ARM_SMCCC_OWNER_SHIFT) | \
+	((func_num) & ARM_SMCCC_FUNC_MASK))
+
+#define ARM_SMCCC_OWNER_ARCH		0
+#define ARM_SMCCC_OWNER_CPU		1
+#define ARM_SMCCC_OWNER_SIP		2
+#define ARM_SMCCC_OWNER_OEM		3
+#define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_TRUSTED_APP	48
+#define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
+#define ARM_SMCCC_OWNER_TRUSTED_OS	50
+#define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
+
+#ifndef __ASSEMBLY__
+
+/**
+ * struct arm_smccc_res - Result from SMC/HVC call
+ * @a0-a3 result values from registers 0 to 3
+ */
+struct arm_smccc_res {
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+};
+
+/**
+ * arm_smccc_smc() - make SMC calls
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This function is used to make SMC calls following SMC Calling Convention.
+ * The content of the supplied param are copied to registers 0 to 7 prior
+ * to the SMC instruction. The return values are updated with the content
+ * from register 0 to 3 on return from the SMC instruction.
+ */
+asmlinkage void arm_smccc_smc(unsigned long a0, unsigned long a1,
+			unsigned long a2, unsigned long a3, unsigned long a4,
+			unsigned long a5, unsigned long a6, unsigned long a7,
+			struct arm_smccc_res *res);
+
+/**
+ * arm_smccc_hvc() - make HVC calls
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This function is used to make HVC calls following SMC Calling
+ * Convention.  The content of the supplied param are copied to registers 0
+ * to 7 prior to the HVC instruction. The return values are updated with
+ * the content from register 0 to 3 on return from the HVC instruction.
+ */
+asmlinkage void arm_smccc_hvc(unsigned long a0, unsigned long a1,
+			unsigned long a2, unsigned long a3, unsigned long a4,
+			unsigned long a5, unsigned long a6, unsigned long a7,
+			struct arm_smccc_res *res);
+
+#endif /*__ASSEMBLY__*/
+#endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.21.0.rc0.269.g1a574e7a288b

