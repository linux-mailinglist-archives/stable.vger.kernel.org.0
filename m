Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E405A9C7
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 11:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfF2JLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 05:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfF2JLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jun 2019 05:11:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3E2214DA;
        Sat, 29 Jun 2019 09:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561799462;
        bh=zXdr+Vao8tEivgZ5LT/UbsF8u4CsjUqYk6BSfKxz+fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F5JqH7XhPro7yzmL6qJVnuxTf6+gKL7w0xgk+URkdSmAzi3u+eYqtKYCRtcWPXLmK
         GhGhRVkOm04mFGHsM0rqxd5S6Yvx14K+A2FzHSV0ZHabS/kR7yUMjGRl+9a2Hl2WJw
         lSS8HjdCwZmabI6xInf1Qi7jiOxH7XeAi7jkwneM=
Date:   Sat, 29 Jun 2019 11:10:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        stable <stable@vger.kernel.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
Message-ID: <20190629091059.GA4198@kroah.com>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
 <20190629065721.GA365@kroah.com>
 <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 29, 2019 at 10:47:00AM +0200, Ard Biesheuvel wrote:
> On Sat, 29 Jun 2019 at 08:57, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jun 28, 2019 at 11:42:13AM -0700, Srivatsa S. Bhat wrote:
> > > From: Gen Zhang <blackgod016574@gmail.com>
> > >
> > > commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.
> > >
> > > The old_memmap flow in efi_call_phys_prolog() performs numerous memory
> > > allocations, and either does not check for failure at all, or it does
> > > but fails to propagate it back to the caller, which may end up calling
> > > into the firmware with an incomplete 1:1 mapping.
> > >
> > > So let's fix this by returning NULL from efi_call_phys_prolog() on
> > > memory allocation failures only, and by handling this condition in the
> > > caller. Also, clean up any half baked sets of page tables that we may
> > > have created before returning with a NULL return value.
> > >
> > > Note that any failure at this level will trigger a panic() two levels
> > > up, so none of this makes a huge difference, but it is a nice cleanup
> > > nonetheless.
> >
> > With a description like this, why is this needed in a stable kernel if
> > it does not really fix anything useful?
> >
> 
> Because it fixes a 'CVE', remember? :-)

No, I don't remember that at all.

Remember, I get 1000+ emails a day to do something with, and hence, have
the short-term memory of prior emails of a squirrel.

Also, CVEs mean nothing, anyone can get one and they are impossible to
revoke, so don't treat them like they are "authoritative" at all.

greg k-h
