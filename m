Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A028B30C037
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhBBNvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhBBNuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D3C64FAA;
        Tue,  2 Feb 2021 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273359;
        bh=gUgc0r8bk0KNca2XaqGTfkET84c0c5MGJDlemNb8X/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFu0dvun52MZRdSsuWom1+pTXDgaR0TJbTcodczDbeVuEoY8q5x50sUmkbhPS9ogX
         eJJ62K0V8TLXU0/NlGAPgsm+hHR2Sbvx6A398OM27zCDsKOxMQxO8HmHzVxWp012hD
         t7ZNRUDnrGO0touxTinYOTxSc/zVr4fl4uehrf5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 046/142] KVM: Forbid the use of tagged userspace addresses for memslots
Date:   Tue,  2 Feb 2021 14:36:49 +0100
Message-Id: <20210202132959.627719612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 139bc8a6146d92822c866cf2fd410159c56b3648 upstream.

The use of a tagged address could be pretty confusing for the
whole memslot infrastructure as well as the MMU notifiers.

Forbid it altogether, as it never quite worked the first place.

Cc: stable@vger.kernel.org
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/virt/kvm/api.rst |    3 +++
 virt/kvm/kvm_main.c            |    1 +
 2 files changed, 4 insertions(+)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1264,6 +1264,9 @@ field userspace_addr, which must point a
 the entire memory slot size.  Any object may back this memory, including
 anonymous memory, ordinary files, and hugetlbfs.
 
+On architectures that support a form of address tagging, userspace_addr must
+be an untagged address.
+
 It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1289,6 +1289,7 @@ int __kvm_set_memory_region(struct kvm *
 		return -EINVAL;
 	/* We can read the guest memory with __xxx_user() later on. */
 	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
 	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size))
 		return -EINVAL;


