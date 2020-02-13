Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1715C530
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbgBMPxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgBMPZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:59 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BC1246A4;
        Thu, 13 Feb 2020 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607559;
        bh=S4DzwHYCY3CLuYO3qyPRO+7UY3eDtnVPUgCVumY+X5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE5In5XhDEFSATUXhfF859l6aEglMnforsBSyZAStIhIE99DGAYEhHIIxhzPFzTep
         gXRj+SsdcVK9zPhGoOmI8aqq+/5yB8FNGakTnEQMa+3bV9cH+aUnDPFRt2Y8Q1MrPX
         HrbCPghPD6eeMVYDBdeiwo2lFRbZfqMnuECD/1BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/173] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
Date:   Thu, 13 Feb 2020 07:20:34 -0800
Message-Id: <20200213152005.151928034@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit e30a7d623dccdb3f880fbcad980b0cb589a1da45 ]

Remove the bogus 64-bit only condition from the check that disables MMIO
spte optimization when the system supports the max PA, i.e. doesn't have
any reserved PA bits.  32-bit KVM always uses PAE paging for the shadow
MMU, and per Intel's SDM:

  PAE paging translates 32-bit linear addresses to 52-bit physical
  addresses.

The kernel's restrictions on max physical addresses are limits on how
much memory the kernel can reasonably use, not what physical addresses
are supported by hardware.

Fixes: ce88decffd17 ("KVM: MMU: mmio page fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d915ea0e69cfd..d6851636edab3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6314,7 +6314,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
-	if (IS_ENABLED(CONFIG_X86_64) && maxphyaddr == 52)
+	if (maxphyaddr == 52)
 		mask &= ~1ull;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask);
-- 
2.20.1



