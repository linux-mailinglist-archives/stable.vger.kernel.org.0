Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA414F6C
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEFPJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEFOfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A48422087F;
        Mon,  6 May 2019 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153301;
        bh=jKk82LfyayqAJiEj9IJ9TqTSLS0pT1DNZIhKW01x/Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLkMns0y86Ph8p9fi45jLZgnzxSV3M3yvmpP2LEguWJ2807t8LtnsKrRMmRTq/TQD
         vURkAK+gIgqntIs9QIPoBdMGRcJNDWQaok1PgEODZqSSGS81jNuWCWWooAEORcU194
         LW4JLw9DGB/GdKxHeo6NRtGVY+1mkx/7OgLI9QiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 020/122] KVM: lapic: Disable timer advancement if adaptive tuning goes haywire
Date:   Mon,  6 May 2019 16:31:18 +0200
Message-Id: <20190506143056.555695715@linuxfoundation.org>
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

commit 57bf67e73ce9bcce2258890f5abf2adf5f619f1a upstream.

To minimize the latency of timer interrupts as observed by the guest,
KVM adjusts the values it programs into the host timers to account for
the host's overhead of programming and handling the timer event.  Now
that the timer advancement is automatically tuned during runtime, it's
effectively unbounded by default, e.g. if KVM is running as L1 the
advancement can measure in hundreds of milliseconds.

Disable timer advancement if adaptive tuning yields an advancement of
more than 5000ns, as large advancements can break reasonable assumptions
of the guest, e.g. that a timer configured to fire after 1ms won't
arrive on the next instruction.  Although KVM busy waits to mitigate the
case of a timer event arriving too early, complications can arise when
shifting the interrupt too far, e.g. kvm-unit-test's vmx.interrupt test
will fail when its "host" exits on interrupts as KVM may inject the INTR
before the guest executes STI+HLT.   Arguably the unit test is "broken"
in the sense that delaying a timer interrupt by 1ms doesn't technically
guarantee the interrupt will arrive after STI+HLT, but it's a reasonable
assumption that KVM should support.

Furthermore, an unbounded advancement also effectively unbounds the time
spent busy waiting, e.g. if the guest programs a timer with a very large
delay.

5000ns is a somewhat arbitrary threshold.  When running on bare metal,
which is the intended use case, timer advancement is expected to be in
the general vicinity of 1000ns.  5000ns is high enough that false
positives are unlikely, while not being so high as to negatively affect
the host's performance/stability.

Note, a future patch will enable userspace to disable KVM's adaptive
tuning, which will allow priveleged userspace will to specifying an
advancement value in excess of this arbitrary threshold in order to
satisfy an abnormal use case.

Cc: Liran Alon <liran.alon@oracle.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Fixes: 3b8a5df6c4dc6 ("KVM: LAPIC: Tune lapic_timer_advance_ns automatically")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1519,6 +1519,10 @@ void wait_lapic_expire(struct kvm_vcpu *
 		}
 		if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 			lapic_timer_advance_adjust_done = true;
+		if (unlikely(lapic_timer_advance_ns > 5000)) {
+			lapic_timer_advance_ns = 0;
+			lapic_timer_advance_adjust_done = true;
+		}
 	}
 }
 


