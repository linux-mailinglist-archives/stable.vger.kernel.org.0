Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A721E34DAF2
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhC2WYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhC2WWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8156196E;
        Mon, 29 Mar 2021 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056533;
        bh=DPeTCw/WWlAXsi9cSHxRAN8amnCVOudZDZzM/W+sUPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdTlG4gcshXQFSKjkx5ig8nveMFa5nW3pg1Njj/L2gnFW7JU9Kn43zD6tmVLR4QIF
         dEPKF214wu0B7cjiSSdmGWx+yaYqBfXaJlk67o/DsLpUyBhKhlijyZrkxVOVhNIG1i
         ux1i0aCQHo2ZPtPNNsV/wkQb4uG96RhdKdbKWLLIg+NG+J6Kwl+ltHXXK2yejMp/rs
         DVbVrh94A8ttIP9T3v8ZkjJG+WgNdBSX47wAXLs+TUQyo8dLK7bb1KsvrzOnpg4zpq
         xFxVmz3O9AxMhN9FtGPVveUP7VmoTuFJCA/+A3LFdI9QB+AHCGRUv+WzMjx/nJ7Tzg
         rNcFHkhCnRRvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rich Wiley <rwiley@nvidia.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 31/38] arm64: kernel: disable CNP on Carmel
Date:   Mon, 29 Mar 2021 18:21:26 -0400
Message-Id: <20210329222133.2382393-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rich Wiley <rwiley@nvidia.com>

[ Upstream commit 20109a859a9b514eb10c22b8a14b5704ffe93897 ]

On NVIDIA Carmel cores, CNP behaves differently than it does on standard
ARM cores. On Carmel, if two cores have CNP enabled and share an L2 TLB
entry created by core0 for a specific ASID, a non-shareable TLBI from
core1 may still see the shared entry. On standard ARM cores, that TLBI
will invalidate the shared entry as well.

This causes issues with patchsets that attempt to do local TLBIs based
on cpumasks instead of broadcast TLBIs. Avoid these issues by disabling
CNP support for NVIDIA Carmel cores.

Signed-off-by: Rich Wiley <rwiley@nvidia.com>
Link: https://lore.kernel.org/r/20210324002809.30271-1-rwiley@nvidia.com
[will: Fix pre-existing whitespace issue]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  3 +++
 arch/arm64/Kconfig                     | 10 ++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         |  8 ++++++++
 arch/arm64/kernel/cpufeature.c         |  5 ++++-
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 719510247292..d410a47ffa57 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -130,6 +130,9 @@ stable kernels.
 | Marvell        | ARM-MMU-500     | #582743         | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| NVIDIA         | Carmel Core     | N/A             | NVIDIA_CARMEL_CNP_ERRATUM   |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e42da99db91f..2517dd8c5a4d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -805,6 +805,16 @@ config QCOM_FALKOR_ERRATUM_E1041
 
 	  If unsure, say Y.
 
+config NVIDIA_CARMEL_CNP_ERRATUM
+	bool "NVIDIA Carmel CNP: CNP on Carmel semantically different than ARM cores"
+	default y
+	help
+	  If CNP is enabled on Carmel cores, non-sharable TLBIs on a core will not
+	  invalidate shared TLB entries installed by a different core, as it would
+	  on standard ARM cores.
+
+	  If unsure, say Y.
+
 config SOCIONEXT_SYNQUACER_PREITS
 	bool "Socionext Synquacer: Workaround for GICv3 pre-ITS"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index b77d997b173b..c40f2490cd7b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_HAS_LDAPR				59
 #define ARM64_KVM_PROTECTED_MODE		60
+#define ARM64_WORKAROUND_NVIDIA_CARMEL_CNP	61
 
-#define ARM64_NCAPS				61
+#define ARM64_NCAPS				62
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a63428301f42..3fc281e4e655 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -527,6 +527,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 				  0, 0,
 				  1, 0),
 	},
+#endif
+#ifdef CONFIG_NVIDIA_CARMEL_CNP_ERRATUM
+	{
+		/* NVIDIA Carmel */
+		.desc = "NVIDIA Carmel CNP erratum",
+		.capability = ARM64_WORKAROUND_NVIDIA_CARMEL_CNP,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 33b6f56dcb21..b1f7bfadab9f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1270,7 +1270,10 @@ has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
 	 * may share TLB entries with a CPU stuck in the crashed
 	 * kernel.
 	 */
-	 if (is_kdump_kernel())
+	if (is_kdump_kernel())
+		return false;
+
+	if (cpus_have_const_cap(ARM64_WORKAROUND_NVIDIA_CARMEL_CNP))
 		return false;
 
 	return has_cpuid_feature(entry, scope);
-- 
2.30.1

