Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255F2178C46
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCDIKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgCDIKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 03:10:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 164502166E;
        Wed,  4 Mar 2020 08:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583309403;
        bh=1YrwTCj3XBWbFrhCAMXtkFQ1x10evEuvmD/owQ7q17A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4PdvpzxhaRLCz25gwPPpfHUHtEjNdHB+jSF/ktZlEQVqWSuei9rdcT0NQo1GP+Mt
         z4kEYk+KJpIywFAoh1bPhwOro3DuRvOzCbO2PxDDPS6gTfMdWRSYEMCfN9QsWd3V9o
         jsDKVAH6G3bfWXwGLHPh8txEFcNoItskBrA9L4uM=
Date:   Wed, 4 Mar 2020 09:10:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 111/176] KVM: nVMX: Emulate MTF when performing
 instruction emulation
Message-ID: <20200304081001.GB1401372@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <20200303174317.670749078@linuxfoundation.org>
 <8780cf08-374b-da06-0047-0fe8eeec0113@redhat.com>
 <CAOQ_QsjG32KrG6hVMaMenUYk1+Z+jhcCsGOk=t9i+-9oZRGWeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjG32KrG6hVMaMenUYk1+Z+jhcCsGOk=t9i+-9oZRGWeA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 11:39:35PM -0800, Oliver Upton wrote:
> On Tue, Mar 3, 2020 at 11:23 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 03/03/20 18:42, Greg Kroah-Hartman wrote:
> > > From: Oliver Upton <oupton@google.com>
> > >
> > > commit 5ef8acbdd687c9d72582e2c05c0b9756efb37863 upstream.
> > >
> > > Since commit 5f3d45e7f282 ("kvm/x86: add support for
> > > MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> > > flag processor-based execution control for its L2 guest. KVM simply
> > > forwards any MTF VM-exits to the L1 guest, which works for normal
> > > instruction execution.
> > >
> > > However, when KVM needs to emulate an instruction on the behalf of an L2
> > > guest, the monitor trap flag is not emulated. Add the necessary logic to
> > > kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> > > instruction emulation for L2.
> > >
> > > Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > Why is this included in a stable release?  It was part of a series of
> > four patches and the prerequisites as far as I can see are not part of 5.5.
> 
> It looks like these commits were already picked from upstream:
> 
> 684c0422da71 ("KVM: nVMX: Handle pending #DB when injecting INIT VM-exit")
> 307f1cfa2696 ("KVM: x86: Mask off reserved bit from #DB exception payload")
> 
> Which were bug fixes in their own right and were sensible for
> backporting (though I didn't cc stable if I'm not mistaken).
> 
> but not:
> 
> a06230b62b89 ("KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS")
> 
> which this patch absolutely depends on.
> 
> Otherwise, I'll defer discussions regarding the suitability of this
> patch for stable to Paolo.

I picked this patch up solely because of the Fixes: tag showed that this
ommit resolved something from a previous commit.  The interdependancies
were not obvious, especially as it all seemed to build just fine here.

> > I have already said half a dozen times that I don't want any of the
> > autopick stuff for KVM.  Is a Fixes tag sufficient to get patches into
> > stable now?

Yes, it can happen that a Fixes tag does cause a patch to get into
stable because I look out for that.  I do that because a number of
maintainers/developers only put that tag in there, and also to catch
patches for when we backport stuff and then need to take a fix for that
backport (not the case here though).

I'll be glad to just put KVM into the "never apply any patches to
stable unless you explicitly mark it as such", but the sad fact is that
many recent KVM fixes for reported CVEs never had any "Cc: stable@vger"
markings.  They only had "Fixes:" tags and so I have had to dig them out
of the tree and backport them myself in order to resolve those very
public issues.

So can I ask that you always properly tag things for stable?  If so, I
will be glad to ignore Fixes: tags for KVM patches in the future.

I'll go drop this patch as well.  Note, there are other KVM patches in
this release cycle also, can someone verify that I did not overreach for
them as well?

thanks,

greg k-h
