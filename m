Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4ED1F4338
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732832AbgFIRv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732822AbgFIRv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:51:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F87620734;
        Tue,  9 Jun 2020 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725086;
        bh=8Ek3Viz9ic17MIFg/BdoH39M2OMxeaYTDzErvNY+nNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1almMziFfsbrTp+VRVPOtGz7d+G1cH9vabHA9iIRmvvBFNWn6CettsyfY48srIAv
         om0Wa0n6HD5zFUdhIzRoU2Mj1o2QuEj38qV4vXNKokXksFwljm6gkuhC/RKY0tHOmU
         HM9errtLpoarBBDWOKA05HJdPgSNBMGosJbhHT8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 4.19 19/25] x86/cpu: Add a steppings field to struct x86_cpu_id
Date:   Tue,  9 Jun 2020 19:45:09 +0200
Message-Id: <20200609174050.861051913@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174048.576094775@linuxfoundation.org>
References: <20200609174048.576094775@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 arch/x86/include/asm/cpu_device_id.h |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c          |    7 ++++++-
 include/linux/mod_devicetable.h      |    6 ++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -9,6 +9,33 @@
 
 #include <linux/mod_devicetable.h>
 
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
 
 #endif
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -34,13 +34,18 @@ const struct x86_cpu_id *x86_match_cpu(c
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
@@ -621,6 +621,10 @@ struct mips_cdmm_device_id {
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
@@ -629,6 +633,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
+	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -637,6 +642,7 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
+#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*


