Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2772D3D9C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgLIIig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:38:36 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:44365 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgLIIid (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 03:38:33 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 10CD22800BB94;
        Wed,  9 Dec 2020 09:37:30 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id AB41A10DB; Wed,  9 Dec 2020 09:37:47 +0100 (CET)
Date:   Wed, 9 Dec 2020 09:37:47 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201209083747.GA7377@wunner.de>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208211745.GL643756@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 04:17:45PM -0500, Sasha Levin wrote:
> On Tue, Dec 08, 2020 at 06:11:45PM +0100, Lukas Wunner wrote:
> > On Tue, Dec 08, 2020 at 08:47:39AM -0500, Sasha Levin wrote:
> > > Could we instead have the backports exhibit the issue (like they did
> > > upstream) and then take d853b3406903 on top?
> > 
> > The upstream commit e13ee6cc4781 did not apply cleanly to 4.19 and earlier,
> > several adjustments were required.  Could I have made it so that the fixup
> > d853b3406903 would have still been required?  Probably, but it seems a
> > little silly to submit a known-bad patch.
[...]
> 2. It'll make auditing later easier. What will happen now is that after
> this patch is merges, we'll trigger a warning saying that there's a fix
> upstream for one of these patches, and we'll end up wasting the time (of
> probably a few folks) figuring this out.

Would it be possible to amend the tooling such that multiple
"[ Upstream commit ... ]" lines are supported at the top of
the commit message, signifying that the backport patch
subsumes all cited upstream commits?

Could the extra work for stable maintainers be avoided that way?

I imagine there might be more cases where a "clean" backport is
not possible, requiring multiple upstream patches to be combined.


> Note I'm not asking to submit a broken patch, but I'm asking to submit a
> minimal backport followed by the upstream fix to that upstream bug :)

Then please apply the series sans bcm2835aux patch and I'll follow up
with a two-patch series specifically for that driver.

Alternatively, please consider whether multiple "[ Upstream commit ... ]"
lines would be a viable solution and if it is, add a line as follows
when applying the bcm2835aux patch:

[ Upstream commit d853b3406903a7dc5b14eb5bada3e8cd677f66a2 ]

Thanks,

Lukas
