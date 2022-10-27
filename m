Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB846103B5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiJ0VDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiJ0VCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:38 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FE11B1CF;
        Thu, 27 Oct 2022 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904096; x=1698440096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=czKhN6dhPG6+34wxHzNpw6mpujEI4u/ttDPwToFES7o=;
  b=a+yL3OJFUzH/UncfrlxY1qJVtrgFXXg3pICk6gwOZecUVWg/sq/WEwIu
   Rtc/CQUpronhyqvFegMC/pju9HvNFyPts4RmaYU+cKwfU2ZOcRz48No/v
   Yw3oZX7egRv0QFT9dh1sjgjouRIU/oJ/hW2bO088GAC3E0r/+yidsoiGF
   c=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="257153007"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:54:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 382FE81BB6;
        Thu, 27 Oct 2022 20:54:52 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:54:50 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.162.178) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:54:50 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 05/34] x86/cpu: Add consistent CPU match macros
Date:   Thu, 27 Oct 2022 13:54:39 -0700
Message-ID: <20221027205442.17210-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027204801.13146-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 20d437447c0089cda46c683db219d3b4e2cde40e upstream

Finding all places which build x86_cpu_id match tables is tedious and the
logic is hidden in lots of differently named macro wrappers.

Most of these initializer macros use plain C89 initializers which rely on
the ordering of the struct members. So new members could only be added at
the end of the struct, but that's ugly as hell and C99 initializers are
really the right thing to use.

Provide a set of macros which:

  - Have a proper naming scheme, starting with X86_MATCH_

  - Use C99 initializers

The set of provided macros are all subsets of the base macro

    X86_MATCH_VENDOR_FAM_MODEL_FEATURE()

which allows to supply all possible selection criteria:

      vendor, family, model, feature

The other macros shorten this to avoid typing all arguments when they are
not needed and would require one of the _ANY constants. They have been
created due to the requirements of the existing usage sites.

Also add a few model constants for Centaur CPUs and QUARK.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/20200320131508.826011988@linutronix.de
---
 arch/x86/include/asm/cpu_device_id.h | 140 +++++++++++++++++++++++++--
 arch/x86/include/asm/intel-family.h  |   6 ++
 arch/x86/kernel/cpu/match.c          |  13 ++-
 3 files changed, 146 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index a28dc6ba5be1..f11770fac73a 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -5,21 +5,143 @@
 /*
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
- */
-#include <linux/mod_devicetable.h>
-
-/*
+ *
  * The wildcard initializers are in mod_devicetable.h because
  * file2alias needs them. Sigh.
  */
+#include <linux/mod_devicetable.h>
+/* Get the INTEL_FAM* model defines */
+#include <asm/intel-family.h>
+/* And the X86_VENDOR_* ones */
+#include <asm/processor.h>
 
-#define X86_FEATURE_MATCH(x) {			\
-	.vendor		= X86_VENDOR_ANY,	\
-	.family		= X86_FAMILY_ANY,	\
-	.model		= X86_MODEL_ANY,	\
-	.feature	= x,			\
+/* Centaur FAM6 models */
+#define X86_CENTAUR_FAM6_C7_A		0xa
+#define X86_CENTAUR_FAM6_C7_D		0xd
+#define X86_CENTAUR_FAM6_NANO		0xf
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE - Base macro for CPU matching
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * Use only if you need all selectors. Otherwise use one of the shorter
+ * macros of the X86_MATCH_* family. If there is no matching shorthand
+ * macro, consider to add one. If you really need to wrap one of the macros
+ * into another macro at the usage site for good reasons, then please
+ * start this local macro with X86_MATCH to allow easy grepping.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_FEATURE(_vendor, _family, _model,	\
+					   _feature, _data) {		\
+	.vendor		= X86_VENDOR_##_vendor,				\
+	.family		= _family,					\
+	.model		= _model,					\
+	.feature	= _feature,					\
+	.driver_data	= (unsigned long) _data				\
 }
 
+/**
+ * X86_MATCH_VENDOR_FAM_FEATURE - Macro for matching vendor, family and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_FEATURE(vendor, family, feature, data)	\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family,		\
+					   X86_MODEL_ANY, feature, data)
+
+/**
+ * X86_MATCH_VENDOR_FEATURE - Macro for matching vendor and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FEATURE(vendor, feature, data)			\
+	X86_MATCH_VENDOR_FAM_FEATURE(vendor, X86_FAMILY_ANY, feature, data)
+
+/**
+ * X86_MATCH_FEATURE - Macro for matching a CPU feature
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_FEATURE(feature, data)				\
+	X86_MATCH_VENDOR_FEATURE(ANY, feature, data)
+
+/* Transitional to keep the existing code working */
+#define X86_FEATURE_MATCH(feature)	X86_MATCH_FEATURE(feature, NULL)
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL - Match vendor, family and model
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @model:	The model number, model constant or X86_MODEL_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, data)		\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family, model,	\
+					   X86_FEATURE_ANY, data)
+
+/**
+ * X86_MATCH_VENDOR_FAM - Match vendor and family
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments to X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set of wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM(vendor, family, data)			\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, X86_MODEL_ANY, data)
+
+/**
+ * X86_MATCH_INTEL_FAM6_MODEL - Match vendor INTEL, family 6 and model
+ * @model:	The model name without the INTEL_FAM6_ prefix or ANY
+ *		The model name is expanded to INTEL_FAM6_@model internally
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * The vendor is set to INTEL, the family to 6 and all other missing
+ * arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are set to wildcards.
+ *
+ * See X86_MATCH_VENDOR_FAM_MODEL_FEATURE() for further information.
+ */
+#define X86_MATCH_INTEL_FAM6_MODEL(model, data)				\
+	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 6, INTEL_FAM6_##model, data)
+
 /*
  * Match specific microcode revisions.
  *
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 05d2d7169ab8..7811d42e78ef 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -16,6 +16,9 @@
  * that group keep the CPUID for the variants sorted by model number.
  */
 
+/* Wildcard match for FAM6 so X86_MATCH_INTEL_FAM6_MODEL(ANY) works */
+#define INTEL_FAM6_ANY			X86_MODEL_ANY
+
 #define INTEL_FAM6_CORE_YONAH		0x0E
 
 #define INTEL_FAM6_CORE2_MEROM		0x0F
@@ -103,4 +106,7 @@
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
 #define INTEL_FAM6_XEON_PHI_KNM		0x85 /* Knights Mill */
 
+/* Family 5 */
+#define INTEL_FAM5_QUARK_X1000		0x09 /* Quark X1000 SoC */
+
 #endif /* _ASM_X86_INTEL_FAMILY_H */
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 6dd78d8235e4..d3482eb43ff3 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -16,12 +16,17 @@
  * respective wildcard entries.
  *
  * A typical table entry would be to match a specific CPU
- * { X86_VENDOR_INTEL, 6, 0x12 }
- * or to match a specific CPU feature
- * { X86_FEATURE_MATCH(X86_FEATURE_FOOBAR) }
+ *
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_BROADWELL,
+ *				      X86_FEATURE_ANY, NULL);
  *
  * Fields can be wildcarded with %X86_VENDOR_ANY, %X86_FAMILY_ANY,
- * %X86_MODEL_ANY, %X86_FEATURE_ANY or 0 (except for vendor)
+ * %X86_MODEL_ANY, %X86_FEATURE_ANY (except for vendor)
+ *
+ * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
+ * for various common selections. The above can be shortened to:
+ *
+ * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
-- 
2.17.1

