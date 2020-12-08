Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC9B2D3518
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 22:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgLHVS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 16:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgLHVS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 16:18:28 -0500
Date:   Tue, 8 Dec 2020 16:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607462267;
        bh=4Gt9Jsth80Gl2N+3hLk+DslgTwAf2EsMMqeousr7xwo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrSVSOOEc328GZ9erKYQn9fdPJk4BayYsnmWlqHhpj6wS3ZflIb3h7RK5wIbWjo0m
         LiKO4fukTfvXu9yD+dZuYyHpDwnfEGtNkmCNIeFK9ttMFag61+gNKLwEI0c749Q7AR
         9KEumN3ICpm9ydlkCpJL2WUkmWBQyL2NzxF+APzfjdlxRPPJzvCcrrZjrGn7dVIWio
         EcftHZ3xDfMvzbFkbaa8XGdDjRR4jZhoL486Hp3IdwXnw6IP866gpIWUTnAL/p4TK+
         g3h4ri1qsFKDbrPk3+gRTA/NqGR5t1No2ObAntUGeVRB8xj5V0ycWq4xjMOZ0BbPSv
         K2MII8kAb4Ayw==
From:   Sasha Levin <sashal@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208211745.GL643756@sasha-vm>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201208171145.GA3241@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 06:11:45PM +0100, Lukas Wunner wrote:
>On Tue, Dec 08, 2020 at 08:47:39AM -0500, Sasha Levin wrote:
>> On Tue, Dec 08, 2020 at 08:32:41AM +0100, Lukas Wunner wrote:
>> > On Mon, Dec 07, 2020 at 05:49:01PM -0700, Nathan Chancellor wrote:
>> > > On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
>> > > > [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
>> > > >
>> > > > bcm2835aux_spi_remove() accesses the driver's private data after calling
>> > > > spi_unregister_master() even though that function releases the last
>> > > > reference on the spi_master and thereby frees the private data.
>> > > >
>> > > > Fix by switching over to the new devm_spi_alloc_master() helper which
>> > > > keeps the private data accessible until the driver has unbound.
>> > > >
>> > > > Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
>> > > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
>> > > > Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
>> > > > Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
>> > > > Cc: <stable@vger.kernel.org> # v4.4+
>> > > > Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
>> > > > Signed-off-by: Mark Brown <broonie@kernel.org>
>> > >
>> > > Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
>> > > assignment in bcm2835aux_spi_probe") is picked up with this patch in all
>> > > of the stable trees that it is applied to.
>> >
>> > That shouldn't be necessary as I've made sure that the backports to
>> > 4.19 and earlier do not exhibit the issue fixed by d853b3406903.
>> >
>> > However, nobody is perfect, so if I've missed anything, please let
>> > me know.
>>
>> Could we instead have the backports exhibit the issue (like they did
>> upstream) and then take d853b3406903 on top?
>
>The upstream commit e13ee6cc4781 did not apply cleanly to 4.19 and earlier,
>several adjustments were required.  Could I have made it so that the fixup
>d853b3406903 would have still been required?  Probably, but it seems a
>little silly to submit a known-bad patch.

Not silly, there are two motives here:

1. We don't want to diverge too much with backports, which means that
they need to be minimal.
2. It'll make auditing later easier. What will happen now is that after
this patch is merges, we'll trigger a warning saying that there's a fix
upstream for one of these patches, and we'll end up wasting the time (of
probably a few folks) figuring this out.

Note I'm not asking to submit a broken patch, but I'm asking to submit a
minimal backport followed by the upstream fix to that upstream bug :)

-- 
Thanks,
Sasha
