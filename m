Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71BA532D9F
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiEXPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiEXPfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6249F580E1
        for <stable@vger.kernel.org>; Tue, 24 May 2022 08:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F139F6170D
        for <stable@vger.kernel.org>; Tue, 24 May 2022 15:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED33FC34113;
        Tue, 24 May 2022 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653406539;
        bh=7gOyQqI0BmgAbC/65uwz4Q47Og6ISQk62+P8IHxu1fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ebUPesjUERZR0Ds+51eTIJqWccDSmXqqBQNNpe0imsgX1KqHfOB7Bi8K+Fa4DqDBW
         MmMcnplUd+s2DVrd4KT6T5EuzBHzs0gywkImCYucHH/drOdJKJ+3dcnmDfMs1T1J91
         9ndFl7F5Lp0TvtvBdAIO3/tEQ984usALG1uYtZfw=
Date:   Tue, 24 May 2022 17:35:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>
Subject: Re: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest
 INVPCID
Message-ID: <Yoz7SFl7dIb65kPw@kroah.com>
References: <165314153515625@kroah.com>
 <20220524151118.4828-1-vegard.nossum@oracle.com>
 <Yoz4Qg+a5C/lw743@kroah.com>
 <e4127ebb-c589-ac2c-e77a-6c56a9c8fbc4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4127ebb-c589-ac2c-e77a-6c56a9c8fbc4@oracle.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 05:27:56PM +0200, Vegard Nossum wrote:
> 
> On 5/24/22 17:22, Greg KH wrote:
> > On Tue, May 24, 2022 at 05:11:18PM +0200, Vegard Nossum wrote:
> >> From: Paolo Bonzini <pbonzini@redhat.com>
> >>
> >> commit 9f46c187e2e680ecd9de7983e4d081c3391acc76 upstream.
> >>
> >> With shadow paging enabled, the INVPCID instruction results in a call
> >> to kvm_mmu_invpcid_gva.  If INVPCID is executed with CR0.PG=0, the
> >> invlpg callback is not set and the result is a NULL pointer dereference.
> >> Fix it trivially by checking for mmu->invlpg before every call.
> >>
> >> There are other possibilities:
> >>
> >> - check for CR0.PG, because KVM (like all Intel processors after P5)
> >>   flushes guest TLB on CR0.PG changes so that INVPCID/INVLPG are a
> >>   nop with paging disabled
> >>
> >> - check for EFER.LMA, because KVM syncs and flushes when switching
> >>   MMU contexts outside of 64-bit mode
> >>
> >> All of these are tricky, go for the simple solution.  This is CVE-2022-1789.
> >>
> >> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >> [fix conflict due to missing b9e5603c2a3accbadfec570ac501a54431a6bdba]
> >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> >> ---
> >>  arch/x86/kvm/mmu/mmu.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > What kernel tree(s) are you wanting this to be applied to?
> 
> I replied to the v5.17 email
> (https://lore.kernel.org/stable/165314153515625@kroah.com/T/#u) and I've
> only tested this on top of 5.17.9.
> 
> Is that generally enough to trigger attempts to automatically
> cherry-pick it onto the older branches or should I test and submit for
> the older ones as well?

You should test and submit for the older ones as well please.

> How would you prefer to indicate the kernel tree(s) in the future?

Just say so in the [PATCH 5.17.y] subject line, or in the signed-off-by
area or below the --- line.

Responding to the email and relying on the thread alone doesn't usually
work as the original message is long gone from my mailboxes, I can't
keep that old stuff cluttering up the place :)

thanks,

greg k-h
