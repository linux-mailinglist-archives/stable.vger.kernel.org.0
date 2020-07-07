Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BBF2166FE
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 09:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGGHEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 03:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgGGHEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 03:04:23 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1848A206E9;
        Tue,  7 Jul 2020 07:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594105463;
        bh=WaxY9UuFUZMio8lU8uSW/II3c3cTj0kgxwgSUSl8afc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1k2zwVpNaKH4TiNj92q+HbMhUCJ46KTdc6mR7tL9KvnCACDf9OFMbiumIypBMLi+
         DdnPSn6Nke1slCBF2Q/V8HGDi9ZJvYzr68rG3lmDxoze/4pnKOHTRqDGvY71BOTYs6
         QkRhnZQcV5Oqm4vv6ZY9PumhBfgk4YAFyTTEjYsU=
Received: by pali.im (Postfix)
        id E331DBF7; Tue,  7 Jul 2020 09:04:20 +0200 (CEST)
Date:   Tue, 7 Jul 2020 09:04:20 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     BOUGH CHEN <haibo.chen@nxp.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Doug Anderson <dianders@chromium.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] mmc: sdio: fix clock rate setting for SDR12/SDR25 mode
Message-ID: <20200707070420.yn3kunscp4om5iyz@pali>
References: <1592813959-5914-1-git-send-email-haibo.chen@nxp.com>
 <CAPDyKFphkPAgcOEd=j8EUoFyAz7Oj8DEXbgK=k7R15rizWWcTw@mail.gmail.com>
 <VI1PR04MB5294D51A326E7B010D10DE1490660@VI1PR04MB5294.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR04MB5294D51A326E7B010D10DE1490660@VI1PR04MB5294.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 07 July 2020 01:48:18 BOUGH CHEN wrote:
> > -----Original Message-----
> > From: Ulf Hansson [mailto:ulf.hansson@linaro.org]
> > Sent: 2020年7月6日 22:49
> > To: BOUGH CHEN <haibo.chen@nxp.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>; linux-mmc@vger.kernel.org;
> > Pali Rohár <pali@kernel.org>; dl-linux-imx <linux-imx@nxp.com>; Andy Duan
> > <fugang.duan@nxp.com>; Doug Anderson <dianders@chromium.org>;
> > huyue2@yulong.com; Matthias Kaehlcke <mka@chromium.org>
> > Subject: Re: [PATCH] mmc: sdio: fix clock rate setting for SDR12/SDR25 mode
> > 
> > On Mon, 22 Jun 2020 at 10:30, <haibo.chen@nxp.com> wrote:
> > >
> > > From: Haibo Chen <haibo.chen@nxp.com>
> > >
> > > In current code logic, when work in SDR12/SDR25 mode, the final clock
> > > rate is incorrect, just the legancy 400KHz, because the
> > > card->sw_caps.sd3_bus_mode do not has the flag SD_MODE_UHS_SDR12 or
> > > SD_MODE_UHS_SDR25. Besides, SDIO_SPEED_SDR12 is actually value 0, and
> > > every mode need to config the timing and clock rate, so remove the
> > > ‘if’ operator.
> > >
> > > Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> > 
> > This looks like a rather serious error, should we tag this for stable?
> 
> Yes, need to do that.
> 
> Cc: <stable@vger.kernel.org>

Hello! I think you can add Fixes line, e.g.:

Fixes: a303c5319c8e ("mmc: sdio: support SDIO UHS cards")

> Best Regards
> Haibo Chen
> > 
> > In the meantime, I have applied this for next to get it tested, thanks!
> > 
> > Kind regards
> > Uffe
> > 
> > 
> > 
> > > ---
> > >  drivers/mmc/core/sdio.c | 15 ++++++++-------
> > >  1 file changed, 8 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c index
> > > 0e32ca7b9488..7b40553d3934 100644
> > > --- a/drivers/mmc/core/sdio.c
> > > +++ b/drivers/mmc/core/sdio.c
> > > @@ -176,15 +176,18 @@ static int sdio_read_cccr(struct mmc_card *card,
> > u32 ocr)
> > >                         if (mmc_host_uhs(card->host)) {
> > >                                 if (data & SDIO_UHS_DDR50)
> > >
> > card->sw_caps.sd3_bus_mode
> > > -                                               |=
> > SD_MODE_UHS_DDR50;
> > > +                                               |=
> > SD_MODE_UHS_DDR50 | SD_MODE_UHS_SDR50
> > > +                                                       |
> > > + SD_MODE_UHS_SDR25 | SD_MODE_UHS_SDR12;
> > >
> > >                                 if (data & SDIO_UHS_SDR50)
> > >
> > card->sw_caps.sd3_bus_mode
> > > -                                               |=
> > SD_MODE_UHS_SDR50;
> > > +                                               |=
> > SD_MODE_UHS_SDR50 | SD_MODE_UHS_SDR25
> > > +                                                       |
> > > + SD_MODE_UHS_SDR12;
> > >
> > >                                 if (data & SDIO_UHS_SDR104)
> > >
> > card->sw_caps.sd3_bus_mode
> > > -                                               |=
> > SD_MODE_UHS_SDR104;
> > > +                                               |=
> > SD_MODE_UHS_SDR104 | SD_MODE_UHS_SDR50
> > > +                                                       |
> > > + SD_MODE_UHS_SDR25 | SD_MODE_UHS_SDR12;
> > >                         }
> > >
> > >                         ret = mmc_io_rw_direct(card, 0, 0, @@
> > -537,10
> > > +540,8 @@ static int sdio_set_bus_speed_mode(struct mmc_card *card)
> > >         max_rate = min_not_zero(card->quirk_max_rate,
> > >                                 card->sw_caps.uhs_max_dtr);
> > >
> > > -       if (bus_speed) {
> > > -               mmc_set_timing(card->host, timing);
> > > -               mmc_set_clock(card->host, max_rate);
> > > -       }
> > > +       mmc_set_timing(card->host, timing);
> > > +       mmc_set_clock(card->host, max_rate);
> > >
> > >         return 0;
> > >  }
> > > --
> > > 2.17.1
> > >
