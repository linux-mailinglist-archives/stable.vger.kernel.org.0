Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4C66130DB
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJaHCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaHCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50384BC31
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E022460FE9
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3487C433D6;
        Mon, 31 Oct 2022 07:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199732;
        bh=W4VyP3LkI/36PuB6z9Emmh72hZcJQm/7g0X7OFjW9IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUOKv2crzxFnrT3ZpGy5HngR8YRuOy2cyXbApOFczOhweT5PfOKTXo8lQQiOcAkCV
         Xt98+PSACVU0woIhDeQ1vFI9sOPRvgaeFgv77yxcmRP1cdmYwLo+xtknkrlPngGARq
         /5U8k5FbI7cgfa5mYwU3jFtIE5E97VKpSpMGfrw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 01/34] Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"
Date:   Mon, 31 Oct 2022 08:02:34 +0100
Message-Id: <20221031070140.147079986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Suraj Jitindar Singh <surajjs@amazon.com>

This reverts commit ae585de4296413ae4bbb8f2ac09faa38ff78f4cd.

This is commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream. Reverting this
commit makes the following patches apply cleanly. This patch is then reapplied.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
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
@@ -589,10 +589,6 @@ struct mips_cdmm_device_id {
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
@@ -601,7 +597,6 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
-	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -610,7 +605,6 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*


