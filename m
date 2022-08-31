Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5175A7EBB
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 15:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiHaN3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiHaN3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 09:29:02 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8D0CE30D
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 06:29:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-340a4dcb403so183472867b3.22
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 06:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=XcECs4DJ31FnKjCsYhPthF9rexhGTfXS7wMQliShw4Q=;
        b=XTZx6f+SPHT5Zn+Z39YaPpsl8N2bLrFbXwTgWmGHu0S7SkiQnIiQephw44aZOL7Nch
         A/a1kbCqrTK7iRLMVaKmrAXi8dOyHQicv5EABLJ9WhdxdggPt4okS3XNt+/VNskofvTE
         3mPVgaWqsDKkJV/8LzMLFdygJo5X42REO8u4r+jqnfGU82K0kdwFNJp7gepd7BKZ7soo
         EpslChe6wEUp7ztUIxPIIIyfupCY6USKxZevJgA4Kxqii56pbLxGK0cl50595BvEOBcD
         mC30CamSSijs+BKuOiCP1TzVOQ83srzsZw13TNXOn7EU4lkAEV28JVdcAeqw5kZWXKtI
         AZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=XcECs4DJ31FnKjCsYhPthF9rexhGTfXS7wMQliShw4Q=;
        b=qJUdC54z0g2rht+8E3Xn7EqCQt6WZbigsLyNyKg5+c1o3Rbckij+HfRkyXKX1zXRCw
         IInJTvoeRqQqLzbnXhlKwKdCp7sCde0ZNMG2qYhWopKguVH9gZashvjzT9gC0dXmpyZG
         SS0mTnCdWPpTPPJBum7Bwyzk3S1jDC8OXs5NiID6b6IehFZe4Fp2c0JNJCnr9Uvmw8cO
         xtyHpHRegbb9H8IqBF/jd1dD0QWE/svB2AFz1yXACHbwimkGA7GOvemYu61zijpkspuh
         xtkEOHziaUcabW6vsYWkDzJ8x+Mcx8o7+8rtPWZwCBRZNy1BEleT66yOzIbxaogXEiWx
         05LQ==
X-Gm-Message-State: ACgBeo2G5ZLvTSWdlTalXVXvL8uTPr/UHbBkkaa9rzxCr8ngcMGd5teV
        3g+du4gwleke1JSQJLpjPkc5Q0C577zAqT6vpUnTWzzU6GmQpLiSaWMfDiSJXIjaqN13p/iGRbO
        a7A0CBnNhxOEEOOHbKvX+sec5es51uyQRnafRUvhRpgLJLJRMFZOWir9fBl2QjbmXUHA=
X-Google-Smtp-Source: AA6agR5FHKFGSGlh2NFsK1ycs2a+Q+yUhBXSjAzL8i4XN6rFiGC68dOu6fiUtJCH0YM0wSAbvOe8hA0vShEQ8Q==
X-Received: from lucaswei-z840lin.ntc.corp.google.com ([2401:fa00:fc:202:5fc0:c756:a05f:6e56])
 (user=lucaswei job=sendgmr) by 2002:a25:ac10:0:b0:690:a94a:97eb with SMTP id
 w16-20020a25ac10000000b00690a94a97ebmr15654951ybi.592.1661952540234; Wed, 31
 Aug 2022 06:29:00 -0700 (PDT)
Date:   Wed, 31 Aug 2022 21:27:25 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831132724.4101958-1-lucaswei@google.com>
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

commit 39fdb65f52e9a53d32a6ba719f96669fd300ae78 upstream.

Cortex-A510 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Lucas Wei <lucaswei@google.com>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 7c1750bcc5bd..46644736e583 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 69e7e293f72e..9d80c783142f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -666,6 +666,23 @@ config ARM64_ERRATUM_1508412
 
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
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index c67c19d70159..e1be45fc7f5b 100644
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
@@ -427,7 +433,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 	{
-		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
+		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,

base-commit: addc9003c2e895fe8a068a66de1de6fdb4c6ac60
-- 
2.37.2.672.g94769d06f0-goog

