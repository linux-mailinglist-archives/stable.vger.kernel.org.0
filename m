Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738267162C
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfGWKfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:35:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47817 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfGWKfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:35:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3A9355C4;
        Tue, 23 Jul 2019 06:35:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IUnX21
        Ccj9wX1luGAGwwY2aqWXoXWnwxH6Kw62dTkbo=; b=NXK/nYkuCmVdLIk3ExqeRa
        v0rHapPFFfV+tdsraKqEvyR4dejihNL77cRuPtBIsecKYoX4KZZOBOMA7bn4o8dk
        Y+O+cIh2ZG+4GuHFS2X3lhGS+1RHFkuAts+9YpvztyatHhCTZ5Y/Or5d5ojwWblu
        6kQGdWG8Z7udgryp0jpUriQRIGr7Lc2O4WoH/EgnzleTs9+HpQOxaN85lUPYUTjt
        nnGv6fdpOE0WQRjy0CPIWWlyV91DcIBCurh7LBYX2PazSJmWcUQWr+B1vHMGas/4
        jlXkS4zvzTeLQetgWHVU8b+NFmJAQsehBKguIsVl/tMduRU7soOJIGGTogEbJqsg
        ==
X-ME-Sender: <xms:BeM2XZ_j0jmVcKLnqPEsbad9tzzIkXAyUxbd6518kxDZ3XMHzMMIiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:BeM2XaqCbGPOUI-zr4MpSeCk3j7bYhrgGknBG7jhgb2C1_RjKvdFbQ>
    <xmx:BeM2XSp8OSgffvjlK2Wtqz9JPekx4gcW5CEDOf3of7C9kOEkbjn4Mg>
    <xmx:BeM2XV0o_tBhNC7wBEyFL0pPKP5J0CyHAcKKTpGzn6cvh3Feomi4lA>
    <xmx:BeM2XXRrSRJBgPvO0Sq07m-3rfl4Xg_6Wigxash4XctqrQFqzc_XeQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1E3F380075;
        Tue, 23 Jul 2019 06:35:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with" failed to apply to 5.1-stable tree
To:     sean.j.christopherson@intel.com, nadav.amit@gmail.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:32:21 +0200
Message-ID: <1563877941212194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
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

