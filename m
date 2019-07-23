Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC5A71624
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfGWKfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:35:53 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52151 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726907AbfGWKfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:35:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8E69C5C0;
        Tue, 23 Jul 2019 06:35:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hQdbC4
        ISLaBobP863mi9eyWyZA9i2oCSGF40bUXhqAs=; b=ExR7DLhPT+3EyohsJX2v+Z
        7YkyMub8CM5SBgSaJGJ5rd7hfP6827befpbWhpYWEvfcv6DxICMLkEoo2/Tz34Xw
        U8RJk8e20LA0GCR1HYaRi96Bz6HcPYAlMvP1YodwSnjtyapovStxLqLi6pL1t3jH
        qyT3qR7VijYNe45QtkWjtR3uWU0+yVqKsFmosJPpaItQrMqIYIfopWPZqhxJA0iK
        mNpsylH/f73ivr2qoWEp7TcY9YTC5i4aDLcfxCJ3r5Lg9bJ8BN+E1RsctPg6/AVX
        ZHW+f5lWtVLJtrvCovhmAtCNXsrq7lbFMWrcA08IwNkXtH2xCM5uS74onTJ0G5Mw
        ==
X-ME-Sender: <xms:COM2XXBvRhpwuxykWXCQax6PtzqAL1AICV0WZoE7A5RUnSHbmsky3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:COM2XdzH_R2qNsuxjsy7Roqum6FZcSdazadVQYhDYeOmjzVoHdrnaQ>
    <xmx:COM2XbdznEcNIHOO-2cJC6N4F_ms6PAXYE3oXPMmuG862Sl784jyDA>
    <xmx:COM2XdqTtZ4g6qX9S7WJrlUztVxmdP1TzuXalpVHVMASjPIuZokYww>
    <xmx:COM2XVvkBbm-o87d1XEnjbi1ytCzVxSuz7WjZl-wKhk3BA6m9S_wJQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5CD2380074;
        Tue, 23 Jul 2019 06:35:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with" failed to apply to 4.14-stable tree
To:     sean.j.christopherson@intel.com, nadav.amit@gmail.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:32:23 +0200
Message-ID: <1563877943202151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d28f4290b53a157191ed9991ad05dffe9e8c0c89 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 7 May 2019 09:06:27 -0700
Subject: [PATCH] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with
 bad value

The behavior of WRMSR is in no way dependent on whether or not KVM
consumes the value.

Fixes: 4566654bb9be9 ("KVM: vmx: Inject #GP on invalid PAT CR")
Cc: stable@vger.kernel.org
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a87a91e98dc..091610684d28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1894,9 +1894,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					      MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
+		if (!kvm_pat_valid(data))
+			return 1;
+
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
-			if (!kvm_pat_valid(data))
-				return 1;
 			vmcs_write64(GUEST_IA32_PAT, data);
 			vcpu->arch.pat = data;
 			break;

