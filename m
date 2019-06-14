Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B545282
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFNDNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33548 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:22 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so386346plo.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yC2M+WqtpDn8WEqkn0+0Dw3Z53HTrfg3c6ZZe0WXdnU=;
        b=WmcnbRBlcrJ3IY9xi/BpOaVweisIwA209RaPUwI7iSrlOTsC7QIVtv11a++G0ymVy7
         7/d/e7VeS1Blvy4ln/zT1GMlpYXFOnxjRGhRK46l6U0++5CH5OxVJgM3nYwedYcr1Sle
         oDzoFzaqUV04aFnHFxAXamISMuLuvK/1aD7zUY4r9+NCaMrNwNb4wlkrxzVumU0D9+Z6
         T2iUSYDPHRgTLloTFhTVt6JlnrJ6q1Xqtd4HeF1lDvu2En8MYfAfcVMV7OrT0F4SZaXu
         mxcZPmSigde4P5X5BaV8Lxqw5wOkLPQPbd9ia1kHlKJKVZ0Xf1lGzFRtTLUs0my/AxvO
         T4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yC2M+WqtpDn8WEqkn0+0Dw3Z53HTrfg3c6ZZe0WXdnU=;
        b=JuD2gmjpPVLqEku5hc3W27LrZGTNJr/TlMzQeUnSRFcDVk+zdH9o89jkAk2DEznPJU
         lSE9Eday7AjHCctkSNSLCrH4DE+XglYpc1G0s7hjJt98G7IJLCeNnimzFe3eqixyW24D
         GDq0nw02CelWmXU+9zMOxQhKytTEXISHHJ0Gbh81mmAlqhQsLCU4tlfDmMHSSqaEpP9Y
         IAfV8eZp8NU1NUFYo7YsuQK5Ool4Lkkk9fPEQHV8u9FWUT6fzh5zx0cVxehiou6rfr0m
         umJq5ASPmrJC2OxI+hXIB7LhjLNfKrg0Wf92ZbzsLoje3VWimHfoHoNwd51X/akqQJRz
         clcg==
X-Gm-Message-State: APjAAAXeRUnPuraxwxrY9pqTX1XGe69NS6L/BUxhCXnjNQI5Odle1q7V
        nQmv0oI5RjFtJAXROOgE0II43w==
X-Google-Smtp-Source: APXvYqzUJl9Sg4Y4+3JJovtQD1uCkXXEmQspFedgwUHEnuiI9WeCF8uwvGONeY8SRIc2tPUgt/E34A==
X-Received: by 2002:a17:902:7007:: with SMTP id y7mr36617088plk.28.1560482001151;
        Thu, 13 Jun 2019 20:13:21 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id r88sm1527732pjb.8.2019.06.13.20.13.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:20 -0700 (PDT)
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
Subject: [PATCH v4.4 33/45] ARM: 8478/2: arm/arm64: add arm-smccc
Date:   Fri, 14 Jun 2019 08:38:16 +0530
Message-Id: <d96f0b5549581dbcc095f61d3dcc0163f8043470.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

