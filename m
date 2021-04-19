Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88943643E6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbhDSNXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241553AbhDSNUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B2E613D8;
        Mon, 19 Apr 2021 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838239;
        bh=OxV01kUvNRgHcTAQ6TWVRP8AMkFSj9AW+I1Xcfvm8vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+F7UgAA53dvLUlDv2LQITuY9joLPg8m82ea+138zZ3EP+E/8WiGB0/hgZKDurW/D
         4j1vWdISjT8oap5yRwbl9E76BHpBYAtYACpYtFY4Cjsqn4aCWnNLN+NhLnx+2q1LLX
         XGl5RYPKGJKgRQQ1A6c5PgxTq0dlNQ2L9dkGrwSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/103] KVM: VMX: Dont use vcpu->run->internal.ndata as an array index
Date:   Mon, 19 Apr 2021 15:06:45 +0200
Message-Id: <20210419130531.017872691@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

[ Upstream commit 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a ]

__vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
an array access.  Since vcpu->run is (can be) mapped to a user address
space with a writer permission, the 'ndata' could be updated by the
user process at anytime (the user process can set it to outside the
bounds of the array).
So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.

Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20210413154739.490299-1-reijiw@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0b229282dd50..f8835cabf29f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6006,19 +6006,19 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
 	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+		int ndata = 3;
+
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
-			vcpu->run->internal.ndata++;
-			vcpu->run->internal.data[3] =
+			vcpu->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
-		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
-			vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.ndata = ndata;
 		return 0;
 	}
 
-- 
2.30.2



