Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3211E5F535E
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJELdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJELdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718837548E;
        Wed,  5 Oct 2022 04:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5BB0B81DB3;
        Wed,  5 Oct 2022 11:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E7AC433C1;
        Wed,  5 Oct 2022 11:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969585;
        bh=wRsN4cDX9MSmYZUpIrwDnd3bDx0R1YmsP+dixY+4siI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFF6tgWcnOKtKJs0j0NpVgqG/KocvjYRCS+MGAO+TlaKFWD+SF7nUIAIUxHKuq9k1
         7LK/EEsH3PuMsJjRM/BKRsf9kdpil86B9PxNYNV6oz740N/LFHpoJA7BHklLc6Ka+8
         W8hSentRqvpyHLJI93Ujmursdzq/AgeiglMQ/W1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Gross <mgross@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 05/51] x86/cpu: Add a steppings field to struct x86_cpu_id
Date:   Wed,  5 Oct 2022 13:31:53 +0200
Message-Id: <20221005113210.501228600@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: Mark Gross <mgross@linux.intel.com>

commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream.

Intel uses the same family/model for several CPUs. Sometimes the
stepping must be checked to tell them apart.

On x86 there can be at most 16 steppings. Add a steppings bitmask to
x86_cpu_id and a X86_MATCH_VENDOR_FAMILY_MODEL_STEPPING_FEATURE macro
and support for matching against family/model/stepping.

 [ bp: Massage. ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[cascardo: have steppings be the last member as there are initializers
 that don't use named members]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h |   27 ++++++++++++++++++++++++---
 arch/x86/kernel/cpu/match.c          |    7 ++++++-
 include/linux/mod_devicetable.h      |    6 ++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -20,12 +20,14 @@
 #define X86_CENTAUR_FAM6_C7_D		0xd
 #define X86_CENTAUR_FAM6_NANO		0xf
 
+#define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
 /**
- * X86_MATCH_VENDOR_FAM_MODEL_FEATURE - Base macro for CPU matching
+ * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU matching
  * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
  *		The name is expanded to X86_VENDOR_@_vendor
  * @_family:	The family number or X86_FAMILY_ANY
  * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_steppings:	Bitmask for steppings, stepping constant or X86_STEPPING_ANY
  * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
  * @_data:	Driver specific data or NULL. The internal storage
  *		format is unsigned long. The supplied value, pointer
@@ -37,16 +39,35 @@
  * into another macro at the usage site for good reasons, then please
  * start this local macro with X86_MATCH to allow easy grepping.
  */
-#define X86_MATCH_VENDOR_FAM_MODEL_FEATURE(_vendor, _family, _model,	\
-					   _feature, _data) {		\
+#define X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(_vendor, _family, _model, \
+						    _steppings, _feature, _data) { \
 	.vendor		= X86_VENDOR_##_vendor,				\
 	.family		= _family,					\
 	.model		= _model,					\
+	.steppings	= _steppings,					\
 	.feature	= _feature,					\
 	.driver_data	= (unsigned long) _data				\
 }
 
 /**
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE - Macro for CPU matching
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * The steppings arguments of X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE() is
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family, model, feature, data) \
+	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(vendor, family, model, \
+						X86_STEPPING_ANY, feature, data)
+
+/**
  * X86_MATCH_VENDOR_FAM_FEATURE - Macro for matching vendor, family and CPU feature
  * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
  *		The name is expanded to X86_VENDOR_@vendor
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -39,13 +39,18 @@ const struct x86_cpu_id *x86_match_cpu(c
 	const struct x86_cpu_id *m;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	for (m = match; m->vendor | m->family | m->model | m->feature; m++) {
+	for (m = match;
+	     m->vendor | m->family | m->model | m->steppings | m->feature;
+	     m++) {
 		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
 			continue;
 		if (m->family != X86_FAMILY_ANY && c->x86 != m->family)
 			continue;
 		if (m->model != X86_MODEL_ANY && c->x86_model != m->model)
 			continue;
+		if (m->steppings != X86_STEPPING_ANY &&
+		    !(BIT(c->x86_stepping) & m->steppings))
+			continue;
 		if (m->feature != X86_FEATURE_ANY && !cpu_has(c, m->feature))
 			continue;
 		return m;
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -657,6 +657,10 @@ struct mips_cdmm_device_id {
 /*
  * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
  * Although gcc seems to ignore this error, clang fails without this define.
+ *
+ * Note: The ordering of the struct is different from upstream because the
+ * static initializers in kernels < 5.7 still use C89 style while upstream
+ * has been converted to proper C99 initializers.
  */
 #define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
@@ -665,12 +669,14 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
+	__u16 steppings;
 };
 
 /* Wild cards for x86_cpu_id::vendor, family, model and feature */
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
+#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*


