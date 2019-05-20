Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D72623602
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390067AbfETMaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388778AbfETMaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82C620675;
        Mon, 20 May 2019 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355418;
        bh=H6qYUOT9E37EvFF2R2H/o2TLbrpZMRWCgqi4IEYCAG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9QyyOqRemBMfgX8K5lnikjuvrZF87V6WJmxQhjjv+VJgzLVRyCtxTaFXdQnMbNN3
         UzR6ZiRwG71KcQcalJU2iGhAzhAcgd3ZTmM3qGG4cq1QgKULVhS2HCvIjCDQKLzNiJ
         ZRWumlXMmGYXCcqazi5PRZ34OJ0599WoKvjzA9QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 112/123] KVM: lapic: Busy wait for timer to expire when using hv_timer
Date:   Mon, 20 May 2019 14:14:52 +0200
Message-Id: <20190520115252.567542703@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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
@@ -1453,7 +1453,7 @@ static void apic_timer_expired(struct kv
 	if (swait_active(q))
 		swake_up_one(q);
 
-	if (apic_lvtt_tscdeadline(apic))
+	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 }
 


