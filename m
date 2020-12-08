Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91852D30AE
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 18:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbgLHRM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 12:12:28 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:47867 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730330AbgLHRM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 12:12:28 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 8F8712800B1AA;
        Tue,  8 Dec 2020 18:11:28 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B8441DCE4; Tue,  8 Dec 2020 18:11:45 +0100 (CET)
Date:   Tue, 8 Dec 2020 18:11:45 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208171145.GA3241@wunner.de>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208134739.GJ643756@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 08:47:39AM -0500, Sasha Levin wrote:
> On Tue, Dec 08, 2020 at 08:32:41AM +0100, Lukas Wunner wrote:
> > On Mon, Dec 07, 2020 at 05:49:01PM -0700, Nathan Chancellor wrote:
> > > On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
> > > > [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
> > > >
> > > > bcm2835aux_spi_remove() accesses the driver's private data after calling
> > > > spi_unregister_master() even though that function releases the last
> > > > reference on the spi_master and thereby frees the private data.
> > > >
> > > > Fix by switching over to the new devm_spi_alloc_master() helper which
> > > > keeps the private data accessible until the driver has unbound.
> > > >
> > > > Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
> > > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > > > Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
> > > > Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
> > > > Cc: <stable@vger.kernel.org> # v4.4+
> > > > Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
> > > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > 
> > > Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
> > > assignment in bcm2835aux_spi_probe") is picked up with this patch in all
> > > of the stable trees that it is applied to.
> > 
> > That shouldn't be necessary as I've made sure that the backports to
> > 4.19 and earlier do not exhibit the issue fixed by d853b3406903.
> > 
> > However, nobody is perfect, so if I've missed anything, please let
> > me know.
> 
> Could we instead have the backports exhibit the issue (like they did
> upstream) and then take d853b3406903 on top?

The upstream commit e13ee6cc4781 did not apply cleanly to 4.19 and earlier,
several adjustments were required.  Could I have made it so that the fixup
d853b3406903 would have still been required?  Probably, but it seems a
little silly to submit a known-bad patch.

Thanks,

Lukas
