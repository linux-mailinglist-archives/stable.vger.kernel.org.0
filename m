Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708F94D6ECD
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiCLNNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 08:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCLNNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 08:13:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB465235875
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 05:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 654EFB80186
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 13:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819ACC340EB;
        Sat, 12 Mar 2022 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647090722;
        bh=aIyXpKV2wLXkliq2T3lRAIFgicnI9TOR2+yoaWfXkck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjAw9rRh5d6STizSd1rkJrhMKbdYxN3ffMmCUxndmoRQ4kAC3HOop0JcTeiJYkn8L
         ZCNJ94TzNKZMkC5S4uWbKZs+9yQVfozl4alRxxBrGZ/zBuWm5BIOe3PxsaxkD+6iJX
         OGlWM6VmAX2DScMFvJP/IFyNaRdy4qF+JG8CfJqo=
Date:   Sat, 12 Mar 2022 14:11:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.15] KVM: x86/mmu: kvm_faultin_pfn has to return false
 if pfh is returned
Message-ID: <YiycHmFtApPb2Zli@kroah.com>
References: <20220311081333.3855-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311081333.3855-1-avagin@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 12:13:33AM -0800, Andrei Vagin wrote:
> [ Upstream commit a7cc099f2ec3117678adeb69749bef7e9dde3148 ]
> 
> This looks like a typo in 8f32d5e563cb. This change didn't intend to do
> any functional changes.
> 
> The problem was caught by gVisor tests.
> 
> Fixes: 8f32d5e563cb ("KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> Message-Id: <20211015163221.472508-1-avagin@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2297dd90fe4a..d6579bae25ca 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3967,6 +3967,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  
>  	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
>  				    write, writable, hva);
> +	return false;
>  
>  out_retry:
>  	*r = RET_PF_RETRY;
> -- 
> 2.35.1
> 

Now queued up, thanks.

greg k-h
