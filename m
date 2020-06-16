Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF121FA9D7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 09:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgFPHS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 03:18:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:44798 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgFPHS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 03:18:58 -0400
IronPort-SDR: ufttPVRZyfAtwhVR265FFYZwyD483xdyHncEsc7BGXmpaSCQT5z8XlHDfFClcjJtM2V/zrkf/4
 rjQLydH2dMLA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 00:18:57 -0700
IronPort-SDR: PdWgL7kX8wCup7bkSHNhA2FwrbjZ8HbS5hkR6vc3b195KormAP4KBp1sVQ0hQr2gcL3zmj1axL
 IVcEdM/WXJNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="420670451"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004.jf.intel.com with ESMTP; 16 Jun 2020 00:18:55 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jl5s1-00DmDD-Vf; Tue, 16 Jun 2020 10:18:57 +0300
Date:   Tue, 16 Jun 2020 10:18:57 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: patch "serial: imx: Initialize lock for non-registered console"
 added to tty-next
Message-ID: <20200616071857.GL2428291@smile.fi.intel.com>
References: <159065034721114@kroah.com>
 <CA+G9fYtSmkcCAeKVzUj3B5Yj3ZZw-wiMyQAMwqUOSyiPRB2Byg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtSmkcCAeKVzUj3B5Yj3ZZw-wiMyQAMwqUOSyiPRB2Byg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 11:45:18AM +0530, Naresh Kamboju wrote:
> On Thu, 28 May 2020 at 12:49, <gregkh@linuxfoundation.org> wrote:
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     serial: imx: Initialize lock for non-registered console
> >
> > to my tty git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > in the tty-next branch.
> >
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> >
> > The patch will also be merged in the next major kernel release
> > during the merge window.
> >
> > If you have any questions about this process, please let me know.
> >
> >
> > From 8f065acec7573672dd15916e31d1e9b2e785566c Mon Sep 17 00:00:00 2001
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Date: Mon, 25 May 2020 13:59:52 +0300
> > Subject: serial: imx: Initialize lock for non-registered console
> >
> > The commit a3cb39d258ef
> > ("serial: core: Allow detach and attach serial device for console")
> > changed a bit logic behind lock initialization since for most of the console
> > driver it's supposed to have lock already initialized even if console is not
> > enabled. However, it's not the case for Freescale IMX console.
> >
> > Initialize lock explicitly in the ->probe().
> >
> > Note, there is still an open question should or shouldn't not this driver
> > register console properly.
> >
> > Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/tty/serial/imx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> > index 986d902fb7fe..6b078e395931 100644
> > --- a/drivers/tty/serial/imx.c
> > +++ b/drivers/tty/serial/imx.c
> > @@ -2404,6 +2404,9 @@ static int imx_uart_probe(struct platform_device *pdev)
> >                 }
> >         }
> >
> > +       /* We need to initialize lock even for non-registered console */
> > +       spin_lock_init(&sport->port.lock);
> 
> On arm64 Hikey devices running stable-rc 5.7 branch kernel reported following
> kernel INFO while booting.

Does backporting (applying)

8508f4cba308 ("serial: amba-pl011: Make sure we initialize the port.lock spinlock")

fix the issue?

> 
> [    2.059344] mmc2: new SDIO card at address 0001
> [    2.105114] f7111000.uart: ttyAMA1 at MMIO 0xf7111000 (irq = 8,
> base_baud = 0) is a PL011 rev2
> [    2.105886] serial serial0: tty port ttyAMA1 registered
> [    2.106843] f7112000.uart: ttyAMA2 at MMIO 0xf7112000 (irq = 9,
> base_baud = 0) is a PL011 rev2
> [    2.109759] f7113000.uart: ttyAMA3 at MMIO 0xf7113000 (irq = 10,
> base_baud = 0) is a PL011 rev2
> [    2.109916] INFO: trying to register non-static key.
> [    2.109936] the code is fine but needs lockdep annotation.
> [    2.109956] turning off the locking correctness validator.
> [    2.109982] CPU: 2 PID: 57 Comm: kworker/2:1 Not tainted 5.7.3-rc1 #1
> [    2.110004] Hardware name: HiKey Development Board (DT)
> [    2.110040] Workqueue: events deferred_probe_work_func
> [    2.110063] Call trace:
> [    2.110082]  dump_backtrace+0x0/0x1e0
> [    2.110100]  show_stack+0x24/0x30
> [    2.110120]  dump_stack+0xe8/0x150
> [    2.110140]  register_lock_class+0x640/0x680
> [    2.110159]  __lock_acquire+0x7c/0x1728
> [    2.110178]  lock_acquire+0xf8/0x458
> [    2.110200]  _raw_spin_lock_irqsave+0x60/0x80
> [    2.110221]  uart_add_one_port+0x3ac/0x4e8
> [    2.110242]  pl011_register_port+0x70/0xd8
> [    2.110262]  pl011_probe+0x154/0x1a0
> [    2.110283]  amba_probe+0xcc/0x170
> [    2.110301]  really_probe+0x290/0x498
> [    2.110319]  driver_probe_device+0x12c/0x148
> [    2.110339]  __device_attach_driver+0xa4/0x120
> [    2.110359]  bus_for_each_drv+0x78/0xd8
> [    2.110378]  __device_attach+0xe8/0x170
> [    2.110397]  device_initial_probe+0x24/0x30
> [    2.110416]  bus_probe_device+0xa0/0xa8
> [    2.110435]  deferred_probe_work_func+0x94/0xf0
> [    2.110458]  process_one_work+0x2b0/0x770
> [    2.110477]  worker_thread+0x48/0x4a0
> [    2.110496]  kthread+0x158/0x168
> [    2.110515]  ret_from_fork+0x10/0x18
> [    4.158216] printk: console [ttyAMA3] enabled
> [    4.165009] 5V_HUB: supplied by SYS_5V
> 
> Please refer full test log,
> https://lkft.validation.linaro.org/scheduler/job/1496830#L3764
> 
> 
> metadata:
>   git branch: linux-5.7.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: f2c964aa9a1ce76f00767fd3fdcebf8e0db2b99e
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-stable-rc-5.7/6/config
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

-- 
With Best Regards,
Andy Shevchenko


