Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AB63DA943
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG2QmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 12:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2QmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 12:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CADD60EBD;
        Thu, 29 Jul 2021 16:42:18 +0000 (UTC)
Date:   Thu, 29 Jul 2021 17:42:15 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Unregister HYP sections from kmemleak in
 protected mode
Message-ID: <20210729164214.GB31848@arm.com>
References: <20210729135016.3037277-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135016.3037277-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 02:50:16PM +0100, Marc Zyngier wrote:
> Booting a KVM host in protected mode with kmemleak quickly results
> in a pretty bad crash, as kmemleak doesn't know that the HYP sections
> have been taken away.
> 
> Make the unregistration from kmemleak part of marking the sections
> as HYP-private. The rest of the HYP-specific data is obtained via
> the page allocator, which is not subjected to kmemleak.
> 
> Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: stable@vger.kernel.org # 5.13
> ---
>  arch/arm64/kvm/arm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..23f12e602878 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -15,6 +15,7 @@
>  #include <linux/fs.h>
>  #include <linux/mman.h>
>  #include <linux/sched.h>
> +#include <linux/kmemleak.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
> @@ -1960,8 +1961,12 @@ static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
>  }
>  
>  #define pkvm_mark_hyp_section(__section)		\
> +({							\
> +	u64 sz = __section##_end - __section##_start;	\
> +	kmemleak_free_part(__section##_start, sz);	\
>  	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
> -			__pa_symbol(__section##_end))
> +		      __pa_symbol(__section##_end));	\
> +})

Using kmemleak_free_part() is fine in principle as this is not a slab
object. However, the above would call the function even for ranges that
are not tracked at all by kmemleak (text, idmap). Luckily Kmemleak won't
complain, unless you #define DEBUG in the file (initially I tried to
warn all the time but I couldn't fix all the callbacks).

If it was just the BSS, I would move the kmemleak_free_part() call to
finalize_hyp_mode() but there's the __hyp_rodata section as well.

I think we have some inconsistency with .hyp.rodata which falls under
_sdata.._edata while the kernel's own .rodata goes immediately after
_etext. Should we move __hyp_rodata outside _sdata.._edata as well? It
would benefit from the RO NX marking (probably more useful without the
protected mode). If this works, we'd only need to call kmemleak once for
the BSS.

-- 
Catalin
