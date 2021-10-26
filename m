Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9474A43B833
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhJZRey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237815AbhJZRex (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 13:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E11C160041;
        Tue, 26 Oct 2021 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635269549;
        bh=cV1ULMlxLTmmWuVCFHP8HKqbK/MmmPd51mo7+Oer/3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qEAtobNiM8kDesybwBtFJiBXgsgfsSAF0yIHvxu46KN/jG3j2jmKzzulLV6U55/ue
         dOxVu6Oab34qf9fvaKbJXczBQRAnQ9Y0ha7qU1CuaWRjMM93mRuFbXB+WOnNPEmN3b
         6sI62FUvgPp2W7TB/N4lO/eoAruj4BiN09w5UF85NenToUCVcHjgam/lka2wbF+A3V
         eJXcfqVsa75B++KSiCeChVHShNA5kUs5JGEL9srHp1f31SUhUfMa87jq0fDLVsb19S
         xi++buRYPt7MGMjf32l9jwfzpclTrfNC3W3VRNyiBDVnRMwld8+gecxSd1q/CjIybT
         0ZFti0qbvwv3Q==
Date:   Tue, 26 Oct 2021 13:32:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.14 1/5] KVM: X86: fix lazy allocation of rmaps
Message-ID: <YXg7qymDdWZGm3Hm@sashalap>
References: <20211025203828.1404503-1-sashal@kernel.org>
 <9c88dadb-8cae-9bbe-1241-dfc06afe13d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9c88dadb-8cae-9bbe-1241-dfc06afe13d5@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 06:14:34PM +0200, Paolo Bonzini wrote:
>On 25/10/21 22:38, Sasha Levin wrote:
>>From: Paolo Bonzini <pbonzini@redhat.com>
>>
>>[ Upstream commit fa13843d1565d4c5b3aeb9be3343b313416bef46 ]
>>
>>If allocation of rmaps fails, but some of the pointers have already been written,
>>those pointers can be cleaned up when the memslot is freed, or even reused later
>>for another attempt at allocating the rmaps.  Therefore there is no need to
>>WARN, as done for example in memslot_rmap_alloc, but the allocation *must* be
>>skipped lest KVM will overwrite the previous pointer and will indeed leak memory.
>>
>>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  arch/x86/kvm/x86.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>index 4b0e866e9f08..60d9aa0ab389 100644
>>--- a/arch/x86/kvm/x86.c
>>+++ b/arch/x86/kvm/x86.c
>>@@ -11341,7 +11341,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>>  		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
>>  					  slot->base_gfn, level) + 1;
>>-		WARN_ON(slot->arch.rmap[i]);
>>+		if (slot->arch.rmap[i])
>>+			continue;
>>  		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
>>  		if (!slot->arch.rmap[i]) {
>>
>
>NACK
>
>There is no lazy allocation of rmaps in 5.14, and any failure to 
>allocate goes straight to memslot_rmap_free followed by return 
>-ENOMEM.  So the WARN_ON is justified there.

I'll queue up the ones you've acked, thanks :)

-- 
Thanks,
Sasha
