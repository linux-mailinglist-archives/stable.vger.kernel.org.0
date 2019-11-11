Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29408F7A7B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKSIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKKSIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:08:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C190D206C3;
        Mon, 11 Nov 2019 18:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573495703;
        bh=MbEqUAIaN0KyIlMJYMO+dgKL3ZN2z8aikzRbWFd2yso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X32PaJw/RZvBCpWWhSxjXPnIypK+9PrM7XCiKJ+CL5oD9n7Y6JqesfvFbcwZm76M2
         94rBTa0T3xioRqGAAdxu7ozUvg1Fbd077tytI7peYTzkh0MTr5FOuEvQzs4eBUITh1
         mo9A29Y7J+lWSCnIDoWP0rZfSR3mZdz+2fkCGcEw=
Date:   Mon, 11 Nov 2019 19:08:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 167/211] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
Message-ID: <20191111180820.GB1088065@kroah.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154525.870373223@linuxfoundation.org>
 <68d02406-b9cc-2fc1-848c-5d272d9a3350@proxmox.com>
 <20191111173757.GB11805@linux.intel.com>
 <20191111174859.GB1083018@kroah.com>
 <20191111175719.GD11805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111175719.GD11805@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 09:57:19AM -0800, Sean Christopherson wrote:
> On Mon, Nov 11, 2019 at 06:48:59PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Nov 11, 2019 at 09:37:57AM -0800, Sean Christopherson wrote:
> > > On Mon, Nov 11, 2019 at 10:32:05AM +0100, Thomas Lamprecht wrote:
> > > > On 10/3/19 5:53 PM, Greg Kroah-Hartman wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > 
> > > > > commit 16cfacc8085782dab8e365979356ce1ca87fd6cc upstream.
> > > > > 
> > > > > Manually generate the PDPTR reserved bit mask when explicitly loading
> > > > > PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
> > > > It seems that a backport of this to stable and distro kernels tickled out
> > > > some issue[0] for KVM Linux 64bit guests on older than about 8-10 year old
> > > > Intel CPUs[1].
> > > 
> > > It manifests specifically when running with EPT disabled (no surprise
> > > there).  Actually, it probably would reproduce simply with unrestricted
> > > guest disabled, but that's beside the point.
> > > 
> > > The issue is a flawed PAE-paging check in kvm_set_cr3(), which causes KVM
> > > to incorrectly load PDPTRs in 64-bit mode and inject a #GP.  It's a sneaky
> > > little bugger because the "if (is_long_mode() ..." makes it appear to be
> > > correct at first glance.
> > > 
> > > 	if (is_long_mode(vcpu) &&
> > > 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
> > > 		return 1;
> > > 	else if (is_pae(vcpu) && is_paging(vcpu) &&  <--- needs !is_long_mode()
> > > 		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> > > 		return 1;
> > > 
> > > With unrestricted guest, KVM doesn't intercept writes to CR3 and so doesn't
> > > trigger the buggy code.  This doesn't fail upstream because the offending
> > > code was refactored to encapsulate the PAE checks in a single helper,
> > > precisely to avoid this type of headache.
> > > 
> > >   commit bf03d4f9334728bf7c8ffc7de787df48abd6340e
> > >   Author: Paolo Bonzini <pbonzini@redhat.com>
> > >   Date:   Thu Jun 6 18:52:44 2019 +0200
> > > 
> > >     KVM: x86: introduce is_pae_paging
> > > 
> > >     Checking for 32-bit PAE is quite common around code that fiddles with
> > >     the PDPTRs.  Add a function to compress all checks into a single
> > >     invocation.
> > > 
> > > 
> > > Commit bf03d4f93347 ("KVM: x86: introduce is_pae_paging") doesn't apply
> > > cleanly to 4.19 or earlier because of the VMX file movement in 4.20.  But,
> > > the revelant changes in x86.c do apply cleanly, and I've quadruple checked
> > > that the PAE checks in vmx.c are correct, i.e. applying the patch and
> > > ignoring the nested.c/vmx.c conflicts would be a viable lazy option.
> > > 
> > > > Basically, booting this kernel as host, then running an KVM guest distro
> > > > or kernel fails it that guest kernel early in the boot phase without any
> > > > error or other log to serial console, earlyprintk.
> > > 
> > > ...
> > > 
> > > > 
> > > > [0]: https://bugzilla.kernel.org/show_bug.cgi?id=205441
> > > > [1]: models tested as problematic are: intel core2duo E8500; Xeon E5420; so
> > > >      westmere, conroe and that stuff. AFAICT anything from about pre-2010 which
> > > >      has VMX support (i.e. is 64bit based)
> > > 
> > > Note, not Westmere, which has EPT and unrestricted guest.  Xeon E5420 is
> > > Harpertown, a.k.a. Penryn, the shrink of Conroe.  
> > 
> > 
> > Thanks for figuring this out, can you send us a patch that we can apply
> > to fix this issue in the stable tree?
> 
> Can do.  A custom backport will be need for 4.20 and earlier, not 4.19 and
> earlier.  I misremembered when we did the VMX refactoring.
> 
> For 5.0, 5.1 and 5.2, commit bf03d4f93347 can be applied directly.

5.0, 5.1, and 5.2 are all long end-of-life, they are not getting any
updates and no one should be using them, so nothing to worry about
there.

Look at the releases page on kernel.org to see the currently active
trees.

thanks,

greg k-h
