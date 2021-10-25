Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B3E43A4D3
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhJYUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhJYUk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 16:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D868860EDF;
        Mon, 25 Oct 2021 20:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635194314;
        bh=FdDzOuOF3ONG+vnKuszKn5Y0h1yAiXCpPJJDpmRScwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGhmYwAbHf/hmOuGKr6i/MJX9KBjvy6RndUSBBZ96oPthlZDxwRYT1XrZGWzI/5mJ
         ZV3ZfQHJ3l5O3qhjmJja9K+Gto4ttbfQeDBLdbbjTaBg7aDSQnn1Xtvk3Iu+uTiGzg
         3SxmOuXhKzajkvN2BJBgtm4cfezILTANSCvnElutP9uLqk6b514ZmRQx45FH00YJ24
         HCoNRnJI9+RgIYgecL/cUydxzsefqg4glUdWM2qyXsEYy1K3tMTWQr3QRd9zFMKpr9
         tLuUcEWCEsF+L3/fVgO5MTJqYLvG3WBIOPJJEBFfHDF5z7HfFV9iMB+Bj06u+ackYG
         osbD3SiXEhS3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hao Xiang <hao.xiang@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 3/5] KVM: VMX: Remove redundant handling of bus lock vmexit
Date:   Mon, 25 Oct 2021 16:38:25 -0400
Message-Id: <20211025203828.1404503-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025203828.1404503-1-sashal@kernel.org>
References: <20211025203828.1404503-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xiang <hao.xiang@linux.alibaba.com>

[ Upstream commit d61863c66f9b443192997613cd6aeca3f65cc313 ]

Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.

We can remove redundant handling of bus lock vmexit. Unconditionally Set
exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().

Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
Message-Id: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 55de1eb135f9..87150b3c9c5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5551,9 +5551,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 
 static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
-	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-	return 0;
+	/*
+	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
+	 * VM-Exits. Unconditionally set the flag here and leave the handling to
+	 * vmx_handle_exit().
+	 */
+	to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
+	return 1;
 }
 
 /*
@@ -6039,9 +6043,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
 	/*
-	 * Even when current exit reason is handled by KVM internally, we
-	 * still need to exit to user space when bus lock detected to inform
-	 * that there is a bus lock in guest.
+	 * Exit to user space when bus lock detected to inform that there is
+	 * a bus lock in guest.
 	 */
 	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
 		if (ret > 0)
-- 
2.33.0

