Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1443392EF
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCLQTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhCLQTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 11:19:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33FA964F80;
        Fri, 12 Mar 2021 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615565940;
        bh=SvjvS+eYw43j6dDZ3kTZEE/IzNK1vkwq2cjx8Oz0Kok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1HawMuB/z5x3wCDWGqApB6ROaio1ewVhpI4NC86mDZEGMgL6Pv6NlB/E4ft3aqlW
         wXxCBiDCS6WDOn3suectrtQwefcgyzpPNlOmdgfYVYb6tCzIVjcBX/tdwCiSOIHABi
         D4/qegEXQPnrOXqu03+lrb3LpfiStsVvTsGNJIgjj0vkPP1FdC6jnZm0A0JUpYqHtL
         +dLBoDP1m0Lz0Gp477kunJ1RWGCM4toU4i9ALUQWF9y7jQejM7DrC3mGzBMk9MlnMk
         lW/sCQK279N0IxcohqHk+jIWE3P99OftRid/v/GwLgOfX3gJqQ5yRR/SL6J5LyDHW8
         nNwvL0E3LgSzw==
Received: by pali.im (Postfix)
        id E3CF07FB; Fri, 12 Mar 2021 17:18:57 +0100 (CET)
Date:   Fri, 12 Mar 2021 17:18:57 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <20210312161857.ytknen5d5zhfhtbk@pali>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
 <YEuOfI5FKLYgdQV+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEuOfI5FKLYgdQV+@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday 12 March 2021 16:53:32 Andrew Lunn wrote:
> > So theoretically the turris-mox-rwtm driver can be renamed into
> > something else and we can add a different compatible in order not to
> > sound so turris-mox specific.
> 
> That would be a good idea. And if possible, try to push the hardware
> random number code upstream in the firmware repos, so everybody gets
> it by default, not just those using your build. Who is responsible for
> upstream? Marvell?

Hello Andrew! The issue is that upstream Marvell repository contains
only 'fuse.bin' application which is suitable only for fuse programming.
I think it is not correct if this Marvell fuse application start
providing other functionality not relevant to fuse programming. And
Marvell does not provide any other application (publicly). So it would
be needed to send it as another application, not part of 'fuse.bin'. And
then it complicates build system and compile options, which is already
too complicated (you need to set tons of TF-A options and prepare two
sets of cross compile toolchains).

But because application / firmware for MOX / Armada 3720 is actively
developed on different place, I do not think that it make sense to send
every change to two different locations (and wait for Marvell until
review every change and include it into their repository). Such thing
just increase maintenance cost at both sides.

For me it looks like a better solution to provide 'wtmi_app.bin'
application with HW number generator from separate repository, where it
is currently developed and where it is available for a longer time.

We are planning to send documentation update to Trusted-Firmware project
to specify how to build Armada 3720 firmware image with our application.
So people who are building Armada 3720 firmware would be able to switch
from Marvell's 'fuse.bin' application to our 'wtmi_app.bin'.
