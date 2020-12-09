Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDF2D3EEB
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 10:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgLIJgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 04:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgLIJgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 04:36:20 -0500
Date:   Wed, 9 Dec 2020 10:36:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607506539;
        bh=TGctbPD54ZAoX5PZuMoZ2amvrXhfPKW5Dz/GwEYWo0Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=qWg7tSAr97v1MxlktDzk7OPzMkaTnrrNCYM6VacszXK2zRYtoFp0wxHmZGkHBLbJo
         1wcMemTTgYQu1QQkKpIoe1TR2JPgn4xmpGG1lx8KzzMoqcOrv5ibxJXkSeTs8q1PgN
         v/gBHr3yw3INyIMBFD2/GQz/CJ6POiiij7mPvm+Y=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <X9Cat0z0YBZkXlvv@kroah.com>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209083747.GA7377@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 09:37:47AM +0100, Lukas Wunner wrote:
> On Tue, Dec 08, 2020 at 04:17:45PM -0500, Sasha Levin wrote:
> > On Tue, Dec 08, 2020 at 06:11:45PM +0100, Lukas Wunner wrote:
> > > On Tue, Dec 08, 2020 at 08:47:39AM -0500, Sasha Levin wrote:
> > > > Could we instead have the backports exhibit the issue (like they did
> > > > upstream) and then take d853b3406903 on top?
> > > 
> > > The upstream commit e13ee6cc4781 did not apply cleanly to 4.19 and earlier,
> > > several adjustments were required.  Could I have made it so that the fixup
> > > d853b3406903 would have still been required?  Probably, but it seems a
> > > little silly to submit a known-bad patch.
> [...]
> > 2. It'll make auditing later easier. What will happen now is that after
> > this patch is merges, we'll trigger a warning saying that there's a fix
> > upstream for one of these patches, and we'll end up wasting the time (of
> > probably a few folks) figuring this out.
> 
> Would it be possible to amend the tooling such that multiple
> "[ Upstream commit ... ]" lines are supported at the top of
> the commit message, signifying that the backport patch
> subsumes all cited upstream commits?

You could, but that's extra work, which I think you are trying to avoid
when you say:

> Could the extra work for stable maintainers be avoided that way?

this :)


> I imagine there might be more cases where a "clean" backport is
> not possible, requiring multiple upstream patches to be combined.

It is quite rare.  And again, it's almost always better to just take all
of the patches involved, as individual patches, that way we "know" we
did it right, and it's easier to track and audit and review that way.

> > Note I'm not asking to submit a broken patch, but I'm asking to submit a
> > minimal backport followed by the upstream fix to that upstream bug :)
> 
> Then please apply the series sans bcm2835aux patch and I'll follow up
> with a two-patch series specifically for that driver.

Can you just resend the whole series so we know we got it correct?

thanks,

greg k-h
