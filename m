Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF1A19E9C6
	for <lists+stable@lfdr.de>; Sun,  5 Apr 2020 09:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDEHsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Apr 2020 03:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgDEHsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Apr 2020 03:48:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5032206F5;
        Sun,  5 Apr 2020 07:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586072889;
        bh=PYmNB4cBdIA0rye02lJDy4G9K17nz9cmNPuRfoiBR4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D5xjvaQWp87hPQw4FUNtpwLYZgDdp//8OV2/xbNiFXH/Vshm26oUX9c9uZhc7XsEe
         nwlw9Rbr4EWXPOCEhuPC2X493fJzVSokvBI7EYQzOu/KEwijP6/+pfk6PcQHB6MIX5
         PNQr8yKVDZo7kWUYfPUPbPiFdZJGXo613Ik5Un6U=
Date:   Fri, 3 Apr 2020 16:24:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     Stable <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>
Subject: Re: [RFC] Patch backports for CVE-2020-1749
Message-ID: <20200403142404.GB4088318@kroah.com>
References: <3f861dd4ff0e4ed19508965c387cd2c8@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f861dd4ff0e4ed19508965c387cd2c8@SVR-IES-MBX-03.mgc.mentorg.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 01:54:54PM +0000, Schmid, Carsten wrote:
> [back to public]
> [original thread [PATCH Backport to stable/linux-4.14.y] make 'user_access_begin()' do 'access_ok()']
> 
> >
> > On Thu, Apr 02, 2020 at 09:00:14AM +0000, Schmid, Carsten wrote:
> > > Well, your view, and i completely understand your POV.
> > >
> > > Mine is (i don't have such a pretty recording of a discussion, so some
> > words):
> > > - A "CVE" describes a vulnerability found in some product in some version.
> > >   Nothing else. It's kind of a "vulnerability identifier".
> > > - The information collected around the CVE tries to explain (i intentionally
> > write "tries")
> > >   which countermeasures could be taken to mitigate.
> > >   The quality is sometimes good, sometimes not - that really bothers.
> > > - And finally, a "CVE fix" is nothing else than a collection of changes to the
> > product to be done.
> > >   This can be even different for the same vulnerability on different
> > products.
> > >   It's not only a commit id, nor only one CID. Its most times a collection of
> > them.
> > >
> > > I totally agree:
> > > "A bug is a bug is a bug" (and not always a feature like some people say ;-) )
> > >
> > > In Linux kernel context:
> > > - The best way to mitigate is to use latest and greatest - or latest LTS.
> > Whatever fits.
> > >   I totally agree.
> > >
> > > - In case i am a developer who is told by the customer and the chip vendor:
> > >   - We have a vendor kernel
> > >   - We follow upstream LTS
> > >   - We have millions of devices in the field with dedicated setup
> > >   - Updates need to be tested carefully for our products
> > >   - We only have a subset of the kernel functions active
> > >   then things are quite different.
> > >   - There is a delay in between the LTS going into vendor kernel (10-20
> > weeks or so)
> > >      (They say they need this time for testing)
> > >   - There is a delay until integration into the product and updates are tested
> > >      (This time could also be 10+ weeks)
> > >   - There are vulnerabilities that temporary can be fixed by cherry-picking
> > >      (until the next LTS "round" from the vendor kernel arrives)
> > >   - CVE descriptions of NVD and other sources give at least an impression
> > >      if it makes sense to try a temporary backport

There should not be any difference from a testing/push-out-to-devices
point of view from merging a proper LTS release with a device tree, and
cherry-picking random patches all on their own and pushing the result
out to devices.

If there is, you are doing something seriously wrong with your testing
and deployment infrastructure, and I would work on solving that issue,
instead of trying to paper things over and feel like somehow your
devices really are secure by doing this type of thing.

Every single device kernel tree that I have seen that only tries to do
the "we only cherry-pick patches we care about" is insecure.  I have not
seen any exception to that so far.

And, even better yet, here's another person saying pretty much the same
thing:
	https://googleprojectzero.blogspot.com/2020/02/mitigations-are-attack-surface-too.html

Anyway, back to fixing issues:

> There is one CVE report that affects our project, and is not yet fixed in LTS (current 4.14.174).
> It is a leak that data is sent unencrypted - and this really is an issue for us:
> From https://access.redhat.com/security/cve/cve-2020-1749
> A flaw was found in the Linux kernel's implementation of some networking protocols in IPsec, such as VXLAN and GENEVE tunnels over IPv6. When an encrypted tunnel is created between two hosts, the kernel isn't correctly routing tunneled data over the encrypted link; rather sending the data unencrypted. This would allow anyone in between the two endpoints to read the traffic unencrypted. The main threat from this vulnerability is to data confidentiality.
> 
> I have backported 3 fixes from v5.x to 4.14.147 (our current delivery from vendor), see attached patch files.
> Mentioned in https://security-tracker.debian.org/tracker/CVE-2020-1749 the patch
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6c8991f41546c3c472503dff1ea9daaddf9331c2
> is given as a fix, but only this one is hard to port, so i added 2 more.
> 
> From my understanding, in 4.14 the vulnerability exists.
> (i did not check yet if it's also an issue in other LTS kernels - but i assume at least in 4.19 it is)
> 
> I would be glad to hear your opinion on that.
> If you find it worth, i would backport to stable/linux-4.14.y (and maybe 4.19.y too, but i think there is a different patch set needed) and send upstream.

Again, I can't take patches for an older stable kernel, without also
taking them for a newer one at the same time, or first, as we can't have
people updating to newer kernels and having regressions.

So if you could provide me a patch series for 4.14 and 4.19, that I can
review and queue up, I will be glad to do so.

thanks,

greg k-h
