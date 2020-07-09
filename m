Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19772198F5
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 09:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgGIHA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 03:00:58 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:46182 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgGIHA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 03:00:57 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id E4CD83C0582;
        Thu,  9 Jul 2020 09:00:52 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L_p_lQl1UCHK; Thu,  9 Jul 2020 09:00:45 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 655233C0588;
        Thu,  9 Jul 2020 09:00:28 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.15) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 9 Jul 2020
 09:00:27 +0200
Date:   Thu, 9 Jul 2020 09:00:23 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Qais Yousef <qais.yousef@arm.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 105/136] usb/ehci-platform: Set PM runtime as active
 on resume
Message-ID: <20200709070023.GA18414@lxhi-065.adit-jv.com>
References: <20200623195303.601828702@linuxfoundation.org>
 <20200623195308.955410923@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200623195308.955410923@linuxfoundation.org>
X-Originating-IP: [10.72.94.15]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everyone,

Cc: linux-renesas-soc
Cc: linux-pm

On Tue, Jun 23, 2020 at 09:59:21PM +0200, Greg Kroah-Hartman wrote:
> From: Qais Yousef <qais.yousef@arm.com>
> 
> [ Upstream commit 16bdc04cc98ab0c74392ceef2475ecc5e73fcf49 ]
> 
> Follow suit of ohci-platform.c and perform pm_runtime_set_active() on
> resume.
> 
> ohci-platform.c had a warning reported due to the missing
> pm_runtime_set_active() [1].
> 
> [1] https://lore.kernel.org/lkml/20200323143857.db5zphxhq4hz3hmd@e107158-lin.cambridge.arm.com/
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> CC: Tony Prisk <linux@prisktech.co.nz>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Mathias Nyman <mathias.nyman@intel.com>
> CC: Oliver Neukum <oneukum@suse.de>
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-usb@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Link: https://lore.kernel.org/r/20200518154931.6144-3-qais.yousef@arm.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/host/ehci-platform.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
> index f1908ea9fbd86..6fcd332880143 100644
> --- a/drivers/usb/host/ehci-platform.c
> +++ b/drivers/usb/host/ehci-platform.c
> @@ -390,6 +390,11 @@ static int ehci_platform_resume(struct device *dev)
>  	}
>  
>  	ehci_resume(hcd, priv->reset_on_resume);
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +
>  	return 0;

After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
Set PM runtime as active on resume") into downstream v4.14.x, we started
to consistently experience below panic [1] on every second s2ram of
R-Car H3 Salvator-X Renesas reference board.

After some investigations, we concluded the following:
 - the issue does not exist in vanilla v5.8-rc4+
 - [bisecting shows that] the panic on v4.14.186 is caused by the lack
   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
   link support"). Getting evidence for that is easy. Reverting
   987351e1ea7772 in vanilla leads to a similar backtrace [2].

Questions:
 - Backporting 987351e1ea7772 ("phy: core: Add consumer device
   link support") to v4.14.187 looks challenging enough, so probably not
   worth it. Anybody to contradict this?
 - Assuming no plans to backport the missing mainline commit to v4.14.x,
   should the following three v4.14.186 commits be reverted on v4.14.x?
   * baef809ea497a4 ("usb/ohci-platform: Fix a warning when hibernating")
   * 9f33eff4958885 ("usb/xhci-plat: Set PM runtime as active on resume")
   * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on resume")

[1] https://elinux.org/R-Car/Boards/Salvator-X#Suspend-to-RAM
root@rcar-gen3:~# cat s2ram.sh 
modprobe i2c-dev
echo 9 > /proc/sys/kernel/printk
i2cset -f -y 7 0x30 0x20 0x0F
echo 0 > /sys/module/suspend/parameters/pm_test_delay
echo core  > /sys/power/pm_test
echo deep > /sys/power/mem_sleep
echo 1 > /sys/power/pm_debug_messages
echo 0 > /sys/power/pm_print_times
echo mem > /sys/power/state;
root@rcar-gen3:~#
root@rcar-gen3:~# sh s2ram.sh 
[   65.853020] PM: suspend entry (deep)
[   65.858395] PM: Syncing filesystems ... done.
[   65.895890] PM: Preparing system for sleep (deep)
[   65.906272] Freezing user space processes ... (elapsed 0.004 seconds) done.
[   65.918350] OOM killer disabled.
[   65.921827] Freezing remaining freezable tasks ... (elapsed 0.005 seconds) done.
[   65.935063] PM: Suspending system (deep)
[   66.094910] PM: suspend of devices complete after 143.807 msecs
[   66.101282] PM: suspend devices took 0.162 seconds
[   66.133020] PM: late suspend of devices complete after 26.225 msecs
[   66.166806] PM: noirq suspend of devices complete after 24.050 msecs
[   66.173518] Disabling non-boot CPUs ...
[   66.199539] CPU1: shutdown
[   66.202563] psci: CPU1 killed (polled 0 ms)
[   66.230911] CPU2: shutdown
[   66.233923] psci: CPU2 killed (polled 0 ms)
[   66.261940] CPU3: shutdown
[   66.265351] psci: CPU3 killed (polled 0 ms)
[   66.300596] CPU4: shutdown
[   66.303837] psci: CPU4 killed (polled 0 ms)
[   66.340455] NOHZ: local_softirq_pending 202
[   66.346818] CPU5: shutdown
[   66.349811] psci: CPU5 killed (polled 0 ms)
[   66.388761] CPU6: shutdown
[   66.391732] psci: CPU6 killed (polled 0 ms)
[   66.442557] CPU7: shutdown
[   66.445659] psci: CPU7 killed (polled 0 ms)
[   66.452730] PM: suspend debug: Waiting for 0 second(s).
[   66.452730] PM: Timekeeping suspended for 0.005 seconds
[   66.452898] Enabling non-boot CPUs ...
[   66.470705] CPU1 is up
[   66.480825] CPU2 is up
[   66.491482] CPU3 is up
[   66.517818] CPU4 is up
[   66.537699] CPU5 is up
[   66.558622] CPU6 is up
[   66.580985] CPU7 is up
[   66.597724] PM: noirq resume of devices complete after 13.979 msecs
[   66.689793] PM: early resume of devices complete after 83.851 msecs
[   66.700577] Bad mode in Error handler detected on CPU3, code 0xbf000002 -- SError
[   66.700610] Bad mode in Error handler detected on CPU2, code 0xbf000002 -- SError
[   66.700687] Kernel panic - not syncing: bad mode
[   66.700709] CPU: 3 PID: 2689 Comm: kworker/u16:22 Tainted: G         C      4.14.187-ltsi+ #17
[   66.730293] Hardware name: Renesas Salvator-X board based on r8a7795 ES2.0+ (DT)
[   66.738028] Workqueue: events_unbound async_run_entry_fn
[   66.743598] Call trace:
[   66.746232]  dump_backtrace+0x0/0x348
[   66.750106]  show_stack+0x24/0x30
[   66.753618]  dump_stack+0x11c/0x18c
[   66.757311]  panic+0x2e4/0x5fc
[   66.760560]  bad_el0_sync+0x0/0x210
[   66.764375]  el1_error_invalid+0x7c/0x9c
[   66.768528]  rcar_gen3_phy_usb2_init+0xa8/0x228
[   66.773283]  phy_init+0xdc/0x15c
[   66.776701]  ehci_platform_power_on+0x1f4/0x43c
[   66.781443]  ehci_platform_resume+0x194/0x1d8
[   66.786014]  dpm_run_callback+0x754/0xe80
[   66.790232]  device_resume+0x194/0x3bc
[   66.794178]  async_resume+0x30/0x64
[   66.797855]  async_run_entry_fn+0x194/0x4f0
[   66.802244]  process_one_work+0xfe4/0x1b58
[   66.806544]  worker_thread+0x73c/0xaf0
[   66.810490]  kthread+0x3fc/0x414
[   66.813903]  ret_from_fork+0x10/0x18
[   66.817784] SMP: stopping secondary CPUs
[   67.843559] SMP: failed to stop secondary CPUs 2-3
[   67.848616] Kernel Offset: disabled
[   67.852599] CPU features: 0x1002004
[   67.856285] Memory Limit: none
[   67.859568] ---[ end Kernel panic - not syncing: bad mode ]---

[2] Same as [1], but on vanilla after reverting 987351e1ea7772 ("phy: core: Add consumer device link support")
root@rcar-gen3:~# sh s2ram.sh
[   23.028192] Filesystems sync: 0.000 seconds
[   23.033611] PM: Preparing system for sleep (deep)
[   23.040723] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   23.050170] OOM killer disabled.
[   23.054796] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   23.064901] PM: Suspending system (deep)
[   23.098442] PM: suspend of devices complete after 28.499 msecs
[   23.104324] PM: start suspend of devices complete after 35.478 msecs
[   23.110705] PM: suspend devices took 0.042 seconds
[   23.118196] PM: late suspend of devices complete after 2.673 msecs
[   23.126686] PM: noirq suspend of devices complete after 1.837 msecs
[   23.132982] Disabling non-boot CPUs ...
[   23.137756] CPU1: shutdown
[   23.140496] psci: CPU1 killed (polled 0 ms)
[   23.145860] CPU2: shutdown
[   23.148598] psci: CPU2 killed (polled 0 ms)
[   23.153920] CPU3: shutdown
[   23.156658] psci: CPU3 killed (polled 0 ms)
[   23.162406] CPU4: shutdown
[   23.165135] psci: CPU4 killed (polled 0 ms)
[   23.170701] CPU5: shutdown
[   23.173441] psci: CPU5 killed (polled 0 ms)
[   23.178930] CPU6: shutdown
[   23.181706] psci: CPU6 killed (polled 0 ms)
[   23.187070] CPU7: shutdown
[   23.189834] psci: CPU7 killed (polled 0 ms)
[   23.194490] PM: suspend debug: Waiting for 0 second(s).
[   23.194490] PM: Timekeeping suspended for 0.005 seconds
[   23.194515] Enabling non-boot CPUs ...
[   23.203786] Detected PIPT I-cache on CPU1
[   23.203837] CPU1: Booted secondary processor 0x0000000001 [0x411fd073]
[   23.204566] CPU1 is up
[   23.217725] Detected PIPT I-cache on CPU2
[   23.217756] CPU2: Booted secondary processor 0x0000000002 [0x411fd073]
[   23.218352] CPU2 is up
[   23.231469] Detected PIPT I-cache on CPU3
[   23.231496] CPU3: Booted secondary processor 0x0000000003 [0x411fd073]
[   23.232098] CPU3 is up
[   23.245257] Detected VIPT I-cache on CPU4
[   23.245315] CPU4: Booted secondary processor 0x0000000100 [0x410fd034]
[   23.246621] CPU4 is up
[   23.259744] Detected VIPT I-cache on CPU5
[   23.259782] CPU5: Booted secondary processor 0x0000000101 [0x410fd034]
[   23.261039] CPU5 is up
[   23.274141] Detected VIPT I-cache on CPU6
[   23.274180] CPU6: Booted secondary processor 0x0000000102 [0x410fd034]
[   23.275494] CPU6 is up
[   23.288598] Detected VIPT I-cache on CPU7
[   23.288639] CPU7: Booted secondary processor 0x0000000103 [0x410fd034]
[   23.289996] CPU7 is up
[   23.304324] PM: noirq resume of devices complete after 1.369 msecs
[   23.315803] PM: early resume of devices complete after 4.991 msecs
[   23.322623] Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
[   23.322680] SError Interrupt on CPU2, code 0xbf000002 -- SError
[   23.322682] CPU: 2 PID: 1032 Comm: kworker/u16:6 Not tainted 5.8.0-rc4-00075-g81e8773b8f41 #28
[   23.322684] Hardware name: Renesas Salvator-X board based on r8a77951 (DT)
[   23.322686] Workqueue: events_unbound async_run_entry_fn
[   23.322688] pstate: 40000005 (nZcv daif -PAN -UAO BTYPE=--)
[   23.322690] pc : ehci_readl.isra.13+0x8/0x20
[   23.322691] lr : ehci_resume+0x60/0x14c
[   23.322692] sp : ffff80001252bca0
[   23.322693] x29: ffff80001252bca0 x28: 0000000000000000
[   23.322696] x27: 0000000000000000 x26: 0000000000000000
[   23.322698] x25: 0000000000000000 x24: 0000000000000010
[   23.322701] x23: ffff800010d79000 x22: 0000000000000000
[   23.322704] x21: ffff0006f917f324 x20: ffff0006f917f000
[   23.322706] x19: ffff0006f917f250 x18: 000000000000000a
[   23.322709] x17: 0000000000000000 x16: 0000000000000000
[   23.322712] x15: 0000000000000000 x14: 0000000000000000
[   23.322714] x13: 0000000400000000 x12: 0000000000000001
[   23.322717] x11: 0000000000000001 x10: 0000000000000a60
[   23.322719] x9 : ffff80001252bab0 x8 : ffff0006f92045c0
[   23.322722] x7 : ffff80001252bc70 x6 : 0000000000000000
[   23.322724] x5 : ffff0006fa610848 x4 : 0000000000000000
[   23.322727] x3 : 0000000000000000 x2 : 0000000000000001
[   23.322730] x1 : ffff0006f917f138 x0 : 0000000000000000
[   23.322733] Kernel panic - not syncing: Asynchronous SError Interrupt
[   23.460158] Modules linked in:
[   23.463225] CPU: 5 PID: 2116 Comm: kworker/u16:12 Not tainted 5.8.0-rc4-00075-g81e8773b8f41 #28
[   23.471946] Hardware name: Renesas Salvator-X board based on r8a77951 (DT)
[   23.478844] Workqueue: events_unbound async_run_entry_fn
[   23.484172] pstate: 40000005 (nZcv daif -PAN -UAO BTYPE=--)
[   23.489760] pc : ehci_readl.isra.13+0x4/0x20
[   23.494041] lr : ehci_resume+0x60/0x14c
[   23.497885] sp : ffff800012da3ca0
[   23.501206] x29: ffff800012da3ca0 x28: 0000000000000000
[   23.506532] x27: 0000000000000000 x26: 0000000000000000
[   23.511858] x25: 0000000000000000 x24: 0000000000000010
[   23.517184] x23: ffff800010d79000 x22: 0000000000000000
[   23.522510] x21: ffff0006f9f4cb24 x20: ffff0006f9f4c800
[   23.527835] x19: ffff0006f9f4ca50 x18: fffffe001bc4e708
[   23.533162] x17: 0000000000000000 x16: 0000000000000000
[   23.538487] x15: 0000000000000001 x14: 0000000000000000
[   23.543814] x13: 0000000100000000 x12: 0000000000000001
[   23.549139] x11: 0000000000000001 x10: 0000000000000a60
[   23.554465] x9 : ffff800012da3ab0 x8 : ffff0006faeba840
[   23.559791] x7 : ffff800012da3c70 x6 : 0000000000000000
[   23.565117] x5 : ffff0006fa610c48 x4 : 0000000000000000
[   23.570443] x3 : 0000000000000000 x2 : 0000000000000001
[   23.575768] x1 : ffff0006f9f4c938 x0 : ffff800010f6d160
[   23.581096] Call trace:
[   23.583549]  ehci_readl.isra.13+0x4/0x20
[   23.587484]  ehci_platform_resume+0x48/0xb8
[   23.591681]  dpm_run_callback+0x68/0xdc
[   23.595527]  device_resume+0xcc/0x180
[   23.599199]  async_resume+0x28/0x5c
[   23.602696]  async_run_entry_fn+0x50/0x14c
[   23.606808]  process_one_work+0x1dc/0x2b4
[   23.610829]  worker_thread+0x1d0/0x260
[   23.614590]  kthread+0xf0/0x100
[   23.617743]  ret_from_fork+0x10/0x30
[   23.621331] Code: d65f03c0 52808000 17fffffd d503233f (b9400000)
[   23.627441] ---[ end trace f663646e2a9dfb92 ]---
[   23.632072] Internal error: synchronous external abort: 96000210 [#2] PREEMPT SMP
[   23.639576] Modules linked in:
[   23.642642] CPU: 7 PID: 2112 Comm: kworker/u16:8 Tainted: G      D           5.8.0-rc4-00075-g81e8773b8f41 #28
[   23.652668] Hardware name: Renesas Salvator-X board based on r8a77951 (DT)
[   23.659563] Workqueue: events_unbound async_run_entry_fn
[   23.664890] pstate: 40000005 (nZcv daif -PAN -UAO BTYPE=--)
[   23.670477] pc : ehci_readl.isra.13+0x4/0x20
[   23.674758] lr : ehci_resume+0x60/0x14c
[   23.678601] sp : ffff800012d83ca0
[   23.681922] x29: ffff800012d83ca0 x28: 0000000000000000
[   23.687249] x27: 0000000000000000 x26: 0000000000000000
[   23.692574] x25: 0000000000000000 x24: 0000000000000010
[   23.697900] x23: ffff800010d79000 x22: 0000000000000000
[   23.703226] x21: ffff0006f9f4db24 x20: ffff0006f9f4d800
[   23.708552] x19: ffff0006f9f4da50 x18: 000000000000000a
[   23.713878] x17: 0000000000000000 x16: 0000000000000000
[   23.719203] x15: 000000000000000d x14: ffff80001103be18
[   23.724529] x13: ffffffffffffffff x12: 0000000000000000
[   23.729855] x11: 0000000000000000 x10: 0000000000000a60
[   23.735181] x9 : ffff800012d83ab0 x8 : ffff0006faeb9980
[   23.740507] x7 : ffff800012d83c70 x6 : 0000000000000000
[   23.745833] x5 : ffff0006fa611048 x4 : 0000000000000000
[   23.751159] x3 : 0000000000000000 x2 : 0000000000000001
[   23.756484] x1 : ffff0006f9f4d938 x0 : ffff800010f8d160
[   23.761810] Call trace:
[   23.764263]  ehci_readl.isra.13+0x4/0x20
[   23.768197]  ehci_platform_resume+0x48/0xb8
[   23.772391]  dpm_run_callback+0x68/0xdc
[   23.776237]  device_resume+0xcc/0x180
[   23.779908]  async_resume+0x28/0x5c
[   23.783406]  async_run_entry_fn+0x50/0x14c
[   23.787513]  process_one_work+0x1dc/0x2b4
[   23.791534]  worker_thread+0x1d0/0x260
[   23.795292]  kthread+0xf0/0x100
[   23.798442]  ret_from_fork+0x10/0x30
[   23.802028] Code: d65f03c0 52808000 17fffffd d503233f (b9400000)
[   23.808137] ---[ end trace f663646e2a9dfb93 ]---
[   23.812773] SMP: stopping secondary CPUs
[   23.812774] Kernel Offset: disabled
[   23.812775] CPU features: 0x040022,20006004
[   23.812777] Memory Limit: none

-- 
Best regards,
Eugeniu Rosca
