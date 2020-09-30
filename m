Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA0E27E46E
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 11:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgI3JBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 05:01:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:34016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3JBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 05:01:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601456474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3wcjM1WD4AMZUpkaeyzHkgNo//71wQUew5IP9dn8k0=;
        b=G47zxqeG645gYQaUamZxzS7LVDg1V4qJXKJy1KC1laSE20wohb6kGqXiOkRzxdoi+Rujwc
        b9wdS7EIPJcQAuyZ7aLIFhkZXNl9FtkKsczLcESG1oyozu6jmIUwfOqPFPUCGsBfx1HoG7
        GJlTlkqHN63aAKe3zrBnSpCCZV9YNDM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3211AAD2C;
        Wed, 30 Sep 2020 09:01:14 +0000 (UTC)
Subject: Re: [PATCH 4.4 50/62] XEN uses irqdesc::irq_data_common::handler_data
 to store a per interrupt XEN data pointer which contains XEN specific
 information.
To:     Stefan Bader <stefan.bader@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Roman Shaposhnik <roman@zededa.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200901150920.697676718@linuxfoundation.org>
 <20200901150923.247002384@linuxfoundation.org>
 <e958ff30-b7a9-9bd1-b483-542b6d117cc5@canonical.com>
 <15f140ef-cfd3-c3b7-9b8c-2a7ba3fab56a@suse.com>
 <65aac56a-e4a8-cb1c-6684-614b91ea618d@canonical.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <da03f734-a371-a753-0ec1-3c7335bcb1be@suse.com>
Date:   Wed, 30 Sep 2020 11:01:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <65aac56a-e4a8-cb1c-6684-614b91ea618d@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.09.20 10:52, Stefan Bader wrote:
> On 29.09.20 16:05, Jürgen Groß wrote:
>> On 29.09.20 15:13, Stefan Bader wrote:
>>> On 01.09.20 17:10, Greg Kroah-Hartman wrote:
>>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>>
>>>> commit c330fb1ddc0a922f044989492b7fcca77ee1db46 upstream.
>>>>
>>>> handler data is meant for interrupt handlers and not for storing irq chip
>>>> specific information as some devices require handler data to store internal
>>>> per interrupt information, e.g. pinctrl/GPIO chained interrupt handlers.
>>>>
>>>> This obviously creates a conflict of interests and crashes the machine
>>>> because the XEN pointer is overwritten by the driver pointer.
>>>
>>> I cannot say whether this applies the same for the vanilla 4.4 stable kernels
>>> but once this had been applied to our 4.4 based kernels, we observed Xen HVM
>>> guests crashing on boot with:
>>>
>>> [    0.927538] ACPI: bus type PCI registered
>>> [    0.936008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>> [    0.948739] PCI: Using configuration type 1 for base access
>>> [    0.960007] PCI: Using configuration type 1 for extended access
>>> [    0.984340] ACPI: Added _OSI(Module Device)
>>> [    0.988010] ACPI: Added _OSI(Processor Device)
>>> [    0.992007] ACPI: Added _OSI(3.0 _SCP Extensions)
>>> [    0.996013] ACPI: Added _OSI(Processor Aggregator Device)
>>> [    1.002103] BUG: unable to handle kernel paging request at ffffffffff5f3000
>>> [    1.004000] IP: [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
>>> [    1.004000] PGD 1e0f067 PUD 1e11067 PMD 1e12067 PTE 0
>>> [    1.004000] Oops: 0002 [#1] SMP
>>> [    1.004000] Modules linked in:
>>> [    1.004000] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 4.4.0-191-generic
>>> #221-Ubuntu
>>> [    1.004000] Hardware name: Xen HVM domU, BIOS 4.6.5 04/18/2018
>>> [    1.004000] task: ffff880107db0000 ti: ffff880107dac000 task.ti:
>>> ffff880107dac000
>>> [    1.004000] RIP: 0010:[<ffffffff810592ff>]  [<ffffffff810592ff>]
>>> mp_irqdomain_activate+0x5f/0xa0
>>> [    1.004000] RSP: 0018:ffff880107dafc48  EFLAGS: 00010086
>>> [    1.004000] RAX: 0000000000000086 RBX: ffff8800eb852140 RCX: 0000000000000000
>>> [    1.004000] RDX: ffffffffff5f3000 RSI: 0000000000000001 RDI: 000000000020c000
>>> [    1.004000] RBP: ffff880107dafc50 R08: ffffffff81ebdfd0 R09: 00000000ffffffff
>>> [    1.004000] R10: 0000000000000011 R11: 0000000000000009 R12: ffff88010880d400
>>> [    1.004000] R13: 0000000000000001 R14: 0000000000000009 R15: ffff8800eb880080
>>> [    1.004000] FS:  0000000000000000(0000) GS:ffff880108ec0000(0000)
>>> knlGS:0000000000000000
>>> [    1.004000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    1.004000] CR2: ffffffffff5f3000 CR3: 0000000001e0a000 CR4: 00000000000006f0
>>> [    1.004000] Stack:
>>> [    1.004000]  ffff88010880bc58 ffff880107dafc70 ffffffff810ea644
>>> ffff88010880bc00
>>> [    1.004000]  ffff88010880bc58 ffff880107dafca0 ffffffff810e6d88
>>> ffffffff810e1009
>>> [    1.004000]  ffff88010880bc00 ffff88010880bca0 ffff8800eb880080
>>> ffff880107dafd38
>>> [    1.004000] Call Trace:
>>> [    1.004000]  [<ffffffff810ea644>] irq_domain_activate_irq+0x44/0x50
>>> [    1.004000]  [<ffffffff810e6d88>] irq_startup+0x38/0x90
>>> [    1.004000]  [<ffffffff810e1009>] ? vprintk_default+0x29/0x40
>>> [    1.004000]  [<ffffffff810e55e2>] __setup_irq+0x5a2/0x650
>>> [    1.004000]  [<ffffffff811fc064>] ? kmem_cache_alloc_trace+0x1d4/0x1f0
>>> [    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
>>> [    1.004000]  [<ffffffff810e582b>] request_threaded_irq+0xfb/0x1a0
>>> [    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
>>> [    1.004000]  [<ffffffff814bf624>] ? acpi_ev_sci_dispatch+0x64/0x64
>>> [    1.004000]  [<ffffffff814a3f0a>] acpi_os_install_interrupt_handler+0xaa/0x100
>>> [    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
>>> [    1.004000]  [<ffffffff814bf689>] acpi_ev_install_sci_handler+0x23/0x25
>>> [    1.004000]  [<ffffffff814bcf03>] acpi_ev_install_xrupt_handlers+0x1c/0x6c
>>> [    1.004000]  [<ffffffff81fb3e9d>] acpi_enable_subsystem+0x8f/0x93
>>> [    1.004000]  [<ffffffff81fb276c>] acpi_init+0x8b/0x2c4
>>> [    1.004000]  [<ffffffff8141ee1e>] ? kasprintf+0x4e/0x70
>>> [    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
>>> [    1.004000]  [<ffffffff810021f5>] do_one_initcall+0xb5/0x200
>>> [    1.004000]  [<ffffffff810a6fda>] ? parse_args+0x29a/0x4a0
>>> [    1.004000]  [<ffffffff81f69152>] kernel_init_freeable+0x177/0x218
>>> [    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
>>> [    1.004000]  [<ffffffff8185dcfe>] kernel_init+0xe/0xe0
>>> [    1.004000]  [<ffffffff8186ae92>] ret_from_fork+0x42/0x80
>>> [    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
>>> [    1.004000] Code: 8d 1c d2 8d ba 0b 02 00 00 44 8d 51 11 42 8b 14 dd 74 ec 10
>>> 82 c1 e7 0c 48 63 ff 81 e2 ff 0f 00 00 48 81 ea 00 10 80 00 48 29 fa <44> 89 12
>>> 89 72 10 42 8b 14 dd 74 ec 10 82 83 c1 10 81 e2 ff 0f
>>> [    1.004000] RIP  [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
>>> [    1.004000]  RSP <ffff880107dafc48>
>>> [    1.004000] CR2: ffffffffff5f3000
>>> [    1.004000] ---[ end trace 3201cae5b6bd7be1 ]---
>>> [    1.592027] Kernel panic - not syncing: Attempted to kill init!
>>> exitcode=0x00000009
>>> [    1.592027]
>>>
>>> This is from a local server but same stack-trace happens on AWS instances while
>>> initializing ACPI SCI. mp_irqdomain_activate is accessing chip_data expecting
>>> ioapic data there. Oddly enough more recent kernels seem to do the same but not
>>> crashing as HVM guest (neither seen for our 4.15 nor the 5.4).
>>
>> Hmm, could it be that calling irq_set_chip_data() for a legacy irq is
>> a rather bad idea?
>>
>> Could you please try the attached patch (might need some backport, but
>> should be rather easy)?
> 
> Ok, I can confirm that adding your patch (minor backport to 4.4 attached) on top
> of the change to use chip_data generally, the HVM guest does come up
> successfully. Again, I was unable to figure out why this fixup is not needed in
> more recent kernels, but for 4.4.y it seems to be needed.

It seems to be more subtle in newer kernels. I have got another
report for newer kernels where only the floppy driver is showing
the problem.

Thanks for testing.


Juergen
