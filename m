Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E36FFEC56
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 13:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfKPMws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 07:52:48 -0500
Received: from verein.lst.de ([213.95.11.211]:48776 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbfKPMwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 07:52:47 -0500
Received: by verein.lst.de (Postfix, from userid 107)
        id AC45E68BFE; Sat, 16 Nov 2019 13:52:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on verein.lst.de
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=5.0 tests=ALL_TRUSTED,BAYES_50,
        FAKE_REPLY_C autolearn=disabled version=3.3.1
Received: from lst.de (p5B0D82C7.dip0.t-ipconnect.de [91.13.130.199])
        by verein.lst.de (Postfix) with ESMTPSA id 8EC4068AFE;
        Sat, 16 Nov 2019 13:52:39 +0100 (CET)
Date:   Sat, 16 Nov 2019 13:52:33 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191116125233.GA5570@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904124250.25844-1-broonie@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On Wed, 4 Sep 2019 13:42:50 +0100 Mark Brown <broonie@kernel.org> wrote:
[...]
> with Arm laptops coming on the market it's becoming more of an issue so
> let's do something about it.

For the record: I try to run a stock distribution kernel (lots of modules)
on an Olimex Teres-I. The PMIC driver is of course a module.

> In the absence of any better idea just defer the powering off for 30s
> after late_initcall(), this is obviously a hack but it should mask the
> issue for now and it's no more arbitrary than late_initcall() itself.
> Ideally we'd have some heuristics to detect if we're on an affected
> system and tune or skip the delay appropriately, and there may be some
> need for a command line option to be added.

Am I the only one having problems with this change? I get

[   11.917136] anx6345 0-0038: 0-0038 supply dvdd12-supply not found, using dummy regulator
[   11.917174] axp20x-rsb sunxi-rsb-3a3: AXP20x variant AXP803 found

Despite being loaded as a very early module, PMIC init ^^^ only starts now.

[   11.928664] hub 1-0:1.0: 1 port detected
[   11.943230] anx6345 0-0038: 0-0038 supply dvdd25-supply not found, using dummy regulator

So far, so bad, but lucky me has an U-Boot which already enabled the display
along with the relevant voltages in the proper sequence.

[   11.981316] [drm] Found ANX6345 (ver. 170) eDP Transmitter

But much later on

[   38.248573] dcdc4: disabling
[   38.268493] vcc-pd: disabling
[   38.288446] vdd-edp: disabling

screen goes dark and stays dark. Use count of the regulators is 0. I guess
this is because the driver code had been returned the dummy instead?

It's a mobile device so in principle there is nothing wrong with powering
down unused circuitry, and always-on is not an option.
Am I correct to perceive this solution as not 100% mature yet? The anx6345
driver in particular needs to do a little "voltage dance" with specific
timing on the real regulators should the device come up really unpowered,
so IMHO it's probably neccessary to return EPROBE_DEFER at least in this
particular case and prepare the driver for it? Or what would be the real
solution in this case?

	Torsten



