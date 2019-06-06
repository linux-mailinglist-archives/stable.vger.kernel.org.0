Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28237CED
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 21:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfFFTEa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 6 Jun 2019 15:04:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60232 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbfFFTEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 15:04:30 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 2622F283ED2;
        Thu,  6 Jun 2019 20:04:28 +0100 (BST)
Date:   Thu, 6 Jun 2019 21:04:24 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Vitor Soares <Vitor.Soares@synopsys.com>
Cc:     "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] i3c: fix i2c and i3c scl rate by bus mode
Message-ID: <20190606210424.0486903a@collabora.com>
In-Reply-To: <13D59CF9CEBAF94592A12E8AE55501350AABE85C@DE02WEMBXB.internal.synopsys.com>
References: <cover.1559821227.git.vitor.soares@synopsys.com>
        <47de89f2335930df0ed6903be9afe6de4f46e503.1559821228.git.vitor.soares@synopsys.com>
        <20190606161844.4a6b759c@collabora.com>
        <13D59CF9CEBAF94592A12E8AE55501350AABE7FC@DE02WEMBXB.internal.synopsys.com>
        <20190606193540.680d391b@collabora.com>
        <13D59CF9CEBAF94592A12E8AE55501350AABE85C@DE02WEMBXB.internal.synopsys.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 18:08:11 +0000
Vitor Soares <Vitor.Soares@synopsys.com> wrote:

> From: Boris Brezillon <boris.brezillon@collabora.com>
> Date: Thu, Jun 06, 2019 at 18:35:40
> 
> > On Thu, 6 Jun 2019 17:16:55 +0000
> > Vitor Soares <Vitor.Soares@synopsys.com> wrote:
> >   
> > > From: Boris Brezillon <boris.brezillon@collabora.com>
> > > Date: Thu, Jun 06, 2019 at 15:18:44
> > >   
> > > > On Thu,  6 Jun 2019 16:00:01 +0200
> > > > Vitor Soares <Vitor.Soares@synopsys.com> wrote:
> > > >     
> > > > > Currently the I3C framework limits SCL frequency to FM speed when
> > > > > dealing with a mixed slow bus, even if all I2C devices are FM+ capable.
> > > > > 
> > > > > The core was also not accounting for I3C speed limitations when
> > > > > operating in mixed slow mode and was erroneously using FM+ speed as the
> > > > > max I2C speed when operating in mixed fast mode.
> > > > > 
> > > > > Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> > > > > Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> > > > > Cc: Boris Brezillon <bbrezillon@kernel.org>
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Cc: <linux-kernel@vger.kernel.org>
> > > > > ---
> > > > > Changes in v2:
> > > > >   Enhance commit message
> > > > >   Add dev_warn() in case user-defined i2c rate doesn't match LVR constraint
> > > > >   Add dev_warn() in case user-defined i3c rate lower than i2c rate.
> > > > > 
> > > > >  drivers/i3c/master.c | 61 +++++++++++++++++++++++++++++++++++++++++-----------
> > > > >  1 file changed, 48 insertions(+), 13 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> > > > > index 5f4bd52..8cd5824 100644
> > > > > --- a/drivers/i3c/master.c
> > > > > +++ b/drivers/i3c/master.c
> > > > > @@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c_bus *bus)
> > > > >  	up_read(&bus->lock);
> > > > >  }
> > > > >  
> > > > > +static struct i3c_master_controller *
> > > > > +i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
> > > > > +{
> > > > > +	return container_of(i3cbus, struct i3c_master_controller, bus);
> > > > > +}
> > > > > +
> > > > >  static struct i3c_master_controller *dev_to_i3cmaster(struct device *dev)
> > > > >  {
> > > > >  	return container_of(dev, struct i3c_master_controller, dev);
> > > > > @@ -565,20 +571,48 @@ static const struct device_type i3c_masterdev_type = {
> > > > >  	.groups	= i3c_masterdev_groups,
> > > > >  };
> > > > >  
> > > > > -int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode)
> > > > > +int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
> > > > > +		     unsigned long max_i2c_scl_rate)
> > > > >  {
> > > > > -	i3cbus->mode = mode;
> > > > >  
> > > > > -	if (!i3cbus->scl_rate.i3c)
> > > > > -		i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> > > > > +	struct i3c_master_controller *master = i3c_bus_to_i3c_master(i3cbus);
> > > > >  
> > > > > -	if (!i3cbus->scl_rate.i2c) {
> > > > > -		if (i3cbus->mode == I3C_BUS_MODE_MIXED_SLOW)
> > > > > -			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
> > > > > -		else
> > > > > -			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
> > > > > +	i3cbus->mode = mode;
> > > > > +
> > > > > +	switch (i3cbus->mode) {
> > > > > +	case I3C_BUS_MODE_PURE:
> > > > > +		if (!i3cbus->scl_rate.i3c)
> > > > > +			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> > > > > +		break;
> > > > > +	case I3C_BUS_MODE_MIXED_FAST:
> > > > > +		if (!i3cbus->scl_rate.i3c)
> > > > > +			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
> > > > > +		if (!i3cbus->scl_rate.i2c)
> > > > > +			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
> > > > > +		break;
> > > > > +	case I3C_BUS_MODE_MIXED_SLOW:
> > > > > +		if (!i3cbus->scl_rate.i2c)
> > > > > +			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
> > > > > +		if (!i3cbus->scl_rate.i3c ||
> > > > > +		    i3cbus->scl_rate.i3c > i3cbus->scl_rate.i2c)
> > > > > +			i3cbus->scl_rate.i3c = i3cbus->scl_rate.i2c;
> > > > > +		break;
> > > > > +	default:
> > > > > +		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > > +	if (i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c)
> > > > > +		dev_warn(&master->dev,
> > > > > +			 "i3c-scl-hz=%ld lower than i2c-scl-hz=%ld\n",
> > > > > +			 i3cbus->scl_rate.i3c, i3cbus->scl_rate.i2c);
> > > > > +
> > > > > +	if (i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_SCL_RATE &&
> > > > > +	    i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_PLUS_SCL_RATE &&
> > > > > +	    i3cbus->mode != I3C_BUS_MODE_PURE)    
> > > > 
> > > > If you are so strict, there's clearly no point exposing an i2c-scl-hz
> > > > property. I'm still not convinced having an i2c rate that's slower than
> > > > what the I2C/I3C spec defines as the *typical* rate is a bad thing,     
> > > 
> > > I'm not been strictive, I just inform the user about that case.  
> > 
> > Then use dev_debug() and don't make the trace conditional on
> > i2c_rate != typical_rate.   
> 
> Ok. I will change to dev_debug().
> 
> > The only case where we should warn users
> > is i2c_rate > typical_rate, because that might lead to malfunctions.  
> 
> Can you explain why?

Because the speed is limited by the device capabilities. Using a slower
freq works, driving the SLC line faster than what's supported by I2C
slaves doesn't.

> 
> >   
> > >   
> > > > just
> > > > like I'm not convinced having an I3C rate that's slower than the I2C
> > > > one is a problem (it's definitely a weird situation, but there's nothing
> > > > preventing that in the spec).    
> > > 
> > > You agree that there is no point for case where i3c rate < i2c rate yet 
> > > you are not convinced.  
> > 
> > I didn't say that, there might be use cases where one wants to slow
> > down the I3C bus to be able to probe it or use a slower rate when
> > things do not work properly. It's rather unlikely to happen, but I
> > don't think it deserves a warning message when that's the case.
> >   
> > > Do you thing that will be users for this case?
> > > 
> > > Anyway, this isn't a high requirement for me. The all point of this patch 
> > > is to introduce the limited bus configuration.  
> > 
> > And yet, you keep insisting (and ignoring my feedback) on that point :P.  
> 
> If you check the previous version you see that I'm trying to follow 😉
> I will change the dev_warn() to dev_dbg() due the trace is indeed too 
> much.

I have the feeling that you endlessly argue on details while the vast
majority of changes are okay, which means we both spend a lot of time
on things that are not super important.
