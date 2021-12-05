Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A066468ABA
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhLEMOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhLEMOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20DBC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 04:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC7560AD4
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162ADC341C5;
        Sun,  5 Dec 2021 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638706275;
        bh=4cLJzQbQVfwIHVMsppgBi6mDJwHu/0pjMB1Spysm/CU=;
        h=Subject:To:Cc:From:Date:From;
        b=b5yPPVpiCcF+G27rEWnDHTA6f6icLfnEHMn82jAsHXEkZpjQYuZqLdgjNjX9OB0CZ
         cmTNr8U5aeuu1MngPwJpKZ6NPYeAHAonmRfSUy8ebVjQ1L50usQ6HHSE1xBOP6bd0B
         5yifehegXW5mnFZ1E0Cr6y7JIK3Zqz0UxemQkgkQ=
Subject: FAILED: patch "[PATCH] KVM: Disallow user memslot with size that exceeds "unsigned" failed to apply to 4.4-stable tree
To:     seanjc@google.com, maciej.szmigiero@oracle.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:11:12 +0100
Message-ID: <163870627251106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b285a5587506bae084cf9a3ed5aa491d623b91b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Nov 2021 00:25:03 +0000
Subject: [PATCH] KVM: Disallow user memslot with size that exceeds "unsigned
 long"

Reject userspace memslots whose size exceeds the storage capacity of an
"unsigned long".  KVM's uAPI takes the size as u64 to support large slots
on 64-bit hosts, but does not account for the size being truncated on
32-bit hosts in various flows.  The access_ok() check on the userspace
virtual address in particular casts the size to "unsigned long" and will
check the wrong number of bytes.

KVM doesn't actually support slots whose size doesn't fit in an "unsigned
long", e.g. KVM's internal kvm_memory_slot.npages is an "unsigned long",
not a "u64", and misc arch specific code follows that behavior.

Fixes: fa3d315a4ce2 ("KVM: Validate userspace_addr of memslot when registered")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <20211104002531.1176691-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2104fc29cdd2..6c5083f2eb50 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1689,7 +1689,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	id = (u16)mem->slot;
 
 	/* General sanity checks */
-	if (mem->memory_size & (PAGE_SIZE - 1))
+	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
+	    (mem->memory_size != (unsigned long)mem->memory_size))
 		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;

