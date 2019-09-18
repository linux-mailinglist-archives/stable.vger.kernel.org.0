Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12EB5CA2
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfIRG1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbfIRG1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C012C21924;
        Wed, 18 Sep 2019 06:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788051;
        bh=ql6h+HcwawHyRy276sJpNsFQFGRe1iBHEAJ5B3IWtIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKWxzQSgAZxIGgVAzakUoGfYdzIeOMkePN34s8ne9N6ZkHVNoL3tKI38zGg60cn43
         NWvyBGb9kp40dKSvnYFWaU9Y8GBwZVnr6Zi9hlCWjhIbQBwPjhPy/9/ZR9Xocc5Zmo
         HZ/OVW+CkoQDSOwZatCh+R9OXD5FeBj5i/UjlNSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Nadav HarEl <nyh@il.ibm.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 5.2 80/85] kvm: nVMX: Remove unnecessary sync_roots from handle_invept
Date:   Wed, 18 Sep 2019 08:19:38 +0200
Message-Id: <20190918061237.910306483@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit b119019847fbcac36ed1384f166c91f177d070e7 upstream.

When L0 is executing handle_invept(), the TDP MMU is active. Emulating
an L1 INVEPT does require synchronizing the appropriate shadow EPT
root(s), but a call to kvm_mmu_sync_roots in this context won't do
that. Similarly, the hardware TLB and paging-structure-cache entries
associated with the appropriate shadow EPT root(s) must be flushed,
but requesting a TLB_FLUSH from this context won't do that either.

How did this ever work? KVM always does a sync_roots and TLB flush (in
the correct context) when transitioning from L1 to L2. That isn't the
best choice for nested VM performance, but it effectively papers over
the mistakes here.

Remove the unnecessary operations and leave a comment to try to do
better in the future.

Reported-by: Junaid Shahid <junaids@google.com>
Fixes: bfd0a56b90005f ("nEPT: Nested INVEPT")
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Nadav Har'El <nyh@il.ibm.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>
Cc: Xinhao Xu <xinhao.xu@intel.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by Peter Shier <pshier@google.com>
Reviewed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4708,13 +4708,11 @@ static int handle_invept(struct kvm_vcpu
 
 	switch (type) {
 	case VMX_EPT_EXTENT_GLOBAL:
+	case VMX_EPT_EXTENT_CONTEXT:
 	/*
-	 * TODO: track mappings and invalidate
-	 * single context requests appropriately
+	 * TODO: Sync the necessary shadow EPT roots here, rather than
+	 * at the next emulated VM-entry.
 	 */
-	case VMX_EPT_EXTENT_CONTEXT:
-		kvm_mmu_sync_roots(vcpu);
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		break;
 	default:
 		BUG_ON(1);


