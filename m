Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE4CFDD9
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfJHPkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfJHPkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so19988600wrd.3
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0Ll+cn1Z5T2Pfe8NP5R+UwThO0oMcc1htOSDXSVIpY=;
        b=PxDaDH2HGSTXbe8j2jdQ0F5aNPczREiGJ3IgO4cVYi5hdYsx06jqhLDO7fwYHs0xur
         ML7c+nfBISC0NSKhNveEtvqBHn2vKXEhajIdaHx9YHrhwR+dGhb/P5lhC3welZuuOJO6
         7UO4/a3vjj0km4g5t9hzTLrAjJP6usFbt4FP5q+ZVjgVQVjjGbTqU2JOQLh5Ke7GiZaA
         Bs4W4+EgqqYBy4Qt8LoPFfNJU2MFBfNyFR07aJfxRlRNk+MWmxD/1xsXtHNPUtlOSBGL
         vU1Fi31L+fREo2L+23VSMqS0eThBgPYb4q33QcSuG7NF7TdV+/RDpozRKHY9iOaWc3kH
         0SCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0Ll+cn1Z5T2Pfe8NP5R+UwThO0oMcc1htOSDXSVIpY=;
        b=uX6pjZVoGgFMBvPY3PUNh8aAxUL8q061EzpINBzHzLjd+4k5fJvC6oDfiIC0AOhwTh
         RlXwROsYKSY3yj5p1P1uH+4hFxh2VFTlxqv0OvvnvxTMlKBRQJ6I2RsdYMeG1HWVYVHc
         kly1CvOfUpbZRIx97zZFfW0aJzPJMvWjHp/VOoDW0NJYkaiIp0wneWPqM9X5XqS7j5EF
         aHhhAgC4Aqqk4uwvUZ+E0AuBp91eQt8fWXbmRT5L8HBFo2/Pl37pp7wfhF/KFawVWGnF
         TFha9yluxVMUbBIaWHNtQJPFhyK+bdEAydB/Up7k7w9zR6r0NZeQ2HLkf4JeliGixsDs
         eopA==
X-Gm-Message-State: APjAAAXx3fvvgdcq+M9vwJfvq+dQSM7QIi4C7VYi7BmejWMrg7cdMkbF
        jk9UEtilJxY2nfjpjEEUOeiEAw==
X-Google-Smtp-Source: APXvYqz8QWTEYwm7VRclOdErpep6/Sqp+XboWEGOpbS74+T3zHUStUuTLhddFS25GyXCNBHaTcEbGw==
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr23040139wrq.343.1570549220750;
        Tue, 08 Oct 2019 08:40:20 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:19 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 10/16] arm64: Provide a command line to disable spectre_v2 mitigation
Date:   Tue,  8 Oct 2019 17:39:24 +0200
Message-Id: <20191008153930.15386-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit e5ce5e7267ddcbe13ab9ead2542524e1b7993e5a ]

There are various reasons, such as benchmarking, to disable spectrev2
mitigation on a machine. Provide a command-line option to do so.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++----
 arch/arm64/kernel/cpu_errata.c                  | 13 +++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e8ddf0ef232e..cc2f5c9a8161 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2866,10 +2866,10 @@
 			(bounds check bypass). With this option data leaks
 			are possible in the system.
 
-	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
-			(indirect branch prediction) vulnerability. System may
-			allow data leaks with this option, which is equivalent
-			to spectre_v2=off.
+	nospectre_v2	[X86,PPC_FSL_BOOK3E,ARM64] Disable all mitigations for
+			the Spectre variant 2 (indirect branch prediction)
+			vulnerability. System may allow data leaks with this
+			option.
 
 	nospec_store_bypass_disable
 			[HW] Disable all mitigations for the Speculative Store Bypass vulnerability
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 10571a378f4c..2394a105ebf4 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -189,6 +189,14 @@ static void qcom_link_stack_sanitization(void)
 		     : "=&r" (tmp));
 }
 
+static bool __nospectre_v2;
+static int __init parse_nospectre_v2(char *str)
+{
+	__nospectre_v2 = true;
+	return 0;
+}
+early_param("nospectre_v2", parse_nospectre_v2);
+
 static void
 enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 {
@@ -200,6 +208,11 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
 		return;
 
+	if (__nospectre_v2) {
+		pr_info_once("spectrev2 mitigation disabled by command line option\n");
+		return;
+	}
+
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 		return;
 
-- 
2.20.1

