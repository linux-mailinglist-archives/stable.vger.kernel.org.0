Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74C46159DC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiKBDTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiKBDTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C81A83B;
        Tue,  1 Nov 2022 20:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A3F461799;
        Wed,  2 Nov 2022 03:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9690AC433C1;
        Wed,  2 Nov 2022 03:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359178;
        bh=VkO2kVt+Sc2OavXLWzRmHCXFLPmUkduyKof1p+g4S7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo1DME8VipSPQpXp+m86/deweiR7k0+3CvxAb+8yZfQkUJOpCEaX8I7CpEgeijr+I
         1hVl9ouNKm+bcHI3o5tgvzFX5mdJwOJJyx1YeKaQY+Vczlg5XiCpDo9ckmhN1ceyoi
         f4iPj9SKQ+HK+vN8uSZVLjQvo4vG1dxld9yNYPSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.10 88/91] arm64/kexec: Test page size support with new TGRAN range values
Date:   Wed,  2 Nov 2022 03:34:11 +0100
Message-Id: <20221102022057.553634951@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    9 ++++++---
 arch/arm64/include/asm/sysreg.h     |   28 ++++++++++++++++------------
 2 files changed, 22 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -648,7 +648,8 @@ static inline bool system_supports_4kb_g
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN4_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_64kb_granule(void)
@@ -660,7 +661,8 @@ static inline bool system_supports_64kb_
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN64_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_16kb_granule(void)
@@ -672,7 +674,8 @@ static inline bool system_supports_16kb_
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN16_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_mixed_endian_el0(void)
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


