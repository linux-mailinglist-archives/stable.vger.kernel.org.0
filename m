Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CAF6322B4
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiKUMpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiKUMo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B52FBFF5E
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D335B80D7F
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A905C433D6;
        Mon, 21 Nov 2022 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034684;
        bh=O5etzNARcIoGYIBmtBpA8p388Hm1Ts+fjnCCY6nKNes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnNbC+bsiPRqDYqQLiY896dIQmhqy9n5bXsLWidPQaq9p+QZAilYY38kxb+w4GM7M
         bBsihDO42HpQH1LzpN3/rO8L1VcB1iBqvNiXHOlPk3Bsv0Vqb+np/u5f6VBCnguMJG
         DBbHPTTQU/aUtFDEB2kGdrh81c/PFkJV8dwiqviM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 02/34] Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
Date:   Mon, 21 Nov 2022 13:43:24 +0100
Message-Id: <20221121124150.971506489@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suleiman Souhlal <suleiman@google.com>

This reverts commit 6f2f28e71e6af993761b7a70bd2402a8d2096acf.

This is commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream. Reverting this
commit makes the following patches apply cleanly. This patch is then reapplied.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h |   27 ---------------------------
 arch/x86/kernel/cpu/match.c          |    7 +------
 include/linux/mod_devicetable.h      |    6 ------
 3 files changed, 1 insertion(+), 39 deletions(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -9,33 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
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
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 
 #endif
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -34,18 +34,13 @@ const struct x86_cpu_id *x86_match_cpu(c
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
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -621,10 +621,6 @@ struct mips_cdmm_device_id {
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
@@ -633,7 +629,6 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
-	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -642,7 +637,6 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*


