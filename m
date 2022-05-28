Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D70536DCF
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbiE1Qwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiE1Qwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 12:52:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3480015FCC;
        Sat, 28 May 2022 09:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF106B801BD;
        Sat, 28 May 2022 16:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB9FC34100;
        Sat, 28 May 2022 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653756755;
        bh=l6YSFZs/3siq+Vk5NAEOpTNq431P3M8yNr8OeXJt/rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vGms0P5QJaDOA8AIxCQMLhpB1FR+ZSa8/EsmIDYlYJ8NExl6doNNm8nK9qXZNFS1p
         NoqH1OQBS/KGgzeLKbK7IinZ6coCczltfcM3xrRJ5QAgUPuffeRkKaMSa+OKws6sMo
         IcveSdTIvnEHg32WLTaqkk/WiTBDw/2Jbqxem9esFkHpSzB2mE9kW40T2Rvkig5yvw
         Or592vKgK1HSuTjoZA+4ikIq6ItR3x3D+GstkQ38xNfT+i2utPcmc66zXyGIXvfT1R
         uRo/OADqSYgsarCRblzvYv/CT7S6ZdJ3u91KrEmdmAmhDHpBMpZVd9bAF2H5bJDgGL
         s1WONz7sIiWng==
Date:   Sat, 28 May 2022 18:01:28 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Liam Beguin <liambeguin@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Peter Rosin <peda@axentia.se>, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, stable@vger.kernel.org
Subject: Re: [PATCH] iio: afe: rescale: Fix logic bug
Message-ID: <20220528180128.3f160c51@jic23-huawei>
In-Reply-To: <Yo7X9w6i3uiNZqpW@shaak>
References: <20220524075448.140238-1-linus.walleij@linaro.org>
        <Yo7X9w6i3uiNZqpW@shaak>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 May 2022 21:29:27 -0400
Liam Beguin <liambeguin@gmail.com> wrote:

> On Tue, May 24, 2022 at 09:54:48AM +0200, Linus Walleij wrote:
> > When introducing support for processed channels I needed
> > to invert the expression:
> > 
> >   if (!iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
> >       !iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
> >         dev_err(dev, "source channel does not support raw/scale\n");
> > 
> > To the inverse, meaning detect when we can usse raw+scale
> > rather than when we can not. This was the result:
> > 
> >   if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
> >       iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
> >        dev_info(dev, "using raw+scale source channel\n");
> > 
> > Ooops. Spot the error. Yep old George Boole came up and bit me.
> > That should be an &&.
> > 
> > The current code "mostly works" because we have not run into
> > systems supporting only raw but not scale or only scale but not
> > raw, and I doubt there are few using the rescaler on anything
> > such, but let's fix the logic.  
> 
> Maybe `iio: afe: rescale: Fix boolean logic bug` if you're resending,
> otherwise,

Makes sense - I tweaked that whilst applying.

Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

> 
> Reviewed-by: Liam Beguin <liambeguin@gmail.com>
> 
> Thanks,
> Liam
> 
> > Cc: Liam Beguin <liambeguin@gmail.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 53ebee949980 ("iio: afe: iio-rescale: Support processed channels")
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  drivers/iio/afe/iio-rescale.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
> > index 7e511293d6d1..dc426e1484f0 100644
> > --- a/drivers/iio/afe/iio-rescale.c
> > +++ b/drivers/iio/afe/iio-rescale.c
> > @@ -278,7 +278,7 @@ static int rescale_configure_channel(struct device *dev,
> >  	chan->ext_info = rescale->ext_info;
> >  	chan->type = rescale->cfg->type;
> >  
> > -	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
> > +	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
> >  	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
> >  		dev_info(dev, "using raw+scale source channel\n");
> >  	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
> > -- 
> > 2.35.3
> >   

