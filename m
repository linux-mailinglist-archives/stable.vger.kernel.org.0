Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAAD532D57
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbiEXPXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbiEXPXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884959EB5F
        for <stable@vger.kernel.org>; Tue, 24 May 2022 08:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 210B9B8198E
        for <stable@vger.kernel.org>; Tue, 24 May 2022 15:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9A2C34115;
        Tue, 24 May 2022 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653405765;
        bh=CH1zB83TXwY9AXB4/7eLkt47gm0spLwTQC3oJ9y/vKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJKnFuCIUmUQJZ6B8JT4C1ng+JmA0jK3k9vFh0Tb0VE4eKAlCMuN7xtIR0liuTdAW
         jDcCBXcHYAJlR4sMTOlN/yCWE2iYVGrjxIL4GEqAONQH9cmR4Qw1/D7zK6NjxM4OHT
         cEDkgYT2nKiwZsFtNltpBBp0j5+6YbdDSQF1x1Sw=
Date:   Tue, 24 May 2022 17:22:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>
Subject: Re: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest
 INVPCID
Message-ID: <Yoz4Qg+a5C/lw743@kroah.com>
References: <165314153515625@kroah.com>
 <20220524151118.4828-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524151118.4828-1-vegard.nossum@oracle.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 05:11:18PM +0200, Vegard Nossum wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit 9f46c187e2e680ecd9de7983e4d081c3391acc76 upstream.
> 
> With shadow paging enabled, the INVPCID instruction results in a call
> to kvm_mmu_invpcid_gva.  If INVPCID is executed with CR0.PG=0, the
> invlpg callback is not set and the result is a NULL pointer dereference.
> Fix it trivially by checking for mmu->invlpg before every call.
> 
> There are other possibilities:
> 
> - check for CR0.PG, because KVM (like all Intel processors after P5)
>   flushes guest TLB on CR0.PG changes so that INVPCID/INVLPG are a
>   nop with paging disabled
> 
> - check for EFER.LMA, because KVM syncs and flushes when switching
>   MMU contexts outside of 64-bit mode
> 
> All of these are tricky, go for the simple solution.  This is CVE-2022-1789.
> 
> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [fix conflict due to missing b9e5603c2a3accbadfec570ac501a54431a6bdba]
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

What kernel tree(s) are you wanting this to be applied to?

thanks,

greg k-h
