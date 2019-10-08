Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23316CF3AB
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfJHHYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:24:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52455 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730218AbfJHHYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:24:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5FA9621857;
        Tue,  8 Oct 2019 03:24:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wgOrim
        7JccwJ7oXby/QWKyUmu9LOwo5jq+GpvZLczpM=; b=h6Oj4San9DSYRp7XyaDe/1
        fulotY5ZNLuMyBq7Y82kz/DQQySxRCW+xbdPiUXqD6DKc90/jm5jYdm2OLG3wL22
        Nlb1vQaXs12TRg/yQaWDlT74JGOF3JtuLejE/MHEFU8kV7d74Xy+m2zPkSPRvtdT
        i3EydfmucD2FRAyPSkhYUZnM20nl8gSqFHYvrHULEhxSEsliOUVBm8f3QjOXRhyg
        GZIw/f4kaq+YDPXKnHjK8hz7MjU2cN2+5S9RGHJoJppokwV4iSG3AOdbh9iZu9zq
        xOmQpM2qMnfhQtEm9WoslAtBpc7RnoerpskgQggMALOHdzS7goU6UkrM7/XxxNLA
        ==
X-ME-Sender: <xms:mDmcXdoopfspWNMg-zTjA6rMIbtMwlIDtcynw0yNx5HTobu7uUJQ-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:mDmcXXKY9fTlyhNDpzbha31EUOD2Vm0VuMckwv_vDGwZXjl4fxUyiw>
    <xmx:mDmcXQRrROLzff2pHngy-95sYG0l1zYhY0cluSSQicjc02pQLNRbwg>
    <xmx:mDmcXW8yqD46C_BSUnr2x_4JnmqUa2Ow-W5wFSTIX2X8UrI_7NQ1Hg>
    <xmx:mDmcXZtPoglFAZBfE0JcdZIrzW4r8vSUZOSDxe0VaybZ-KEZ1lpY_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E7ADED6005E;
        Tue,  8 Oct 2019 03:24:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Fix consistency check on injected exception error" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, jmattson@google.com,
        namit@vmware.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:23:58 +0200
Message-ID: <157051943878123@kroah.com>
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

