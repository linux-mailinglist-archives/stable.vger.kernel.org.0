Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB564D4A18
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbiCJOV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243879AbiCJOS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F273168093;
        Thu, 10 Mar 2022 06:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43976B81E9E;
        Thu, 10 Mar 2022 14:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8940FC340F4;
        Thu, 10 Mar 2022 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921670;
        bh=O/puTpS0vTBgPhZGErm9BWdP2JhT+u4Mnv+wuMe7TjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owIl5h8AK5ees5dIkycR3GYtX6a3widgxM33AqUczv7GycbK6/m9oPR9xELVdljaJ
         V8rNfvJs2hu5gcDd1+yFdnSc9v8nZQaTeIJ7IsGDPzp/m8N5KXlBiP25cS48OPok6D
         vBgQA7q86w4LZaBBHDy7odPzwButaZy8+SFCrc0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.9 17/38] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
Date:   Thu, 10 Mar 2022 15:13:30 +0100
Message-Id: <20220310140808.640604649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

commit 541625ac47ce9d0835efaee0fcbaa251b0000a37 upstream.

SMCCC 1.1 calls may use either HVC or SMC depending on the PSCI
conduit. Rather than coding this in every call site, provide a macro
which uses the correct instruction. The macro also handles the case
where no conduit is configured/available returning a not supported error
in res, along with returning the conduit used for the call.

This allow us to remove some duplicated code and will be useful later
when adding paravirtualized time hypervisor calls.

Signed-off-by: Steven Price <steven.price@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/arm-smccc.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -311,5 +311,63 @@ asmlinkage void __arm_smccc_hvc(unsigned
 #define SMCCC_RET_NOT_SUPPORTED			-1
 #define SMCCC_RET_NOT_REQUIRED			-2
 
+/*
+ * Like arm_smccc_1_1* but always returns SMCCC_RET_NOT_SUPPORTED.
+ * Used when the SMCCC conduit is not defined. The empty asm statement
+ * avoids compiler warnings about unused variables.
+ */
+#define __fail_smccc_1_1(...)						\
+	do {								\
+		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
+		if (___res)						\
+			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
+	} while (0)
+
+/*
+ * arm_smccc_1_1_invoke() - make an SMCCC v1.1 compliant call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro will make either an HVC call or an SMC call depending on the
+ * current SMCCC conduit. If no valid conduit is available then -1
+ * (SMCCC_RET_NOT_SUPPORTED) is returned in @res.a0 (if supplied).
+ *
+ * The return value also provides the conduit that was used.
+ */
+#define arm_smccc_1_1_invoke(...) ({					\
+		int method = arm_smccc_1_1_get_conduit();		\
+		switch (method) {					\
+		case SMCCC_CONDUIT_HVC:					\
+			arm_smccc_1_1_hvc(__VA_ARGS__);			\
+			break;						\
+		case SMCCC_CONDUIT_SMC:					\
+			arm_smccc_1_1_smc(__VA_ARGS__);			\
+			break;						\
+		default:						\
+			__fail_smccc_1_1(__VA_ARGS__);			\
+			method = SMCCC_CONDUIT_NONE;			\
+			break;						\
+		}							\
+		method;							\
+	})
+
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/


