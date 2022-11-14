Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48765627A8E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKNKdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiKNKdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:33:10 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7401BEBE;
        Mon, 14 Nov 2022 02:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668421988; x=1699957988;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=Y0WdUR+FeU2C43ZxBmO//rjLti3e/g0n9XgzSjyHz+U=;
  b=BCoNOUekDCrU3jD7MiC1LDjmda/cdFGRavFxfxrjZ8XMNxg9SQR32Ifg
   K7Tk9UjBeQZB7xP/v2PBnk9FzbB0Jg4KQDWB7hjOyll2r5GzFGvycxKZ4
   yE8pP6f14b4DW7cnuE9KsXtaa4cp7/uYf/hjC2j5lB6f9bT+gQKhMw0M4
   wYqaEzxL/GJXOy3RTcvv4u2aND6yyEIZ+M3OnoD76ot0UIdlJNeO9j5ye
   oMazl7EAxcGO4ZigUe/PpZVKMzfoTCE8a98HktHqZvJ15rZssmdnkk1qz
   ba6Q1hcZoPj81lFUAG88QdxKBmpk0z+mESlU07EI+sEnJGgO/BlQephd2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="309563246"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="309563246"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 02:33:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="616256319"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616256319"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 02:33:02 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id C75CE32E; Mon, 14 Nov 2022 12:33:26 +0200 (EET)
Date:   Mon, 14 Nov 2022 12:33:26 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Wolfram Sang <wsa@kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
Message-ID: <Y3IZdrwwfiolSjB4@black.fi.intel.com>
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
 <Y3AA7hZFvoI9+2fF@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3AA7hZFvoI9+2fF@shikoro>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Nov 12, 2022 at 09:24:14PM +0100, Wolfram Sang wrote:
> On Thu, Nov 10, 2022 at 05:20:39PM +0100, Ricardo Ribalda wrote:
> > A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> > power off a device that it has not powered on previously.
> > 
> > For devices operating in "full_power" mode, the first call to
> > `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> > will be turned on with `dev_pm_domain_attach`.
> > 
> > If probe fails or the device is removed the second call to
> > `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> > will not be turned off. This is, it will be left in a different power
> > state. Lets fix it.
> > 
> > Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> 
> Adding I2C ACPI maintainer to CC. Mika, could you please help
> reviewing?

Sure.

> > diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> > index b4edf10e8fd0..6f4974c76404 100644
> > --- a/drivers/i2c/i2c-core-base.c
> > +++ b/drivers/i2c/i2c-core-base.c
> > @@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
> >  {
> >  	struct i2c_client	*client = i2c_verify_client(dev);
> >  	struct i2c_driver	*driver;
> > +	bool do_power_on;
> >  	int status;
> >  
> >  	if (!client)
> > @@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
> >  	if (status < 0)
> >  		goto err_clear_wakeup_irq;
> >  
> > -	status = dev_pm_domain_attach(&client->dev,
> > -				      !i2c_acpi_waive_d0_probe(dev));
> > +	do_power_on = !i2c_acpi_waive_d0_probe(dev);
> > +	status = dev_pm_domain_attach(&client->dev, do_power_on);

I think this is fine as the driver says it is OK to see the device in
whatever power state (I assume this is what the
i2c_acpi_waive_d0_probe() is supposed to be doing but there is no
kernel-doc, though).

> >  	if (status)
> >  		goto err_clear_wakeup_irq;
> >  
> > @@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
> >  	if (status)
> >  		goto err_release_driver_resources;
> >  
> > +	client->power_off_on_remove = do_power_on;
> > +
> >  	return 0;
> >  
> >  err_release_driver_resources:
> >  	devres_release_group(&client->dev, client->devres_group_id);
> >  err_detach_pm_domain:
> > -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > +	dev_pm_domain_detach(&client->dev, do_power_on);
> >  err_clear_wakeup_irq:
> >  	dev_pm_clear_wake_irq(&client->dev);
> >  	device_init_wakeup(&client->dev, false);
> > @@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
> >  
> >  	devres_release_group(&client->dev, client->devres_group_id);
> >  
> > -	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > +	dev_pm_domain_detach(&client->dev, client->power_off_on_remove);

However, on the remove path I think we should not call
i2c_acpi_waive_d0_probe() at all as that has nothing to do with remove
(it is for whether the driver accepts any power state on probe AFAICT)
so this should stil be "true" here. Unless I'm missing something.

> >  
> >  	dev_pm_clear_wake_irq(&client->dev);
> >  	device_init_wakeup(&client->dev, false);
> > diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> > index f7c49bbdb8a1..eba83bc5459e 100644
> > --- a/include/linux/i2c.h
> > +++ b/include/linux/i2c.h
> > @@ -326,6 +326,8 @@ struct i2c_driver {
> >   *	calls it to pass on slave events to the slave driver.
> >   * @devres_group_id: id of the devres group that will be created for resources
> >   *	acquired when probing this device.
> > + * @power_off_on_remove: Record if we have turned on the device before probing
> > + *	so we can turn off the device at removal.
> >   *
> >   * An i2c_client identifies a single device (i.e. chip) connected to an
> >   * i2c bus. The behaviour exposed to Linux is defined by the driver
> > @@ -355,6 +357,8 @@ struct i2c_client {
> >  	i2c_slave_cb_t slave_cb;	/* callback for slave mode	*/
> >  #endif
> >  	void *devres_group_id;		/* ID of probe devres group	*/
> > +	bool power_off_on_remove;	/* if device needs to be turned	*/
> > +					/* off by framework at removal	*/
> >  };
> >  #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
> >  
> > 
> > -- 
> > b4 0.11.0-dev-d93f8


