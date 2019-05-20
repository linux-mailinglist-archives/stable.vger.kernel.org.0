Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA502359B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391224AbfETMgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391078AbfETMgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7DC21721;
        Mon, 20 May 2019 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355770;
        bh=awA+Wv5nCbFiijRTlWSxq+pxtJHd9RM2npntWANCrqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAdqDXEzjceu0Ld5dEOc/RHNHjQkXUPfcxjnr3Bk4sBDQeoTG7PqWL9RK4pw7Hg3f
         /OVrXaOwr82HjsiwVqjqoKe5EpxCf5atkbaJrsH9nalUONGYy3kU3P8nROo5ipwNwR
         iveoX+cUO53jF1KLKfLq2dXHm1yKjcCwbOvM2+Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.1 118/128] KVM: lapic: Busy wait for timer to expire when using hv_timer
Date:   Mon, 20 May 2019 14:15:05 +0200
Message-Id: <20190520115256.717288883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit ee66e453db13d4837a0dcf9d43efa7a88603161b upstream.

...now that VMX's preemption timer, i.e. the hv_timer, also adjusts its
programmed time based on lapic_timer_advance_ns.  Without the delay, a
guest can see a timer interrupt arrive before the requested time when
KVM is using the hv_timer to emulate the guest's interrupt.

Fixes: c5ce8235cffa0 ("KVM: VMX: Optimize tscdeadline timer latency")
Cc: <stable@vger.kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1454,7 +1454,7 @@ static void apic_timer_expired(struct kv
 	if (swait_active(q))
 		swake_up_one(q);
 
-	if (apic_lvtt_tscdeadline(apic))
+	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 }
 


