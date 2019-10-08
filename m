Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537B5CF3A4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbfJHHWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:22:04 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57143 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729740AbfJHHWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:22:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1611320E15;
        Tue,  8 Oct 2019 03:22:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wgOrim
        7JccwJ7oXby/QWKyUmu9LOwo5jq+GpvZLczpM=; b=KgVhwie1NyPkVl45MDYuWq
        cIpQbUReHzokwNvgukywvqMM1DdpRgqkkZQ7+aIjbVHpDiT1NP0YvSA8AzgCtr4k
        fl1tgZpM1RdhOW1B0MKueblIJj6yy//yB8w1CWQUR89ywEc3U2u+P5SEk5Ahlykx
        mInTFJm5Nl6RGIYZ8MU1G++w2wbcHs84J22fES0AvBXPFY3XmhYs7knj3dwqDi6Y
        PWhni22nhmFsu1+KlNfM/F/s9XEZ61Kw+jRPXFukWKypib03iYK6wbnR0L4V7yKh
        wEviyMzuQrOJOELMCYEzcD2OUoTcRNvTO7+LW+tneV1lbewcbbABfPngbdpEZdRA
        ==
X-ME-Sender: <xms:GTmcXU2UL9P-qom8bfvf_44l79IgZnt2l5M3MnlgTTRwBynhR4hj7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:GTmcXV2jPqp6nl78Rt8K-4-ygpTYsj1JNwmI7UheJjEJcTXPyFHk_Q>
    <xmx:GTmcXer84DX-qT4R0nEQ2SrXG1NIwz39s6-nKDexPkBpn7YjR4qEgw>
    <xmx:GTmcXZjA264uZNK8Mfphu8JRWCh-TyidehuXLhn78-zemi6FCbbyiw>
    <xmx:GjmcXRSeGlsIela0Lil3DANgfaJrPhidjxvHo1DEV208KvhVNbXDEQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 890B38005C;
        Tue,  8 Oct 2019 03:22:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Fix consistency check on injected exception error" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, jmattson@google.com,
        namit@vmware.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:21:52 +0200
Message-ID: <157051931215935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 567926cca99ba1750be8aae9c4178796bf9bb90b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 1 Oct 2019 09:21:23 -0700
Subject: [PATCH] KVM: nVMX: Fix consistency check on injected exception error
 code

Current versions of Intel's SDM incorrectly state that "bits 31:15 of
the VM-Entry exception error-code field" must be zero.  In reality, bits
31:16 must be zero, i.e. error codes are 16-bit values.

The bogus error code check manifests as an unexpected VM-Entry failure
due to an invalid code field (error number 7) in L1, e.g. when injecting
a #GP with error_code=0x9f00.

Nadav previously reported the bug[*], both to KVM and Intel, and fixed
the associated kvm-unit-test.

[*] https://patchwork.kernel.org/patch/11124749/

Reported-by: Nadav Amit <namit@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41abc62c9a8a..e76eb4f07f6c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2610,7 +2610,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
-		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 15)))
+		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 16)))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: reserved bits */

