Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062B9F7D7F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfKKS50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730824AbfKKS5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E683B2184C;
        Mon, 11 Nov 2019 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498641;
        bh=DM4dbc8qci9+aEw015cRNaVM6ammj5FoIyYGEmVmkZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3DByFK5KvcAX9czNGD4A6QQKPtTTVKHkjQhYBsUkb/QvoSxy1H100gBuUCwxG02Y
         BCe2tfcDWNjLL1TfBlFS/sxpy85KNFpTBXz7yzmBggLWfoTYZDUfXuumHDccoB0X2t
         pOrQ9Bh6gIp6vDMbAwIoyYQJcPG65dXPZeQmH3Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 178/193] arm64: cpufeature: Enable Qualcomm Falkor errata 1009 for Kryo
Date:   Mon, 11 Nov 2019 19:29:20 +0100
Message-Id: <20191111181514.236855312@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 36c602dcdd872e9f9b91aae5266b6d7d72b69b96 ]

The Kryo cores share errata 1009 with Falkor, so add their model
definitions and enable it for them as well.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[will: Update entry in silicon-errata.rst]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 +-
 arch/arm64/kernel/cpu_errata.c         | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 6e52d334bc555..47feda6c15bcc 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -124,7 +124,7 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
 +----------------+-----------------+-----------------+-----------------------------+
-| Qualcomm Tech. | Falkor v1       | E1009           | QCOM_FALKOR_ERRATUM_1009    |
+| Qualcomm Tech. | Kryo/Falkor v1  | E1009           | QCOM_FALKOR_ERRATUM_1009    |
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | QDF2400 ITS     | E0065           | QCOM_QDF2400_ERRATUM_0065   |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1e0b9ae9bf7e2..4465be78ee466 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -659,17 +659,23 @@ static const struct midr_range arm64_harden_el2_vectors[] = {
 #endif
 
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
-
-static const struct midr_range arm64_repeat_tlbi_cpus[] = {
+static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1009
-	MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0, 0, 0, 0),
+	{
+		ERRATA_MIDR_REV(MIDR_QCOM_FALKOR_V1, 0, 0)
+	},
+	{
+		.midr_range.model = MIDR_QCOM_KRYO,
+		.matches = is_kryo_midr,
+	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1286807
-	MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+	{
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+	},
 #endif
 	{},
 };
-
 #endif
 
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
@@ -825,7 +831,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Qualcomm erratum 1009, ARM erratum 1286807",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
-		ERRATA_MIDR_RANGE_LIST(arm64_repeat_tlbi_cpus),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = cpucap_multi_entry_cap_matches,
+		.match_list = arm64_repeat_tlbi_list,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_858921
-- 
2.20.1



