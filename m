Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358C8468AD5
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhLEMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:41:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E43C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 04:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52DA360FC9
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0843CC341C1;
        Sun,  5 Dec 2021 12:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638707910;
        bh=VUXmACMk6Yi/cN23W04gvTdp1kCDqz6Z9yv+jVU9n1E=;
        h=Subject:To:Cc:From:Date:From;
        b=ZN8Y7x/lVzw1H5r/jZ2tbfbHxwMO6KCnkQLqPs6COAoUSk/XcTrzRUx7+j35r6+0c
         NDIA8kL0Q+5otz1Us1dXrE1rcz3PXiMERxoPuN8KjekSlrLSVhicP84EozCv6EC5A2
         X0UQRrPzYl9c1GyKbg5nBYgBaL6TS8AqooD7Lgho=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:38:27 +0100
Message-ID: <1638707907156129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7533377215b6ee432c06c5855f6be5d66e694e46 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 20 Nov 2021 01:50:08 +0000
Subject: [PATCH] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU
 notifier unmapping

Use the yield-safe variant of the TDP MMU iterator when handling an
unmapping event from the MMU notifier, as most occurences of the event
allow yielding.

Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120015008.3780032-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1f8c9f783b78..4cd6bf7e73f0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush = zap_gfn_range(kvm, root, range->start, range->end,
 				      range->may_block, flush, false);
 

