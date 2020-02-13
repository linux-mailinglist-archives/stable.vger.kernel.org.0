Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4682D15C6D5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgBMQEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:04:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgBMPYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:08 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98D0E24690;
        Thu, 13 Feb 2020 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607447;
        bh=NSl0QrEKiOkbgfri/p32nDkaFvn2spBG2s1vpvEtXyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEGRRGCEsc1H/gdKdI3qKBm6hUdMgRSGURxG5V/w0NiKnmKinIoh+FUF9rSknmAjT
         aY8cZYVOCHQJglNRm3xdHKn8xuPvkMoX1IFFzhee7nJcR5fi9ymjxeg1iqUO2gYERJ
         FNv3UEwJBXP2dnOc7IprA8tREXPIjcSNJo5FBhSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/116] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
Date:   Thu, 13 Feb 2020 07:20:34 -0800
Message-Id: <20200213151917.983069432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
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
 arch/x86/kvm/x86.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6132,14 +6132,12 @@ static void kvm_set_mmio_spte_mask(void)
 	/* Set the present bit. */
 	mask |= 1ull;
 
-#ifdef CONFIG_X86_64
 	/*
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
 	if (maxphyaddr == 52)
 		mask &= ~1ull;
-#endif
 
 	kvm_mmu_set_mmio_spte_mask(mask);
 }


