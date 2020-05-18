Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EEE1D84EC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgERSOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732219AbgERSA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE9120715;
        Mon, 18 May 2020 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824827;
        bh=qL+mTuSLwqoTGoWdrlMCBkmZTudQ4BJUVXLqeLHnYyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nT4se/wezt39TeGe4EKxkCmtYOUYqwEDx2gmwuR5eJQL7fg86c2nT4zkc5FjCB236
         SeYkcJ8jEC5yFnbWiMgNkbJRzKWhETjCcHyL6x1w4Ikyp/PIhpkjQbjzNFfndq5duQ
         hruS2+mJqKmF2bgyGdig51HFyaqX1H2gr35S6TTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 002/194] kvm: nVMX: reflect MTF VM-exits if injected by L1
Date:   Mon, 18 May 2020 19:34:52 +0200
Message-Id: <20200518173531.722065159@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit b045ae906b42afb361dc7ecf1a3cea110fb0a65f ]

According to SDM 26.6.2, it is possible to inject an MTF VM-exit via the
VM-entry interruption-information field regardless of the 'monitor trap
flag' VM-execution control. KVM appropriately copies the VM-entry
interruption-information field from vmcs12 to vmcs02. However, if L1
has not set the 'monitor trap flag' VM-execution control, KVM fails to
reflect the subsequent MTF VM-exit into L1.

Fix this by consulting the VM-entry interruption-information field of
vmcs12 to determine if L1 has injected the MTF VM-exit. If so, reflect
the exit, regardless of the 'monitor trap flag' VM-execution control.

Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20200414224746.240324-1-oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b773989308015..3a2f05ef51fa4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5504,6 +5504,23 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	return 1 & (b >> (field & 7));
 }
 
+static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
+{
+	u32 entry_intr_info = vmcs12->vm_entry_intr_info_field;
+
+	if (nested_cpu_has_mtf(vmcs12))
+		return true;
+
+	/*
+	 * An MTF VM-exit may be injected into the guest by setting the
+	 * interruption-type to 7 (other event) and the vector field to 0. Such
+	 * is the case regardless of the 'monitor trap flag' VM-execution
+	 * control.
+	 */
+	return entry_intr_info == (INTR_INFO_VALID_MASK
+				   | INTR_TYPE_OTHER_EVENT);
+}
+
 /*
  * Return 1 if we should exit from L2 to L1 to handle an exit, or 0 if we
  * should handle it ourselves in L0 (and then continue L2). Only call this
@@ -5618,7 +5635,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has_mtf(vmcs12);
+		return nested_vmx_exit_handled_mtf(vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
-- 
2.20.1



