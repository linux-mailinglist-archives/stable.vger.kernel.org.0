Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FE2613473
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 12:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJaLXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 07:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJaLXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 07:23:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4C4E08E;
        Mon, 31 Oct 2022 04:23:05 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N19cW5xCyz15MDn;
        Mon, 31 Oct 2022 19:18:03 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:23:03 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:23:01 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <james.morse@arm.com>,
        <anshuman.khandual@arm.com>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <maz@kernel.org>, <suzuki.poulose@arm.com>,
        <ardb@kernel.org>, <mark.rutland@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <anders.roxell@linaro.org>
Subject: [PATCH 5.10 2/2] arm64/kexec: Test page size support with new TGRAN range values
Date:   Mon, 31 Oct 2022 19:22:46 +0800
Message-ID: <20221031112246.1588-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20221031112246.1588-1-yuzenghui@huawei.com>
References: <20221031112246.1588-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 79d82cbcbb3d2a56c009ad6a6df92c5dee061dad upstream.

The commit 26f55386f964 ("arm64/mm: Fix __enable_mmu() for new TGRAN range
values") had already switched into testing ID_AA64MMFR0_TGRAN range values.
This just changes system_supports_[4|16|64]kb_granule() helpers to perform
similar range tests as well. While here, it standardizes page size specific
supported min and max TGRAN values.

Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/1626237975-1909-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  9 ++++++---
 arch/arm64/include/asm/sysreg.h     | 28 ++++++++++++++++------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 423f9b40e4d9..31ba0ac7db63 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -648,7 +648,8 @@ static inline bool system_supports_4kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN4_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_64kb_granule(void)
@@ -660,7 +661,8 @@ static inline bool system_supports_64kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN64_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_16kb_granule(void)
@@ -672,7 +674,8 @@ static inline bool system_supports_16kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN16_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_mixed_endian_el0(void)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 763a745af6a8..06755fad3830 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -786,12 +786,16 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
-#define ID_AA64MMFR0_TGRAN4_NI		0xf
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN64_NI		0xf
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN16_NI		0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_TGRAN4_NI			0xf
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN64_NI			0xf
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN16_NI			0x0
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN	0x1
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX	0xf
+
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -961,16 +965,16 @@
 
 #if defined(CONFIG_ARM64_4K_PAGES)
 #define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN4_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN4_SUPPORTED
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX
 #elif defined(CONFIG_ARM64_16K_PAGES)
 #define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN16_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN16_SUPPORTED
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0xF
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX
 #elif defined(CONFIG_ARM64_64K_PAGES)
 #define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN64_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN64_SUPPORTED
-#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX
 #endif
 
 #define MVFR2_FPMISC_SHIFT		4
-- 
2.33.0

