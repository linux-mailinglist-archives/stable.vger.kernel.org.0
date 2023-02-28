Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED936A54DA
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 09:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjB1IyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 03:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjB1Ix6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 03:53:58 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE3BAE;
        Tue, 28 Feb 2023 00:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677574424; x=1709110424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CgL5Fcr6YGnyPCpy5htzDGKDt3Ojypa0NvHwLK41CjU=;
  b=c64VYPy/Pxuk4PwBvBfLyBJbEAHaEbzCbRZ5XlUliDjVGeYjQB7NoczZ
   bIVks9WkDPXpOlOaim6Ve/6OTPYOlvmh6WWw4RhAHM0ekOWygPRxomM1s
   lteUVsi38YSak1WJk2sE5gnp4IqRmJPCQ0wJGEHtsT5Jx7qnfhc/TFhzW
   k=;
X-IronPort-AV: E=Sophos;i="5.98,221,1673913600"; 
   d="scan'208";a="301815546"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:53:43 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id C3BD285F7A;
        Tue, 28 Feb 2023 08:53:40 +0000 (UTC)
Received: from EX19D010UWA004.ant.amazon.com (10.13.138.204) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 28 Feb 2023 08:53:40 +0000
Received: from u9aa42af9e4c55a.ant.amazon.com (10.106.100.8) by
 EX19D010UWA004.ant.amazon.com (10.13.138.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 28 Feb 2023 08:53:38 +0000
From:   Munehisa Kamata <kamatam@amazon.com>
To:     <u.kleine-koenig@pengutronix.de>
CC:     <kamatam@amazon.com>, <khilman@baylibre.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        <neil.armstrong@linaro.org>, <stable@vger.kernel.org>,
        <thierry.reding@gmail.com>
Subject: Re: [PATCH] pwm: core: Zero-initialize the temp state
Date:   Tue, 28 Feb 2023 00:53:28 -0800
Message-ID: <20230228085328.909555-1-kamatam@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227091621.ocxwbb6f7z5vysvx@pengutronix.de>
References: <20230227091621.ocxwbb6f7z5vysvx@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.8]
X-ClientProxiedBy: EX19D046UWB003.ant.amazon.com (10.13.139.174) To
 EX19D010UWA004.ant.amazon.com (10.13.138.204)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On Mon, 2023-02-27 09:16:21 +0000, Uwe Kleine-König wrote:
>
> Hello,
> 
> On Sun, Feb 26, 2023 at 06:48:30PM -0800, Munehisa Kamata wrote:
> > On Sun, 2023-02-26 09:17:52 +0000, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> > > > Zero-initialize the on-stack structure to avoid unexpected behaviors. Some
> > > > drivers may not set or initialize all the values in pwm_state through their
> > > > .get_state() callback and therefore some random values may remain there and
> > > > be set into pwm->state eventually.
> > > > 
> > > > This actually caused regression on ODROID-N2+ as reported in [1]; kernel
> > > > fails to boot due to random panic or hang-up.
> > > > 
> > > > [1] https://forum.odroid.com/viewtopic.php?f=177&t=46360
> > > 
> > > Looking through the report I wonder what actually made the machine fail
> > > to boot. Doesn't this paper over a problem that should be fixed (also)
> > > somewhere else?
> > 
> > Yes, you're right and I think the commit message could have described more
> > details. This patch is for ensuring all drivers see zeroed state same as
> > before, but I still don't fully understand how it ends up such random-ish
> > crashes. There could be another or bigger problem that should be fixed.
> > 
> > > Which driver is the one that the problem occur for?
> > 
> > It's pwm-meson and seems to be caused by random polarity value somehow. If
> > meson_pwm_get_state() sets polarity to zero instead, I don't see the
> > problem. According the comment, looks like the driver does not set polarity
> > by design.
> > 
> >  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/pwm/pwm-meson.c?h=v6.2&id=c9c3395d5e3dcc6daee66c6908354d47bf98cb0c#n9
> > 
> > Before commit c73a3107624d, the memory was kcalloc'ed and always zeroed,
> > but I don't know if the driver was (is) assuming that. I'm adding Meson SoC
> > people to CC.
> > 
> > Apart from how polarity should be handled in the driver, I'm very puzzled
> > by the crashes I've observed so far. There seems to be some patterns, but
> > they don't seem obviously related to PWM.
> > 
> > [    1.360542] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40:2) Detected
> > [    1.363906] Insufficient stack space to handle exception!
> > [    1.363913] ESR: 0x0000000096000047 -- DABT (current EL)
> > [    1.363917] FAR: 0xffff800009a47ff0
> > [    1.363920] Task stack:     [0xffff800009a48000..0xffff800009a4c000]
> > [    1.363923] IRQ stack:      [0xffff8000099a8000..0xffff8000099ac000]
> > [    1.363927] Overflow stack: [0xffff000077b76100..0xffff000077b77100]
> > [    1.363931] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.2.0-odroid-arm64 #47
> > [    1.363938] Hardware name: Hardkernel ODROID-N2Plus (DT)
> > [    1.363941] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [    1.363947] pc : __do_kernel_fault+0x4/0x180
> > [    1.363961] lr : do_page_fault+0xd0/0x3d0
> > [    1.363968] sp : ffff800009a48020
> > [    1.363970] x29: ffff800009a48020 x28: ffff000002948000 x27: 0000000000000000
> > [    1.363980] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> > [    1.363987] x23: 0000000096000004 x22: ffff800009a48110 x21: 00000000ffffffff
> > [    1.363994] x20: ffff800009a48110 x19: 00000000ffffffff x18: 000000000000001c
> > [    1.364001] x17: 00000000863047f6 x16: ffff800009860a80 x15: 0000000000000003
> > [    1.364008] x14: 00000000000003ef x13: 0000000000000000 x12: 0000000000000279
> > [    1.364015] x11: 0000000000000001 x10: 0000000000000001 x9 : 0000000000000400
> > [    1.364021] x8 : ffff000077b7fc40 x7 : ffff000077b7fbc0 x6 : ffff8000094f7990
> > [    1.364028] x5 : 0000000000000000 x4 : ffff000002948000 x3 : 0001000000000000
> > [    1.364035] x2 : ffff800009a48110 x1 : 0000000096000004 x0 : 00000000ffffffff
> > [    1.364043] Kernel panic - not syncing: kernel stack overflow
> > [    1.364047] SMP: stopping secondary CPUs
> > 
> > Another example:
> > 
> > [    1.360997] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40:2) Detected
> > [    1.364333] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> > [    1.364435] Unable to handle kernel paging request at virtual address 0000000008003388
> > [    1.367470] Internal error: Oops - Undefined instruction: 0000000002000000 [#1] PREEMPT SMP
> > [    1.367483] Modules linked in:
> > [    1.367490] CPU: 2 PID: 66 Comm: kworker/u12:1 Not tainted 6.2.0-odroid-arm64 #47
> > [    1.367498] Hardware name: Hardkernel ODROID-N2Plus (DT)
> > [    1.367502] Workqueue: events_unbound async_run_entry_fn
> > [    1.367516] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [    1.367523] pc : arch_timer_handler_phys+0x0/0x44
> > [    1.367535] lr : handle_percpu_devid_irq+0x84/0x140
> > [    1.367543] sp : ffff8000099abf70
> > [    1.367546] x29: ffff8000099abf70 x28: ffff000002a40000 x27: 0000000000000006
> > [    1.367556] x26: ffff800009d208a4 x25: ffff800009d20b44 x24: 0000000000000008
> > [    1.367565] x23: ffff8000094f8b50 x22: 000000000000000b x21: ffff000002829000
> > [    1.367573] x20: ffff800008f89fb0 x19: ffff00000282a600 x18: ffff0000021792e8
> > [    1.367581] x17: ffff80006e685000 x16: ffff8000099ac000 x15: 0000000000004000
> > [    1.367589] x14: ffff800009d27bde x13: ffff800009d2887b x12: 0000000000000308
> > [    1.367597] x11: 0000000000000a92 x10: 0000000000000068 x9 : ef01a5948f440b31
> > [    1.367606] x8 : 0000000000003273 x7 : ffff800009d262a8 x6 : 000000003754d375
> > [    1.367614] x5 : ffff80006e685000 x4 : ffff8000099abf70 x3 : ffff80006e685000
> > [    1.367622] x2 : ffff800008c26c30 x1 : ffff000077b83a00 x0 : 000000000000000b
> > [    1.367630] Call trace:
> > [    1.367633]  arch_timer_handler_phys+0x0/0x44
> > [    1.367641]  generic_handle_domain_irq+0x2c/0x44
> > [    1.367650]  gic_handle_irq+0x44/0xc4
> > [    1.367659]  call_on_irq_stack+0x2c/0x5c
> > [    1.367666]  do_interrupt_handler+0x80/0x84
> > [    1.367672]  el1_interrupt+0x34/0x70
> > [    1.367682]  el1h_64_irq_handler+0x18/0x2c
> > [    1.367686]  el1h_64_irq+0x64/0x68
> > [    1.367690]  HUF_decompress4X1_usingDTable_internal_default+0x2fc/0xd60
> > [    1.367702]  HUF_decompress4X_hufOnly_wksp_bmi2+0xec/0x140
> > [    1.367711]  ZSTD_decodeLiteralsBlock+0x580/0x630
> > [    1.367717]  ZSTD_decompressBlock_internal.part.0+0x5c/0x1b4
> > [    1.367723]  ZSTD_decompressBlock_internal+0x1c/0x30
> > [    1.367729]  ZSTD_decompressContinue.part.0+0x364/0x444
> > [    1.367734]  ZSTD_decompressContinueStream+0x98/0x180
> > [    1.367738]  ZSTD_decompressStream+0x5b0/0x8c0
> > [    1.367743]  zstd_decompress_stream+0x10/0x20
> > [    1.367751]  unzstd+0x290/0x37c
> > [    1.367760]  unpack_to_rootfs+0x174/0x298
> > [    1.367767]  do_populate_rootfs+0x84/0x1dc
> > [    1.367773]  async_run_entry_fn+0x34/0x150
> > [    1.367778]  process_one_work+0x1d0/0x320
> > [    1.367785]  worker_thread+0x14c/0x444
> > 
> > Perhaps, the driver or the PWM core could do something wrong based on the
> > invalid polarity and corrupt certain memory location, but I'm still not
> > able to relate the random value to these crashes.
> 
> I can imagine that the compiler creates code (a jump table) that relies
> on .polarity being either PWM_POLARITY_NORMAL or PWM_POLARITY_INVERSED
> and that exibits UB if that isn't true. (I think the compiler is allowed
> to do that.)
> 
> Looking at the driver, there are several problems:
> 
>  - The driver does just
> 
>    	if (state->polarity == PWM_POLARITY_INVERSED)
>    		duty = period - duty;
> 
>    which is broken because each period is supposed to start with the
>    active part. (You could argue this being ridiculous and I'd agree.
>    But that's what we have and just doing it differently in a driver is
>    wrong.) The fix is to check if the hardware actually emits normal or
>    inversed polarity and refuse the other one. Then in .get_state() set
>    the appropriate polarity.

Looking at the comment in the source, I'm not sure if such checking is 
possible with this hardware.

From pwm-meson.c:
 * The hardware has no "polarity" setting. This driver reverses the period
 * cycles (the low length is inverted with the high length) for
 * PWM_POLARITY_INVERSED. This means that .get_state cannot read the polarity
 * from the hardware.

As far as I see, there seems to be some drivers that hard-code polarity in
.get_state() without getting it from hardware. Perhaps, we could do that
instead? Honestly, I don't understand how it's a bad idea here.

>  - In meson_pwm_calc() we have:
> 
>    	unsigned int duty, ...;
>    
>    	duty = state->duty_cycle;
> 
>    which is wrong for state->duty_cycle > U32_MAX. The same for period.
> 
>  - After period is fixed to be proper u64, fin_freq * (u64)period might
>    overflow.
> 
>  - harmless: The check
> 
>    	duty_cnt = div64_u64(fin_freq * (u64)duty,
>    			     NSEC_PER_SEC * (pre_div + 1));
>    	if (duty_cnt > 0xffff)
>    		...
> 
>    never triggers, as duty <= period (after fixing the first issue) and
>    we already know that
> 
>    	div64_u64(fin_freq * (u64)period, NSEC_PER_SEC * (pre_div + 1)) <= 0xffff.

Ah, I believe this requires a separate fix.


Regards,
Munehisa
