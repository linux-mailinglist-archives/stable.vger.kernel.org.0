Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2D55F30B7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJCNLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJCNLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:11:12 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB554DB1D;
        Mon,  3 Oct 2022 06:11:05 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 5B56842FB4;
        Mon,  3 Oct 2022 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802664;
        bh=iuze0yy4jlKvAn7S9Oll1rNrneXEjeFUpLO0U56AsdU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cp9X+u+S5oAsPIpWvzcps+DGa6xAwURFZ2nqLUV+FKQqePdJRxBkwqkbjh2sQ0GHz
         8aEdQ1FVj5VupZI/xRomP39eGZUhySXIkUjPzU5S2EPXf2vKios0cbA7theDPPu5Cn
         UfEKFCm/QPlPzXFxorQRa+OR3h0LeM2BV1542lnn50tcvqSNk/gZDBrSoaebrM9KoC
         FuXg6EzUaVl+BY8lmqfH5z4NWbhaeQ7UEmN9hwda6Yk+5rtZYSYMX2ooQ/KjX04lm4
         qS6q4a2qWF4bpbjBhPg5DKkrmLgBMjW8lnI1SLifnp574k5Amlr8gYmwIi6qu9abXm
         rlYg0ZCjAZ3eg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 02/37] Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
Date:   Mon,  3 Oct 2022 10:10:03 -0300
Message-Id: <20221003131038.12645-3-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 749ec6b48a9a41f95154cd5aa61053aaeb7c7aff.

This is commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream. A proper
backport will be done. This will make it easier to check for parts affected
by Retbleed, which require X86_MATCH_VENDOR_FAM_MODEL.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/cpu_device_id.h | 30 ----------------------------
 arch/x86/kernel/cpu/match.c          |  7 +------
 include/linux/mod_devicetable.h      |  6 ------
 3 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 0c814cd9ea42..31c379c1da41 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -9,36 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-#define X86_CENTAUR_FAM6_C7_D		0xd
-#define X86_CENTAUR_FAM6_NANO		0xf
-
-#define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
-
-/**
- * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU matching
- * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
- *		The name is expanded to X86_VENDOR_@_vendor
- * @_family:	The family number or X86_FAMILY_ANY
- * @_model:	The model number, model constant or X86_MODEL_ANY
- * @_steppings:	Bitmask for steppings, stepping constant or X86_STEPPING_ANY
- * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
- * @_data:	Driver specific data or NULL. The internal storage
- *		format is unsigned long. The supplied value, pointer
- *		etc. is casted to unsigned long internally.
- *
- * Backport version to keep the SRBDS pile consistant. No shorter variants
- * required for this.
- */
-#define X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(_vendor, _family, _model, \
-						    _steppings, _feature, _data) { \
-	.vendor		= X86_VENDOR_##_vendor,				\
-	.family		= _family,					\
-	.model		= _model,					\
-	.steppings	= _steppings,					\
-	.feature	= _feature,					\
-	.driver_data	= (unsigned long) _data				\
-}
-
 /*
  * Match specific microcode revisions.
  *
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 2f163e6646b6..6dd78d8235e4 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -34,18 +34,13 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	const struct x86_cpu_id *m;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	for (m = match;
-	     m->vendor | m->family | m->model | m->steppings | m->feature;
-	     m++) {
+	for (m = match; m->vendor | m->family | m->model | m->feature; m++) {
 		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
 			continue;
 		if (m->family != X86_FAMILY_ANY && c->x86 != m->family)
 			continue;
 		if (m->model != X86_MODEL_ANY && c->x86_model != m->model)
 			continue;
-		if (m->steppings != X86_STEPPING_ANY &&
-		    !(BIT(c->x86_stepping) & m->steppings))
-			continue;
 		if (m->feature != X86_FEATURE_ANY && !cpu_has(c, m->feature))
 			continue;
 		return m;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 4c56404e53a7..04a19e30b168 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -657,10 +657,6 @@ struct mips_cdmm_device_id {
 /*
  * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
  * Although gcc seems to ignore this error, clang fails without this define.
- *
- * Note: The ordering of the struct is different from upstream because the
- * static initializers in kernels < 5.7 still use C89 style while upstream
- * has been converted to proper C99 initializers.
  */
 #define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
@@ -669,7 +665,6 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
-	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -678,7 +673,6 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*
-- 
2.34.1

