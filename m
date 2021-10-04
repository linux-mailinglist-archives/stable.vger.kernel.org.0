Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1407E420F94
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhJDNgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237412AbhJDNeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6816322E;
        Mon,  4 Oct 2021 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353335;
        bh=LgLeeQ3zUhnWp7pPHG74A0xyP+Q69eZpi8ZtnZdj5jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egxm7QMSgs9BGaqAvlm406ORJB4ELT/Gtm7rcpXCh0pDvrdcSwP7z76sqqk4edAd3
         ar9e7ry+ETKaOKMGuI/0CoRfw1epS/jq2CzLZHDbYVsBVu4ir8uqjv/UIAG41ewV6F
         KcKXPoloUEfnyWU49xfjxW3H418/byzbe7KuuObw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 061/172] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Date:   Mon,  4 Oct 2021 14:51:51 +0200
Message-Id: <20211004125046.965171779@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

commit 5c49d1850ddd3240d20dc40b01f593e35a184f38 upstream.

When updating the host's mask for its MSR_IA32_TSX_CTRL user return entry,
clear the mask in the found uret MSR instead of vmx->guest_uret_msrs[i].
Modifying guest_uret_msrs directly is completely broken as 'i' does not
point at the MSR_IA32_TSX_CTRL entry.  In fact, it's guaranteed to be an
out-of-bounds accesses as is always set to kvm_nr_uret_msrs in a prior
loop. By sheer dumb luck, the fallout is limited to "only" failing to
preserve the host's TSX_CTRL_CPUID_CLEAR.  The out-of-bounds access is
benign as it's guaranteed to clear a bit in a guest MSR value, which are
always zero at vCPU creation on both x86-64 and i386.

Cc: stable@vger.kernel.org
Fixes: 8ea8b8d6f869 ("KVM: VMX: Use common x86's uret MSR list as the one true list")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210926015545.281083-1-zhenzhong.duan@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6816,7 +6816,7 @@ static int vmx_create_vcpu(struct kvm_vc
 		 */
 		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (tsx_ctrl)
-			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);


