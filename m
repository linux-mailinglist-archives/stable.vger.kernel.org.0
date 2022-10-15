Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2AB5FF8A1
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 07:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJOFpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJOFpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 01:45:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29752DAA0
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 22:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CBB8B80DC0
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 05:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00FCC433C1;
        Sat, 15 Oct 2022 05:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665812701;
        bh=zQ5p5Jt0AohBTf1AFnWVaPhdrCkYt2k0e5IMpdkLn0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofJGXAp/Maw/Ja5prPrGTYy6fZgEZMfrLtU6PwuLP27KB7saWgA9dIHakwcLScB5I
         oT9p38cpZdWwDuj4RqvJrB8jM74OGSkJaqctRTgWrVVOylYqA+DuJEBhUJ6vpO0wME
         hPakAePLJPAvMsvzNmz6+vrm5DJuJqn00NEmTMwo=
Date:   Sat, 15 Oct 2022 07:45:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     surajjs@amazon.com, luizcap@amazon.com, aams@amazon.de,
        mbacco@amazon.com, David Woodhouse <dwmw2@infradead.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: Fix recording of guest steal time /
 preempted status
Message-ID: <Y0pJCrVBEGNpFzNV@kroah.com>
References: <20221014222643.25815-1-risbhat@amazon.com>
 <20221014222643.25815-4-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014222643.25815-4-risbhat@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 10:26:36PM +0000, Rishabh Bhatnagar wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> commit 7e2175ebd695f17860c5bd4ad7616cce12ed4591 upstream.
> 
> In commit b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is
> not missed") we switched to using a gfn_to_pfn_cache for accessing the
> guest steal time structure in order to allow for an atomic xchg of the
> preempted field. This has a couple of problems.
> 
> Firstly, kvm_map_gfn() doesn't work at all for IOMEM pages when the
> atomic flag is set, which it is in kvm_steal_time_set_preempted(). So a
> guest vCPU using an IOMEM page for its steal time would never have its
> preempted field set.
> 
> Secondly, the gfn_to_pfn_cache is not invalidated in all cases where it
> should have been. There are two stages to the GFN->PFN conversion;
> first the GFN is converted to a userspace HVA, and then that HVA is
> looked up in the process page tables to find the underlying host PFN.
> Correct invalidation of the latter would require being hooked up to the
> MMU notifiers, but that doesn't happen---so it just keeps mapping and
> unmapping the *wrong* PFN after the userspace page tables change.
> 
> In the !IOMEM case at least the stale page *is* pinned all the time it's
> cached, so it won't be freed and reused by anyone else while still
> receiving the steal time updates. The map/unmap dance only takes care
> of the KVM administrivia such as marking the page dirty.
> 
> Until the gfn_to_pfn cache handles the remapping automatically by
> integrating with the MMU notifiers, we might as well not get a
> kernel mapping of it, and use the perfectly serviceable userspace HVA
> that we already have.  We just need to implement the atomic xchg on
> the userspace address with appropriate exception handling, which is
> fairly trivial.
> 
> Cc: stable@vger.kernel.org
> Fixes: b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Message-Id: <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
> [I didn't entirely agree with David's assessment of the
>  usefulness of the gfn_to_pfn cache, and integrated the outcome
>  of the discussion in the above commit message. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [risbhat@amazon.com: Use the older mark_page_dirty_in_slot api without
> kvm argument]
> Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   2 +-
>  arch/x86/kvm/x86.c              | 105 +++++++++++++++++++++++---------
>  2 files changed, 76 insertions(+), 31 deletions(-)

This is already in some stable kernels, why send it again and what
tree(s) are you asking for it to be applied to?

Same for the other backports you sent.

confused,

greg k-h
