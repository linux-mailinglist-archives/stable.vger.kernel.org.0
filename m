Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A27961346D
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 12:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJaLXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 07:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiJaLXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 07:23:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A95E08E;
        Mon, 31 Oct 2022 04:23:03 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N19cb2YwQzVj84;
        Mon, 31 Oct 2022 19:18:07 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:23:02 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:23:00 +0800
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
Subject: [PATCH 5.10 1/2] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Date:   Mon, 31 Oct 2022 19:22:45 +0800
Message-ID: <20221031112246.1588-2-yuzenghui@huawei.com>
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

From: James Morse <james.morse@arm.com>

commit 26f55386f964cefa92ab7ccbed68f1a313074215 upstream.

As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
might contain a range of values to describe supported translation granules
(4K and 16K pages sizes in particular) instead of just enabled or disabled
values. This changes __enable_mmu() function to handle complete acceptable
range of values (depending on whether the field is signed or unsigned) now
represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
also fix similar situations in EFI stub and KVM as well.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/1615355590-21102-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h           | 20 ++++++++++++++------
 arch/arm64/kernel/head.S                  |  6 ++++--
 arch/arm64/kvm/reset.c                    | 10 ++++++----
 drivers/firmware/efi/libstub/arm64-stub.c |  2 +-
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1f2209ad2cca..763a745af6a8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -795,6 +795,11 @@
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
+
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
 #else
@@ -955,14 +960,17 @@
 #define ID_PFR1_PROGMOD_SHIFT		0
 
 #if defined(CONFIG_ARM64_4K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN4_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN4_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN4_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN4_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0x7
 #elif defined(CONFIG_ARM64_16K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN16_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN16_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN16_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN16_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0xF
 #elif defined(CONFIG_ARM64_64K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN64_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN64_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN64_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN64_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	0x7
 #endif
 
 #define MVFR2_FPMISC_SHIFT		4
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index f9119eea735e..e1c25fa3b8e6 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -797,8 +797,10 @@ SYM_FUNC_END(__secondary_too_slow)
 SYM_FUNC_START(__enable_mmu)
 	mrs	x2, ID_AA64MMFR0_EL1
 	ubfx	x2, x2, #ID_AA64MMFR0_TGRAN_SHIFT, 4
-	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
-	b.ne	__no_granule_support
+	cmp     x2, #ID_AA64MMFR0_TGRAN_SUPPORTED_MIN
+	b.lt    __no_granule_support
+	cmp     x2, #ID_AA64MMFR0_TGRAN_SUPPORTED_MAX
+	b.gt    __no_granule_support
 	update_early_cpu_boot_status 0, x2, x3
 	adrp	x2, idmap_pg_dir
 	phys_to_ttbr x1, x1
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 204c62debf06..6f85c1821c3f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -397,16 +397,18 @@ int kvm_set_ipa_limit(void)
 	}
 
 	switch (cpuid_feature_extract_unsigned_field(mmfr0, tgran_2)) {
-	default:
-	case 1:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE:
 		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
 		return -EINVAL;
-	case 0:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT:
 		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
 		break;
-	case 2:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN ... ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX:
 		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
 		break;
+	default:
+		kvm_err("Unsupported value for TGRAN_2, giving up\n");
+		return -EINVAL;
 	}
 
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 415a971e7694..7f4bafcd9d33 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -24,7 +24,7 @@ efi_status_t check_platform_features(void)
 		return EFI_SUCCESS;
 
 	tg = (read_cpuid(ID_AA64MMFR0_EL1) >> ID_AA64MMFR0_TGRAN_SHIFT) & 0xf;
-	if (tg != ID_AA64MMFR0_TGRAN_SUPPORTED) {
+	if (tg < ID_AA64MMFR0_TGRAN_SUPPORTED_MIN || tg > ID_AA64MMFR0_TGRAN_SUPPORTED_MAX) {
 		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
 			efi_err("This 64 KB granular kernel is not supported by your CPU\n");
 		else
-- 
2.33.0

