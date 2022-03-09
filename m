Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE9B4D334F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiCIQLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiCIQHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:07:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1A7145AD5;
        Wed,  9 Mar 2022 08:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D9B461666;
        Wed,  9 Mar 2022 16:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B07C340E8;
        Wed,  9 Mar 2022 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841835;
        bh=0pT0F4nlPGnHUHDLi+M/CClvusdGck96cayN7JdG+0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qop546wVX3FhmhPPKza0Q89aDAoomRSqirxXyzqEn9Ja2vaF8FQbh5ETDpGcqRFSM
         Nkxk2J8Tz9w9k4qHTjUVXN7aVYImWzRbJklU0kn9y1VjwE+QPqXSen80YLxiOY9eol
         ilUit7eJ4bSAuEDt92YkdpoVlXcd2MMDbsZu1JEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 11/18] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
Date:   Wed,  9 Mar 2022 17:00:00 +0100
Message-Id: <20220309155856.886465553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
References: <20220309155856.552503355@linuxfoundation.org>
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
@@ -304,5 +304,63 @@ asmlinkage void __arm_smccc_hvc(unsigned
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


