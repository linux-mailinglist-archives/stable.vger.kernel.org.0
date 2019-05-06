Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1830014EC4
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfEFOi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfEFOix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8CDE214AF;
        Mon,  6 May 2019 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153532;
        bh=BKhbmqv6L6lntJ0v+ab+H4zgl/rxM7OzeccCAY5BKTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEex5zyep3Il6EmGrJerD3x3YUsVqB/uxJDGZUwpf7ZNqrWaB95d6XCU5tfbBbC9/
         uSdE2zkMpa0NYYh8vD1MtVM2PvdHZagMxn5Phty9bvDWmV7lJXRSvAwxOp9un2VLyl
         zFhVqysVoluJUZIBB5PS5ecUW56Egc0sQqwFLO7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f7e65445a40d3e0e4ebf@syzkaller.appspotmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 103/122] KVM: lapic: Check for in-kernel LAPIC before deferencing apic pointer
Date:   Mon,  6 May 2019 16:32:41 +0200
Message-Id: <20190506143103.965452572@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b904cb8dff824b79233e82c078837627ebd52717 upstream.

...to avoid dereferencing a null pointer when querying the per-vCPU
timer advance.

Fixes: 39497d7660d98 ("KVM: lapic: Track lapic timer advance per vCPU")
Reported-by: syzbot+f7e65445a40d3e0e4ebf@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    3 ---
 arch/x86/kvm/x86.c   |    3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1504,9 +1504,6 @@ void wait_lapic_expire(struct kvm_vcpu *
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 guest_tsc, tsc_deadline, ns;
 
-	if (!lapic_in_kernel(vcpu))
-		return;
-
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7886,7 +7886,8 @@ static int vcpu_enter_guest(struct kvm_v
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	if (vcpu->arch.apic->lapic_timer.timer_advance_ns)
+	if (lapic_in_kernel(vcpu) &&
+	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
 		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 


