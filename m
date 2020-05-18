Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8CC1D82DD
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbgERSAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732162AbgERR77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8F920715;
        Mon, 18 May 2020 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824799;
        bh=c48ogVGF6S4M1K07w86brOJZ061L4fbVfuNXGCQGEbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtjhCKUVHsForUIVA1WnRVACBYXTy55RtVvcxzqSWG5Lmdr7aDq/E0ZFXoKJQ/los
         jFZJTxhmYE5Zfj8jSoMcFTRp348Puaq+YmQM4AGEI2r/ZkyQS8d9ZMkUsD3NGgS6ls
         bptRAZh/V/Eea4qnlItdpn16C+jLGchMjWBfWva8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 001/194] KVM: nVMX: Consolidate nested MTF checks to helper function
Date:   Mon, 18 May 2020 19:34:51 +0200
Message-Id: <20200518173531.615601713@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 212617dbb6bac2a21dec6ef7d6012d96bb6dbb5d ]

commit 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing
instruction emulation") introduced a helper to check the MTF
VM-execution control in vmcs12. Change pre-existing check in
nested_vmx_exit_reflected() to instead use the helper.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index eec7b2d93104c..b773989308015 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5618,7 +5618,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+		return nested_cpu_has_mtf(vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
-- 
2.20.1



