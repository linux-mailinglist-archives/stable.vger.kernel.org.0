Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA56455A08
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 12:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343789AbhKRLY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 06:24:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39946 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343887AbhKRLWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 06:22:19 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211118111916euoutp02796d4fdba08e7cd825a4204aca490e8a~4n-kIXPRF1678916789euoutp02I
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 11:19:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211118111916euoutp02796d4fdba08e7cd825a4204aca490e8a~4n-kIXPRF1678916789euoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637234356;
        bh=hM8rPM/pYkID2lim/Aw8esf/cOiSPIsJ7suI4QCL4yc=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=lgMWQDDsovhRhXAlEat3xlrX9J3CE0tjYTqVjn3YDtyvTijCmquLtOupWIcuJQXNw
         3VimXOcbOzche67e8dnzWHL/ipMVmrWNzVc/qdHaKRIjobwj9NQX1JrL87TL1uukSU
         95rdwbrHH7om0XNBh7Lyx4cZXp3EbjAE1RkgurSI=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211118111916eucas1p1be23bc6273113c8f97131a79abf212a3~4n-j73L6l2177821778eucas1p16;
        Thu, 18 Nov 2021 11:19:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 9D.B6.10260.4B636916; Thu, 18
        Nov 2021 11:19:16 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e~4n-jkBiDT1163711637eucas1p28;
        Thu, 18 Nov 2021 11:19:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211118111915eusmtrp2905e90741cb63487e8280e6bf60f442e~4n-ji1rJb2775127751eusmtrp2i;
        Thu, 18 Nov 2021 11:19:15 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-00-619636b4609f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9F.15.09404.3B636916; Thu, 18
        Nov 2021 11:19:15 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211118111915eusmtip2dcf129c69811780d8119f36ef2dfa6ee~4n-jCrEVn0722207222eusmtip2F;
        Thu, 18 Nov 2021 11:19:15 +0000 (GMT)
Message-ID: <f3bfcbc7-f701-c74a-09bd-6491d4c8d863@samsung.com>
Date:   Thu, 18 Nov 2021 12:19:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] usb: hub: Fix usb enumeration issue due to address0
 race
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7djPc7pbzKYlGix/yWxxae1eVovmxevZ
        LN4cn85kceFpD5vFomWtzBavPzSxWCzY+IjRYsLvC2wOHB6zGnrZPOadDPTYP3cNu8f7fVfZ
        PGbf/cHocfzGdiaPz5vkAtijuGxSUnMyy1KL9O0SuDLerlnMWjDdo+LI5hPsDYyvbLoYOTkk
        BEwkvlw9xg5iCwmsYJTYe1Ski5ELyP7CKPF+9TdGiMRnRokvH/lhGpZPu8sEUbScUeL07nZ2
        COcjo0TDhLtADgcHr4CdxLfPLiANLAKqEl+aP4MN4hUQlDg58wkLiC0qkCRxunUSM4gtLOAv
        8fX5bVYQm1lAXOLWk/lMILaIQKVE54JONoh4msSOxoVg9WwChhJdb7vA4pwCLhJzD/exQNTI
        SzRvnc0Mco+EwBcOiVcTDzJCXO0isfziDyYIW1ji1fEt7BC2jMT/nfOZIBqaGSUenlvLDuH0
        MEpcbpoB1W0tcefcLzaQz5gFNCXW79IHMSUEHCUW7i2CMPkkbrwVhLiBT2LStunMEGFeiY42
        IYgZahKzjq+D23rwwiXmCYxKs5BCZRaS72ch+WYWwtoFjCyrGMVTS4tz01OLjfNSy/WKE3OL
        S/PS9ZLzczcxAlPT6X/Hv+5gXPHqo94hRiYOxkOMEhzMSiK8Qg1TE4V4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzivxpSBQSSE8sSc1OTS1ILYLJMnFwSjUwJZ/46paXX+A071t6gFzz3CnLbz1M
        rNAI3Cp8ZHv5Re7Y8+uVthYtnLN3nUCmHN9Vo28/3j3girbpZap4K6npwrZsyVK+yudzpoVe
        y80ut91be7/735efV40Xt/SVzpKZGjH9uKeIYqi5kq4ri2OCNN+9K+ZLS1T91624zqrnM+u5
        qb/cBJFP7BbXJ2/YyC+WxL5AhpE3q3DLI43YSZp9EYlNM3wu+k5ZrnFidkfp4mCfBauU2UUn
        utRH7HLRDlrrVmHac+rig0gPxk1uD1Y3ckezNt154vrDU8OiYsUNexWxYrEj61mv2Tdn+MeW
        /Dz7u20/4w77uv+Vb0od2Y4YH36kv0/C0jJ4ypaNQvOVWIozEg21mIuKEwHpQN7EvAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xe7qbzaYlGvxarWlxae1eVovmxevZ
        LN4cn85kceFpD5vFomWtzBavPzSxWCzY+IjRYsLvC2wOHB6zGnrZPOadDPTYP3cNu8f7fVfZ
        PGbf/cHocfzGdiaPz5vkAtij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX0
        7WxSUnMyy1KL9O0S9DLerlnMWjDdo+LI5hPsDYyvbLoYOTkkBEwklk+7y9TFyMUhJLCUUWLW
        is0sEAkZiZPTGlghbGGJP9e62CCK3jNKPNoxCaiIg4NXwE7i22cXkBoWAVWJL82fGUFsXgFB
        iZMzn4DNERVIkuj/vosZxBYW8JX4/vssWA2zgLjErSfzmUBsEYFKiS2ND5kg4mkSl7Y1sIPY
        QgLOEmtOtYDNYRMwlOh6C3IDJwengIvE3MN9LBD1ZhJdW7ugZspLNG+dzTyBUWgWkjNmIVk3
        C0nLLCQtCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG47ZjP7fsYFz56qPeIUYmDsZD
        jBIczEoivEINUxOFeFMSK6tSi/Lji0pzUosPMZoCw2Iis5Rocj4wIeSVxBuaGZgamphZGpha
        mhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTCprK46uHp92Qu3IMPOpw6vvxeePxxy5I9L
        UvMRvtrDwdYm8Svnr0leLHc5qFy6YA3PD3WDZXfXPdLc7nvC8t3m0hcHFqwvC5fivKXSprw7
        lsH6NaPhhFdz157WaOyJyVu/5Iyv8PGFOW/MLdiebhC3MNqw8bA411/h2jcH7q6ePvV/mFTl
        g+DkrW9TymvL1gu+6hY0F6/dwL8g9EH45fbuIJlZxxZ/Xajy9VaFkKgIV/HLmfdLbKatzPNq
        FQ8UvHPxeaj/j+2W/AfezFj3LoR15f/inX2lXxkfmJ1Nce5pS+de82Pzk7xTnYeO2K/Q7P+r
        H7dipVXCIgGdaA2ndDkb/b/fJ17QyzNdz3EuibVfiaU4I9FQi7moOBEAcwKOilADAAA=
X-CMS-MailID: 20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e
References: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
        <CGME20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 15.11.2021 23:16, Mathias Nyman wrote:
> xHC hardware can only have one slot in default state with address 0
> waiting for a unique address at a time, otherwise "undefined behavior
> may occur" according to xhci spec 5.4.3.4
>
> The address0_mutex exists to prevent this across both xhci roothubs.
>
> If hub_port_init() fails, it may unlock the mutex and exit with a xhci
> slot in default state. If the other xhci roothub calls hub_port_init()
> at this point we end up with two slots in default state.
>
> Make sure the address0_mutex protects the slot default state across
> hub_port_init() retries, until slot is addressed or disabled.
>
> Note, one known minor case is not fixed by this patch.
> If device needs to be reset during resume, but fails all hub_port_init()
> retries in usb_reset_and_verify_device(), then it's possible the slot is
> still left in default state when address0_mutex is unlocked.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

This patch landed in linux next-20211118 as commit 6ae6dc22d2d1 ("usb: 
hub: Fix usb enumeration issue due to address0 race"). On my test 
systems it triggers the following deplock warning during system 
suspend/resume cycle:

======================================================
WARNING: possible circular locking dependency detected
5.16.0-rc1-00014-g6ae6dc22d2d1 #4126 Not tainted
------------------------------------------------------
kworker/u16:8/738 is trying to acquire lock:
cf81f738 (hcd->address0_mutex){+.+.}-{3:3}, at: 
usb_reset_and_verify_device+0xe8/0x3e4

but task is already holding lock:
cf80ab3c (&port_dev->status_lock){+.+.}-{3:3}, at: 
usb_port_resume+0xa0/0x7e8

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&port_dev->status_lock){+.+.}-{3:3}:
        mutex_lock_nested+0x1c/0x24
        hub_event+0x824/0x1758
        process_one_work+0x2c8/0x7ec
        worker_thread+0x50/0x584
        kthread+0x13c/0x19c
        ret_from_fork+0x14/0x2c
        0x0

-> #0 (hcd->address0_mutex){+.+.}-{3:3}:
        lock_acquire+0x2a0/0x42c
        __mutex_lock+0x94/0xaa8
        mutex_lock_nested+0x1c/0x24
        usb_reset_and_verify_device+0xe8/0x3e4
        usb_port_resume+0x4e0/0x7e8
        usb_generic_driver_resume+0x18/0x40
        usb_resume_both+0x120/0x164
        usb_resume+0x14/0x60
        usb_dev_resume+0xc/0x10
        dpm_run_callback+0x98/0x32c
        device_resume+0xb4/0x258
        async_resume+0x20/0x64
        async_run_entry_fn+0x40/0x15c
        process_one_work+0x2c8/0x7ec
        worker_thread+0x50/0x584
        kthread+0x13c/0x19c
        ret_from_fork+0x14/0x2c
        0x0

other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&port_dev->status_lock);
                                lock(hcd->address0_mutex);
lock(&port_dev->status_lock);
   lock(hcd->address0_mutex);

  *** DEADLOCK ***

4 locks held by kworker/u16:8/738:
  #0: c1c08ca8 ((wq_completion)events_unbound){+.+.}-{0:0}, at: 
process_one_work+0x21c/0x7ec
  #1: cd9cff18 ((work_completion)(&entry->work)){+.+.}-{0:0}, at: 
process_one_work+0x21c/0x7ec
  #2: cf810148 (&dev->mutex){....}-{3:3}, at: device_resume+0x60/0x258
  #3: cf80ab3c (&port_dev->status_lock){+.+.}-{3:3}, at: 
usb_port_resume+0xa0/0x7e8

stack backtrace:
CPU: 4 PID: 738 Comm: kworker/u16:8 Not tainted 
5.16.0-rc1-00014-g6ae6dc22d2d1 #4126
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events_unbound async_run_entry_fn
[<c01110d0>] (unwind_backtrace) from [<c010cab8>] (show_stack+0x10/0x14)
[<c010cab8>] (show_stack) from [<c0b7427c>] (dump_stack_lvl+0x58/0x70)
[<c0b7427c>] (dump_stack_lvl) from [<c0192958>] 
(check_noncircular+0x144/0x15c)
[<c0192958>] (check_noncircular) from [<c0195e68>] 
(__lock_acquire+0x17e4/0x3180)
[<c0195e68>] (__lock_acquire) from [<c01983ec>] (lock_acquire+0x2a0/0x42c)
[<c01983ec>] (lock_acquire) from [<c0b7ba80>] (__mutex_lock+0x94/0xaa8)
[<c0b7ba80>] (__mutex_lock) from [<c0b7c4b0>] (mutex_lock_nested+0x1c/0x24)
[<c0b7c4b0>] (mutex_lock_nested) from [<c077bf9c>] 
(usb_reset_and_verify_device+0xe8/0x3e4)
[<c077bf9c>] (usb_reset_and_verify_device) from [<c077e79c>] 
(usb_port_resume+0x4e0/0x7e8)
[<c077e79c>] (usb_port_resume) from [<c07941f0>] 
(usb_generic_driver_resume+0x18/0x40)
[<c07941f0>] (usb_generic_driver_resume) from [<c0789a40>] 
(usb_resume_both+0x120/0x164)
[<c0789a40>] (usb_resume_both) from [<c078a854>] (usb_resume+0x14/0x60)
[<c078a854>] (usb_resume) from [<c0777fa0>] (usb_dev_resume+0xc/0x10)
[<c0777fa0>] (usb_dev_resume) from [<c06ca1b8>] 
(dpm_run_callback+0x98/0x32c)
[<c06ca1b8>] (dpm_run_callback) from [<c06ca500>] (device_resume+0xb4/0x258)
[<c06ca500>] (device_resume) from [<c06ca6c4>] (async_resume+0x20/0x64)
[<c06ca6c4>] (async_resume) from [<c01548bc>] 
(async_run_entry_fn+0x40/0x15c)
[<c01548bc>] (async_run_entry_fn) from [<c0148a68>] 
(process_one_work+0x2c8/0x7ec)
[<c0148a68>] (process_one_work) from [<c0148fdc>] (worker_thread+0x50/0x584)
[<c0148fdc>] (worker_thread) from [<c0151274>] (kthread+0x13c/0x19c)
[<c0151274>] (kthread) from [<c0100108>] (ret_from_fork+0x14/0x2c)
Exception stack(0xcd9cffb0 to 0xcd9cfff8)
ffa0:                                     00000000 00000000 00000000 
00000000
ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
usb 1-1: reset high-speed USB device number 2 using exynos-ehci
usb 1-1.1: reset high-speed USB device number 3 using exynos-ehci
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
s3c-rtc 101e0000.rtc: rtc disabled, re-enabling
smsc95xx 1-1.1:1.0 eth0: Link is Down
OOM killer enabled.
Restarting tasks ... done.
PM: suspend exit

Reverting it on top of next-20211118 fixes/hides this warning. Let me 
know if I can help somehow fixing this issue.

> ---
>   drivers/usb/core/hub.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 86658a81d284..00c3506324e4 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4700,8 +4700,6 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
>   	if (oldspeed == USB_SPEED_LOW)
>   		delay = HUB_LONG_RESET_TIME;
>   
> -	mutex_lock(hcd->address0_mutex);
> -
>   	/* Reset the device; full speed may morph to high speed */
>   	/* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
>   	retval = hub_port_reset(hub, port1, udev, delay, false);
> @@ -5016,7 +5014,6 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
>   		hub_port_disable(hub, port1, 0);
>   		update_devnum(udev, devnum);	/* for disconnect processing */
>   	}
> -	mutex_unlock(hcd->address0_mutex);
>   	return retval;
>   }
>   
> @@ -5246,6 +5243,9 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   		unit_load = 100;
>   
>   	status = 0;
> +
> +	mutex_lock(hcd->address0_mutex);
> +
>   	for (i = 0; i < PORT_INIT_TRIES; i++) {
>   
>   		/* reallocate for each attempt, since references
> @@ -5282,6 +5282,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   		if (status < 0)
>   			goto loop;
>   
> +		mutex_unlock(hcd->address0_mutex);
> +
>   		if (udev->quirks & USB_QUIRK_DELAY_INIT)
>   			msleep(2000);
>   
> @@ -5370,6 +5372,7 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   
>   loop_disable:
>   		hub_port_disable(hub, port1, 1);
> +		mutex_lock(hcd->address0_mutex);
>   loop:
>   		usb_ep0_reinit(udev);
>   		release_devnum(udev);
> @@ -5396,6 +5399,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   	}
>   
>   done:
> +	mutex_unlock(hcd->address0_mutex);
> +
>   	hub_port_disable(hub, port1, 1);
>   	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
>   		if (status != -ENOTCONN && status != -ENODEV)
> @@ -5915,6 +5920,8 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
>   	bos = udev->bos;
>   	udev->bos = NULL;
>   
> +	mutex_lock(hcd->address0_mutex);
> +
>   	for (i = 0; i < PORT_INIT_TRIES; ++i) {
>   
>   		/* ep0 maxpacket size may change; let the HCD know about it.
> @@ -5924,6 +5931,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
>   		if (ret >= 0 || ret == -ENOTCONN || ret == -ENODEV)
>   			break;
>   	}
> +	mutex_unlock(hcd->address0_mutex);
>   
>   	if (ret < 0)
>   		goto re_enumerate;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

