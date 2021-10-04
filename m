Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03464420E1D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhJDNVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236126AbhJDNTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E83B161507;
        Mon,  4 Oct 2021 13:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352913;
        bh=kEcqwp9mXAMYwj8cNUa25CVhfk4qG4FSVdvEhS3bt1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmG+cHyyJQuqwIdiCnSOQjzQF/i06uFXxFP1DdLj9b1LC2oTlywXOVAqlx5LtBU0F
         crLW51yhZEWl/0GINYJUlSGVPyZ8tfjaAB3c0NcebA3prY+aaiC7DqtATgoHALU7h1
         QsuDmZjRhfNOky8hXhFFLQUM5+UjJNviAlI6kqKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 17/93] KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()
Date:   Mon,  4 Oct 2021 14:52:15 +0200
Message-Id: <20211004125035.147989748@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 2f9b68f57c6278c322793a06063181deded0ad69 upstream.

KASAN reports the following issue:

 BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
 Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798

 CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
 Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
 Call Trace:
  dump_stack+0xa5/0xe6
  print_address_description.constprop.0+0x18/0x130
  ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  __kasan_report.cold+0x7f/0x114
  ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  kasan_report+0x38/0x50
  kasan_check_range+0xf5/0x1d0
  kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
  ? kvm_arch_exit+0x110/0x110 [kvm]
  ? sched_clock+0x5/0x10
  ioapic_write_indirect+0x59f/0x9e0 [kvm]
  ? static_obj+0xc0/0xc0
  ? __lock_acquired+0x1d2/0x8c0
  ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]

The problem appears to be that 'vcpu_bitmap' is allocated as a single long
on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
the lower 16 bits of it with bitmap_zero() for no particular reason (my
guess would be that 'bitmap' and 'vcpu_bitmap' variables in
kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
16-bit long, the later should accommodate all possible vCPUs).

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210827092516.1027264-7-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/ioapic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -319,8 +319,8 @@ static void ioapic_write_indirect(struct
 	unsigned index;
 	bool mask_before, mask_after;
 	union kvm_ioapic_redirect_entry *e;
-	unsigned long vcpu_bitmap;
 	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -384,9 +384,9 @@ static void ioapic_write_indirect(struct
 			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
-			bitmap_zero(&vcpu_bitmap, 16);
+			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-						 &vcpu_bitmap);
+						 vcpu_bitmap);
 			if (old_dest_mode != e->fields.dest_mode ||
 			    old_dest_id != e->fields.dest_id) {
 				/*
@@ -399,10 +399,10 @@ static void ioapic_write_indirect(struct
 				    kvm_lapic_irq_dest_mode(
 					!!e->fields.dest_mode);
 				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-							 &vcpu_bitmap);
+							 vcpu_bitmap);
 			}
 			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
-							  &vcpu_bitmap);
+							  vcpu_bitmap);
 		} else {
 			kvm_make_scan_ioapic_request(ioapic->kvm);
 		}


