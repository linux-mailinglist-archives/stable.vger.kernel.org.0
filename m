Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0D11E39DE
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 09:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgE0HH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 03:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgE0HH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 03:07:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E663A2078C;
        Wed, 27 May 2020 07:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590563277;
        bh=KBsrsoQqY1mI119oVrtYJKQOJoFFOjrZYR+mbY5YiF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IBKlwNNyb1qbUyCkXClSPffijI+PIWS6bf/lsfYJU/ZmdgDoNZR7mMR+VbsbcCNpH
         kRkOr0bplJAad2U6nPkAmsuWnarKgoAdfYIIzRYApKHeNrM3QlASFNvsgZE5nTZ79t
         +7BOMAvQJh6kSvrLNd/6dPd3fxKBAP0vrpvyYwYM=
Date:   Wed, 27 May 2020 09:07:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wojtek Porczyk <woju@invisiblethingslab.com>
Cc:     Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200527070755.GB39696@kroah.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526154835.GW499505@tassilo.jf.intel.com>
 <20200526163235.GA42137@kroah.com>
 <20200526172403.GA14256@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526172403.GA14256@invisiblethingslab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 07:24:03PM +0200, Wojtek Porczyk wrote:
> On Tue, May 26, 2020 at 06:32:35PM +0200, Greg KH wrote:
> > On Tue, May 26, 2020 at 08:48:35AM -0700, Andi Kleen wrote:
> > > On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > > > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > > > From: Andi Kleen <ak@linux.intel.com>
> > > > > 
> > > > > Since there seem to be kernel modules floating around that set
> > > > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > > > CR4 pinning just checks that bits are set, this also checks
> > > > > that the FSGSBASE bit is not set, and if it is clears it again.
> > > > 
> > > > So we are trying to "protect" ourselves from broken out-of-tree kernel
> > > > modules now?  
> > > 
> > > Well it's a specific case where we know they're opening a root hole
> > > unintentionally. This is just an pragmatic attempt to protect the users in the 
> > > short term.
> > 
> > Can't you just go and fix those out-of-tree kernel modules instead?
> > What's keeping you all from just doing that instead of trying to force
> > the kernel to play traffic cop?
> 
> We'd very much welcome any help really, but we're under impression that this
> couldn't be done correctly in a module, so this hack occured.

Really?  How is this hack anything other than a "prevent a kernel module
from doing something foolish" change?

Why can't you just change the kernel module's code to not do this?  What
prevents that from happening right now which would prevent the need to
change a core api from being abused in such a way?

> This was written in 2015 as part of original (research) codebase for those
> reasons:
> - A module is easier to deploy by scientists, who are no kernel developers and
>   no sysadmins either, so applying patchset and recompiling kernel is a big
>   ask.
> - It has no implications on security in SGX/Graphene threat model and in
>   expected deployment scenario.
> - This had no meaning to the actual research being done, so it wasn't cared
>   about.
> 
> Let me expand the second point, because I understand both the module and the
> explanation looks wrong.
> 
> Graphene is intended to be run in a cloud, where the CPU time is sold in
> a form of virtual machine, so the VM kernel, which would load this module, is
> not trusted by hardware owner, so s/he don't care. But the owner of the
> enclave also doesn't care, because SGX' threat model assumes adversary who is
> capable of arbitrary code execution in both kernel and userspace outside
> enclave. So the kernel immediately outside the enclave is a no-man's land,
> untrusted by both sides and forsaken, reduced to a compatibility layer
> between x86 and ELF.
> 
> I acknowledge this is unusual threat model and certainly to mainline
> developers, who rarely encounter userspace that is more trusted than kernel.
> 
> What we've failed at is to properly explain this, because if someone loads
> this module outside of this expected scenario, will certainly be exposed to
> a gaping root hole. Therefore we acknowledge this patch and as part of
> Graphene we'll probably maintain a patchset, until the support is upstream.
> Right now this will take us some time to change from our current kernel
> interfaces.

I'm sorry, but I still do not understand.  Your kernel module calls the
core with this bit being set, and this new kernel patch is there to
prevent the bit from being set and will WARN_ON() if it happens.  Why
can't you just change your module code to not set the bit?

Do you have a pointer to the kernel module code that does this operation
which this core kernel change will try to prevent from happening?

thanks,

greg k-h
