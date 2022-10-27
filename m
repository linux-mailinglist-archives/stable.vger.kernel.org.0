Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6C6103B0
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiJ0VDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiJ0VCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:36 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0791B1D5;
        Thu, 27 Oct 2022 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904095; x=1698440095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=HhKbIg4tzcUqelSNODWjqI3XMAhvpBqdGkitTiC4IOU=;
  b=KMNyMfeH2mf4yw4RQbh4Gwuu99D1PXVgUqwROj7niTotZkZ942OqID59
   XgmFiB/8GDtxFaKgg2ljxMS31ewnaVwTvobro9IsB8pVvGSwOMLRKSCHz
   C53uoe38p2oeZuoApkXJlpTisVb5T8GInUh4HxJQ+557+EKqFTGUh0OSV
   o=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="260700167"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:54:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 47F37417DA;
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
Subject: [PATCH 4.14 06/34] x86/cpu: Add a steppings field to struct x86_cpu_id
Date:   Thu, 27 Oct 2022 13:54:40 -0700
Message-ID: <20221027205442.17210-2-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205442.17210-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205442.17210-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Gross <mgross@linux.intel.com>

commit e9d7144597b10ff13ff2264c059f7d4a7fbc89ac upstream

Intel uses the same family/model for several CPUs. Sometimes the
stepping must be checked to tell them apart.

On x86 there can be at most 16 steppings. Add a steppings bitmask to
x86_cpu_id and a X86_MATCH_VENDOR_FAMILY_MODEL_STEPPING_FEATURE macro
and support for matching against family/model/stepping.

 [ bp: Massage.
   tglx: Lightweight variant for backporting ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h | 27 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c          |  7 ++++++-
 include/linux/mod_devicetable.h      |  6 ++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index f11770fac73a..e54babe529c7 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -168,6 +168,33 @@ struct x86_cpu_desc {
 	.x86_microcode_rev	= (revision),			\
 }
 
+#define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU matching
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_steppings:	Bitmask for steppings, stepping constant or X86_STEPPING_ANY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * Backport version to keep the SRBDS pile consistant. No shorter variants
+ * required for this.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(_vendor, _family, _model, \
+						    _steppings, _feature, _data) { \
+	.vendor		= X86_VENDOR_##_vendor,				\
+	.family		= _family,					\
+	.model		= _model,					\
+	.steppings	= _steppings,					\
+	.feature	= _feature,					\
+	.driver_data	= (unsigned long) _data				\
+}
+
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index d3482eb43ff3..ad6776081e60 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -39,13 +39,18 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
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
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e57cd43989fe..97794823eabd 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -589,6 +589,10 @@ struct mips_cdmm_device_id {
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
@@ -597,12 +601,14 @@ struct x86_cpu_id {
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
-- 
2.17.1

