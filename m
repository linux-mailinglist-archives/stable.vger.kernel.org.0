Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A71662D01
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 18:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjAIRkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 12:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbjAIRkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 12:40:31 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1119CE05
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 09:40:29 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id n63so4865476iod.7
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 09:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DACwT/eplpec0VqeUF7jWlh6DDiVed+jRgRCtq4aYtk=;
        b=WCZTKsJCMmBFAICZAZVnIaAbEXxQjY0G27DlvsynIhaAAuHy9EOQFfFMZOmR125MDt
         S3gDorg8Sy901aExHvenx3cxSBSUaJurFxbQolzbH7F/zX0sGEYXD9JrDEcOEmndRKlc
         IO0AZdzhKKJ3AcN95DAJb7I41PRf78YTcknAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DACwT/eplpec0VqeUF7jWlh6DDiVed+jRgRCtq4aYtk=;
        b=Sy4RuWGFwKj+lkxqcAuw1OIAC7QaG33sJywyGgwsu+jPlxyaToMhtRFwaKYSeowCbl
         zWsoS/qs0JEsRYP16zhiduKzvPfOKl83xv8dmqEFspytIWZLVqnShPA3xyV8zEWNb6Cq
         I+y6a75DhGF9McUAFTg2Ucz85O5CoUbU3dk7iYGC7TgHf2LyFYsCMHurZu1cTDQ51HhL
         wNz2Hmhm6wW8FkQBj8lYfA7YWmrjW/azA7EFXJD34e1P/aDyoaAfTqiWrnvtVEV6RZUI
         iWvXmKslCO7DYPzrKO/mU2j7VrGknI0TcVv/pYiDbhnLg2jNY6p4Jvoks1UD02qrNstZ
         sNJA==
X-Gm-Message-State: AFqh2kqGxSD0hfccxgIiWQ4h3ebHYvRTl5WhD2+gkQP3pnp1yvTXz+++
        Dso+cDPNA2I9o4rDqWzWr0TzvQ==
X-Google-Smtp-Source: AMrXdXuADas8+CJG83rybN+UF/B7rB04yYuHA9uG+FqSxO2HzilWovlvZGupFuLVMAMSXdQpJWpeZA==
X-Received: by 2002:a6b:b2c8:0:b0:6e2:a51:83dd with SMTP id b191-20020a6bb2c8000000b006e20a5183ddmr40659310iof.21.1673286029148;
        Mon, 09 Jan 2023 09:40:29 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id h9-20020a05660208c900b006eba8966048sm3442499ioz.54.2023.01.09.09.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 09:40:28 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:40:28 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH 2/2] usb: misc: onboard_hub: Move 'attach' work to the
 driver
Message-ID: <Y7xRjDAgI3UO8Xuv@google.com>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
 <20230105230119.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
 <d606398d-8569-5695-5fd7-038977c83eb4@i2se.com>
 <a5a32db9-21a1-1734-1c4f-88b9431d7aa8@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5a32db9-21a1-1734-1c4f-88b9431d7aa8@i2se.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 08, 2023 at 11:47:13AM +0100, Stefan Wahren wrote:
> Am 07.01.23 um 18:23 schrieb Stefan Wahren:
> > Hi Matthias,
> > 
> > Am 06.01.23 um 00:03 schrieb Matthias Kaehlcke:
> > > Currently each onboard_hub platform device owns an 'attach' work,
> > > which is scheduled when the device probes. With this deadlocks
> > > have been reported on a Raspberry Pi 3 B+ [1], which has nested
> > > onboard hubs.
> > > 
> > > The flow of the deadlock is something like this (with the onboard_hub
> > > driver built as a module) [2]:
> > > 
> > > - USB root hub is instantiated
> > > - core hub driver calls onboard_hub_create_pdevs(), which creates the
> > >    'raw' platform device for the 1st level hub
> > > - 1st level hub is probed by the core hub driver
> > > - core hub driver calls onboard_hub_create_pdevs(), which creates
> > >    the 'raw' platform device for the 2nd level hub
> > > 
> > > - onboard_hub platform driver is registered
> > > - platform device for 1st level hub is probed
> > >    - schedules 'attach' work
> > > - platform device for 2nd level hub is probed
> > >    - schedules 'attach' work
> > > 
> > > - onboard_hub USB driver is registered
> > > - device (and parent) lock of hub is held while the device is
> > >    re-probed with the onboard_hub driver
> > > 
> > > - 'attach' work (running in another thread) calls driver_attach(), which
> > >     blocks on one of the hub device locks
> > > 
> > > - onboard_hub_destroy_pdevs() is called by the core hub driver when one
> > >    of the hubs is detached
> > > - destroying the pdevs invokes onboard_hub_remove(), which waits for the
> > >    'attach' work to complete
> > >    - waits forever, since the 'attach' work can't acquire the device
> > > lock
> > > 
> > > Use a single work struct for the driver instead of having a work struct
> > > per onboard hub platform driver instance. With that it isn't necessary
> > > to cancel the work in onboard_hub_remove(), which fixes the deadlock.
> > > The work is only cancelled when the driver is unloaded.
> > 
> > i applied both patches for this series on top of v6.1
> > (multi_v7_defconfig), but usb is still broken on Raspberry Pi 3 B+

Thanks for testing.

> here is the hung task output:
> 
> [  243.682193] INFO: task kworker/1:0:18 blocked for more than 122 seconds.
> [  243.682222]       Not tainted 6.1.0-00002-gaa61d98d165b #2
> [  243.682233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  243.682242] task:kworker/1:0     state:D stack:0     pid:18 ppid:2     
> flags:0x00000000
> [  243.682267] Workqueue: events onboard_hub_attach_usb_driver
> [onboard_usb_hub]
> [  243.682317]  __schedule from schedule+0x4c/0xe0
> [  243.682345]  schedule from schedule_preempt_disabled+0xc/0x10
> [  243.682367]  schedule_preempt_disabled from
> __mutex_lock.constprop.0+0x244/0x804
> [  243.682394]  __mutex_lock.constprop.0 from __driver_attach+0x7c/0x188
> [  243.682421]  __driver_attach from bus_for_each_dev+0x70/0xb0
> [  243.682449]  bus_for_each_dev from onboard_hub_attach_usb_driver+0xc/0x28
> [onboard_usb_hub]
> [  243.682494]  onboard_hub_attach_usb_driver [onboard_usb_hub] from
> process_one_work+0x1ec/0x4d0
> [  243.682534]  process_one_work from worker_thread+0x50/0x540
> [  243.682559]  worker_thread from kthread+0xd0/0xec
> [  243.682582]  kthread from ret_from_fork+0x14/0x2c
> [  243.682600] Exception stack(0xf086dfb0 to 0xf086dff8)
> [  243.682615] dfa0:                                     00000000 00000000
> 00000000 00000000
> [  243.682631] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [  243.682646] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  243.682692] INFO: task kworker/1:2:82 blocked for more than 122 seconds.
> [  243.682703]       Not tainted 6.1.0-00002-gaa61d98d165b #2
> [  243.682713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  243.682721] task:kworker/1:2     state:D stack:0     pid:82 ppid:2     
> flags:0x00000000
> [  243.682741] Workqueue: events_power_efficient hub_init_func2
> [  243.682764]  __schedule from schedule+0x4c/0xe0
> [  243.682785]  schedule from schedule_preempt_disabled+0xc/0x10
> [  243.682808]  schedule_preempt_disabled from
> __mutex_lock.constprop.0+0x244/0x804
> [  243.682833]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
> [  243.682859]  hub_activate from process_one_work+0x1ec/0x4d0
> [  243.682883]  process_one_work from worker_thread+0x50/0x540
> [  243.682907]  worker_thread from kthread+0xd0/0xec
> [  243.682927]  kthread from ret_from_fork+0x14/0x2c
> [  243.682944] Exception stack(0xf1509fb0 to 0xf1509ff8)
> [  243.682958] 9fa0:                                     00000000 00000000
> 00000000 00000000
> [  243.682974] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [  243.682988] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  243.683023] INFO: task kworker/1:4:257 blocked for more than 122 seconds.
> [  243.683034]       Not tainted 6.1.0-00002-gaa61d98d165b #2
> [  243.683043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  243.683051] task:kworker/1:4     state:D stack:0     pid:257 ppid:2     
> flags:0x00000000
> [  243.683071] Workqueue: events_power_efficient hub_init_func2
> [  243.683092]  __schedule from schedule+0x4c/0xe0
> [  243.683113]  schedule from schedule_preempt_disabled+0xc/0x10
> [  243.683135]  schedule_preempt_disabled from
> __mutex_lock.constprop.0+0x244/0x804
> [  243.683160]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
> [  243.683184]  hub_activate from process_one_work+0x1ec/0x4d0
> [  243.683209]  process_one_work from worker_thread+0x50/0x540
> [  243.683233]  worker_thread from kthread+0xd0/0xec
> [  243.683253]  kthread from ret_from_fork+0x14/0x2c
> [  243.683270] Exception stack(0xf09d9fb0 to 0xf09d9ff8)
> [  243.683283] 9fa0:                                     00000000 00000000
> 00000000 00000000
> [  243.683299] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [  243.683313] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Does commenting the following help:

  while (work_busy(&attach_usb_driver_work) & WORK_BUSY_RUNNING)
      msleep(10);

?

I'm wondering if the loop is actually needed. The idea behind it was:

The currently running work might not take into account the USB devices
of the hub that is currently probed, which should probe shortly after
the hub was powered on.

The 'attach' work is only needed for USB devices that were previously
detached through device_release_driver() in onboard_hub_remove(). These
USB device objects only persist in the kernel if the hub is not powered
off by onboard_hub_remove() (powering the hub off should be the usual
case).

If onboard_hub_probe() is invoked and the USB device objects persisted,
then an already running 'attach' work should take them into account. If
they didn't persist the running work might miss them, but that wouldn't
be a problem since the newly created USB devices don't need to be
explicitly attached (since they weren't detached previously).
