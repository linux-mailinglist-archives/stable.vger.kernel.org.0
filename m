Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4180627BDC
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbiKNLPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiKNLOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:14:41 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3818627CC9;
        Mon, 14 Nov 2022 03:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668424208; x=1699960208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nGEqhrhCRjraU9msMAtVay4bIhxuQjiyK7exgf1cV2E=;
  b=G7vgQKDb3RPaQbI2LPzodooX62fsRpRtOgsJMlPHs4jCxUBVqMTC6xRK
   RlvnvREnKWNtrNDHnzW+g8eM245DfXFx0jeEdogC5krax4e05ja8TBK0R
   K8m7Dw+1BXA4FL2/ijgrh5O6J2nuFDMjXatp1aluq9ofoQvtkKapHYojF
   PvR8QybFVok863EL0DLz06tp590wocHfk4eqpMTWFCisk0cBrPaOlj4Ym
   HsWRPXOB296JAgLfR1thVQHOLCgHwDbtjbYNM0VyTWfgi+Yef3ElRfU3y
   hkTA16QXE0JvlWRDlKO0G/zVMhbvEPStgO6DmSqFj+YeuAGhUej9w8dh7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="310650886"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="310650886"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 03:10:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="707272970"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="707272970"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 03:10:05 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id A559C20225;
        Mon, 14 Nov 2022 13:10:02 +0200 (EET)
Date:   Mon, 14 Nov 2022 11:10:02 +0000
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
Message-ID: <Y3IiCmrw4BNjgVKx@paasikivi.fi.intel.com>
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
 <Y3AA7hZFvoI9+2fF@shikoro>
 <Y3IZdrwwfiolSjB4@black.fi.intel.com>
 <CANiDSCvmcZ32PBZbrLWfZXvEjSPdxYJcWn6V00wR+W2stThBdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiDSCvmcZ32PBZbrLWfZXvEjSPdxYJcWn6V00wR+W2stThBdg@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo, Mika,

On Mon, Nov 14, 2022 at 11:51:24AM +0100, Ricardo Ribalda wrote:
> Hi Mika
> 
> Thanks for your review!
> 
> On Mon, 14 Nov 2022 at 11:33, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > Hi,
> >
> > On Sat, Nov 12, 2022 at 09:24:14PM +0100, Wolfram Sang wrote:
> > > On Thu, Nov 10, 2022 at 05:20:39PM +0100, Ricardo Ribalda wrote:
> > > > A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> > > > power off a device that it has not powered on previously.
> > > >
> > > > For devices operating in "full_power" mode, the first call to
> > > > `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> > > > will be turned on with `dev_pm_domain_attach`.
> > > >
> > > > If probe fails or the device is removed the second call to
> > > > `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> > > > will not be turned off. This is, it will be left in a different power
> > > > state. Lets fix it.
> > > >
> > > > Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
> > > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > >
> > > Adding I2C ACPI maintainer to CC. Mika, could you please help
> > > reviewing?
> >
> > Sure.
> >
> > > > diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> > > > index b4edf10e8fd0..6f4974c76404 100644
> > > > --- a/drivers/i2c/i2c-core-base.c
> > > > +++ b/drivers/i2c/i2c-core-base.c
> > > > @@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
> > > >  {
> > > >     struct i2c_client       *client = i2c_verify_client(dev);
> > > >     struct i2c_driver       *driver;
> > > > +   bool do_power_on;
> > > >     int status;
> > > >
> > > >     if (!client)
> > > > @@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
> > > >     if (status < 0)
> > > >             goto err_clear_wakeup_irq;
> > > >
> > > > -   status = dev_pm_domain_attach(&client->dev,
> > > > -                                 !i2c_acpi_waive_d0_probe(dev));
> > > > +   do_power_on = !i2c_acpi_waive_d0_probe(dev);
> > > > +   status = dev_pm_domain_attach(&client->dev, do_power_on);
> >
> > I think this is fine as the driver says it is OK to see the device in
> > whatever power state (I assume this is what the
> > i2c_acpi_waive_d0_probe() is supposed to be doing but there is no
> > kernel-doc, though).
> >
> > > >     if (status)
> > > >             goto err_clear_wakeup_irq;
> > > >
> > > > @@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
> > > >     if (status)
> > > >             goto err_release_driver_resources;
> > > >
> > > > +   client->power_off_on_remove = do_power_on;
> > > > +
> > > >     return 0;
> > > >
> > > >  err_release_driver_resources:
> > > >     devres_release_group(&client->dev, client->devres_group_id);
> > > >  err_detach_pm_domain:
> > > > -   dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > > > +   dev_pm_domain_detach(&client->dev, do_power_on);
> > > >  err_clear_wakeup_irq:
> > > >     dev_pm_clear_wake_irq(&client->dev);
> > > >     device_init_wakeup(&client->dev, false);
> > > > @@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
> > > >
> > > >     devres_release_group(&client->dev, client->devres_group_id);
> > > >
> > > > -   dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > > > +   dev_pm_domain_detach(&client->dev, client->power_off_on_remove);
> >
> > However, on the remove path I think we should not call
> > i2c_acpi_waive_d0_probe() at all as that has nothing to do with remove
> > (it is for whether the driver accepts any power state on probe AFAICT)
> > so this should stil be "true" here. Unless I'm missing something.
> 
> I guess the problem is that we would be undoing something (power-off),
> that we did not do.
> 
> 
> Sakari, can you think of a use-case where this can break something? If
> not I can send a v6.

I don't think there's any harm from powering the device off here. The
driver should have done it but there could be bugs...

The genpd equivalent doesn't even use the argument but powers off the
domain in any case.

-- 
Kind regards,

Sakari Ailus
