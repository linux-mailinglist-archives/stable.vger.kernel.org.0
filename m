Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152B81578ED
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgBJNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgBJMjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D737B24649;
        Mon, 10 Feb 2020 12:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338342;
        bh=4D7tUMkPsG5FNg/v28rRZBjTiHvzug2ly/7Bk6CjtN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkDB8pKmRWunaEAGtbOOAFqOJYGy2KQ1z1ziACCX/1JiL/lvlPBazgZfyi5TCAwRp
         Qkigh420qySNHOKBI4BEk1yH4oOQUwO+yVq8Av4h7H7Edc36CR1XdVw/RMikCWxZdN
         SWeybUrh6IxshlTDVNlxny8fPnqvrKKhrSU4UStI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/309] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
Date:   Mon, 10 Feb 2020 04:34:11 -0800
Message-Id: <20200210122435.142959769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2ce9da58611ed..3644ac215567b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -6249,7 +6249,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
-	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
+	if (shadow_phys_bits == 52)
 		mask &= ~1ull;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
-- 
2.20.1



