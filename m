Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89EF30A8C7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhBANcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231477AbhBANcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 08:32:24 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD41964E8F;
        Mon,  1 Feb 2021 13:31:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6ZIr-00BHLa-I2; Mon, 01 Feb 2021 13:31:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable-5.4][PATCH] KVM: Forbid the use of tagged userspace addresses for memslots
Date:   Mon,  1 Feb 2021 13:31:37 +0000
Message-Id: <20210201133137.3541896-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, pbonzini@redhat.com, gregkh@linuxfoundation.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 139bc8a6146d92822c866cf2fd410159c56b3648 upstream.

The use of a tagged address could be pretty confusing for the
whole memslot infrastructure as well as the MMU notifiers.

Forbid it altogether, as it never quite worked the first place.

Cc: stable@vger.kernel.org
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.txt | 3 +++
 virt/kvm/kvm_main.c            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index a18e996fa54b..7064efd3b5ea 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -1132,6 +1132,9 @@ field userspace_addr, which must point at user addressable memory for
 the entire memory slot size.  Any object may back this memory, including
 anonymous memory, ordinary files, and hugetlbfs.
 
+On architectures that support a form of address tagging, userspace_addr must
+be an untagged address.
+
 It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f3b40ec02b7..f25b5043cbca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1017,6 +1017,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* We can read the guest memory with __xxx_user() later on. */
 	if ((id < KVM_USER_MEM_SLOTS) &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+	     (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
 		goto out;
-- 
2.29.2

