Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC74156AA6
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgBINlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:41:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:41:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A89C421DC6;
        Sun,  9 Feb 2020 08:41:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Wpuecr
        4K0bbjCJt1hbJtUHD4AIWyGIwHn0sdkmMksBc=; b=guTUY1zssts4NR0JYI2HWV
        vzI+zhD0BgufpTU/lVPfhHNRzuomIeC2P4xVvzZdzuTni9BAJSsZDAx9hGP9lyyC
        2FnZT7drorX/tBIzEAUjr68n9Bvb/i6t7m9JXEj4pOJzTYccmBbEkO5zTSqVgW4d
        nOP7KUeQ+lBnrcd5nGmQqqq2YjG6FDR/pRRf7gyeYY/ySh2SnVAjUGEbOtAeVBbY
        9ZwF4xksoomHFpoxnPkfbKlLwScNwsWfI6kHGJ5eAhxB6hqIFCvC0IXpI5IkA8V6
        0rAYYu7Q/mxYbWoB8Zkp/m3AMDqSCTEJGjlXCyAXBGC4hUUb1McpBtn/wUC16wpA
        ==
X-ME-Sender: <xms:_AtAXsfidd1JYiQoEpNFEmFZMyjLkhvROG8vbAGLtSy7BVnbBnCHTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_AtAXidOiXd7XqTNJ_nVAaPS98BpZx_KgwcOXDMkQ_TtjGZVt6MUjQ>
    <xmx:_AtAXog9TOHGmuOw1GdStZVWTg2UT4FEjw2w7DDTApNBFzsYVdr-pg>
    <xmx:_AtAXmRsHSWoJGmnXsP7DlZZ7im3GrEOd_IUYKrtdgNAJvYPqE660g>
    <xmx:_AtAXrSMRK6_3VpGVqj70JkVjkZ4-HnYwwps-opEB8Y9zvQl2uXWGA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA0013280060;
        Sun,  9 Feb 2020 08:41:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: use CPUID to locate host page table reserved bits" failed to apply to 5.4-stable tree
To:     pbonzini@redhat.com, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:31:10 +0100
Message-ID: <158125147044100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7adacf5eb2d2048045d9fd8fdab861fd9e7e2e96 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 4 Dec 2019 15:50:27 +0100
Subject: [PATCH] KVM: x86: use CPUID to locate host page table reserved bits

The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
available, it is simplest and works even if memory is not encrypted.

Cc: stable@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..1e4ee4f8de5f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -538,16 +538,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
-	 * in CPU detection code, but MKTME treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
-	 * we should still return physical address bits reported by CPUID.
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_TME) ||
-	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
-		return boot_cpu_data.x86_phys_bits;
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
 
-	return cpuid_eax(0x80000008) & 0xff;
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
 }
 
 static void kvm_mmu_reset_all_pte_masks(void)

