Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DCCAA976
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732466AbfIEQ41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbfIEQ40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 12:56:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058F820825;
        Thu,  5 Sep 2019 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567702586;
        bh=c/OMZv0zohuMV0wtRCRjkEXWrbEw4kJfGSXiyO8XusQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sYZtgxNNud5vMDdsJrzWJPcbo5Bz+xWXUJqWiEqOCXYRJuKH4X7mNx0ZouvcYdbFP
         9ANOEfawZR8hLks4fenNV+9Uh46OiYJgeru3urz7nW6bGxUzYlMWYRv1amsfUrPH5q
         ZgjMbOgWU6A6TOc3hVVfnmHq4sJHU0wZruV2JxHI=
Date:   Thu, 5 Sep 2019 18:56:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
Message-ID: <20190905165623.GA2737@kroah.com>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
 <20190905141634.GA25790@kroah.com>
 <ae007007-02cc-0081-22c0-34b2d67f2cd3@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae007007-02cc-0081-22c0-34b2d67f2cd3@hpe.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 07:47:34AM -0700, Mike Travis wrote:
> 
> 
> On 9/5/2019 7:16 AM, Greg KH wrote:
> > On Thu, Sep 05, 2019 at 08:02:58AM -0500, Mike Travis wrote:
> > > Decode the hubless UVsystab passed from BIOS to the kernel saving
> > > pertinent info in a similar manner that hubbed UVsystabs are decoded.
> > > 
> > > Signed-off-by: Mike Travis <mike.travis@hpe.com>
> > > Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> > > Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> > > To: Thomas Gleixner <tglx@linutronix.de>
> > > To: Ingo Molnar <mingo@redhat.com>
> > > To: H. Peter Anvin <hpa@zytor.com>
> > > To: Andrew Morton <akpm@linux-foundation.org>
> > > To: Borislav Petkov <bp@alien8.de>
> > > To: Christoph Hellwig <hch@infradead.org>
> > > Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> > > Cc: Russ Anderson <russ.anderson@hpe.com>
> > > Cc: Hedi Berriche <hedi.berriche@hpe.com>
> > > Cc: Steve Wahl <steve.wahl@hpe.com>
> > > Cc: x86@kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org
> > > ---
> > >   arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
> > >   1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > If you are trying to get one of my automated "WTF: patch XXXX was
> > seriously submitted to be applied to the stable tree?" emails, you are
> > on track for it...
> > 
> > Please go read the documentation link I sent you last time and figure
> > out how you can justify any of this patch series for a stable kernel
> > tree.
> 
> Is it because it has fixes for new hardware?  If so, then I'll quit
> submitting them to stable (we've had requests from distros for all updates
> be in the stable tree for acceptance).  Otherwise I thought it does comply
> with:
> 
>    " - To have the patch automatically included in the stable tree,
>    add the tag
>      Cc: stable@vger.kernel.org
>    in the sign-off area. Once the patch is merged it will be applied
>    to the stable tree without anything else needing to be done by the
>    author or subsystem maintainer."
> 
> Or is there some other reason that I'm not understanding?

Yes, that's how you get a patch applied, but how in the world does all
of the patches in this series actually meet the requirements of a patch
that should be applied to the stable kernel tree?

I see no regression fixes, no new device ids, no bug fixes.  Only
support for new hardware, i.e. a new feature to the kernel for something
that never worked in the first place.

And yes, distros do request bugfixes to get added to stable trees,
that's great, but I fail to understand how any of these patches are "bug
fixes".  Maybe you need to work on your changelog texts...

good luck!

greg k-h
