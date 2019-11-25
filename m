Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B721093A4
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKYSlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbfKYSlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 13:41:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 466672082F;
        Mon, 25 Nov 2019 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574707274;
        bh=ao7yUUFS4L3B1AFCGdlva7cNzx6j5ghH6aHUFbb5xz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Et46g5fCJajUxfEMmEmKtCblNoVIX87XC545jvu9h/epJUWsmu9hTTIxJSecih6Av
         K6s8sDSiKF2fbkYmjx06sJLaiUkB5x7JeEHvYuZJDhTnGOQPrUJURyi3zksqE466CD
         OAfAHA6TR8Irf2+Povy1a7w4MvTokCVW93mlhSwY=
Date:   Mon, 25 Nov 2019 19:41:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, dan.j.williams@intel.com,
        david@redhat.com, kilobyte@angband.pl, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: MMU: Do not treat ZONE_DEVICE pages
 as being reserved" failed to apply to 4.19-stable tree
Message-ID: <20191125184112.GA2961575@kroah.com>
References: <1574090560219@kroah.com>
 <20191125174359.GI5861@sasha-vm>
 <20191125180136.GE12178@linux.intel.com>
 <20191125183434.GG12178@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125183434.GG12178@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 10:34:34AM -0800, Sean Christopherson wrote:
> On Mon, Nov 25, 2019 at 10:01:36AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 25, 2019 at 12:43:59PM -0500, Sasha Levin wrote:
> > > On Mon, Nov 18, 2019 at 04:22:40PM +0100, gregkh@linuxfoundation.org wrote:
> > > >
> > > >The patch below does not apply to the 4.19-stable tree.
> 
> ...
> 
> > > >Reported-by: Adam Borowski <kilobyte@angband.pl>
> > > >Analyzed-by: David Hildenbrand <david@redhat.com>
> > > >Acked-by: Dan Williams <dan.j.williams@intel.com>
> > > >Cc: stable@vger.kernel.org
> > > >Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
> > > >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > >Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > I also took e7912386ede8 ("KVM: x86: reintroduce pte_list_remove, but
> > > including mmu_spte_clear_track_bits") and queued both for 4.19-4.9.
> > 
> > I don't think that will work, you'd also have to pull in commit 8daf346226b2
> > ("KVM: x86: rename pte_list_remove to __pte_list_remove").  And e7912386ede8
> > in particular isn't stable material.
> > 
> > I'll send a proper backport for 4.19 and earlier, the conflicts should be
> > easy to resolve.
> 
> I have a silly backporting question regarding SOBs.  Should I add a second
> SOB for myself, reorder the SOBs, or leave it as is?  E.g. (A) is the most
> correct from a chronological handling perspective, but having two SOBs
> feels weird.
> 
>   Option A:
>     Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     [sean: backport to 4.x; resolve conflict in mmu.c]
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
>   Option B:
>     Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     [sean: backport to 4.x; resolve conflict in mmu.c]
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
>   Option C:
>     Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I really do not care, what ever one you want to do :)

Sometimes A or B is usually a bit nicer to give some context as to what
you did.

thanks,

greg k-h
