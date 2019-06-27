Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DC57846
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfF0Adj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfF0Adi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:38 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 177AE217F4;
        Thu, 27 Jun 2019 00:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595617;
        bh=VeKmQzho/gOhdsnYmQ/DgZecF4AfC/P/ofqbJwvbxYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3ZyZL8ay4f++sn4G9Tdyk/dpjWOpNAo0okYe5GtPubuTsml7ijX+EmB6I4TayWip
         6TH1n23NefdpQSxbYfxUibQRJ3huE5A94dA9ATKOhHlP96JokcLgHhfjvLA/pxyvrU
         sKOcn5ijNn+MM4fGOmtWRygKS/NfXfafBWskKVLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 57/95] KVM: nVMX: use correct clean fields when copying from eVMCS
Date:   Wed, 26 Jun 2019 20:29:42 -0400
Message-Id: <20190627003021.19867-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f9bc5227652df4900eff12a9b8b38e9a8c7c78ea ]

Unfortunately, a couple of mistakes were made while implementing
Enlightened VMCS support, in particular, wrong clean fields were
used in copy_enlightened_to_vmcs12():
- exception_bitmap is covered by CONTROL_EXCPN;
- vm_exit_controls/pin_based_vm_exec_control/secondary_vm_exec_control
  are covered by CONTROL_GRP1.

Fixes: 945679e301ea0 ("KVM: nVMX: add enlightened VMCS state")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5fa0c17d0b41..4ca834d22169 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1404,7 +1404,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 	}
 
 	if (unlikely(!(evmcs->hv_clean_fields &
-		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC))) {
+		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN))) {
 		vmcs12->exception_bitmap = evmcs->exception_bitmap;
 	}
 
@@ -1444,7 +1444,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 	}
 
 	if (unlikely(!(evmcs->hv_clean_fields &
-		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1))) {
+		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1))) {
 		vmcs12->pin_based_vm_exec_control =
 			evmcs->pin_based_vm_exec_control;
 		vmcs12->vm_exit_controls = evmcs->vm_exit_controls;
-- 
2.20.1

