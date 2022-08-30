Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912F45A66EB
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiH3PIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiH3PIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 11:08:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61CF107C48
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:08:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-340e618b145so112738057b3.2
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=V33DPmShGPh7e6kGyQ9SJaUPnW5Oj51FJ3aQ+xAj4aQ=;
        b=P70NJWydtmbGVaF1z4k6j7WiG6v4k6UN7MzKmPwRsT5vKgmdW6Wk1ZLGaBIbY5KSUl
         mSfBON9xuusu6jeKIg+XjcnhFOp00MvmsXkhJ9U8nRnifMnS3Tu2HjIr/Nb/p54Co3xG
         ViUXUli+y2YnioPc6KqWWdM5zjO3Vi6qhtict1h/CEXESCqBbHgRnmG4nLrYal1XcJtn
         MArE/lN4Gp+RcBYJtOPYCxC8fAIofRb3u3Dr3QsK/MEWiETgLCy4hzf8fGufR4yjRRK9
         lUm5ktgc8wqL6TQDLfrcTCWPaTH7b7vVT1QjsdYvmAAllYCn5wwW5cHc55K7uzRaL4v8
         szqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=V33DPmShGPh7e6kGyQ9SJaUPnW5Oj51FJ3aQ+xAj4aQ=;
        b=VX02pny56pQC6h5TDs7DkON4EXVnxjSKIWlfnSoeQcbnKMIQk0okba/hGoCphgoRGf
         GWOouXrQccU5cVsZH6KRAoO6y14wAyPjLGacqZpXqWGLaYt8NlIo/Xpr50K35vlppAQY
         jGmFFfVYQwdP5DGhrkC74OPuh3Z0oyXBiqC7MuefBdG7kMZoIlYiSYfMq5FGiL4PLdmH
         2G/ZVBRtQQzkCjcFfuVF9xfa/QrRB91koLiRgKdQlLTrOm7PFRC7Tv8R08BsKxBMRHYx
         hHTAlkFVOg/aeFdKDHveMrn69I+w2pzQGFLEvVgYnJaxst3Fp7bl30Gr4PaqoijJKRcu
         AOjg==
X-Gm-Message-State: ACgBeo08l6trzibyVJIGuNYBKlKlFcw4ZQbLiHh8EmieWxizauKRs48v
        y6fp3cxlo3llhb2u30m1GkBFxlGthIu4/lFoKjW6SkxlYrC4JjOEyUiOt7GOVZb0MchSGFLxus7
        KRRj7hHZGGUMrYisoJ8NaUJVaWtuKQTmMgyVYq30HLrqYbjNnoT0Y5tqan8i7UeFiNlo=
X-Google-Smtp-Source: AA6agR57Uqe9NuxsH4LM/28Pazo9LNonh3DSngHKyHqKW1/7R63d4yc+NrrB9b1qdn8Q0sHECtKSo2SX1dSwuw==
X-Received: from lucaswei-z840lin.ntc.corp.google.com ([2401:fa00:fc:202:13a0:6ed1:4429:c921])
 (user=lucaswei job=sendgmr) by 2002:a81:85c5:0:b0:31c:1f50:1bbb with SMTP id
 v188-20020a8185c5000000b0031c1f501bbbmr13868756ywf.3.1661872113372; Tue, 30
 Aug 2022 08:08:33 -0700 (PDT)
Date:   Tue, 30 Aug 2022 23:08:04 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830150804.3425929-1-lucaswei@google.com>
Subject: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
From:   Lucas Wei <lucaswei@google.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     lucaswei@google.com, robinpeng@google.com, willdeacon@google.com,
        aaronding@google.com, danielmentz@google.com,
        James Morse <james.morse@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

Cortex-A510 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 0b4235b1f8c4..33b04db8408f 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -106,6 +106,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2077057        | ARM64_ERRATUM_2077057       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a5d1b561ed53..001eaba5a6b4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -838,6 +838,23 @@ config ARM64_ERRATUM_2224489
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2441009
+	bool "Cortex-A510: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	default y
+	select ARM64_WORKAROUND_REPEAT_TLBI
+	help
+	  This option adds a workaround for ARM Cortex-A510 erratum #2441009.
+
+	  Under very rare circumstances, affected Cortex-A510 CPUs
+	  may not handle a race between a break-before-make sequence on one
+	  CPU, and another CPU accessing the same page. This could allow a
+	  store to a page that has been unmapped.
+
+	  Work around this by adding the affected CPUs to the list that needs
+	  TLB sequences to be done twice.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2064142
 	bool "Cortex-A510: 2064142: workaround TRBE register writes while disabled"
 	depends on CORESIGHT_TRBE
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6b92989f4cc2..aa9609e6ca67 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -211,6 +211,12 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2441009
+	{
+		/* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+	},
 #endif
 	{},
 };
@@ -488,7 +494,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 	{
-		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
+		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
-- 


