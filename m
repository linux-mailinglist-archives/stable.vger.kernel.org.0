Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67C2CD347
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 11:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgLCKRo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 3 Dec 2020 05:17:44 -0500
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:36668 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLCKRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 05:17:44 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2020 05:17:42 EST
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id AF4C944C5A;
        Thu,  3 Dec 2020 11:10:10 +0100 (CET)
To:     dan.carpenter@oracle.com
Cc:     James.Bottomley@suse.de,
        jayamohank@HDRedirect-LB5-1afb6e2973825a56.elb.us-east-1.amazonaws.com,
        jejb@linux.ibm.com, jitendra.bhivare@broadcom.com,
        kernel-janitors@vger.kernel.org, ketan.mukadam@broadcom.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, subbu.seetharaman@broadcom.com,
        stable@vger.kernel.org
References: <20200928091300.GD377727@mwanda>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: Re: [PATCH] scsi: be2iscsi: Fix a theoretical leak in
 beiscsi_create_eqs()
Message-ID: <54f36c62-10bf-8736-39ce-27ece097d9de@proxmox.com>
Date:   Thu, 3 Dec 2020 11:10:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20200928091300.GD377727@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The be_fill_queue() function can only fail when "eq_vaddress" is NULL
> and since it's non-NULL here that means the function call can't fail.
> But imagine if it could, then in that situation we would want to store
> the "paddr" so that dma memory can be released.
> 
> Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This came in here through the stable 5.4 tree with v5.4.74, and we have some
users of ours report that it results in kernel oopses and delayed boot on their
HP DL 380 Gen 9 (and other Gen 9, FWICT) servers:

> systemd-udevd   D    0   501      1 0x80000000
> Call Trace:
>  __schedule+0x2e6/0x6f0
>  schedule+0x33/0xa0
>  schedule_timeout+0x205/0x330
>  wait_for_completion+0xb7/0x140
>  ? wake_up_q+0x80/0x80
>  __flush_work+0x131/0x1e0
>  ? worker_detach_from_pool+0xb0/0xb0
>  work_on_cpu+0x6d/0x90
>  ? workqueue_congested+0x80/0x80
>  ? pci_device_shutdown+0x60/0x60
>  pci_device_probe+0x190/0x1b0
>  really_probe+0x1c8/0x3e0
>  driver_probe_device+0xbb/0x100
>  device_driver_attach+0x58/0x60
>  __driver_attach+0x8f/0x150
>  ? device_driver_attach+0x60/0x60
>  bus_for_each_dev+0x79/0xc0
>  ? kmem_cache_alloc_trace+0x1a0/0x230
>  driver_attach+0x1e/0x20
>  bus_add_driver+0x154/0x1f0
>  ? 0xffffffffc0453000
>  driver_register+0x70/0xc0
>  ? 0xffffffffc0453000
>  __pci_register_driver+0x57/0x60
>  beiscsi_module_init+0x62/0x1000 [be2iscsi]
>  do_one_initcall+0x4a/0x1fa
>  ? _cond_resched+0x19/0x30
>  ? kmem_cache_alloc_trace+0x1a0/0x230
>  do_init_module+0x60/0x230
>  load_module+0x231b/0x2590
>  __do_sys_finit_module+0xbd/0x120
>  ? __do_sys_finit_module+0xbd/0x120
>  __x64_sys_finit_module+0x1a/0x20
>  do_syscall_64+0x57/0x190
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f00aca06f59
> Code: Bad RIP value.
> RSP: 002b:00007ffc14380858 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 0000558c726262e0 RCX: 00007f00aca06f59
> RDX: 0000000000000000 RSI: 00007f00ac90bcad RDI: 000000000000000e
> RBP: 00007f00ac90bcad R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000000e R11: 0000000000000246 R12: 0000000000000000
> R13: 0000558c725f6030 R14: 0000000000020000 R15: 0000558c726262e0

Blacklisting the be2iscsi module or reverting this commit helps, I did not get
around to look further into the mechanics at play and figured you would be
faster at that, or that this info at least helps someone else when searching
for the same symptoms.

cheers,
Thomas


