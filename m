Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62847F7DAC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfKKS5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbfKKS5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA042184C;
        Mon, 11 Nov 2019 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498659;
        bh=Yg5APykiLBbTYygB+VJWegrWeN78ZT6GmOlo7CdiLaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af0WtYrWRuM6dTkFxT6foArhqbF4hQrXT0MZ+VdtGLF6FkGcs4jCxN0UeZtOgPqJJ
         IB7nL1zTkLaxs5dl1iMTldyOZvs1Ha2EqCJCvzV1gvpubNAi8HGJOIIoqu+SI3Cak2
         4OuLdF89e64p6v0RuDaDSdfMfbMNmwEazRaGuPas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 182/193] arm64: apply ARM64_ERRATUM_843419 workaround for Brahma-B53 core
Date:   Mon, 11 Nov 2019 19:29:24 +0100
Message-Id: <20191111181514.532157274@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 1cf45b8fdbb87040e1d1bd793891089f4678aa41 ]

The Broadcom Brahma-B53 core is susceptible to the issue described by
ARM64_ERRATUM_843419 so this commit enables the workaround to be applied
when executing on that core.

Since there are now multiple entries to match, we must convert the
existing ARM64_ERRATUM_843419 into an erratum list and use
cpucap_multi_entry_cap_matches to match our entries.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/kernel/cpu_errata.c         | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 8c87c68dcc324..d5f72a5b214f8 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -93,6 +93,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
 +----------------+-----------------+-----------------+-----------------------------+
+| Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_843419        |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX ITS    | #22375,24313    | CAVIUM_ERRATUM_22375        |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 799d62ef7a9bd..ed4c2f28f1576 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -755,6 +755,23 @@ static const struct midr_range erratum_845719_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_843419
+static const struct arm64_cpu_capabilities erratum_843419_list[] = {
+	{
+		/* Cortex-A53 r0p[01234] */
+		.matches = is_affected_midr_range,
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
+		MIDR_FIXED(0x4, BIT(8)),
+	},
+	{
+		/* Brahma-B53 r0p[0] */
+		.matches = is_affected_midr_range,
+		ERRATA_MIDR_REV(MIDR_BRAHMA_B53, 0, 0),
+	},
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -786,11 +803,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_843419
 	{
-	/* Cortex-A53 r0p[01234] */
 		.desc = "ARM erratum 843419",
 		.capability = ARM64_WORKAROUND_843419,
-		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
-		MIDR_FIXED(0x4, BIT(8)),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = cpucap_multi_entry_cap_matches,
+		.match_list = erratum_843419_list,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
-- 
2.20.1



