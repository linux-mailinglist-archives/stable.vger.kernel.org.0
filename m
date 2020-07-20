Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C299226894
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbgGTQHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732952AbgGTQHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F6F20672;
        Mon, 20 Jul 2020 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261270;
        bh=1mwQxeH1sKwF0Vvv4pn91hOjwotml+EqP6fGsLwU0Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vROzD8xEXgD7gAc+/l+vXQM3zycq/aVHvjCKI1ysKVOwLYAsr1lkUotLCXJZRPFI8
         e6zpMM6CeUuDp85IJQL3u9XykM5R4F/YH+p6P0epth7FvOenm12qBi4nXZqhOz/lRZ
         k9ABgSvC8mRsth4knTliwILypIJH5ScQ+xhyIBmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 056/244] arm64: Add KRYO4XX gold CPU cores to erratum list 1463225 and 1418040
Date:   Mon, 20 Jul 2020 17:35:27 +0200
Message-Id: <20200720152828.524047985@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit a9e821b89daa55cc940c546b124101939d3f0451 ]

KRYO4XX gold/big CPU core revisions r0p0 to r3p1 are affected by
erratum 1463225 and 1418040, so add them to the respective list.
The variant and revision bits are implementation defined and are
different from the their Cortex CPU counterparts on which they are
based on, i.e., (r0p0 to r3p1) is equivalent to (rcpe to rfpf).

Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/83780e80c6377c12ca51b5d53186b61241685e49.1593539394.git.saiprakash.ranjan@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/kernel/cpu_errata.c         | 19 +++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 2c08c628febdf..6902feba6b412 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -147,6 +147,10 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Falkor v{1,2}   | E1041           | QCOM_FALKOR_ERRATUM_1041    |
 +----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1463225       |
++----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1418040       |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0f37045fafab3..e0f8474979b19 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -472,12 +472,7 @@ static bool
 has_cortex_a76_erratum_1463225(const struct arm64_cpu_capabilities *entry,
 			       int scope)
 {
-	u32 midr = read_cpuid_id();
-	/* Cortex-A76 r0p0 - r3p1 */
-	struct midr_range range = MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 1);
-
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range(midr, &range) && is_kernel_in_hyp_mode();
+	return is_affected_midr_range_list(entry, scope) && is_kernel_in_hyp_mode();
 }
 #endif
 
@@ -728,6 +723,8 @@ static const struct midr_range erratum_1418040_list[] = {
 	MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 1),
 	/* Neoverse-N1 r0p0 to r3p1 */
 	MIDR_RANGE(MIDR_NEOVERSE_N1, 0, 0, 3, 1),
+	/* Kryo4xx Gold (rcpe to rfpf) => (r0p0 to r3p1) */
+	MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xf),
 	{},
 };
 #endif
@@ -773,6 +770,15 @@ static const struct midr_range erratum_speculative_at_vhe_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1463225
+static const struct midr_range erratum_1463225[] = {
+	/* Cortex-A76 r0p0 - r3p1 */
+	MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 1),
+	/* Kryo4xx Gold (rcpe to rfpf) => (r0p0 to r3p1) */
+	MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xf),
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -912,6 +918,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_1463225,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_cortex_a76_erratum_1463225,
+		.midr_range_list = erratum_1463225,
 	},
 #endif
 #ifdef CONFIG_CAVIUM_TX2_ERRATUM_219
-- 
2.25.1



