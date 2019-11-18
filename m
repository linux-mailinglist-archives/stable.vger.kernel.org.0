Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1009B100C53
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 20:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKRTkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 14:40:20 -0500
Received: from verein.lst.de ([213.95.11.211]:58218 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfKRTkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 14:40:20 -0500
Received: by verein.lst.de (Postfix, from userid 107)
        id 5E75C68BFE; Mon, 18 Nov 2019 20:40:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on verein.lst.de
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=5.0 tests=ALL_TRUSTED,BAYES_50
        autolearn=disabled version=3.3.1
Received: from lst.de (p5B0D82C7.dip0.t-ipconnect.de [91.13.130.199])
        by verein.lst.de (Postfix) with ESMTPSA id BCEA168AFE;
        Mon, 18 Nov 2019 20:40:13 +0100 (CET)
Date:   Mon, 18 Nov 2019 20:40:12 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191118194012.GB7894@lst.de>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
 <20191118124654.GD9761@sirena.org.uk>
 <20191118164101.GA7894@lst.de>
 <20191118165651.GK9761@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118165651.GK9761@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 04:56:51PM +0000, Mark Brown wrote:
> On Mon, Nov 18, 2019 at 05:41:01PM +0100, Torsten Duwe wrote:
> > On Mon, Nov 18, 2019 at 12:46:54PM +0000, Mark Brown wrote:
> 
> > > This is not new behaviour, all this change did was delay this.  We've
> > > been powering off unused regulators for a bit over a decade.
> 
> > For me, this appeared first after upgrading from from 5.3.0-rc1 to 5.4.0-rc6.
> > I guess the late initcall was executed before the regulator driver module got
> > loaded? And now, with the 30s delay, the regulator driver is finally there?
> > Would that explain it?
> 
> If the regulator driver wasn't loaded you'd not see the power off on
> late init, yes.

Then this is the change I see, thanks for the confirmation.

> 
> Regulators are enabled using the regulator_enable() call,

Fine, the driver does that, but...

> I don't follow at all, if a driver is calling regulator_get() and
> regulator_put() repeatedly at runtime around voltage changes then it
> sounds like the driver is extremely broken.  Further, if a supply has a
> regulator provided in device tree then a dummy regulator will never be
> provided for it.  

I'm afraid I must object here:

kernel: anx6345 0-0038: 0-0038 supply dvdd12-supply not found, using dummy regulator
kernel: anx6345 0-0038: 0-0038 supply dvdd25-supply not found, using dummy regulator

DT has:
  dvdd25-supply = <&reg_dldo2>;
  dvdd12-supply = <&reg_dldo3>;

It's only that the regulator driver module has not fully loaded at that point.

> > AFAICS the caller is then stuck with a reference to the dummy, correct?
> 
> If a dummy regulator has been provided then there is no possibility that
> a real supply could be provided, there's not a firmware description of
> one.  We use a dummy regulator to keep software working on the basis
> that it's unlikely that the device can operate without power but lacking
> any information on the regulator we can't actually control it.

That's what I figured. I was fancying some hash table for yet unkown
regulators with callbacks to those who had asked. Or the EPROBE_DEFER
to have them come back later. Maybe initrd barriers would help.

So is my understanding correct that with the above messages, the anx6345
driver will never be able to control those voltages for real?
And additionally, the real regulator's use count will remain 0 unless there
are other users (which there aren't)?

Again: this all didn't matter before this init completion code was moved
to the right location. Power management wouldn't work, but at least the
established voltages stayed on.

	Torsten

