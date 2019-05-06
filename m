Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4074C14670
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 10:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfEFIev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 04:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfEFIev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 04:34:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23462082F;
        Mon,  6 May 2019 08:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557131690;
        bh=jFwc2BDkRhYUSCCt361d4c7fwgUAreClV7jhe5+bBiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OwD10NAs/F9s/T1LyhV5B9KtQYKyoNNkoVKVE8JEgGbXImAUW4D4w9dBoM7V7Rljc
         N7qo3jQeqHtSoIEiyoMQW3j+CPzjMHKbaZwexTCa3Sy5vcjiNaSHkxyzfXL7WCiB93
         FsvOjOyuuR6Ekl+BnvTcEE24djQ1X+OaMnVC5LmQ=
Date:   Mon, 6 May 2019 10:34:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: Re: [PATCH 5.0 100/101] leds: pca9532: fix a potential NULL pointer
 dereference
Message-ID: <20190506083447.GA1198@kroah.com>
References: <20190502143339.434882399@linuxfoundation.org>
 <20190502143346.636141727@linuxfoundation.org>
 <CAMuHMdVQWLfBOCyXza0bwG5-4FJ5z2gLjpsPEj8FaQepd5_nMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVQWLfBOCyXza0bwG5-4FJ5z2gLjpsPEj8FaQepd5_nMA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 10:21:28AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Thu, May 2, 2019 at 5:34 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > [ Upstream commit 0aab8e4df4702b31314a27ec4b0631dfad0fae0a ]
> >
> > In case of_match_device cannot find a match, return -EINVAL to avoid
> > NULL pointer dereference.
> >
> > Fixes: fa4191a609f2 ("leds: pca9532: Add device tree support")
> > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> > Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> > Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
> 
> > --- a/drivers/leds/leds-pca9532.c
> > +++ b/drivers/leds/leds-pca9532.c
> > @@ -513,6 +513,7 @@ static int pca9532_probe(struct i2c_client *client,
> >         const struct i2c_device_id *id)
> >  {
> >         int devid;
> > +       const struct of_device_id *of_id;
> >         struct pca9532_data *data = i2c_get_clientdata(client);
> >         struct pca9532_platform_data *pca9532_pdata =
> >                         dev_get_platdata(&client->dev);
> > @@ -528,8 +529,11 @@ static int pca9532_probe(struct i2c_client *client,
> >                         dev_err(&client->dev, "no platform data\n");
> >                         return -EINVAL;
> >                 }
> > -               devid = (int)(uintptr_t)of_match_device(
> > -                       of_pca9532_leds_match, &client->dev)->data;
> > +               of_id = of_match_device(of_pca9532_leds_match,
> > +                               &client->dev);
> > +               if (unlikely(!of_id))
> 
> This condition (1) can never be true, as of_pca9532_leds_match[]
> populates the .data field of all entries, and (2) is already checked for
> in pca9532_of_populate_pdata(), so pca9532_probe() would already
> have aborted with -ENODEV before.
> 
> https://lore.kernel.org/lkml/CAMuHMdXELu2tcSB5C1yKUGft6sDGPAy997ApPzy17n0MssfyWA@mail.gmail.com/
> 
> So please stop backporting this to even more stable trees.
> Thanks!

It's already merged in a bunch of stable trees, so let's just leave it
as-is :)

thanks,

greg k-h
