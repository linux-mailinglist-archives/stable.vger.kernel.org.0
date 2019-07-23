Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1296371631
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbfGWKgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:12 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41265 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 89DEB46F;
        Tue, 23 Jul 2019 06:36:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tad+9y
        91h3CA2rIxECBowYRkmenW71EcFBT7Zgx5DKc=; b=CXEU3/7alHEwyGNMBJgZC6
        +R6/mKGzAOr8TVOH/rejvVvWjU37qIFdzGP2ukRCfeSueFgNVaSdhTxWwAST+c9Q
        kvnYzGXHmVWZPCeuOUBK/+qFn3ptZ2Zc+1fK37d4Q6JYkV9s5xP8p+ej/ILjDzow
        2IpzWHUf8wHtM+pf+roYNgk1ZF8s8GazrpslExMBAj6l3jO3e7OaLw1r8NhEGDGk
        KeG6nSamaGKRUwuC+Atz78g3rLirsXzYwpAhjK/x5p+OJHTgIbCmO4QfhMfbfm6R
        fborjRWjDboCKWfPwHxC77dpbvVDI4/3HRmhBdx6s92UpRe0f9tno+cz4BkGJF2A
        ==
X-ME-Sender: <xms:GeM2Xbz356WZL5Y-NWNMuWxrJUTAjiYDLpVU_HxlvY25XZreRvg0vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:GuM2XUe2yrLTUyz50q92J7cZbWZf5mEZNsKDtc32Li7xIguLqvawmw>
    <xmx:GuM2XVxQQsCEO3p8mtqOkc_YsqFl4uHzSC-EvPIMzqimv-d4b20DRw>
    <xmx:GuM2Xe5iiskvuTkrFOlDght1NsoiSQusjBGplTlnxkGmq-4NYTUVVQ>
    <xmx:GuM2XX3iuIlsn-7IquQ0ue1-xfTrnDDNOwC6A-OUENQpUyF6SV9ZoQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90D12380074;
        Tue, 23 Jul 2019 06:36:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: do not use dangling shadow VMCS after guest reset" failed to apply to 5.2-stable tree
To:     pbonzini@redhat.com, jan.kiszka@siemens.com, liran.alon@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:35:31 +0200
Message-ID: <1563878131859@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Jul 2019 18:41:10 +0200
Subject: [PATCH] KVM: nVMX: do not use dangling shadow VMCS after guest reset

If a KVM guest is reset while running a nested guest, free_nested will
disable the shadow VMCS execution control in the vmcs01.  However,
on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
the VMCS12 to the shadow VMCS which has since been freed.

This causes a vmptrld of a NULL pointer on my machime, but Jan reports
the host to hang altogether.  Let's see how much this trivial patch fixes.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4f23e34f628b..0f1378789bd0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
@@ -1341,6 +1342,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 	unsigned long val;
 	int i;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	preempt_disable();
 
 	vmcs_load(shadow_vmcs);
@@ -1373,6 +1377,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	unsigned long val;
 	int i, q;
 
+	if (WARN_ON(!shadow_vmcs))
+		return;
+
 	vmcs_load(shadow_vmcs);
 
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
@@ -4436,7 +4443,6 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.need_vmcs12_to_shadow_sync = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;

