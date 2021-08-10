Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C603E7E99
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhHJRe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232827AbhHJRdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17ECB61058;
        Tue, 10 Aug 2021 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616809;
        bh=xvFd2K8Cj1moFOA5Q2nGdV2VZIP7mef1IQrDR9e6hDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1noYsVO6DbRGrswtDB+TYGmxuCMCbjw5PIVLs+vfZet4GtzxTxswlCrKP1Iu1ni9
         HlWg4nLBzf6sK077lEg1/35Y0WYsqtER+Zgd+2w87XW3tt+gPsaZRY27wwCM0c7cdS
         wWIzAa9twz+ZiSV9CdhkgEF7HaczU4qEPUARlNU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 45/54] KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds
Date:   Tue, 10 Aug 2021 19:30:39 +0200
Message-Id: <20210810172945.680686881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d5aaad6f83420efb8357ac8e11c868708b22d0a9 upstream.

Take a signed 'long' instead of an 'unsigned long' for the number of
pages to add/subtract to the total number of pages used by the MMU.  This
fixes a zero-extension bug on 32-bit kernels that effectively corrupts
the per-cpu counter used by the shrinker.

Per-cpu counters take a signed 64-bit value on both 32-bit and 64-bit
kernels, whereas kvm_mod_used_mmu_pages() takes an unsigned long and thus
an unsigned 32-bit value on 32-bit kernels.  As a result, the value used
to adjust the per-cpu counter is zero-extended (unsigned -> signed), not
sign-extended (signed -> signed), and so KVM's intended -1 gets morphed to
4294967295 and effectively corrupts the counter.

This was found by a staggering amount of sheer dumb luck when running
kvm-unit-tests on a 32-bit KVM build.  The shrinker just happened to kick
in while running tests and do_shrink_slab() logged an error about trying
to free a negative number of objects.  The truly lucky part is that the
kernel just happened to be a slightly stale build, as the shrinker no
longer yells about negative objects as of commit 18bb473e5031 ("mm:
vmscan: shrink deferred objects proportional to priority").

 vmscan: shrink_slab: mmu_shrink_scan+0x0/0x210 [kvm] negative objects to delete nr=-858993460

Fixes: bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210804214609.1096003-1-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2042,7 +2042,7 @@ static int is_empty_shadow_page(u64 *spt
  * aggregate version in order to make the slab shrinker
  * faster
  */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);


