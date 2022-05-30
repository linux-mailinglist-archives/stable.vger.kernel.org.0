Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AD8537BAA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiE3NZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiE3NZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:25:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E25E82166;
        Mon, 30 May 2022 06:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC15F60DD5;
        Mon, 30 May 2022 13:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C61C3411F;
        Mon, 30 May 2022 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917112;
        bh=x8Opey4gPhl/T9ZY27fZLs+uA+C7ZsiJ2XZJphbacJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKHKTt7+xhVfrrnu6sZgmNaBhSuxlqEVSpx75hod76TKMQUOAKYjkmV4fFm8tu1+S
         oc2ACxALtOUJ/4Lny7mqAdQi3E0Bj3mUIldZVVhAx0v6uDgTJPH2CtyLDsVpfh5U/b
         V9RAOiYn7195OjZyaepcz2zW7fsu1R051O845MJ/Ooi0fZn6oKQnZLTvvvgePxFZ31
         T7Q6NxZS1IewDn86CofaGP+HSCYycAIij3cUwLdmNIN1lIS9u0wxVATw3JXxsjfyM7
         M1PWXleUSdxIzCyYMC0pJYoUGyTDfbkFAsjAgtyQzouM4GCq05B0vJP5U0UFoR08fC
         vnoo17Z41lSWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org
Subject: [PATCH AUTOSEL 5.18 019/159] ACPICA: Avoid cache flush inside virtual machines
Date:   Mon, 30 May 2022 09:22:04 -0400
Message-Id: <20220530132425.1929512-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

[ Upstream commit e2efb6359e620521d1e13f69b2257de8ceaa9475 ]

While running inside virtual machine, the kernel can bypass cache
flushing. Changing sleep state in a virtual machine doesn't affect the
host system sleep state and cannot lead to data loss.

Before entering sleep states, the ACPI code flushes caches to prevent
data loss using the WBINVD instruction.  This mechanism is required on
bare metal.

But, any use WBINVD inside of a guest is worthless.  Changing sleep
state in a virtual machine doesn't affect the host system sleep state
and cannot lead to data loss, so most hypervisors simply ignore it.
Despite this, the ACPI code calls WBINVD unconditionally anyway.
It's useless, but also normally harmless.

In TDX guests, though, WBINVD stops being harmless; it triggers a
virtualization exception (#VE).  If the ACPI cache-flushing WBINVD
were left in place, TDX guests would need handling to recover from
the exception.

Avoid using WBINVD whenever running under a hypervisor.  This both
removes the useless WBINVDs and saves TDX from implementing WBINVD
handling.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20220405232939.73860-30-kirill.shutemov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/acenv.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/acenv.h b/arch/x86/include/asm/acenv.h
index 9aff97f0de7f..d937c55e717e 100644
--- a/arch/x86/include/asm/acenv.h
+++ b/arch/x86/include/asm/acenv.h
@@ -13,7 +13,19 @@
 
 /* Asm macros */
 
-#define ACPI_FLUSH_CPU_CACHE()	wbinvd()
+/*
+ * ACPI_FLUSH_CPU_CACHE() flushes caches on entering sleep states.
+ * It is required to prevent data loss.
+ *
+ * While running inside virtual machine, the kernel can bypass cache flushing.
+ * Changing sleep state in a virtual machine doesn't affect the host system
+ * sleep state and cannot lead to data loss.
+ */
+#define ACPI_FLUSH_CPU_CACHE()					\
+do {								\
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))	\
+		wbinvd();					\
+} while (0)
 
 int __acpi_acquire_global_lock(unsigned int *lock);
 int __acpi_release_global_lock(unsigned int *lock);
-- 
2.35.1

