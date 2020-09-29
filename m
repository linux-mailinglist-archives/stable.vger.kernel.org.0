Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C446627D093
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgI2OFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:05:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:50164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgI2OFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 10:05:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601388330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ppx/XAwVJW65wcKTfoa9Qzd5LPd+RTKcJwjVlw+TwBw=;
        b=pE2I5pC3FsjPjV05BZGR6xqHgScqksuUYXJv21Ig3TK7YsSRWH87DeijmuLaRnwor6kDGx
        k5mbZQLUyhPCDw2kiooF3xDGKbuAu5wyuC3ftZ3E027F0rX7+rsqvlM3g0/xIlyJyzjHpR
        7U3D7Mw/dLyi5G5upOd2O38nsTFRAUM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 64666AC4D;
        Tue, 29 Sep 2020 14:05:30 +0000 (UTC)
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
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <15f140ef-cfd3-c3b7-9b8c-2a7ba3fab56a@suse.com>
Date:   Tue, 29 Sep 2020 16:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e958ff30-b7a9-9bd1-b483-542b6d117cc5@canonical.com>
Content-Type: multipart/mixed;
 boundary="------------28F51D861F4C99D5E2D3F176"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------28F51D861F4C99D5E2D3F176
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.09.20 15:13, Stefan Bader wrote:
> On 01.09.20 17:10, Greg Kroah-Hartman wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> commit c330fb1ddc0a922f044989492b7fcca77ee1db46 upstream.
>>
>> handler data is meant for interrupt handlers and not for storing irq chip
>> specific information as some devices require handler data to store internal
>> per interrupt information, e.g. pinctrl/GPIO chained interrupt handlers.
>>
>> This obviously creates a conflict of interests and crashes the machine
>> because the XEN pointer is overwritten by the driver pointer.
> 
> I cannot say whether this applies the same for the vanilla 4.4 stable kernels
> but once this had been applied to our 4.4 based kernels, we observed Xen HVM
> guests crashing on boot with:
> 
> [    0.927538] ACPI: bus type PCI registered
> [    0.936008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.948739] PCI: Using configuration type 1 for base access
> [    0.960007] PCI: Using configuration type 1 for extended access
> [    0.984340] ACPI: Added _OSI(Module Device)
> [    0.988010] ACPI: Added _OSI(Processor Device)
> [    0.992007] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.996013] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.002103] BUG: unable to handle kernel paging request at ffffffffff5f3000
> [    1.004000] IP: [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
> [    1.004000] PGD 1e0f067 PUD 1e11067 PMD 1e12067 PTE 0
> [    1.004000] Oops: 0002 [#1] SMP
> [    1.004000] Modules linked in:
> [    1.004000] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 4.4.0-191-generic
> #221-Ubuntu
> [    1.004000] Hardware name: Xen HVM domU, BIOS 4.6.5 04/18/2018
> [    1.004000] task: ffff880107db0000 ti: ffff880107dac000 task.ti: ffff880107dac000
> [    1.004000] RIP: 0010:[<ffffffff810592ff>]  [<ffffffff810592ff>]
> mp_irqdomain_activate+0x5f/0xa0
> [    1.004000] RSP: 0018:ffff880107dafc48  EFLAGS: 00010086
> [    1.004000] RAX: 0000000000000086 RBX: ffff8800eb852140 RCX: 0000000000000000
> [    1.004000] RDX: ffffffffff5f3000 RSI: 0000000000000001 RDI: 000000000020c000
> [    1.004000] RBP: ffff880107dafc50 R08: ffffffff81ebdfd0 R09: 00000000ffffffff
> [    1.004000] R10: 0000000000000011 R11: 0000000000000009 R12: ffff88010880d400
> [    1.004000] R13: 0000000000000001 R14: 0000000000000009 R15: ffff8800eb880080
> [    1.004000] FS:  0000000000000000(0000) GS:ffff880108ec0000(0000)
> knlGS:0000000000000000
> [    1.004000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.004000] CR2: ffffffffff5f3000 CR3: 0000000001e0a000 CR4: 00000000000006f0
> [    1.004000] Stack:
> [    1.004000]  ffff88010880bc58 ffff880107dafc70 ffffffff810ea644 ffff88010880bc00
> [    1.004000]  ffff88010880bc58 ffff880107dafca0 ffffffff810e6d88 ffffffff810e1009
> [    1.004000]  ffff88010880bc00 ffff88010880bca0 ffff8800eb880080 ffff880107dafd38
> [    1.004000] Call Trace:
> [    1.004000]  [<ffffffff810ea644>] irq_domain_activate_irq+0x44/0x50
> [    1.004000]  [<ffffffff810e6d88>] irq_startup+0x38/0x90
> [    1.004000]  [<ffffffff810e1009>] ? vprintk_default+0x29/0x40
> [    1.004000]  [<ffffffff810e55e2>] __setup_irq+0x5a2/0x650
> [    1.004000]  [<ffffffff811fc064>] ? kmem_cache_alloc_trace+0x1d4/0x1f0
> [    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
> [    1.004000]  [<ffffffff810e582b>] request_threaded_irq+0xfb/0x1a0
> [    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
> [    1.004000]  [<ffffffff814bf624>] ? acpi_ev_sci_dispatch+0x64/0x64
> [    1.004000]  [<ffffffff814a3f0a>] acpi_os_install_interrupt_handler+0xaa/0x100
> [    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
> [    1.004000]  [<ffffffff814bf689>] acpi_ev_install_sci_handler+0x23/0x25
> [    1.004000]  [<ffffffff814bcf03>] acpi_ev_install_xrupt_handlers+0x1c/0x6c
> [    1.004000]  [<ffffffff81fb3e9d>] acpi_enable_subsystem+0x8f/0x93
> [    1.004000]  [<ffffffff81fb276c>] acpi_init+0x8b/0x2c4
> [    1.004000]  [<ffffffff8141ee1e>] ? kasprintf+0x4e/0x70
> [    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
> [    1.004000]  [<ffffffff810021f5>] do_one_initcall+0xb5/0x200
> [    1.004000]  [<ffffffff810a6fda>] ? parse_args+0x29a/0x4a0
> [    1.004000]  [<ffffffff81f69152>] kernel_init_freeable+0x177/0x218
> [    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
> [    1.004000]  [<ffffffff8185dcfe>] kernel_init+0xe/0xe0
> [    1.004000]  [<ffffffff8186ae92>] ret_from_fork+0x42/0x80
> [    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
> [    1.004000] Code: 8d 1c d2 8d ba 0b 02 00 00 44 8d 51 11 42 8b 14 dd 74 ec 10
> 82 c1 e7 0c 48 63 ff 81 e2 ff 0f 00 00 48 81 ea 00 10 80 00 48 29 fa <44> 89 12
> 89 72 10 42 8b 14 dd 74 ec 10 82 83 c1 10 81 e2 ff 0f
> [    1.004000] RIP  [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
> [    1.004000]  RSP <ffff880107dafc48>
> [    1.004000] CR2: ffffffffff5f3000
> [    1.004000] ---[ end trace 3201cae5b6bd7be1 ]---
> [    1.592027] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
> [    1.592027]
> 
> This is from a local server but same stack-trace happens on AWS instances while
> initializing ACPI SCI. mp_irqdomain_activate is accessing chip_data expecting
> ioapic data there. Oddly enough more recent kernels seem to do the same but not
> crashing as HVM guest (neither seen for our 4.15 nor the 5.4).

Hmm, could it be that calling irq_set_chip_data() for a legacy irq is
a rather bad idea?

Could you please try the attached patch (might need some backport, but
should be rather easy)?


Juergen

--------------28F51D861F4C99D5E2D3F176
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-xen-events-don-t-use-chip_data-for-legacy-IRQs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xen-events-don-t-use-chip_data-for-legacy-IRQs.patch"

From 35b71ae9cc69cdd151cc3a4d587f67eb8d86007d Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Tue, 29 Sep 2020 15:47:21 +0200
Subject: [PATCH] xen/events: don't use chip_data for legacy IRQs

Storing Xen specific data via chip_data is fine, as long as this isn't
done for a legacy IRQ.

Use a local array for this purpose in case of legacy IRQs.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 90b8f56fbadb..6f02c18fa65c 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -92,6 +92,8 @@ static bool (*pirq_needs_eoi)(unsigned irq);
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
+static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
+
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
@@ -156,7 +158,18 @@ int get_evtchn_to_irq(evtchn_port_t evtchn)
 /* Get info for IRQ */
 struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_get_chip_data(irq);
+	if (irq < nr_legacy_irqs())
+		return legacy_info_ptrs[irq];
+	else
+		return irq_get_chip_data(irq);
+}
+
+static void set_info_for_irq(unsigned int irq, struct irq_info *info)
+{
+	if (irq < nr_legacy_irqs())
+		legacy_info_ptrs[irq] = info;
+	else
+		irq_set_chip_data(irq, info);
 }
 
 /* Constructors for packed IRQ information. */
@@ -377,7 +390,7 @@ static void xen_irq_init(unsigned irq)
 	info->type = IRQT_UNBOUND;
 	info->refcnt = -1;
 
-	irq_set_chip_data(irq, info);
+	set_info_for_irq(irq, info);
 
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -426,14 +439,14 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
 
 	list_del(&info->list);
 
-	irq_set_chip_data(irq, NULL);
+	set_info_for_irq(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
@@ -603,7 +616,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1108,7 +1121,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
@@ -1142,7 +1155,7 @@ int evtchn_make_refcounted(evtchn_port_t evtchn)
 	if (irq == -1)
 		return -ENOENT;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		return -ENOENT;
@@ -1170,7 +1183,7 @@ int evtchn_get(evtchn_port_t evtchn)
 	if (irq == -1)
 		goto done;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		goto done;
-- 
2.26.2


--------------28F51D861F4C99D5E2D3F176--
