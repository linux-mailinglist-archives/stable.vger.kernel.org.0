Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A094E6103AB
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbiJ0VC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbiJ0VCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:33 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB2EF00C;
        Thu, 27 Oct 2022 13:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904088; x=1698440088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dJvYCpOAdCjd9/3g2fkVS+3aDUOrfwYD/A6WJmmN1jI=;
  b=SSXYOgVm1mx7/W2Zhe5okuD/vmsnFebLxJtVPitXZxS+wgaptr+ppStb
   X900oPY/jvhsObs4VXdOX/gCBd2l88Qtbz8JaBHdJpS6R31Cv1dGHcEnZ
   zuDOuH3ZYlZug0MNqwzZMu+wDHF+IZNUfcN8wztwwY5w4jRmP9HC8eyfr
   c=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="145243564"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:54:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id ED8A761158;
        Thu, 27 Oct 2022 20:54:48 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:54:41 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:54:40 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 02/34] x86/cpufeature: Add facility to check for min microcode revisions
Date:   Thu, 27 Oct 2022 13:54:28 -0700
Message-ID: <20221027205430.17122-2-surajjs@amazon.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 0f42b790c9ba5ec2f25b7da8b0b6d361082d67b0 upstream

For bug workarounds or checks, it is useful to check for specific
microcode revisions.

Add a new generic function to match the CPU with stepping.
Add the other function to check the min microcode revisions for
the matched CPU.

A new table format is introduced to facilitate the quirk to
fill the related information.

This does not change the existing x86_cpu_id because it's an ABI
shared with modules, and also has quite different requirements,
as in no wildcards, but everything has to be matched exactly.

Originally-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com
Link: https://lkml.kernel.org/r/1549319013-4522-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/cpu_device_id.h | 28 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c          | 31 ++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index baeba0567126..3417110574c1 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -11,4 +11,32 @@
 
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 
+/*
+ * Match specific microcode revisions.
+ *
+ * vendor/family/model/stepping must be all set.
+ *
+ * Only checks against the boot CPU.  When mixed-stepping configs are
+ * valid for a CPU model, add a quirk for every valid stepping and
+ * do the fine-tuning in the quirk handler.
+ */
+
+struct x86_cpu_desc {
+	__u8	x86_family;
+	__u8	x86_vendor;
+	__u8	x86_model;
+	__u8	x86_stepping;
+	__u32	x86_microcode_rev;
+};
+
+#define INTEL_CPU_DESC(mod, step, rev) {			\
+	.x86_family = 6,					\
+	.x86_vendor = X86_VENDOR_INTEL,				\
+	.x86_model = mod,					\
+	.x86_stepping = step,					\
+	.x86_microcode_rev = rev,				\
+}
+
+extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
+
 #endif
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 3fed38812eea..6dd78d8235e4 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -48,3 +48,34 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	return NULL;
 }
 EXPORT_SYMBOL(x86_match_cpu);
+
+static const struct x86_cpu_desc *
+x86_match_cpu_with_stepping(const struct x86_cpu_desc *match)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	const struct x86_cpu_desc *m;
+
+	for (m = match; m->x86_family | m->x86_model; m++) {
+		if (c->x86_vendor != m->x86_vendor)
+			continue;
+		if (c->x86 != m->x86_family)
+			continue;
+		if (c->x86_model != m->x86_model)
+			continue;
+		if (c->x86_stepping != m->x86_stepping)
+			continue;
+		return m;
+	}
+	return NULL;
+}
+
+bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table)
+{
+	const struct x86_cpu_desc *res = x86_match_cpu_with_stepping(table);
+
+	if (!res || res->x86_microcode_rev > boot_cpu_data.microcode)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(x86_cpu_has_min_microcode_rev);
-- 
2.17.1

