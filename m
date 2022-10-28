Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1F461142B
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJ1OMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 10:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJ1OMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 10:12:31 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9CA1C8406;
        Fri, 28 Oct 2022 07:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666966350; x=1698502350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9Olp4YqLgqBAJYRL0jQZ9E01eAQBEhHXpcQaGWFd5k=;
  b=V4Ye95J+B1DfRqorVBi7sn1QK+BTGZhUhrCD7aapn7PkY6koRPfI72Iz
   L1/zjR0eNcP7suSVShYGabbU9wakm9WH3PuMR/+JZ7aopXardZ65zeCfX
   zXCLYusKdPELZaqWhgbI6JfR0rutMVxsRp7icl4JIduoKMZZalQNpCV2k
   xpJnOB/Gx+WJVJ6VMrbqdPAJHL+LltiSqxF4WHdMuDMrurlCaZKmn/m/L
   Q+7JXbnNnC516qxM9Tghlp/Rcx6HKNG6I6MuU+V8hcFP+i8NL/jdcirBV
   EdFkSz9Iti5JUUAOFdVoawlYTlnRqvE0eejAjIkpOImY1PrOPpEQ1S55F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="335142692"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="335142692"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 07:12:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="583936262"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="583936262"
Received: from snehalde-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.46.229])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 07:12:24 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 1DFAF10828A; Fri, 28 Oct 2022 17:12:22 +0300 (+03)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org
Cc:     sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        dan.j.williams@intel.com, david@redhat.com, hpa@zytor.com,
        seanjc@google.com, thomas.lendacky@amd.com,
        elena.reshetova@intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] x86/tdx: Do not allow #VE due to EPT violation on the private memory
Date:   Fri, 28 Oct 2022 17:12:20 +0300
Message-Id: <20221028141220.29217-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221028141220.29217-1-kirill.shutemov@linux.intel.com>
References: <20221028141220.29217-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Virtualization Exceptions (#VE) are delivered to TDX guests due to
specific guest actions such as using specific instructions or accessing
a specific MSR.

Notable reason for #VE is access to specific guest physical addresses.
It requires special security considerations as it is not fully in
control of the guest kernel. VMM can remove a page from EPT page table
and trigger #VE on access.

The primary use-case for #VE on a memory access is MMIO: VMM removes
page from EPT to trigger exception in the guest which allows guest to
emulate MMIO with hypercalls.

MMIO only happens on shared memory. All conventional kernel memory is
private. This includes everything from kernel stacks to kernel text.

Handling exceptions on arbitrary accesses to kernel memory is
essentially impossible as handling #VE may require access to memory
that also triggers the exception.

TDX module provides mechanism to disable #VE delivery on access to
private memory. If SEPT_VE_DISABLE TD attribute is set, private EPT
violation will not be reflected to the guest as #VE, but will trigger
exit to VMM.

Make sure the attribute is set by VMM. Panic otherwise.

There's small window during the boot before the check where kernel has
early #VE handler. But the handler is only for port I/O and panic as
soon as it sees any other #VE reason.

SEPT_VE_DISABLE makes SEPT violation unrecoverable and terminating the
TD is the only option.

Kernel has no legitimate use-cases for #VE on private memory. It is
either a guest kernel bug (like access of unaccepted memory) or
malicious/buggy VMM that removes guest page that is still in use.

In both cases terminating TD is the right thing to do.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 9a22bf6debbf ("x86/traps: Add #VE support for TDX guest")
Cc: stable@vger.kernel.org # v5.19
---
 arch/x86/coco/tdx/tdx.c | 49 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 343d60853b71..a376a0c3fddc 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -34,6 +34,9 @@
 #define VE_GET_PORT_NUM(e)	((e) >> 16)
 #define VE_IS_IO_STRING(e)	((e) & BIT(4))
 
+/* TD Attributes */
+#define ATTR_SEPT_VE_DISABLE	BIT(28)
+
 /* Caches GPA width from TDG.VP.INFO TDCALL */
 static unsigned int gpa_width __ro_after_init;
 
@@ -770,6 +773,52 @@ void __init tdx_early_init(void)
 	 */
 	tdx_parse_tdinfo();
 
+	/*
+	 * Do not allow #VE due to EPT violation on the private memory
+	 *
+	 * Virtualization Exceptions (#VE) are delivered to TDX guests due to
+	 * specific guest actions such as using specific instructions or
+	 * accessing a specific MSR.
+	 *
+	 * Notable reason for #VE is access to specific guest physical
+	 * addresses. It requires special security considerations as it is not
+	 * fully in control of the guest kernel. VMM can remove a page from EPT
+	 * page table and trigger #VE on access.
+	 *
+	 * The primary use-case for #VE on a memory access is MMIO: VMM removes
+	 * page from EPT to trigger exception in the guest which allows guest to
+	 * emulate MMIO with hypercalls.
+	 *
+	 * MMIO only happens on shared memory. All conventional kernel memory is
+	 * private. This includes everything from kernel stacks to kernel text.
+	 *
+	 * Handling exceptions on arbitrary accesses to kernel memory is
+	 * essentially impossible as handling #VE may require access to memory
+	 * that also triggers the exception.
+	 *
+	 * TDX module provides mechanism to disable #VE delivery on access to
+	 * private memory. If SEPT_VE_DISABLE TD attribute is set, private EPT
+	 * violation will not be reflected to the guest as #VE, but will trigger
+	 * exit to VMM.
+	 *
+	 * Make sure the attribute is set by VMM. Panic otherwise.
+	 *
+	 * There's small window during the boot before the check where kernel has
+	 * early #VE handler. But the handler is only for port I/O and panic as
+	 * soon as it sees any other #VE reason.
+	 *
+	 * SEPT_VE_DISABLE makes SEPT violation unrecoverable and terminating
+	 * the TD is the only option.
+	 *
+	 * Kernel has no legitimate use-cases for #VE on private memory. It is
+	 * either a guest kernel bug (like access of unaccepted memory) or
+	 * malicious/buggy VMM that removes guest page that is still in use.
+	 *
+	 * In both cases terminating TD is the right thing to do.
+	 */
+	if (!(td_attr & ATTR_SEPT_VE_DISABLE))
+		panic("TD misconfiguration: SEPT_VE_DISABLE attibute must be set.\n");
+
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
 
 	cc_set_vendor(CC_VENDOR_INTEL);
-- 
2.38.0

