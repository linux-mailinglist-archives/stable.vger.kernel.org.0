Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1E4388C7
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 14:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhJXMLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 08:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXMLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 08:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D6560EE3;
        Sun, 24 Oct 2021 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635077358;
        bh=oDBNTiGMQ711D8WpAd40BfsNfaSmVbpYKn4+LGBcTwo=;
        h=Subject:To:Cc:From:Date:From;
        b=zmE/nZboaALktNWWLLaNmnvt2eLUCKl7Bjwlg8RZkLYW9s1Y9qJNOmP2RPpYGa1RR
         kQ/vcaLtHd9u7ZDtqfBXUeGBrCDwvh1ZPsa7oWCB5B7ItE9DCSWbfgp/TZRg98C21g
         oXZ0bfIPyol4249QU6UK7mYBglS03xj2uHyQhAP0=
Subject: FAILED: patch "[PATCH] KVM: MMU: Reset mmu->pkru_mask to avoid stale data" failed to apply to 5.4-stable tree
To:     chenyi.qiang@intel.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 14:09:08 +0200
Message-ID: <163507734812758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From a3ca5281bb771d8103ea16f0a6a8a5df9a7fb4f3 Mon Sep 17 00:00:00 2001
From: Chenyi Qiang <chenyi.qiang@intel.com>
Date: Thu, 21 Oct 2021 15:10:22 +0800
Subject: [PATCH] KVM: MMU: Reset mmu->pkru_mask to avoid stale data

When updating mmu->pkru_mask, the value can only be added but it isn't
reset in advance. This will make mmu->pkru_mask keep the stale data.
Fix this issue.

Fixes: 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Message-Id: <20211021071022.1140-1-chenyi.qiang@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a64ba5b9437..0cc58901bf7a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4596,10 +4596,10 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 	unsigned bit;
 	bool wp;
 
-	if (!is_cr4_pke(mmu)) {
-		mmu->pkru_mask = 0;
+	mmu->pkru_mask = 0;
+
+	if (!is_cr4_pke(mmu))
 		return;
-	}
 
 	wp = is_cr0_wp(mmu);
 

