Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205CB4528C
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfFNDNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39769 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so494706pfe.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kulBovnYLz4YjgSJ0sOniJhX8Qcc8ljUXoag6+mJQMI=;
        b=ZuPth7El82cfeoWv8qXI0kULOoymbsqUIM1ht3vdgKpkGkPrBhXQjROt8Y46oqOOZN
         NW0wSdYyeYqZbWOn8EkbIGVulRgHXgcl8gWsNQFY5Ho5YsDuostC4jlQrdPSLMXql821
         uIPnibCnCusSMq9GlFaiDZs7zRIL5CXUIWhDrasfXcSXkC/b5kIdkIu3IJXUoBJI5D9m
         72+PNQK90lICef7SjkbVshOMWasZqTLV07YKmMK9uetNJrv+ZQGx4PZmsbyGy5FJyYxH
         nN5PgAknmx1xcU9tLut4myAh+yT9NN1ZatTB4RArnw5pHuc+UhsIfPdarUdobDXL18LY
         HfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kulBovnYLz4YjgSJ0sOniJhX8Qcc8ljUXoag6+mJQMI=;
        b=Li6blahh0b4kYoWtV1lQ1k65hki3c4GWhT8g1OK53hvwBACA/vD6N+JrMOVwbvOp2y
         xkeBxjMrB6M83FLlWrpP/mieDEECIBy98lcbpWe33FAAwclIUpAOokbxaux44PrGuKLj
         6us9rMzG3fTWBjdJDPcJaSNt8sVAkHn1mL5Svatmzi652wfki2qC4Nx3bkT4xBeWatkZ
         cgPIYT//hrcPuqBbFG3EvKA/Z0n6LkSLxIxasCKAlPn5CpjJKNdnDOe21MLO0d1+CEVy
         Z1zrSATtn4swANRjGiLDETi1iJx255Yxzc2UzKjbmofNtcKzpZDITeBfKl7UzTgg6Tto
         8bwQ==
X-Gm-Message-State: APjAAAVuyzyMdpBNPsZnUCyUSa93IKXZqLc8MmsmET/o2YMTmcs4l5kE
        EU65XCR/fHhWz1IJgj2WSZ3hmQ==
X-Google-Smtp-Source: APXvYqx0Kkci7UqnQCFalHHZtOTO2SjyfHBEjwe2NpR5FtlxaURVTZ0I9PFv4Aq0n91C/9rOr621Ww==
X-Received: by 2002:a63:6ecf:: with SMTP id j198mr20165303pgc.437.1560482024157;
        Thu, 13 Jun 2019 20:13:44 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id l44sm1270624pje.29.2019.06.13.20.13.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:43 -0700 (PDT)
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
Subject: [PATCH v4.4 42/45] arm/arm64: smccc: Implement SMCCC v1.1 inline primitive
Date:   Fri, 14 Jun 2019 08:38:25 +0530
Message-Id: <ca843383a8f027d3401268ff89aec8cb6b23dcde.1560480942.git.viresh.kumar@linaro.org>
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

commit f2d3b2e8759a5833df6f022e42df2d581e6d843c upstream.

One of the major improvement of SMCCC v1.1 is that it only clobbers
the first 4 registers, both on 32 and 64bit. This means that it
becomes very easy to provide an inline version of the SMC call
primitive, and avoid performing a function call to stash the
registers that would otherwise be clobbered by SMCCC v1.0.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/arm-smccc.h | 141 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 4c45fd75db5d..60c2ad6316d8 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -122,5 +122,146 @@ asmlinkage void arm_smccc_hvc(unsigned long a0, unsigned long a1,
 			unsigned long a5, unsigned long a6, unsigned long a7,
 			struct arm_smccc_res *res);
 
+/* SMCCC v1.1 implementation madness follows */
+#ifdef CONFIG_ARM64
+
+#define SMCCC_SMC_INST	"smc	#0"
+#define SMCCC_HVC_INST	"hvc	#0"
+
+#elif defined(CONFIG_ARM)
+#include <asm/opcodes-sec.h>
+#include <asm/opcodes-virt.h>
+
+#define SMCCC_SMC_INST	__SMC(0)
+#define SMCCC_HVC_INST	__HVC(0)
+
+#endif
+
+#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
+
+#define __count_args(...)						\
+	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
+
+#define __constraint_write_0						\
+	"+r" (r0), "=&r" (r1), "=&r" (r2), "=&r" (r3)
+#define __constraint_write_1						\
+	"+r" (r0), "+r" (r1), "=&r" (r2), "=&r" (r3)
+#define __constraint_write_2						\
+	"+r" (r0), "+r" (r1), "+r" (r2), "=&r" (r3)
+#define __constraint_write_3						\
+	"+r" (r0), "+r" (r1), "+r" (r2), "+r" (r3)
+#define __constraint_write_4	__constraint_write_3
+#define __constraint_write_5	__constraint_write_4
+#define __constraint_write_6	__constraint_write_5
+#define __constraint_write_7	__constraint_write_6
+
+#define __constraint_read_0
+#define __constraint_read_1
+#define __constraint_read_2
+#define __constraint_read_3
+#define __constraint_read_4	"r" (r4)
+#define __constraint_read_5	__constraint_read_4, "r" (r5)
+#define __constraint_read_6	__constraint_read_5, "r" (r6)
+#define __constraint_read_7	__constraint_read_6, "r" (r7)
+
+#define __declare_arg_0(a0, res)					\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register unsigned long r1 asm("r1");				\
+	register unsigned long r2 asm("r2");				\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_1(a0, a1, res)					\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register unsigned long r2 asm("r2");				\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_2(a0, a1, a2, res)				\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register typeof(a2)    r2 asm("r2") = a2;			\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_3(a0, a1, a2, a3, res)				\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register typeof(a2)    r2 asm("r2") = a2;			\
+	register typeof(a3)    r3 asm("r3") = a3
+
+#define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
+	__declare_arg_3(a0, a1, a2, a3, res);				\
+	register typeof(a4) r4 asm("r4") = a4
+
+#define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
+	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
+	register typeof(a5) r5 asm("r5") = a5
+
+#define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
+	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
+	register typeof(a6) r6 asm("r6") = a6
+
+#define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
+	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
+	register typeof(a7) r7 asm("r7") = a7
+
+#define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
+#define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
+
+#define ___constraints(count)						\
+	: __constraint_write_ ## count					\
+	: __constraint_read_ ## count					\
+	: "memory"
+#define __constraints(count)	___constraints(count)
+
+/*
+ * We have an output list that is not necessarily used, and GCC feels
+ * entitled to optimise the whole sequence away. "volatile" is what
+ * makes it stick.
+ */
+#define __arm_smccc_1_1(inst, ...)					\
+	do {								\
+		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		asm volatile(inst "\n"					\
+			     __constraints(__count_args(__VA_ARGS__)));	\
+		if (___res)						\
+			*___res = (typeof(*___res)){r0, r1, r2, r3};	\
+	} while (0)
+
+/*
+ * arm_smccc_1_1_smc() - make an SMCCC v1.1 compliant SMC call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro is used to make SMC calls following SMC Calling Convention v1.1.
+ * The content of the supplied param are copied to registers 0 to 7 prior
+ * to the SMC instruction. The return values are updated with the content
+ * from register 0 to 3 on return from the SMC instruction if not NULL.
+ */
+#define arm_smccc_1_1_smc(...)	__arm_smccc_1_1(SMCCC_SMC_INST, __VA_ARGS__)
+
+/*
+ * arm_smccc_1_1_hvc() - make an SMCCC v1.1 compliant HVC call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro is used to make HVC calls following SMC Calling Convention v1.1.
+ * The content of the supplied param are copied to registers 0 to 7 prior
+ * to the HVC instruction. The return values are updated with the content
+ * from register 0 to 3 on return from the HVC instruction if not NULL.
+ */
+#define arm_smccc_1_1_hvc(...)	__arm_smccc_1_1(SMCCC_HVC_INST, __VA_ARGS__)
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.21.0.rc0.269.g1a574e7a288b

