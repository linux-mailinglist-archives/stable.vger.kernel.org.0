Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52812E0AA
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 23:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgAAWJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 17:09:38 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40822 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgAAWJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 17:09:38 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so2556348pjb.5;
        Wed, 01 Jan 2020 14:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9cdgl502YwKvDfHVgw0H+MtAaSfZwpnZUROdexmqNFI=;
        b=sGf5efnoItF7FgjSqmc0IRbZAYG9oEccARElQkBdonnNrA/iqpQ53+SD4wGRCYmcH2
         07oruHYgJAzwKVX4nwwXYTn0QBggbq2pH1f/vszfP4irES5WmQ8EQoCS6iWRMpOLXy82
         QGOthBpl6sOEFEItfoHAcyd+AJ0IppJE6qh2eXItRws92jtP1no5x/e0WbrWfaR5kbRv
         t7CtzFYzmJiKL//M6lCkw52xlmjvImjDgOA/BIb1HJaXjGcc32soFSwr0N117m1IYsf2
         BOw8X8heyeQbWmnFlv0RKIkEPdaJMaHyv4t7Uv1cSZEvMkuqrYGitapOLHvN1wWvQKBv
         rBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cdgl502YwKvDfHVgw0H+MtAaSfZwpnZUROdexmqNFI=;
        b=WT9MDjXZp/eka4bvkr5PA6JZtUNzq+uCafInSnZxpg31sOtd1yhFb5MRAs5h9eU5BG
         b6O6HnSpvAfC9HIeudLvFZMR+6FPrzBYnpJCPZEnLPTBjTWPADjYpYvvI3Ycrn7p7+m3
         cwZL52q1PkhSMiy2TNJmQbi0RS/obRkFx9BQT3V8tKPc+pD/V7tYEChbs5Nvnz7F3QCO
         P35EsGPQM7iL6Nge7SHxIi4gHLo4SBBk+cjbNkIfgaRz4MBrK6g0Nj9ckPjSWXcxxhqP
         wsmbxMibkTfOxE8IU7uwrOYsgC+5zXiFAX3R82tZDUL4VGH1eN82QAiNqqz1kgVtnHeA
         SozA==
X-Gm-Message-State: APjAAAXMrmFUqDY0N0pGTApeohN8S0uzKe7RjuZgaVIxnLAgf9gZPAKt
        Cq8WW5FlWZ4Ya79UeuUgOv8CSJb+
X-Google-Smtp-Source: APXvYqzHOIgnfBYhFwq/vuLOSK6OcQY1qVy7GdZ45Basskuon2Dl7ezQYajlH8vez7vMBBCgSlPjyw==
X-Received: by 2002:a17:90a:ab0c:: with SMTP id m12mr15469694pjq.81.1577916577258;
        Wed, 01 Jan 2020 14:09:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u12sm39081895pfm.165.2020.01.01.14.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jan 2020 14:09:36 -0800 (PST)
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        stable@vger.kernel.org
References: <Pine.LNX.4.44L0.1912291137150.19645-100000@netrider.rowland.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1fd709ce-04a3-4183-da39-c1921ec69ce7@roeck-us.net>
Date:   Wed, 1 Jan 2020 14:09:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1912291137150.19645-100000@netrider.rowland.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/29/19 8:40 AM, Alan Stern wrote:
> On Sun, 29 Dec 2019, Guenter Roeck wrote:
> 
>> On Sat, Dec 28, 2019 at 02:33:01PM -0500, Alan Stern wrote:
>>>
>>> Let's try a slightly different approach.  What happens with this patch?
>>>
>>> Alan Stern
>>>
>>>
>>> Index: usb-devel/drivers/usb/core/hub.c
>>> ===================================================================
>>> --- usb-devel.orig/drivers/usb/core/hub.c
>>> +++ usb-devel/drivers/usb/core/hub.c
>>> @@ -1065,6 +1065,7 @@ static void hub_activate(struct usb_hub
>>>   		if (type == HUB_INIT) {
>>>   			delay = hub_power_on_good_delay(hub);
>>>   
>>> +			hub->power_bits[0] = ~0UL;	/* All ports on */
>>>   			hub_power_on(hub, false);
>>>   			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
>>>   			queue_delayed_work(system_power_efficient_wq,
>>>
>>
>> That doesn't make a difference - the traceback is still seen with this patch
>> applied.
> 
> Can you trace what's going on?  Does this code pathway now end up
> calling ehci_port_power() for each root-hub port, and from there down
> into the chipidea driver?  If not, can you find where it gets
> sidetracked?
> 

A complete traceback is attached below, so, yes, I think it is safe to say that
ehci_port_power() is called unconditionally for each root-hub port on shutdown.

The only mystery to me was why ehci_port_power() isn't called to enable port power
when the port comes up. As it turns out, HCS_PPC(ehci->hcs_params) is false on my
simulated hardware, and thus ehci_port_power(..., true) is not called from
ehci_hub_control().

Given that, it may well be that the problem is not seen on "real" hardware,
at least not with real mcimx7d-sabre hardware, if the hub on that hardware does
support power control. To test this idea, I modified qemu to claim hub power
control support by setting the "power control support" capability bit. With
that, the traceback is gone.

Any suggestion how to proceed ?

Thanks,
Guenter

---
[   31.916567] ------------[ cut here ]------------
[   31.917178] WARNING: CPU: 0 PID: 182 at drivers/regulator/core.c:2598 _regulator_disable+0x1a8/0x210
[   31.917331] unbalanced disables for usb_otg2_vbus
[   31.917468] Modules linked in:
[   31.917877] CPU: 0 PID: 182 Comm: init Not tainted 5.4.8-rc1-00003-gb8e36d27e314 #1
[   31.918032] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   31.918246] [<c0313658>] (unwind_backtrace) from [<c030d698>] (show_stack+0x10/0x14)
[   31.918397] [<c030d698>] (show_stack) from [<c113439c>] (dump_stack+0xe0/0x10c)
[   31.918522] [<c113439c>] (dump_stack) from [<c0349098>] (__warn+0xf4/0x10c)
[   31.918641] [<c0349098>] (__warn) from [<c0349128>] (warn_slowpath_fmt+0x78/0xbc)
[   31.918768] [<c0349128>] (warn_slowpath_fmt) from [<c09f3c3c>] (_regulator_disable+0x1a8/0x210)
[   31.918900] [<c09f3c3c>] (_regulator_disable) from [<c09f3cdc>] (regulator_disable+0x38/0xe8)
[   31.919032] [<c09f3cdc>] (regulator_disable) from [<c0df837c>] (ehci_ci_portpower+0x38/0xdc)
	ehci_ci_portpower() calls regulator_enable() or regulator_disable()
	if priv->reg_vbus is not NULL
[   31.919166] [<c0df837c>] (ehci_ci_portpower) from [<c0db5724>] (ehci_port_power+0x50/0xa4)
	ehci_port_power() calls hcd->driver->port_power(), which is ehci_ci_portpower()
[   31.919296] [<c0db5724>] (ehci_port_power) from [<c0db5ba0>] (ehci_silence_controller+0x5c/0xc4)
	ehci_silence_controller() calls ehci_turn_off_all_ports(), which calls
	ehci_port_power() for each port
[   31.919430] [<c0db5ba0>] (ehci_silence_controller) from [<c0db7dc4>] (ehci_stop+0x3c/0xcc)
	ehci_silence_controller() called unconditionally from ehci_stop()
[   31.919560] [<c0db7dc4>] (ehci_stop) from [<c0d5c504>] (usb_remove_hcd+0xe0/0x19c)	
	ehci_stop() called unconditionally from usb_remove_hcd() with hcd->driver->stop(hcd);
[   31.919685] [<c0d5c504>] (usb_remove_hcd) from [<c0df7e08>] (host_stop+0x38/0xa8)
[   31.919809] [<c0df7e08>] (host_stop) from [<c0df3704>] (ci_hdrc_remove+0x44/0xe4)
[   31.919932] [<c0df3704>] (ci_hdrc_remove) from [<c0b1a5e4>] (platform_drv_remove+0x20/0x40)
[   31.920062] [<c0b1a5e4>] (platform_drv_remove) from [<c0b18a50>] (device_release_driver_internal+0xe8/0x1b8)
[   31.920210] [<c0b18a50>] (device_release_driver_internal) from [<c0b17464>] (bus_remove_device+0xd0/0xfc)
[   31.920351] [<c0b17464>] (bus_remove_device) from [<c0b1401c>] (device_del+0x140/0x374)
[   31.920477] [<c0b1401c>] (device_del) from [<c0b1aaf8>] (platform_device_del.part.3+0x10/0x74)
[   31.920608] [<c0b1aaf8>] (platform_device_del.part.3) from [<c0b1ab8c>] (platform_device_unregister+0x1c/0x28)
[   31.920758] [<c0b1ab8c>] (platform_device_unregister) from [<c0df22f4>] (ci_hdrc_remove_device+0xc/0x20)
[   31.920898] [<c0df22f4>] (ci_hdrc_remove_device) from [<c0df9ea4>] (ci_hdrc_imx_remove+0x28/0x110)
[   31.921033] [<c0df9ea4>] (ci_hdrc_imx_remove) from [<c0b15ac4>] (device_shutdown+0x180/0x224)
[   31.921166] [<c0b15ac4>] (device_shutdown) from [<c037652c>] (kernel_restart+0xc/0x50)
[   31.921292] [<c037652c>] (kernel_restart) from [<c03767d0>] (__do_sys_reboot+0x15c/0x1ec)
[   31.921444] [<c03767d0>] (__do_sys_reboot) from [<c0301000>] (ret_fast_syscall+0x0/0x28)
[   31.921595] Exception stack(0xc93c1fa8 to 0xc93c1ff0)
