Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C75B4D72
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 12:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiIKKdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 06:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIKKdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 06:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A1F3C151;
        Sun, 11 Sep 2022 03:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A86B80AFD;
        Sun, 11 Sep 2022 10:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0B5C433C1;
        Sun, 11 Sep 2022 10:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662892382;
        bh=cssxUf85fo3xwMVXH/oVbDV1rjWJb8y2wy7UmYIaa/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XhS4kISCYFy6qLa6qqROP8fKIKO2yZ7KB3lILrsOWftAH4qhs7fP9GJNhGGgIf0mV
         tgsdv8Hp9Mh65yi1xD1HgolYEFzi9moGvQiLZkmA0QYx3wvg+jTpT/bMx64kWwX4MT
         T77oD/VHNrpD0k0tp9zTOqGHmUavTYm9QG6uYgFQudGTQOm4nfrDE+N6FuqhLfpg2O
         ZRCbPokf5+pXGG2vYiGAbA0oKhTOjCtU0d2CjAcjTQUMM8TYsvrxc3/jZfYs2hMVLw
         7QYrLteGR+Mt8OW/FzFjZ4N9Qv/YjOItXlC16XCsvOlmVApc4bs+uw9a390RCDuljs
         QxvNmLSs+IvAQ==
Date:   Sun, 11 Sep 2022 10:58:54 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Shreeya Patel <shreeya.patel@collabora.com>
Cc:     lars@metafoo.de, krisman@collabora.com,
        dmitry.osipenko@collabora.com, kernel@collabora.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] iio: light: tsl2583: Fix module unloading
Message-ID: <20220911105855.4acad644@jic23-huawei>
In-Reply-To: <03401e6f-f660-9313-61dc-a930675c82ec@collabora.com>
References: <20220826122352.288438-1-shreeya.patel@collabora.com>
        <20220828173327.7949ad73@jic23-huawei>
        <03401e6f-f660-9313-61dc-a930675c82ec@collabora.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Sep 2022 00:25:49 +0530
Shreeya Patel <shreeya.patel@collabora.com> wrote:

> On 28/08/22 22:03, Jonathan Cameron wrote:
> > On Fri, 26 Aug 2022 17:53:52 +0530
> > Shreeya Patel <shreeya.patel@collabora.com> wrote:
> >  
> >> tsl2583 uses devm_iio_device_register() function and
> >> calling iio_device_unregister() in remove breaks the
> >> module unloading.
> >> Fix this by using iio_device_register() instead of
> >> devm_iio_device_register() function in probe.  
> > Not sure why you are wrapping at 55 chars. I rewrapped this whilst applying.
> >
> > Reworded it a little too as I was touching it anyway.
> >
> > Applied to the fixes-togreg branch of iio.git.  
> 
> Hi Jonathan,
> 
> I was wondering if this got picked by you. I don't see it in 
> fixes-togreg that's why wanted to just confirm if you aren't looking for 
> some extra changes in this.
> 
> 
oops. I forgot to push that branch out. Done so now.

Jonathan

> Thanks
> Shreeya Patel
> 
> >  
> >> Cc: stable@vger.kernel.org
> >> Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")  
> > I took a look at this patch and it introduces the issue I just pointed
> > out in replying to your v1 by dropping the
> > /* Make sure the chip is on */
> > Which was correct even with runtime pm because it covered the case of
> > runtime_pm being disabled.   We probably need to bring that back as well,
> > perhaps as part of a cleanup patch taking this fully devm_
> >
> > This driver has another issue for working if runtime PM isn't built into
> > the kernel which is that it checks the return of pm_runtime_put_autosuspend()
> > which calls
> >
> > static inline int __pm_runtime_suspend(struct device *dev, int rpmflags)
> > {
> > 	return -ENOSYS;
> > }
> >
> > I've been meaning to do an audit for drivers that have this problem for
> > a while, but not yet gotten to it.
> >
> > An ideal IIO driver needs to work correctly whether or not CONFIG_PM is
> > enabled.
> >
> > Jonathan
> >
> >  
> >> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> >> ---
> >> Changes in v2
> >>    - Use iio_device_register() instead of devm_iio_device_register()
> >>    - Add fixes and stable tags
> >>
> >>   drivers/iio/light/tsl2583.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
> >> index 82662dab87c0..94d75ec687c3 100644
> >> --- a/drivers/iio/light/tsl2583.c
> >> +++ b/drivers/iio/light/tsl2583.c
> >> @@ -858,7 +858,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
> >>   					 TSL2583_POWER_OFF_DELAY_MS);
> >>   	pm_runtime_use_autosuspend(&clientp->dev);
> >>   
> >> -	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
> >> +	ret = iio_device_register(indio_dev);
> >>   	if (ret) {
> >>   		dev_err(&clientp->dev, "%s: iio registration failed\n",
> >>   			__func__);  
> >  

