Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4714F408DC3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbhIMN3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241406AbhIMNZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B896124F;
        Mon, 13 Sep 2021 13:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539348;
        bh=BNUQ91d/Lullesgw99EjLMu/iP6LnWrweewAFbZkZ2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbSEzsOcU7C/Q0BJN3M/cgIB/37r3+O+B2R6S1RByI5ujUaUVrK8gxgpXt4krerlA
         mb7cPEQsC6aOqSDPjj5QxF/f307YU8zpaeKXhhyIORX+mwrHQZKZKoqs0Ca4Qt2g7R
         DkmKEz9awOLJeaLvtT2SoLMPzyJihgQP8SRE80B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 136/144] KVM: x86: Update vCPUs hv_clock before back to guest when tsc_offset is adjusted
Date:   Mon, 13 Sep 2021 15:15:17 +0200
Message-Id: <20210913131052.484327380@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zelin Deng <zelin.deng@linux.alibaba.com>

commit d9130a2dfdd4b21736c91b818f87dbc0ccd1e757 upstream.

When MSR_IA32_TSC_ADJUST is written by guest due to TSC ADJUST feature
especially there's a big tsc warp (like a new vCPU is hot-added into VM
which has been up for a long time), tsc_offset is added by a large value
then go back to guest. This causes system time jump as tsc_timestamp is
not adjusted in the meantime and pvclock monotonic character.
To fix this, just notify kvm to update vCPU's guest time before back to
guest.

Cc: stable@vger.kernel.org
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <1619576521-81399-2-git-send-email-zelin.deng@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2764,6 +2764,10 @@ int kvm_set_msr_common(struct kvm_vcpu *
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				/* Before back to guest, tsc_timestamp must be adjusted
+				 * as well, otherwise guest's percpu pvclock time could jump.
+				 */
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}


