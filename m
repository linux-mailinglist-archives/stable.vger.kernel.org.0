Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36249FD55
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1IlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 04:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfH1IlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 04:41:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4106323403;
        Wed, 28 Aug 2019 08:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566981669;
        bh=Adxs43tpYLNFVmrV7jqedrM7btP1zHEfdzG69L/1X+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=orkIvZ5ngyRCkNL6XIJ72pStboJuYtdx86SU4xA4LCV0JSOWYB+tH8QgBOwiqt1Kk
         KS2lHXyoIg6nhMt4ROKVj4iwAFNQQdcamdNqyV+XMRkPCCC/PyVYjjA2+S1Rqken33
         IpT2mSV/4K/9B3QjbaLpASsnIexNuDAA1n9VWkw0=
Date:   Wed, 28 Aug 2019 10:41:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190828084107.GB29927@kroah.com>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
 <20190827200151.GA19618@roeck-us.net>
 <20190827202901.GB1118@kroah.com>
 <20190827204841.GA21062@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827204841.GA21062@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 01:48:41PM -0700, Guenter Roeck wrote:
> On Tue, Aug 27, 2019 at 10:29:01PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
> > > On Tue, Aug 27, 2019 at 02:10:03PM -0400, Sasha Levin wrote:
> > > > On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
> > > > >Hi,
> > > > >
> > > > >I recently wrote a script which identifies patches potentially missing
> > > > >in downstream kernel branches. The idea is to identify patches backported/
> > > > >applied to a downstream branch for which patches tagged with Fixes: are
> > > > >available in the upstream kernel, but those fixes are missing from the
> > > > >downstream branch. The script workflow is something like:
> > > > >
> > > > >- Identify locally applied patches in downstream branch
> > > > >- For each patch, identify the matching upstream SHA
> > > > >- Search the upstream kernel for Fixes: tags with this SHA
> > > > >- If one or more patches with matching Fixes: tags are found, check
> > > > > if the patch was applied to the downstream branch.
> > > > >- If the patch was not applied to the downstream branch, report
> > > > >
> > > > >Running this script on chromeos-4.19 identified, not surprisingly, a number
> > > > >of such patches. However, and more surprisingly, it also identified several
> > > > >patches applied to v4.19.y for which fixes are available in the upstream
> > > > >kernel, but those fixes have not been applied to v4.19.y. Some of those
> > > > >are on the cosmetic side, but several seem to be relevant. I didn't
> > > > >cross-check all of them, but the ones I tried did apply to linux-4.19.y.
> > > > >The complete list is attached below.
> > > > >
> > > > >Question: Do Sasha's automated scripts identify such patches ? If not,
> > > > >would it make sense to do it ? Or is there some reason why the patches
> > > > >have not been applied to v4.19.y ?
> > > > 
> > > > Hey Guenter,
> > > > 
> > > > I have a very similar script with a slight difference: I don't try to
> > > > find just "Fixes:" tags, but rather just any reference from one patch to
> > > > another. This tends to catch cases where once patch states it's "a
> > > > similar fix to ..." and such.
> > > > 
> > > > The tricky part is that it's causing a whole bunch of false positives,
> > > > which takes a while to weed through - and that's where the issue is
> > > > right now.
> > > > 
> > > 
> > > I didn't see any false positives, at least not yet. Would it possibly
> > > make sense to start with looking at Fixes: ? After all, additional
> > > references (wich higher chance for false positives) can always be
> > > searched for later.
> > 
> > I used to do this "by hand" with a tiny bit of automation, but need to
> > step it up and do it "correctly" like you did.
> > 
> > If you have a pointer to your script, I'd be glad to run it here locally
> > to keep track of this, like I do so for patches tagged with syzbot
> > issues.
> > 
> 
> I'd have to rewrite it to work with stable branches. Its current
> primary goal is to assist the rebase of one chromeos branch to
> a later upstream kernel release. I just repurposed part of it and
> use the generated databases to identify patches tagged with Fixes:.
> 
> I'll be happy to do that and make it work on stable branches in
> general if you think it would add value.

No worries, I can add the functionality to my local scripts that I have.
If you just had happened to have it in stand-alone format, it would have
saved me 30 minutes or so :)

thanks for the reminder that we need to be doing this more,

greg k-h
