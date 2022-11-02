Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6894C6159DA
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKBDTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiKBDTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A191AD88;
        Tue,  1 Nov 2022 20:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8714617CB;
        Wed,  2 Nov 2022 03:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10EEC433D6;
        Wed,  2 Nov 2022 03:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359172;
        bh=iynURxrRBYrJ6NojP8lnzNky088vEQ/PHuoP5eoclyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Tvsw2SnCiq0L8jRuBBiIRe6tycsh1cSNioNSmeOAnw8MFjpkhJ2dZlmIzCkJUzBU
         qoMqe4QlzzPvyyUDKX7ZTkgzs7e+8IpXEnnU5nSbj6GT3uebMedMfwff4+F+FvQ2Z0
         Lb4gccBerrQ5zJ4UHkPuDlg8raQriCxFc8oVxPNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.10 87/91] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Date:   Wed,  2 Nov 2022 03:34:10 +0100
Message-Id: <20221102022057.526259928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h           |   20 ++++++++++++++------
 arch/arm64/kernel/head.S                  |    6 ++++--
 arch/arm64/kvm/reset.c                    |   10 ++++++----
 drivers/firmware/efi/libstub/arm64-stub.c |    2 +-
 4 files changed, 25 insertions(+), 13 deletions(-)

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
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -24,7 +24,7 @@ efi_status_t check_platform_features(voi
 		return EFI_SUCCESS;
 
 	tg = (read_cpuid(ID_AA64MMFR0_EL1) >> ID_AA64MMFR0_TGRAN_SHIFT) & 0xf;
-	if (tg != ID_AA64MMFR0_TGRAN_SUPPORTED) {
+	if (tg < ID_AA64MMFR0_TGRAN_SUPPORTED_MIN || tg > ID_AA64MMFR0_TGRAN_SUPPORTED_MAX) {
 		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
 			efi_err("This 64 KB granular kernel is not supported by your CPU\n");
 		else


