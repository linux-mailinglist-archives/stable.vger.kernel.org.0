Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2DA24FC71
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgHXLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgHXLWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:22:02 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC4E52074D;
        Mon, 24 Aug 2020 11:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268122;
        bh=InHJO9IDwgJ9G/1F483WcyJQJgAGoBfqoSXLsR1DFMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDVLAOuNR+FC3JhIPWGkQN0ggIT8DiYi6rG+sIBYkD/8ZFA4X7v+wYAokhh2Yygpk
         eBnrOTQW6f6am0WYyjDmYTCNajRu0NBPruSaflTAPnttZQEZ0jreO7TLzdYwwEjTyD
         6j3ZeM2oh/ijDbbIfK0e2Sr/q2+VTkX96bzdxwho=
Date:   Mon, 24 Aug 2020 12:21:57 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     james.morse@arm.com, maz@kernel.org, pbonzini@redhat.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] KVM: Pass MMU notifier range flags to
 kvm_unmap_hva_range()" failed to apply to 5.7-stable tree
Message-ID: <20200824112156.GA24319@willie-the-truck>
References: <1598185585188235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598185585188235@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Aug 23, 2020 at 02:26:25PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
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
> From fdfe7cbd58806522e799e2a50a15aee7f2cbb7b6 Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 11 Aug 2020 11:27:24 +0100
> Subject: [PATCH] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
> 
> The 'flags' field of 'struct mmu_notifier_range' is used to indicate
> whether invalidate_range_{start,end}() are permitted to block. In the
> case of kvm_mmu_notifier_invalidate_range_start(), this field is not
> forwarded on to the architecture-specific implementation of
> kvm_unmap_hva_range() and therefore the backend cannot sensibly decide
> whether or not to block.
> 
> Add an extra 'flags' parameter to kvm_unmap_hva_range() so that
> architectures are aware as to whether or not they are permitted to block.

Backporting this is a bit fiddly, so I'll send specific backports for all
the stable kernels shortly. In the meantime, please drop this from all the
stable queues (even if it applied, as there's a risk of build breakage for
32-bit Arm).

Cheers,

Will
