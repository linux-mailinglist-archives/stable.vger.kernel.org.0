Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3C2031FA
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFVIWz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 22 Jun 2020 04:22:55 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:35824 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgFVIWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 04:22:55 -0400
Received: by mail-ej1-f68.google.com with SMTP id rk21so731412ejb.2;
        Mon, 22 Jun 2020 01:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9ZlATqR5O/UN7V9Eb99Sg6fAT9FDErao+gempLRB4Hs=;
        b=Qn/IQqULFWTpHJkcVZwCAnHVUxC2Di6ENDOr2L0aiWD8dFw+GwZBstk3smvKBB1uMa
         0POIi5kZ1Yawlsc9rKsz5ewLBhUNfspFnKcoKYOY5ITENqW1K6mWZfnkgkmIHoE+As20
         fLw+XZJ2AZTPsGk7Y53AdPY+iyyUCfzjzmK3kK0c3UJM1Hajd5U99O5STzE4DVjYzEhk
         quSu2faJMpMzuoCmkAJYWVBExyG/gkN+4cms+6aU9VMaOBGp0iVxmjjjCrKbn0B0gvZa
         BTTYt5oOn99fGFVf0++FGz8doGCd0IiSNvr/YiHonq+lHX58n/UXjzkqumbKhJXgQlLz
         jsVw==
X-Gm-Message-State: AOAM532z8tfwptPeuuy0c3eTeLxylmpTQ5/divCnje9hy+/x470JqgEm
        Ihm8BK1CeVRDDsL+I9v4CUtXk0kY
X-Google-Smtp-Source: ABdhPJxHL5xAGjXOsi3UXzAfElfBzqTRUs53bfauWLTCDgrPL7mZ5fkIVPHO2sSUaoWFAW5zPjyjHA==
X-Received: by 2002:a17:906:2b92:: with SMTP id m18mr15685524ejg.218.1592814171374;
        Mon, 22 Jun 2020 01:22:51 -0700 (PDT)
Received: from kozik-lap ([194.230.155.235])
        by smtp.googlemail.com with ESMTPSA id h9sm11776156edr.65.2020.06.22.01.22.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2020 01:22:50 -0700 (PDT)
Date:   Mon, 22 Jun 2020 10:22:48 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
Message-ID: <20200622082248.GB28886@kozik-lap>
References: <20200525113220.369-1-krzk@kernel.org>
 <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
 <20200527074254.vhyfntpolphj3eeq@pali>
 <20200619175521.xrcd7ahvjtc4zoqi@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200619175521.xrcd7ahvjtc4zoqi@earth.universe>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 07:55:21PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, May 27, 2020 at 09:42:54AM +0200, Pali Rohár wrote:
> > On Tuesday 26 May 2020 21:16:28 Andrew F. Davis wrote:
> > > On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> > > > This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> > > > 
> > > > If device was unbound and bound, the polling interval would be set to 0.
> > > > This is both unexpected and messes up with other bq27xxx devices (if
> > > > more than one battery device is used).
> > > > 
> > > > This reset of polling interval was added in commit 8cfaaa811894
> > > > ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > > > stating that power_supply_unregister() calls get_property().  However in
> > > > Linux kernel v3.1 and newer, such call trace does not exist.
> > > > Unregistering power supply does not call get_property() on unregistered
> > > > power supply.
> > > > 
> > > > Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > 
> > > > ---
> > > > 
> > > > I really could not identify the issue being fixed in offending commit
> > > > 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00
> > > > driver"), therefore maybe I missed here something important.
> > > > 
> > > > Please share your thoughts on this.
> > > 
> > > I'm having a hard time finding the OOPS also. Maybe there is a window
> > > where the poll function is running or about to run where
> > > cancel_delayed_work_sync() is called and cancels the work, only to have
> > > an interrupt or late get_property call in to the poll function and
> > > re-schedule it.
> > > 
> > > What we really need is to do is look at how we are handling the polling
> > > function. It gets called from the workqueue, from a threaded interrupt
> > > context, and from a power supply framework callback, possibly all at the
> > > same time. Sometimes its protected by a lock, sometimes not. Updating
> > > the device's cached data should always be locked.
> > > 
> > > What's more is the poll function is self-arming, so if we call
> > > cancel_delayed_work_sync() (remove it from the work queue then then wait
> > > for it to finish if running), are we sure it wont have just re-arm itself?
> > > 
> > > We should make the only way we call the poll function be through the
> > > work queue, (plus make sure all accesses to the cache are locked).
> > > 
> > > Andrew
> > 
> > I do not remember details too. It is long time ago.
> > 
> > CCing Ivaylo Dimitrov as he may remember something...
> 
> Applying this revert introduces at least a race condition when
> userspace reads sysfs files while kernel removes the driver.
> 
> So looking at the entrypoints for schedules:
> 
> bq27xxx_battery_i2c_probe:
>   Not relevant, probe is done when the battery is being removed.
> 
> poll_interval_param_set:
>   Can be avoided by unregistering from the list earlier. This
>   is the right thing to do considering the battery is added to
>   the list as last step in the probe routine, it should be removed
>   first during teardown.

Yes, good point.

> 
> bq27xxx_external_power_changed:
>   This can happen at any time while the power-supply device is
>   registered, because of the code in get_property.
> 
> bq27xxx_battery_poll:
>   This can happen at any time while the power-supply device is
>   registered.
> 
> As far as I can see the only thing in the delayed work needing
> the power-supply device is power_supply_changed(). If we add a
> check, that di->bat is not NULL, we should be able to reorder
> teardown like this:

Except power_supply structure there is the device state struct
bq27xxx_device_info 'di'. If bq27xxx_battery_poll() is called during the
unbind, it will access the 'di' which is being freed by devm-framework.
And just checking for di->bat is also not thread safe (can be
reordered).

I think there is no easy few-line fix for this.  Instead, the
workqueue scheduling should be guarded everywhere by device-instance
mutex (bq27xxx_device_info.lock).


> 
> 1. remove from list
> 2. unregister power-supply device and set to di->bat to NULL
> 3. cancel delayed work
> 4. destroy mutex
> 
> Also I agree with Andrew, that the locking looks fishy. I think
> the lock needs to be moved, so that the call to
> bq27xx_battery_update(di) in bq27xxx_battery_poll is protected.

Exactly.

Best regards,
Krzysztof
