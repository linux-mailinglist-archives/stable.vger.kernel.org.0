Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE730A8BE
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhBANaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhBAN3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 08:29:47 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AA764E8F;
        Mon,  1 Feb 2021 13:29:04 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6ZGI-00BHHR-7Y; Mon, 01 Feb 2021 13:29:02 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 13:29:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: Forbid the use of tagged userspace
 addresses for" failed to apply to 5.4-stable tree
In-Reply-To: <16121832895919@kroah.com>
References: <16121832895919@kroah.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <6253bf3c8ccea96cd36bc225ff5f7ed6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, catalin.marinas@arm.com, rick.p.edgecombe@intel.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2021-02-01 12:41, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 139bc8a6146d92822c866cf2fd410159c56b3648 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 21 Jan 2021 12:08:15 +0000
> Subject: [PATCH] KVM: Forbid the use of tagged userspace addresses for
>  memslots
> 
> The use of a tagged address could be pretty confusing for the
> whole memslot infrastructure as well as the MMU notifiers.
> 
> Forbid it altogether, as it never quite worked the first place.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 4e5316ed10e9..c347b7083abf 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1269,6 +1269,9 @@ field userspace_addr, which must point at user
> addressable memory for
>  the entire memory slot size.  Any object may back this memory, 
> including
>  anonymous memory, ordinary files, and hugetlbfs.
> 
> +On architectures that support a form of address tagging, 
> userspace_addr must
> +be an untagged address.
> +
>  It is recommended that the lower 21 bits of guest_phys_addr and 
> userspace_addr
>  be identical.  This allows large pages in the guest to be backed by 
> large
>  pages in the host.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..a9abaf5f8e53 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1290,6 +1290,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		return -EINVAL;
>  	/* We can read the guest memory with __xxx_user() later on. */
>  	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> +	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
>  	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>  			mem->memory_size))
>  		return -EINVAL;

I'll post a revised patch for 5.4. No need to go beyond that as that's
the point where we allowed tagged addresses at the syscall boundary.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
