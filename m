Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC3D395E07
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhEaNxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhEaNvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37EB613EA;
        Mon, 31 May 2021 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467938;
        bh=JZciasEvEPmMhPJ2Yltw5AYj7KSxC5rV+XIOgYsS43U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx1aN+ECmWH84CDjMx3R4Ke2eMuzkYSrLThSeM5UyPAidaBVsAXUGHGt196NVtdyp
         87/ZLETbAIxpEHFnvdPKVN7ER1TRPbHPqON9v6e5aDGPStlk9klpU2jA6aOBVRdhJ1
         b39Rc2N5FmTg0eeSLds+ckx5jpuSX3ly7t11BAT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 057/252] KVM: X86: Fix vCPU preempted state from guests point of view
Date:   Mon, 31 May 2021 15:12:02 +0200
Message-Id: <20210531130659.917507144@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 1eff0ada88b48e4ac1e3fe26483b3684fedecd27 upstream.

Commit 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's
CPUID) avoids to access pv tlb shootdown host side logic when this pv feature
is not exposed to guest, however, kvm_steal_time.preempted not only leveraged
by pv tlb shootdown logic but also mitigate the lock holder preemption issue.
>From guest's point of view, vCPU is always preempted since we lose the reset
of kvm_steal_time.preempted before vmentry if pv tlb shootdown feature is not
exposed. This patch fixes it by clearing kvm_steal_time.preempted before
vmentry.

Fixes: 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's CPUID)
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1621339235-11131-3-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3006,6 +3006,8 @@ static void record_steal_time(struct kvm
 				       st->preempted & KVM_VCPU_FLUSH_TLB);
 		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
+	} else {
+		st->preempted = 0;
 	}
 
 	vcpu->arch.st.preempted = 0;


