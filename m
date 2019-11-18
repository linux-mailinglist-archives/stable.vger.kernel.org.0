Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC1100958
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 17:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfKRQlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 11:41:13 -0500
Received: from verein.lst.de ([213.95.11.211]:57612 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfKRQlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 11:41:13 -0500
Received: by verein.lst.de (Postfix, from userid 107)
        id 77F8A68BFE; Mon, 18 Nov 2019 17:41:11 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on verein.lst.de
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=5.0 tests=ALL_TRUSTED,BAYES_50
        autolearn=disabled version=3.3.1
Received: from lst.de (p5B0D82C7.dip0.t-ipconnect.de [91.13.130.199])
        by verein.lst.de (Postfix) with ESMTPSA id 7BA3B68AFE;
        Mon, 18 Nov 2019 17:41:06 +0100 (CET)
Date:   Mon, 18 Nov 2019 17:41:01 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191118164101.GA7894@lst.de>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
 <20191118124654.GD9761@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118124654.GD9761@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 12:46:54PM +0000, Mark Brown wrote:
> On Sat, Nov 16, 2019 at 01:52:33PM +0100, Torsten Duwe wrote:
> > On Wed, 4 Sep 2019 13:42:50 +0100 Mark Brown <broonie@kernel.org> wrote:
> 
> > But much later on
> 
> > [   38.248573] dcdc4: disabling
> > [   38.268493] vcc-pd: disabling
> > [   38.288446] vdd-edp: disabling
> 
> > screen goes dark and stays dark. Use count of the regulators is 0. I guess
> > this is because the driver code had been returned the dummy instead?
> 
> This is not new behaviour, all this change did was delay this.  We've
> been powering off unused regulators for a bit over a decade.

For me, this appeared first after upgrading from from 5.3.0-rc1 to 5.4.0-rc6.
I guess the late initcall was executed before the regulator driver module got
loaded? And now, with the 30s delay, the regulator driver is finally there?
Would that explain it?

> We power off regulators which aren't enabled by any driver and where we
> have permission from the constraints to change the state.  If the
> regulator can't be powered off then it should be flagged as always-on in
> constraints, if a driver needs it the driver should be enabling the
> regulator.

How exactly? I have been looking for deficiencies in the driver, but found
devm_regulator_get() should actually do the right thing (use_count++). Is
that correct, or am I missing something?

> I don't folow what you're saying about probe deferral here at all,
> sorry.

I was worried about the regulator core handing out refs to the dummy
regulator when the requesting driver wants to change the voltages next.
I concluded the requesting device driver would have to wait until the real
regulator driver was registered. But either this somehow works or my eDP
bridge is still powered on correctly from U-Boot. What does the warning
"...  using dummy regulator" mean for the caller of regulator_get()?
AFAICS the caller is then stuck with a reference to the dummy, correct?

Any hints welcome,

	Torsten

