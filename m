Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD55469EE5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359171AbhLFPon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390547AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE758C0698D6;
        Mon,  6 Dec 2021 07:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6FE6130D;
        Mon,  6 Dec 2021 15:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E22C34900;
        Mon,  6 Dec 2021 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804501;
        bh=dImLpwY/A2mb8Y8aH3ujPVNwegqlEU8u3t8Sj+a3SMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lycb9wVn6/+onUchghr0gIMMWXgdpu7Jhcy0uY9et9d6ULBJyfRM7pMomrz0J1o8
         57WReikww6IJLNd87mRSJy6TOeLeVTq2sqrD2poy9Y9dxz1ChLb4xrV47sMLD5j7Nt
         HareG24BFasvy2yewQY6RGFmhwD2ZXB1+UFxtPPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/207] KVM: VMX: Set failure code in prepare_vmcs02()
Date:   Mon,  6 Dec 2021 15:57:02 +0100
Message-Id: <20211206145616.089268934@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit bfbb307c628676929c2d329da0daf9d22afa8ad2 ]

The error paths in the prepare_vmcs02() function are supposed to set
*entry_failure_code but this path does not.  It leads to using an
uninitialized variable in the caller.

Fixes: 71f7347025bf ("KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Message-Id: <20211130125337.GB24578@kili>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 302f1752cc4c2..e97a11abc1d85 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2609,8 +2609,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-				     vmcs12->guest_ia32_perf_global_ctrl)))
+				     vmcs12->guest_ia32_perf_global_ctrl))) {
+		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
+	}
 
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
-- 
2.33.0



