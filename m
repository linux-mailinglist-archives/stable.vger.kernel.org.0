Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C59229878
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgGVMse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMse (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:48:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F30F0206C1;
        Wed, 22 Jul 2020 12:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422113;
        bh=dGBfp7Klwok4vr8vUMfrfauNsOobvQmUSzL0CqTbW4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cR00N/iyHl4P1vbbXusxvbADqNF0VIlB0XTJCc3Mxvd+cVV+SMuD/DPNE1qJOBEjJ
         N/0jQkwF6fA9LO3OiKzeq1UYZMANMcDKNZbNoLHEON3moX7OsWWRy+1ew+0xgtA8Pb
         /UFVpogso/yPktLj4Po8cEYK5YJ5QtA8eVyk1UgA=
Date:   Wed, 22 Jul 2020 14:48:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     walken@google.com, Atish Patra <Atish.Patra@wdc.com>,
        naresh.kamboju@linaro.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, zong.li@sifive.com,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Message-ID: <20200722124839.GB3155653@kroah.com>
References: <20200720191403.GB1529125@kroah.com>
 <mhng-903745bf-c5df-4e70-ade8-c1e596265fc4@palmerdabbelt-glaptop1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-903745bf-c5df-4e70-ade8-c1e596265fc4@palmerdabbelt-glaptop1>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 03:50:35PM -0700, Palmer Dabbelt wrote:
> On Mon, 20 Jul 2020 12:14:03 PDT (-0700), Greg KH wrote:
> > On Mon, Jul 20, 2020 at 06:50:10PM +0000, Atish Patra wrote:
> > > On Mon, 2020-07-20 at 23:11 +0530, Naresh Kamboju wrote:
> > > > RISC-V build breaks on stable-rc 5.7 branch.
> > > > build failed with gcc-8, gcc-9 and gcc-9.
> > > >
> > > 
> > > Sorry for the compilation issue.
> > > 
> > > mmap_read_lock was intrdouced in the following commit.
> > > 
> > > commit 9740ca4e95b4
> > > Author: Michel Lespinasse <walken@google.com>
> > > Date:   Mon Jun 8 21:33:14 2020 -0700
> > > 
> > >     mmap locking API: initial implementation as rwsem wrappers
> > > 
> > > The following two commits replaced the usage of mmap_sem rwsem calls
> > > with mmap_lock.
> > > 
> > > d8ed45c5dcd4 (mmap locking API: use coccinelle to convert mmap_sem
> > > rwsem call sites)
> > > 89154dd5313f (mmap locking API: convert mmap_sem call sites missed by
> > > coccinelle)
> > > 
> > > The first commit is not present in stale 5.7-y for obvious reasons.
> > > 
> > > Do we need to send a separate patch only for stable branch with
> > > mmap_sem ? I am not sure if that will cause a conflict again in future.
> > 
> > I do not like taking odd backports, and would rather take the real patch
> > that is upstream.
> 
> I guess I'm a bit new to stable backports so I'm not sure what's expected here.
> The failing patch fixes a bug by using a new interface.  The smallest diff fix
> for the stable kernels would be to construct a similar fix without the new
> interface, which in this case is very easy as the new interface just converted
> some generic locking calls to one-line functions.  It seems somewhat circuitous
> to land that in Linus' tree, though, as it would require breaking our port
> before fixing it to use the old interfaces and then cleaning it up to use the
> new interfaces.
> 
> Are we expected to pull the new interface onto stable in addition to this fix?

If it really does fix a big issue, yes, that is fine to do.

> The new interface doesn't actually fix anything itself, but it would allow a
> functional kernel to be constructed that consisted of only backports from
> Linus' tree (which would also make further fixes easier).

That's fine.

> It seems safe to
> just pull in 9740ca4e95b4 ("mmap locking API: initial implementation as rwsem
> wrappers") before this failing patch, as in this case the new interface will
> function correctly with only a subset of callers having been converted.  Of
> course that's not a generally true statement so I don't know if future code
> will behave that way, but pulling in those conversion patches is definitely
> unnecessary diff right now.

If someone wants to send me a full set of the git ids that need to be
pulled in, I will be glad to do so.

thanks,

greg k-h
