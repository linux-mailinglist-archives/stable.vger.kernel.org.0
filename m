Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5242A6103AD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiJ0VDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiJ0VCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:34 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12DC15FC7;
        Thu, 27 Oct 2022 13:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904094; x=1698440094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=9Kahb+orhjnAV05AznrvMjsB3aa/Mnd5iCCJYwehWVU=;
  b=caRrJg33dipDtXroHG66RGmeuGuEp9sHTG1UAGzC4RnkPUCcuosCZ4cd
   DMUv1TM2PSHa2LyW0mphHYeM+68XABaAfPS/6tsauX8LPDP1VqhJJLEQW
   bMWLFINBtcdznvAVFef1Ouh6wVNO+Noj4pcyx4UzfKMQcoPNCtSVLJPI6
   g=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:54:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 4A909416F7;
        Thu, 27 Oct 2022 20:54:49 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:54:41 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:54:41 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 03/34] x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header
Date:   Thu, 27 Oct 2022 13:54:29 -0700
Message-ID: <20221027205430.17122-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205430.17122-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205430.17122-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

commit 266d63a7d9d48c6d5dee486378ec0e8c86c4d74a upstream

Thomas noticed that the new arch/x86/include/asm/cpu_device_id.h header is
a train-wreck that didn't incorporate review feedback like not using __u8
in kernel-only headers.

While at it also fix all the *other* problems this header has:

 - Use canonical names for the header guards. It's inexplicable why a non-standard
   guard was used.

 - Don't define the header guard to 1. Plus annotate the closing #endif as done
   absolutely every other header. Again, an inexplicable source of noise.

 - Move the kernel API calls provided by this header next to each other, there's
   absolutely no reason to have them spread apart in the header.

 - Align the INTEL_CPU_DESC() macro initializations vertically, this is easier to
   read and it's also the canonical style.

 - Actually name the macro arguments properly: instead of 'mod, step, rev',
   spell out 'model, stepping, revision' - it's not like we have a lack of
   characters in this header.

 - Actually make arguments macro-safe - again it's inexplicable why it wasn't
   done properly to begin with.

Quite amazing how many problems a 41 lines header can contain.

This kind of code quality is unacceptable, and it slipped through the
review net of 2 developers and 2 maintainers, including myself, until
Thomas noticed it. :-/

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/cpu_device_id.h | 31 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 3417110574c1..31c379c1da41 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CPU_DEVICE_ID
-#define _CPU_DEVICE_ID 1
+#ifndef _ASM_X86_CPU_DEVICE_ID
+#define _ASM_X86_CPU_DEVICE_ID
 
 /*
  * Declare drivers belonging to specific x86 CPUs
@@ -9,8 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
-
 /*
  * Match specific microcode revisions.
  *
@@ -22,21 +20,22 @@ extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
  */
 
 struct x86_cpu_desc {
-	__u8	x86_family;
-	__u8	x86_vendor;
-	__u8	x86_model;
-	__u8	x86_stepping;
-	__u32	x86_microcode_rev;
+	u8	x86_family;
+	u8	x86_vendor;
+	u8	x86_model;
+	u8	x86_stepping;
+	u32	x86_microcode_rev;
 };
 
-#define INTEL_CPU_DESC(mod, step, rev) {			\
-	.x86_family = 6,					\
-	.x86_vendor = X86_VENDOR_INTEL,				\
-	.x86_model = mod,					\
-	.x86_stepping = step,					\
-	.x86_microcode_rev = rev,				\
+#define INTEL_CPU_DESC(model, stepping, revision) {		\
+	.x86_family		= 6,				\
+	.x86_vendor		= X86_VENDOR_INTEL,		\
+	.x86_model		= (model),			\
+	.x86_stepping		= (stepping),			\
+	.x86_microcode_rev	= (revision),			\
 }
 
+extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
-#endif
+#endif /* _ASM_X86_CPU_DEVICE_ID */
-- 
2.17.1

