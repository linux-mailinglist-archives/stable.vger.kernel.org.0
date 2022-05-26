Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C62534EE2
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiEZMNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiEZMND (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:13:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425CEB0A5E
        for <stable@vger.kernel.org>; Thu, 26 May 2022 05:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0398CB82058
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E245C385A9;
        Thu, 26 May 2022 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653567179;
        bh=ydqPOih56mPyBRP/uHqvs5hKcOR8Eg10Oajsk3uM3iI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eZyJM6ZpPujNW8NZt5mG5DQ5fyaJ1JBemwmBZJ4d2OEKD3fd/L97EfPQZT5evC1Oa
         x5n2ROWEdiO40oqfjTUZpwx8VreVNsFAxNHBHeX52hbSrjcZ2PCCjr0v+zgS+4eeeT
         dgcCf3g7k0z17eD323UQtriVPSVF3BKQTfEvUfYY=
Date:   Thu, 26 May 2022 14:12:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>
Subject: Re: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest
 INVPCID
Message-ID: <Yo9uyGymsYPeaIw/@kroah.com>
References: <165314153515625@kroah.com>
 <20220524151118.4828-1-vegard.nossum@oracle.com>
 <Yoz4Qg+a5C/lw743@kroah.com>
 <e4127ebb-c589-ac2c-e77a-6c56a9c8fbc4@oracle.com>
 <Yoz7SFl7dIb65kPw@kroah.com>
 <46577540-6ed7-0ff5-11d5-2982cd29e92b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46577540-6ed7-0ff5-11d5-2982cd29e92b@oracle.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 07:48:51PM +0200, Vegard Nossum wrote:
> 
> On 5/24/22 17:35, Greg KH wrote:
> > On Tue, May 24, 2022 at 05:27:56PM +0200, Vegard Nossum wrote:
> >>
> >> On 5/24/22 17:22, Greg KH wrote:
> >>> What kernel tree(s) are you wanting this to be applied to?
> >>
> >> I replied to the v5.17 email
> >> (https://lore.kernel.org/stable/165314153515625@kroah.com/T/#u) and I've
> >> only tested this on top of 5.17.9.
> >>
> >> Is that generally enough to trigger attempts to automatically
> >> cherry-pick it onto the older branches or should I test and submit for
> >> the older ones as well?
> > 
> > You should test and submit for the older ones as well please.
> 
> Thanks, will do shortly.
> 
> >> How would you prefer to indicate the kernel tree(s) in the future?
> > 
> > Just say so in the [PATCH 5.17.y] subject line, or in the signed-off-by
> > area or below the --- line.
> > 
> > Responding to the email and relying on the thread alone doesn't usually
> > work as the original message is long gone from my mailboxes, I can't
> > keep that old stuff cluttering up the place :)
> 
> If you want to make it easier for people to respond to these emails you
> could change the FAILED: message to list specific git commands needed to
> fix and submit. For this one in particular, you could for example make
> it say:
> 
> git fetch
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
> linux-5.17.y
> git checkout FETCH_HEAD
> git cherry-pick -x 9f46c187e2e680ecd9de7983e4d081c3391acc76
> # <resolve conflicts, build, test, etc.>
> git send-email --subject-prefix 'PATCH 5.17.y' --to
> 'stable@vger.kernel.org' HEAD^..
> 
> Just an idea...

That's a nice idea, I'll consider adding it to my scripts.

> (And argh, just sent out for 5.15 and I put "PATCH 5.15" instead of
> "PATCH 5.15.y" -- does that matter?)

No, not at all, all is good and now queued up, thanks.

greg k-h
