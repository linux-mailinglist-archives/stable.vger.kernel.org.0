Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3234C12327A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfLQQaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 11:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfLQQaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 11:30:46 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4FA721835;
        Tue, 17 Dec 2019 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576600245;
        bh=Ruri3xp18Qqifgv+llL3zcYiL8zvB2i9sWMuqfeuf+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRw8mIyNZPgJgNQKxV12br+jPuVGBsPbBd8R2L0MKGnXYkV1orl+4g4PRX8jLyGiA
         v+xT5QbnJMl2Y1s4y14pHKMxPikne1O1PdI+mBzGegRfyl7xGgMgG1D1pJiZBNuXp4
         ajpNr0TEJ7SPd/Ds9YsFCnruHmPfRfmzpvJqhxxY=
Date:   Tue, 17 Dec 2019 11:30:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrea Merello <andrea.merello@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 4.19 106/140] iio: ad7949: kill pointless
 "readback"-handling code
Message-ID: <20191217163043.GH17708@sasha-vm>
References: <20191216174747.111154704@linuxfoundation.org>
 <20191216174815.749524432@linuxfoundation.org>
 <CAN8YU5NrEbJx3yxBNoRWnwUiAYWffDp6gEcCcGUK+g4zjbHwEg@mail.gmail.com>
 <20191216184536.GB2411653@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191216184536.GB2411653@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 07:45:36PM +0100, Greg Kroah-Hartman wrote:
>On Mon, Dec 16, 2019 at 07:31:31PM +0100, Andrea Merello wrote:
>> Something nasty seems happening here: it looks like the commit message
>> and the actual diff have nothing to do one wrt the other; the commit
>> message is from one of my patches, the diff is against some unrelated
>> file.
>>
>> Il giorno lun 16 dic 2019 alle ore 19:05 Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> ha scritto:
>> >
>> > From: Meng Li <Meng.Li@windriver.com>
>> >
>> > [ Upstream commit c270bbf7bb9ddc4e2a51b3c56557c377c9ac79bc ]
>> >
>> > The device could be configured to spit out also the configuration word
>> > while reading the AD result value (in the same SPI xfer) - this is called
>> > "readback" in the device datasheet.
>> >
>> > The driver checks if readback is enabled and it eventually adjusts the SPI
>> > xfer length and it applies proper shifts to still get the data, discarding
>> > the configuration word.
>> >
>> > The readback option is actually never enabled (the driver disables it), so
>> > the said checks do not serve for any purpose.
>> >
>> > Since enabling the readback option seems not to provide any advantage (the
>> > driver entirely sets the configuration word without relying on any default
>> > value), just kill the said, unused, code.
>> >
>> > Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>> > Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  drivers/edac/altera_edac.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
>> > index 56de378ad13dc..c9108906bcdc0 100644
>> > --- a/drivers/edac/altera_edac.c
>> > +++ b/drivers/edac/altera_edac.c
>> > @@ -600,6 +600,7 @@ static const struct regmap_config s10_sdram_regmap_cfg = {
>> >         .reg_read = s10_protected_reg_read,
>> >         .reg_write = s10_protected_reg_write,
>> >         .use_single_rw = true,
>> > +       .fast_io = true,
>> >  };
>> >
>> >  static int altr_s10_sdram_probe(struct platform_device *pdev)
>> > --
>> > 2.20.1
>> >
>> >
>> >
>
>Wow, something went wrong.
>
>Sasha, can you look into this?

Yikes, sorry - this is one of the commits that needed to be manually
backported, and I must have copy pasted the wrong commit hash to use as
the commit message.

This really is 56d9e7bd3fa0 ("EDAC/altera: Use fast register IO for S10
IRQs") which needs to be in the stable tree, I'll go fix up the message.

-- 
Thanks,
Sasha
