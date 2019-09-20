Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7E6B8C5E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 10:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391092AbfITIG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 04:06:56 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37216 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391003AbfITIG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 04:06:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id w67so4383611lff.4;
        Fri, 20 Sep 2019 01:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gz7X0SW/xnl3tGxq30hcsGDXhtDvbl61SOj/nTQHmns=;
        b=MoFGy/N/BJqyBmJRHQzXBX6YRXNTo1aM9YXd2CDfNzyWDJpzkBYSbONbk5jom8R4iv
         weOq25UybYgDboX8ae4b90z6wS/qte0iK8u7jAYF204S3chi5hjctE16L4TqjtNcTa1h
         SxKQww7sx6tPGl0nLManLAvA6Noansa16M56ujlWMATtI+985X/VqJO8hV4EcarOIBXh
         vErY9BKWQUPFA20/nMLkROH70tRDyl4D1vAYvlCrJs5SXY8/KPFjax7Xa23E0GAJ1Vm1
         J6c4RfVZgktDvXfrJL2/3F52qkDw5UBnL5yY9YRilBtqsgdjuYTorKvWZA+IF233NEL6
         wFxA==
X-Gm-Message-State: APjAAAVl+qEAjRVhVWa8wHoOiUcuiqIped9qP5BqZ+3rqlSUsmDrDbru
        6Jkj9XVcvrW6tsBabSj9pGFFBNDj
X-Google-Smtp-Source: APXvYqxHl0pI/SGAh/IOmt6QUA+GVj4jg2AUfXvg7NBcDe2KX+TgHef+3ehDNCNWKjKFheZ7jsFwpw==
X-Received: by 2002:ac2:5dd6:: with SMTP id x22mr7815896lfq.71.1568966812357;
        Fri, 20 Sep 2019 01:06:52 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id h3sm314833lfc.26.2019.09.20.01.06.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 01:06:51 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iBDwJ-00012r-2b; Fri, 20 Sep 2019 10:06:51 +0200
Date:   Fri, 20 Sep 2019 10:06:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     Johan Hovold <johan@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, lanqing.liu@unisoc.com,
        linux-serial@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BACKPORT 4.14.y v2 6/6] serial: sprd: Modify the baud rate
 calculation formula
Message-ID: <20190920080651.GJ30545@localhost>
References: <cover.1567649728.git.baolin.wang@linaro.org>
 <4fe6ec82960301126b9f4be52dd6083c30e17420.1567649729.git.baolin.wang@linaro.org>
 <20190905090130.GF1701@localhost>
 <CAMz4kuJGmQxfy5mi1aZNL8SA8MQBSTTyDeWcHHEtG2aXsFZgug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMz4kuJGmQxfy5mi1aZNL8SA8MQBSTTyDeWcHHEtG2aXsFZgug@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 05:58:05PM +0800, Baolin Wang wrote:
> Hi Johan,
> 
> On Thu, 5 Sep 2019 at 17:01, Johan Hovold <johan@kernel.org> wrote:
> >
> > On Thu, Sep 05, 2019 at 11:11:26AM +0800, Baolin Wang wrote:
> > > From: Lanqing Liu <lanqing.liu@unisoc.com>
> > >
> > > [Upstream commit 5b9cea15a3de5d65000d49f626b71b00d42a0577]
> > >
> > > When the source clock is not divisible by the expected baud rate and
> > > the remainder is not less than half of the expected baud rate, the old
> > > formular will round up the frequency division coefficient. This will
> > > make the actual baud rate less than the expected value and can not meet
> > > the external transmission requirements.
> > >
> > > Thus this patch modifies the baud rate calculation formula to support
> > > the serial controller output the maximum baud rate.
> > >
> > > Signed-off-by: Lanqing Liu <lanqing.liu@unisoc.com>
> > > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> > > ---
> > >  drivers/tty/serial/sprd_serial.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
> > > index e902494..72e96ab8 100644
> > > --- a/drivers/tty/serial/sprd_serial.c
> > > +++ b/drivers/tty/serial/sprd_serial.c
> > > @@ -380,7 +380,7 @@ static void sprd_set_termios(struct uart_port *port,
> > >       /* ask the core to calculate the divisor for us */
> > >       baud = uart_get_baud_rate(port, termios, old, 0, SPRD_BAUD_IO_LIMIT);
> > >
> > > -     quot = (unsigned int)((port->uartclk + baud / 2) / baud);
> > > +     quot = port->uartclk / baud;
> >
> > Are you sure the original patch is even correct?
> >
> > By replacing the divisor rounding with truncation you are introducing
> > larger errors for some baud rates, something which could possibly even
> > break working systems.
> 
> Our UART clock source is 26M, and there is no difference for lower
> than 3M baud rate between dividing closest or dividing down.

But there is; you have introduced larger errors for at least a few
standard rates by changing to truncation.

> But we have one special use case is our BT/GPS want to set 3.25M baud
> rate, but we have to select 3M baud rate in baud_table since no 3.25M
> setting. So in this case if we use the old formula, we will only get
> about 2.8M baud rate, which can not meet our requirement. If we change
> the dividing down method, we can get 3.25M baud rate.
> 
> I have to say this is a workaroud for our special case, and can solve
> our problem. If you have any good suggestion, we can change to a
> better solution. Thanks.

Yeah, I don't think purposefully introducing larger errors, and risk
breaking other people's setups, to work around that use case is
warranted.

We have an interface for setting arbitrary baudrates (TCSETS2) which you
can you use (even if glibc support is still not in place). You'd just
need to lift the seemingly arbitrary limitation to 3 Mbaud in the driver
first.

> > Perhaps the original patch should even be reverted, but in any case
> > backporting this to stable looks questionable.

So I think reverting this may be the right thing to do.

Johan
