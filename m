Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59525F7D82
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbfKKS5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbfKKS5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFCD222C1;
        Mon, 11 Nov 2019 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498649;
        bh=jciIuqN6+XJ0SohuD/SxNfkHQ9OpVxARqL5y9dtpxGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+clynyva2d7wCrL1UoFWj3U+fkp2cKm6kA2OEbPyyeaA+spqvgcQ+wUK9V6eG/wx
         OPdafkbHOJWqroSNs/3m5gob+spbyEmlZkgWcupx99joOJa6rZFtPGvbPB+CaBItnC
         rRtiPDbSAinNxOVaqxdmJ979Lk6EBhrLxKh4b0hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 180/193] arm64: apply ARM64_ERRATUM_845719 workaround for Brahma-B53 core
Date:   Mon, 11 Nov 2019 19:29:22 +0100
Message-Id: <20191111181514.384894649@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit bfc97f9f199cb041cf897af3af096540948cc705 ]

The Broadcom Brahma-B53 core is susceptible to the issue described by
ARM64_ERRATUM_845719 so this commit enables the workaround to be applied
when executing on that core.

Since there are now multiple entries to match, we must convert the
existing ARM64_ERRATUM_845719 into an erratum list.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  3 +++
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/kernel/cpu_errata.c         | 13 +++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 47feda6c15bcc..8c87c68dcc324 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -91,6 +91,9 @@ stable kernels.
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX ITS    | #22375,24313    | CAVIUM_ERRATUM_22375        |
 +----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144        |
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index b1454d117cd2c..aca07c2f6e6e3 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -79,6 +79,7 @@
 #define CAVIUM_CPU_PART_THUNDERX_83XX	0x0A3
 #define CAVIUM_CPU_PART_THUNDERX2	0x0AF
 
+#define BRCM_CPU_PART_BRAHMA_B53	0x100
 #define BRCM_CPU_PART_VULCAN		0x516
 
 #define QCOM_CPU_PART_FALKOR_V1		0x800
@@ -105,6 +106,7 @@
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
 #define MIDR_CAVIUM_THUNDERX2 MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX2)
+#define MIDR_BRAHMA_B53 MIDR_CPU_MODEL(ARM_CPU_IMP_BRCM, BRCM_CPU_PART_BRAHMA_B53)
 #define MIDR_BRCM_VULCAN MIDR_CPU_MODEL(ARM_CPU_IMP_BRCM, BRCM_CPU_PART_VULCAN)
 #define MIDR_QCOM_FALKOR_V1 MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_FALKOR_V1)
 #define MIDR_QCOM_FALKOR MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_FALKOR)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 4465be78ee466..d9da4201ba858 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -743,6 +743,16 @@ static const struct midr_range erratum_1418040_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_845719
+static const struct midr_range erratum_845719_list[] = {
+	/* Cortex-A53 r0p[01234] */
+	MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
+	/* Brahma-B53 r0p[0] */
+	MIDR_REV(MIDR_BRAHMA_B53, 0, 0),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -783,10 +793,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
 	{
-	/* Cortex-A53 r0p[01234] */
 		.desc = "ARM erratum 845719",
 		.capability = ARM64_WORKAROUND_845719,
-		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
+		ERRATA_MIDR_RANGE_LIST(erratum_845719_list),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
-- 
2.20.1



