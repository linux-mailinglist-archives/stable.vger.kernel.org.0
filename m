Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E222A24F3CA
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgHXIS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgHXIS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C711E20738;
        Mon, 24 Aug 2020 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257105;
        bh=jc2ZdJllY7rFi6smiNrx8eJZXT27bCjsYZyb/p1oIOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iNmau/avDoftaYMD38taVSkLs5uknKkHzcy14C72Q59OVYBS/mFgSzqJ2zKf9vrPs
         yeMuyJrJ2fyN97+yZhmQD1uh3IM0vptMzS3vH6x2oD2A0vDj3AuFZojFDg0VD/y4AS
         OBo1w7ITWGdhhamXCuXhdltt3+ujlauzoN9X/qxk=
Date:   Mon, 24 Aug 2020 10:18:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Stephen Boyd <sboyd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
Subject: Re: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent
 __clk_set_parent_before on db410c
Message-ID: <20200824081843.GB248691@kroah.com>
References: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com>
 <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com>
 <159549159798.3847286.18202724980881020289@swboyd.mtv.corp.google.com>
 <CA+G9fYte5U-D7fqps2qJga_LSuGrb6t9Y1rOvPCPzz46BwchyA@mail.gmail.com>
 <159549996283.3847286.2480782726716664105@swboyd.mtv.corp.google.com>
 <159725426896.33733.4908725817224764584@swboyd.mtv.corp.google.com>
 <CA+G9fYuVQonk+hcaJWaJ2CNWrsgV5EsRa+1eUr6+UUKxHGB3vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuVQonk+hcaJWaJ2CNWrsgV5EsRa+1eUr6+UUKxHGB3vw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 07:30:40PM +0530, Naresh Kamboju wrote:
> On Wed, 12 Aug 2020 at 23:14, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Quoting Stephen Boyd (2020-07-23 03:26:02)
> > > Quoting Naresh Kamboju (2020-07-23 03:10:37)
> > > > On Thu, 23 Jul 2020 at 13:36, Stephen Boyd <sboyd@kernel.org> wrote:
> > > > >
> > > > > It sounds like maybe you need this patch?
> > > > >
> > > > > bdcf1dc25324 ("clk: Evict unregistered clks from parent caches")
> > > >
> > > > Cherry-pick did not work on stable-rc 4.14
> > > > this patch might need backporting.
> > > > I am not sure.
> > > >
> > >
> > > Ok. That commit fixes a regression in the 3.x series of the kernel so it
> > > should go back to any LTS kernels. It looks like at least on 4.14 it's a
> > > trivial conflict. Here's a backport to 4.14
> >
> > Did this help?
> 
> Thanks for your patch.
> Sorry for the late reply.
> The reported issue is not always reproducible However,
> I have tested this for 100 cycles and did not notice the reported problem.
> 
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Great, now queued up to 4.14.y and 4.19.y.

greg k-h
