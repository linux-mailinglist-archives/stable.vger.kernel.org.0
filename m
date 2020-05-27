Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333061E3AD0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 09:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbgE0Hm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 03:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387505AbgE0Hm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 03:42:58 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206BB207CB;
        Wed, 27 May 2020 07:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590565377;
        bh=y9jv0X6AJuMhRlgaHgmpRyxvEQ1kjbp4zfnCjc2GtLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t+D/NwRI+txSmZugjz829nauDSQwiNIfYqiLI4Fq/oyuzNzRSXl3CrSBGAAI5NlX7
         8wQEitRE7t+HJ+B8JKcWvjzzdSK/ZJ77QQAz8l3gy1dy3ZMCaihz8YTeVnQrbhnhvt
         FQd84V9xOkiyKqe7p9uFCe+ZxIdWS/kco3AlYlsM=
Received: by pali.im (Postfix)
        id BAD19BF4; Wed, 27 May 2020 09:42:54 +0200 (CEST)
Date:   Wed, 27 May 2020 09:42:54 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Andrew F. Davis" <afd@ti.com>
Cc:     Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
Message-ID: <20200527074254.vhyfntpolphj3eeq@pali>
References: <20200525113220.369-1-krzk@kernel.org>
 <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 26 May 2020 21:16:28 Andrew F. Davis wrote:
> On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> > This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> > 
> > If device was unbound and bound, the polling interval would be set to 0.
> > This is both unexpected and messes up with other bq27xxx devices (if
> > more than one battery device is used).
> > 
> > This reset of polling interval was added in commit 8cfaaa811894
> > ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > stating that power_supply_unregister() calls get_property().  However in
> > Linux kernel v3.1 and newer, such call trace does not exist.
> > Unregistering power supply does not call get_property() on unregistered
> > power supply.
> > 
> > Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > 
> > ---
> > 
> > I really could not identify the issue being fixed in offending commit
> > 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00
> > driver"), therefore maybe I missed here something important.
> > 
> > Please share your thoughts on this.
> 
> 
> I'm having a hard time finding the OOPS also. Maybe there is a window
> where the poll function is running or about to run where
> cancel_delayed_work_sync() is called and cancels the work, only to have
> an interrupt or late get_property call in to the poll function and
> re-schedule it.
> 
> What we really need is to do is look at how we are handling the polling
> function. It gets called from the workqueue, from a threaded interrupt
> context, and from a power supply framework callback, possibly all at the
> same time. Sometimes its protected by a lock, sometimes not. Updating
> the device's cached data should always be locked.
> 
> What's more is the poll function is self-arming, so if we call
> cancel_delayed_work_sync() (remove it from the work queue then then wait
> for it to finish if running), are we sure it wont have just re-arm itself?
> 
> We should make the only way we call the poll function be through the
> work queue, (plus make sure all accesses to the cache are locked).
> 
> Andrew

I do not remember details too. It is long time ago.

CCing Ivaylo Dimitrov as he may remember something...

> 
> > ---
> >  drivers/power/supply/bq27xxx_battery.c | 8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
> > index 942c92127b6d..4c94ee72de95 100644
> > --- a/drivers/power/supply/bq27xxx_battery.c
> > +++ b/drivers/power/supply/bq27xxx_battery.c
> > @@ -1905,14 +1905,6 @@ EXPORT_SYMBOL_GPL(bq27xxx_battery_setup);
> >  
> >  void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
> >  {
> > -	/*
> > -	 * power_supply_unregister call bq27xxx_battery_get_property which
> > -	 * call bq27xxx_battery_poll.
> > -	 * Make sure that bq27xxx_battery_poll will not call
> > -	 * schedule_delayed_work again after unregister (which cause OOPS).
> > -	 */
> > -	poll_interval = 0;
> > -
> >  	cancel_delayed_work_sync(&di->work);
> >  
> >  	power_supply_unregister(di->bat);
> > 
