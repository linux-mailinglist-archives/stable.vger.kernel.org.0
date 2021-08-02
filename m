Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB413DD9CE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhHBOEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236123AbhHBOBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9ED961215;
        Mon,  2 Aug 2021 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912603;
        bh=75ydvlkxzI2lOQKegpJKGTjz/apSNRyVkaj7VQ4fzlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5rHWpmZZaKMpezqMF1h6t5PEPP2atPQOSg5VUeTZtpnIxd9brxdhrUMPzdSh9TeP
         M48lMv+mvOqf3v2hxi87m6dm64BncFM+mRw0JaArnUcclOaOthlxwnVY0YD5nq30Pj
         IngbfOlC7Rn6jsvveuyzATmXjXd9/0g8/VpAcDjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/104] KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access
Date:   Mon,  2 Aug 2021 15:45:05 +0200
Message-Id: <20210802134346.247628112@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 0a31df6823232516f61f174907e444f710941dfe ]

MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
stated in Documentation/virt/kvm/msr.rst.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Message-Id: <20210722123018.260035-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5a3de788b5f..d6a9f0518784 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3314,7 +3314,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
-		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
 			return 1;
 		if (data & 0x1) {
 			vcpu->arch.apf.pageready_pending = false;
@@ -3646,7 +3646,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
-		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
 			return 1;
 
 		msr_info->data = 0;
-- 
2.30.2



