Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9744F203198
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgFVIJt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 22 Jun 2020 04:09:49 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:40116 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgFVIJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 04:09:34 -0400
Received: by mail-ej1-f68.google.com with SMTP id q19so17070932eja.7;
        Mon, 22 Jun 2020 01:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3fdNZBRanbw2j050aGrs3qTjrJIS7AlFCNiO5dWDkNE=;
        b=a/pekVRpBBnQ71juZNi+U+jNkNntgararY+tRj0I+LlMGxux9tOD/PgGIHNGiqRYUw
         g5R4+m3taOGegcCywkNi0BGU+9C8QpheS3T/LS9esM6GElcdUaeRuPt6nIQ05Ca2WZ4v
         DxBszo/SB5iKoS8stysV7ECzQ5w9NErakAns4FOQEFvWgNFOd+8z1eKNzrdnKYh8cZ3+
         G8jdNPd/u02EEdl7sMrEgKGMoNZyjIvOTACmNDq/ntCEtPfL0xLROSiNn11t09vbJpB1
         j6NVHVT2WOLy6Z25QW3VeJa+RjmedNW+9Fz93ZfDk3DFzNMvcZr3armv7dJtb1vWKuVb
         xRSw==
X-Gm-Message-State: AOAM533+RnwzOPSFzSEdu63eHnRr8JXs+zPaHyG9WlPDIPtl/zykjuJs
        0fRF7XDLowF+Tt59FsbIgt8=
X-Google-Smtp-Source: ABdhPJyRAIYbarP8J0dCUcQ5OHjOYXvqdOuQ0wf3e0cR9VlcoVZxMURuWd+0vWTzEB69q/Npzpv0Jw==
X-Received: by 2002:a17:906:4d13:: with SMTP id r19mr14484488eju.45.1592813370851;
        Mon, 22 Jun 2020 01:09:30 -0700 (PDT)
Received: from kozik-lap ([194.230.155.235])
        by smtp.googlemail.com with ESMTPSA id o7sm12260465edj.52.2020.06.22.01.09.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2020 01:09:30 -0700 (PDT)
Date:   Mon, 22 Jun 2020 10:09:27 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Sebastian Reichel <sre@kernel.org>, "Andrew F. Davis" <afd@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
Message-ID: <20200622080927.GA28886@kozik-lap>
References: <20200525113220.369-1-krzk@kernel.org>
 <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
 <20200527074254.vhyfntpolphj3eeq@pali>
 <20200619175521.xrcd7ahvjtc4zoqi@earth.universe>
 <20200619185829.jd4ognwwjlsrjhcb@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200619185829.jd4ognwwjlsrjhcb@pali>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 08:58:29PM +0200, Pali Rohár wrote:
> On Friday 19 June 2020 19:55:21 Sebastian Reichel wrote:
> > Hi,
> > 
> > On Wed, May 27, 2020 at 09:42:54AM +0200, Pali Rohár wrote:
> > > On Tuesday 26 May 2020 21:16:28 Andrew F. Davis wrote:
> > > > On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> > > > > This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> > > > > 
> > > > > If device was unbound and bound, the polling interval would be set to 0.
> > > > > This is both unexpected and messes up with other bq27xxx devices (if
> > > > > more than one battery device is used).
> > > > > 
> > > > > This reset of polling interval was added in commit 8cfaaa811894
> > > > > ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > > > > stating that power_supply_unregister() calls get_property().  However in
> > > > > Linux kernel v3.1 and newer, such call trace does not exist.
> > > > > Unregistering power supply does not call get_property() on unregistered
> > > > > power supply.
> > > > > 
> > > > > Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > > 
> > > > > ---
> > > > > 
> > > > > I really could not identify the issue being fixed in offending commit
> > > > > 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00
> > > > > driver"), therefore maybe I missed here something important.
> > > > > 
> > > > > Please share your thoughts on this.
> > > > 
> > > > I'm having a hard time finding the OOPS also. Maybe there is a window
> > > > where the poll function is running or about to run where
> > > > cancel_delayed_work_sync() is called and cancels the work, only to have
> > > > an interrupt or late get_property call in to the poll function and
> > > > re-schedule it.
> > > > 
> > > > What we really need is to do is look at how we are handling the polling
> > > > function. It gets called from the workqueue, from a threaded interrupt
> > > > context, and from a power supply framework callback, possibly all at the
> > > > same time. Sometimes its protected by a lock, sometimes not. Updating
> > > > the device's cached data should always be locked.
> > > > 
> > > > What's more is the poll function is self-arming, so if we call
> > > > cancel_delayed_work_sync() (remove it from the work queue then then wait
> > > > for it to finish if running), are we sure it wont have just re-arm itself?
> > > > 
> > > > We should make the only way we call the poll function be through the
> > > > work queue, (plus make sure all accesses to the cache are locked).
> > > > 
> > > > Andrew
> > > 
> > > I do not remember details too. It is long time ago.
> > > 
> > > CCing Ivaylo Dimitrov as he may remember something...
> 
> Hello!
> 
> I did some archeology and found some more details about this problem.
> 
> rmmoding bq module without that patch at that time sometimes caused oops
> and reboot of N900 device. backtrace of crash contained:
> 
> =======================================================================
> [80084.031646] Backtrace:
> [80084.031677] [<c0158bbc>] (kobject_uevent_env+0x0/0x3a0) from [<c0158f70>] (kobject_uevent+0x14/0x18)
> [80084.031768] [<c0158f5c>] (kobject_uevent+0x0/0x18) from [<bf2b8128>] (power_supply_changed_work+0x44/0x50 [power_supply])
> [80084.031890] [<bf2b80e4>] (power_supply_changed_work+0x0/0x50 [power_supply]) from [<c0069a64>] (run_workqueue+0xd4/0x198)
> [80084.031982]  r5:cf028000 r4:c40859a8
> [80084.032012] [<c0069990>] (run_workqueue+0x0/0x198) from [<c006a804>] (worker_thread+0xf0/0x104)
> [80084.032104]  r9:00000000 r8:00000000 r7:cf000780 r6:cf028000 r5:cf01ab40
> [80084.032165] r4:cf029fb8
> [80084.032196] [<c006a714>] (worker_thread+0x0/0x104) from [<c006da88>] (kthread+0x54/0x80)
> [80084.032287]  r7:00000000 r6:00000000 r5:c006a714 r4:cf000780
> [80084.032318] [<c006da34>] (kthread+0x0/0x80) from [<c005a948>] (do_exit+0x0/0x7bc)
> [80084.032409]  r5:00000000 r4:00000000
> [80084.032440] Code: e3530000 1afffff9 e3e05015 ea0000c6 (e59a802c)
> =======================================================================
> 
> I dig more in my disk storage and private archives and found following
> email from Ivaylo which describe that problem and is also source of that
> patch. I hope that Ivo would not be against putting copy of it here :-)
> 
> =======================================================================
> Date: Mon, 31 Oct 2011 16:00:33 +0200 (EET)
> Message-ID: <1251363478.202876.1320069633552.JavaMail.apache@mail82.abv.bg>
> 
> Hi,
> 
> The bug in bq27x00_battery is in function bq27x00_battery_poll. What happens is that after all pending poll work requests are canceled with cancel_delayed_work_sync(&di->work); in function bq27x00_powersupply_unregister  there is a call to power_supply_unregister(&di->bat); which in turn calls bq27x00_battery_get_property. And bq27x00_battery_get_property calls
> bq27x00_battery_poll which leads to another delayed poll work queued. So after the timer expires kernel tries to execute a function in an already unloaded module, so OOPS ;)

Unfortunately this does not tell us anything new.  Even on that kernel,
unregistering power supply was not calling get_property().  Otherwise all power supply drivers
would have such problem.

I think Sebastian pointed the real case - user-space was trying to read
the battery status in one of following options:

Thread 1                                  Thread 1
 - get_property()
   - bq27xxx_battery_poll()
     - bq27xxx_battery_update()
       - i2c transfer which locks the bus
         thus can sleep
                                          - unbind
                                              - bq27xxx_battery_teardown()
                                              - cancel_delayed_work_sync()
                                              - power_supply_unregister()
     - schedule_delayed_work()

Or poll_interval_param_set() if unbind() happens exactly between
cancel_delayed_work_sync() and schedule_delayed_work().

> 
> The fix would be to set poll_interval = 0; in bq27x00_powersupply_unregister so the function will look like:
> 
> static  void  bq27x00_powersupply_unregister(struct  bq27x00_device_info  *di)
> 
> {
> 
>         poll_interval = 0;
> 
>         cancel_delayed_work_sync(&di->work);
> 
>         power_supply_unregister(&di->bat);
> 
>         mutex_destroy(&di->lock);
> 
> }
> 
> thus no new delayed work to be scheduled in function bq27x00_battery_poll.
> 
> Hope the above helps.
> =======================================================================
> 
> > Applying this revert introduces at least a race condition when
> > userspace reads sysfs files while kernel removes the driver.
> > 
> > So looking at the entrypoints for schedules:
> > 
> > bq27xxx_battery_i2c_probe:
> >   Not relevant, probe is done when the battery is being removed.
> > 
> > poll_interval_param_set:
> >   Can be avoided by unregistering from the list earlier. This
> >   is the right thing to do considering the battery is added to
> >   the list as last step in the probe routine, it should be removed
> >   first during teardown.
> > 
> > bq27xxx_external_power_changed:
> >   This can happen at any time while the power-supply device is
> >   registered, because of the code in get_property.
> > 
> > bq27xxx_battery_poll:
> >   This can happen at any time while the power-supply device is
> >   registered.
> > 
> > As far as I can see the only thing in the delayed work needing
> > the power-supply device is power_supply_changed(). If we add a
> > check, that di->bat is not NULL, we should be able to reorder
> > teardown like this:
> > 
> > 1. remove from list
> > 2. unregister power-supply device and set to di->bat to NULL
> > 3. cancel delayed work
> > 4. destroy mutex
> > 
> > Also I agree with Andrew, that the locking looks fishy. I think
> > the lock needs to be moved, so that the call to
> > bq27xx_battery_update(di) in bq27xxx_battery_poll is protected.
> > 
> > -- Sebastian
> 
> And... I found another discussion about crash in bq27x00 battery driver:
> https://lkml.org/lkml/2015/5/18/364

Yes, I remember this topic.  It was however for the
power_supply_register() which in fact leads to get_property() call.


Best regards,
Krzysztof

