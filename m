Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C379B58D3BE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 08:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiHIG2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 02:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiHIG2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 02:28:40 -0400
Received: from mail.thorsis.com (mail.thorsis.com [92.198.35.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3895B1FCF7;
        Mon,  8 Aug 2022 23:28:38 -0700 (PDT)
Date:   Tue, 9 Aug 2022 08:28:29 +0200
From:   Alexander Dahl <ada@thorsis.com>
To:     linux-mtd@lists.infradead.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peda@axentia.se, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bbrezillon@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Message-ID: <6569588.q2PsfMjIKe@ada>
Mail-Followup-To: linux-mtd@lists.infradead.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peda@axentia.se, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bbrezillon@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
 <2099405.mp5hVA6q5l@ada>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2099405.mp5hVA6q5l@ada>
X-KMail-Identity: 600738659
X-KMail-Transport: 2015100914
X-KMail-Link-Message: 6877017
X-KMail-Link-Type: reply
X-KMail-Identity-Name: Alexander Dahl (thorsis, en)
X-KMail-Transport-Name: thorsis.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Am Freitag, 29. Juli 2022, 12:59:55 CEST schrieb Alexander Dahl:
> Hello Tudor,
> 
> Am Donnerstag, 28. Juli 2022, 09:40:14 CEST schrieb Tudor Ambarus:
> > Every dma_map_single() call should have its dma_unmap_single()
> > counterpart,
> > because the DMA address space is a shared resource and one could render
> > the
> > machine unusable by consuming all DMA addresses.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> > Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> > ---
> > 
> >  drivers/mtd/nand/raw/atmel/nand-controller.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c
> > b/drivers/mtd/nand/raw/atmel/nand-controller.c index
> > 6ef14442c71a..330d2dafdd2d 100644
> > --- a/drivers/mtd/nand/raw/atmel/nand-controller.c
> > +++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
> > @@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct
> > atmel_nand_controller *nc,
> > 
> >  	dma_async_issue_pending(nc->dmac);
> >  	wait_for_completion(&finished);
> > 
> > +	dma_unmap_single(nc->dev, buf_dma, len, dir);
> > 
> >  	return 0;
> 
> Acked-by: Alexander Dahl <ada@thorsis.com>
> 
> After studying
> https://www.kernel.org/doc/html/latest/core-api/dma-api-howto.html
> this seems like the correct thing to do to me.
> 
> I was made aware of this patch in IRC, after discussing a strange lzo
> decompression and/or page reading error with Richard after upgrading from
> kernel v5.2.21-rt13 to v5.15.49-rt47.
> 
> Now testing this on top of 5.15.49-rt47 on two boards, both with Microchip
> sama5d27c 128MiB SiP and Spansion S34ML02G1 raw nand flash. Will report
> later.

After almost two weeks of running three or four of those boards with
different loads including that patch we had not a single occurance
anymore of the issue I reported on IRC earlier (kernel log below, the
error happened in late boot when userspace daemons were started).
So I'm confident to give my tested-by:

Tested-by: Alexander Dahl <ada@thorsis.com>

[Fri Jul 29 09:36:48 2022] Memory: 121108K/131072K available (5120K kernel code, 397K rwdata, 1080K rodata, 1024K init, 90K bss, 9964K reserved, 0K cma-reserved)
[Fri Jul 29 09:36:48 2022] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[Fri Jul 29 09:36:48 2022] trace event string verifier disabled
[Fri Jul 29 09:36:48 2022] rcu: Preemptible hierarchical RCU implementation.
[Fri Jul 29 09:36:48 2022] rcu:         RCU priority boosting: priority 1 delay 500 ms.
[Fri Jul 29 09:36:48 2022] rcu:         RCU_SOFTIRQ processing moved to rcuc kthreads.
[Fri Jul 29 09:36:48 2022]      No expedited grace period (rcu_normal_after_boot).
[Fri Jul 29 09:36:48 2022]      Trampoline variant of Tasks RCU enabled.
[Fri Jul 29 09:36:48 2022] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[Fri Jul 29 09:36:48 2022] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[Fri Jul 29 09:36:48 2022] L2C-310 ID prefetch enabled, offset 2 lines
[Fri Jul 29 09:36:48 2022] L2C-310 dynamic clock gating enabled, standby mode enabled
[Fri Jul 29 09:36:48 2022] L2C-310 cache controller enabled, 8 ways, 128 kB
[Fri Jul 29 09:36:48 2022] L2C-310: CACHE_ID 0x410000c9, AUX_CTRL 0x36020000
[Fri Jul 29 09:36:48 2022] clocksource: timer@f800c000: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 186464433812 ns
[Fri Jul 29 09:36:48 2022] sched_clock: 32 bits at 10MHz, resolution 97ns, wraps every 209510599631ns
[Fri Jul 29 09:36:48 2022] Switching to timer-based delay loop, resolution 97ns
[Fri Jul 29 09:36:48 2022] Console: colour dummy device 80x30
[Fri Jul 29 09:36:48 2022] Calibrating delay loop (skipped), value calculated using timer frequency.. 20.50 BogoMIPS (lpj=102500)
[Fri Jul 29 09:36:48 2022] pid_max: default: 32768 minimum: 301
[Fri Jul 29 09:36:48 2022] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[Fri Jul 29 09:36:48 2022] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[Fri Jul 29 09:36:48 2022] CPU: Testing write buffer coherency: ok
[Fri Jul 29 09:36:48 2022] Setting up static identity map for 0x20100000 - 0x2010003c
[Fri Jul 29 09:36:48 2022] rcu: Hierarchical SRCU implementation.
[Fri Jul 29 09:36:48 2022] devtmpfs: initialized
[Fri Jul 29 09:36:48 2022] VFP support v0.3: implementor 41 architecture 2 part 30 variant 5 rev 1
[Fri Jul 29 09:36:48 2022] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[Fri Jul 29 09:36:48 2022] futex hash table entries: 256 (order: 0, 6144 bytes, linear)
[Fri Jul 29 09:36:48 2022] pinctrl core: initialized pinctrl subsystem
[Fri Jul 29 09:36:48 2022] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[Fri Jul 29 09:36:48 2022] DMA: preallocated 256 KiB pool for atomic coherent allocations
[Fri Jul 29 09:36:48 2022] at_xdmac f0010000.dma-controller: 16 channels, mapped at 0x(ptrval)
[Fri Jul 29 09:36:48 2022] at_xdmac f0004000.dma-controller: 16 channels, mapped at 0x(ptrval)
[Fri Jul 29 09:36:48 2022] AT91: Detected SoC family: sama5d2
[Fri Jul 29 09:36:48 2022] AT91: Detected SoC: sama5d27c 128MiB SiP, revision 2
[Fri Jul 29 09:36:48 2022] clocksource: Switched to clocksource timer@f800c000
[Fri Jul 29 09:36:48 2022] NET: Registered PF_INET protocol family
[Fri Jul 29 09:36:48 2022] IP idents hash table entries: 2048 (order: 2, 16384 bytes, linear)
[Fri Jul 29 09:36:48 2022] tcp_listen_portaddr_hash hash table entries: 256 (order: 0, 5120 bytes, linear)
[Fri Jul 29 09:36:48 2022] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[Fri Jul 29 09:36:48 2022] TCP established hash table entries: 1024 (order: 0, 4096 bytes, linear)
[Fri Jul 29 09:36:48 2022] TCP bind hash table entries: 1024 (order: 2, 16384 bytes, linear)
[Fri Jul 29 09:36:48 2022] TCP: Hash tables configured (established 1024 bind 1024)
[Fri Jul 29 09:36:48 2022] UDP hash table entries: 256 (order: 1, 12288 bytes, linear)
[Fri Jul 29 09:36:48 2022] UDP-Lite hash table entries: 256 (order: 1, 12288 bytes, linear)
[Fri Jul 29 09:36:48 2022] NET: Registered PF_UNIX/PF_LOCAL protocol family
[Fri Jul 29 09:36:48 2022] workingset: timestamp_bits=30 max_order=15 bucket_order=0
[Fri Jul 29 09:36:48 2022] pinctrl-at91-pio4 fc038000.pinctrl: atmel pinctrl initialized
[Fri Jul 29 09:36:48 2022] atmel_usart_serial.0.auto: ttyS0 at MMIO 0xf8020000 (irq = 29, base_baud = 5125000) is a ATMEL_SERIAL
[Fri Jul 29 09:36:48 2022] printk: console [ttyS0] enabled
[Fri Jul 29 09:36:48 2022] at91_rtc f80480b0.rtc: registered as rtc0
[Fri Jul 29 09:36:48 2022] at91_rtc f80480b0.rtc: setting system clock to 2022-07-29T07:36:49 UTC (1659080209)
[Fri Jul 29 09:36:48 2022] at91_rtc f80480b0.rtc: AT91 Real Time Clock driver.
[Fri Jul 29 09:36:48 2022] atmel_aes f002c000.aes: version: 0x500
[Fri Jul 29 09:36:48 2022] atmel_aes f002c000.aes: Atmel AES - Using dma0chan0, dma0chan1 for DMA transfers
[Fri Jul 29 09:36:48 2022] atmel_sha f0028000.sha: version: 0x510
[Fri Jul 29 09:36:48 2022] atmel_sha f0028000.sha: using dma0chan2 for DMA transfers
[Fri Jul 29 09:36:48 2022] atmel_sha f0028000.sha: Atmel SHA1/SHA256/SHA224/SHA384/SHA512
[Fri Jul 29 09:36:48 2022] atmel_tdes fc044000.tdes: version: 0x703
[Fri Jul 29 09:36:48 2022] atmel_tdes fc044000.tdes: using dma0chan3, dma0chan4 for DMA transfers
[Fri Jul 29 09:36:48 2022] atmel_tdes fc044000.tdes: Atmel DES/TDES
[Fri Jul 29 09:36:48 2022] nand: device found, Manufacturer ID: 0x01, Chip ID: 0xda
[Fri Jul 29 09:36:48 2022] nand: AMD/Spansion S34ML02G1
[Fri Jul 29 09:36:48 2022] nand: 256 MiB, SLC, erase size: 128 KiB, page size: 2048, OOB size: 64
[Fri Jul 29 09:36:48 2022] Bad block table found at page 131008, version 0xFF
[Fri Jul 29 09:36:48 2022] Bad block table found at page 130944, version 0xFF
[Fri Jul 29 09:36:48 2022] 8 cmdlinepart partitions found on MTD device atmel_nand
[Fri Jul 29 09:36:48 2022] Creating 8 MTD partitions on "atmel_nand":
[Fri Jul 29 09:36:48 2022] 0x000000000000-0x000000040000 : "bootstrap"
[Fri Jul 29 09:36:48 2022] 0x000000040000-0x000000100000 : "uboot"
[Fri Jul 29 09:36:48 2022] 0x000000100000-0x000000140000 : "env1"
[Fri Jul 29 09:36:48 2022] 0x000000140000-0x000000180000 : "env2"
[Fri Jul 29 09:36:48 2022] 0x000000180000-0x0000001c0000 : "fpga_led"
[Fri Jul 29 09:36:48 2022] 0x0000001c0000-0x000000200000 : "reserved"
[Fri Jul 29 09:36:48 2022] 0x000000200000-0x000003400000 : "rootfs_rec"
[Fri Jul 29 09:36:48 2022] 0x000003400000-0x000010000000 : "filesystem"
[Fri Jul 29 09:36:48 2022] NET: Registered PF_PACKET protocol family
[Fri Jul 29 09:36:48 2022] printk: console [ttyS0]: printing thread started
[Fri Jul 29 09:36:48 2022] ubi0: attaching mtd6
[Fri Jul 29 09:36:48 2022] ubi0: MTD device 6 is write-protected, attach in read-only mode
[Fri Jul 29 09:36:48 2022] ubi0: scanning is finished
[Fri Jul 29 09:36:48 2022] ubi0 warning: autoresize: skip auto-resize because of R/O mode
[Fri Jul 29 09:36:48 2022] ubi0: attached mtd6 (name "rootfs_rec", size 50 MiB)
[Fri Jul 29 09:36:48 2022] ubi0: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[Fri Jul 29 09:36:48 2022] ubi0: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
[Fri Jul 29 09:36:48 2022] ubi0: VID header offset: 2048 (aligned 2048), data offset: 4096
[Fri Jul 29 09:36:48 2022] ubi0: good PEBs: 400, bad PEBs: 0, corrupted PEBs: 0
[Fri Jul 29 09:36:48 2022] ubi0: user volume: 1, internal volumes: 1, max. volumes count: 128
[Fri Jul 29 09:36:48 2022] ubi0: max/mean erase counter: 0/0, WL threshold: 4096, image sequence number: 399903508
[Fri Jul 29 09:36:48 2022] ubi0: available PEBs: 193, total reserved PEBs: 207, PEBs reserved for bad PEB handling: 40
[Fri Jul 29 09:36:48 2022] ubi1: attaching mtd7
[Fri Jul 29 09:36:48 2022] ubi0: background thread "ubi_bgt0d" started, PID 84
[Fri Jul 29 09:36:49 2022] ubi1: scanning is finished
[Fri Jul 29 09:36:49 2022] ubi1: attached mtd7 (name "filesystem", size 204 MiB)
[Fri Jul 29 09:36:49 2022] ubi1: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[Fri Jul 29 09:36:49 2022] ubi1: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
[Fri Jul 29 09:36:49 2022] ubi1: VID header offset: 2048 (aligned 2048), data offset: 4096
[Fri Jul 29 09:36:49 2022] ubi1: good PEBs: 1628, bad PEBs: 4, corrupted PEBs: 0
[Fri Jul 29 09:36:49 2022] ubi1: user volume: 3, internal volumes: 1, max. volumes count: 128
[Fri Jul 29 09:36:49 2022] ubi1: max/mean erase counter: 3/1, WL threshold: 4096, image sequence number: 642295739
[Fri Jul 29 09:36:49 2022] ubi1: available PEBs: 0, total reserved PEBs: 1628, PEBs reserved for bad PEB handling: 36
[Fri Jul 29 09:36:49 2022] ubi1: background thread "ubi_bgt1d" started, PID 85
[Fri Jul 29 09:36:49 2022] input: gpio_keys as /devices/platform/gpio_keys/input/input0
[Fri Jul 29 09:36:49 2022] atmel_usart_serial atmel_usart_serial.0.auto: using dma0chan6 for rx DMA transfers
[Fri Jul 29 09:36:49 2022] atmel_usart_serial atmel_usart_serial.0.auto: using dma0chan7 for tx DMA transfers
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): Mounting in unauthenticated mode
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): recovery needed
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): recovery deferred
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): UBIFS: mounted UBI device 1, volume 1, name "rootfs2", R/O mode
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): FS size: 40632320 bytes (38 MiB, 320 LEBs), max 330 LEBs, journal size 5586944 bytes (5 MiB, 44 LEBs)
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): reserved for root: 0 bytes (0 KiB)
[Fri Jul 29 09:36:49 2022] UBIFS (ubi1:1): media format: w4/r0 (latest is w5/r0), UUID CBFCD4DB-1E48-42B6-996E-DEB8664487BE, small LPT model
[Fri Jul 29 09:36:49 2022] VFS: Mounted root (ubifs filesystem) readonly on device 0:13.
[Fri Jul 29 09:36:49 2022] devtmpfs: mounted
[Fri Jul 29 09:36:49 2022] Freeing unused kernel image (initmem) memory: 1024K
[Fri Jul 29 09:36:49 2022] Run /sbin/init as init process
[Fri Jul 29 09:36:49 2022]   with arguments:
[Fri Jul 29 09:36:49 2022]     /sbin/init
[Fri Jul 29 09:36:49 2022]   with environment:
[Fri Jul 29 09:36:49 2022]     HOME=/
[Fri Jul 29 09:36:49 2022]     TERM=linux
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): Mounting in unauthenticated mode
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): background thread "ubifs_bgt1_2" started, PID 93
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): recovery needed
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): recovery completed
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): UBIFS: mounted UBI device 1, volume 2, name "data"
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): FS size: 95358976 bytes (90 MiB, 751 LEBs), max 762 LEBs, journal size 4825088 bytes (4 MiB, 38 LEBs)
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): reserved for root: 4504039 bytes (4398 KiB)
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:2): media format: w5/r0 (latest is w5/r0), UUID 26A84B72-1192-4A9F-B2E5-C282C07DA04C, small LPT model
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:1): completing deferred recovery
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:1): background thread "ubifs_bgt1_1" started, PID 96
[Fri Jul 29 09:36:50 2022] UBIFS (ubi1:1): deferred recovery completed
[Fri Jul 29 09:36:50 2022] random: crng init done
[Fri Jul 29 09:36:50 2022] at91-reset f8048000.rstc: Starting after software reset
[Fri Jul 29 09:36:50 2022] pps_core: LinuxPPS API ver. 1 registered
[Fri Jul 29 09:36:50 2022] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[Fri Jul 29 09:36:50 2022] PTP clock support registered
[Fri Jul 29 09:36:50 2022] SMSC LAN8710/LAN8720 f8008000.ethernet-ffffffff:01: Probing 'ethernet-phy@1'
[Fri Jul 29 09:36:50 2022] SMSC LAN8710/LAN8720 f8008000.ethernet-ffffffff:01: Disabling energy detect!
[Fri Jul 29 09:36:50 2022] macb f8008000.ethernet eth0: Cadence GEM rev 0x00020203 at 0xf8008000 irq 24 (00:50:c2:31:58:d4)
[Fri Jul 29 09:36:52 2022] macb f8008000.ethernet eth0: PHY [f8008000.ethernet-ffffffff:01] driver [SMSC LAN8710/LAN8720] (irq=POLL)
[Fri Jul 29 09:36:52 2022] macb f8008000.ethernet eth0: configuring for phy/rmii link mode
[Fri Jul 29 09:36:54 2022] macb f8008000.ethernet eth0: PHY [f8008000.ethernet-ffffffff:01] driver [SMSC LAN8710/LAN8720] (irq=POLL)
[Fri Jul 29 09:36:54 2022] macb f8008000.ethernet eth0: configuring for phy/rmii link mode
[Fri Jul 29 09:36:57 2022] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control tx
[Fri Jul 29 09:37:00 2022] macb f8008000.ethernet eth0: Link is Down
[Fri Jul 29 09:37:02 2022] macb f8008000.ethernet eth0: PHY [f8008000.ethernet-ffffffff:01] driver [SMSC LAN8710/LAN8720] (irq=POLL)
[Fri Jul 29 09:37:02 2022] macb f8008000.ethernet eth0: configuring for phy/rmii link mode
[Fri Jul 29 09:37:04 2022] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control tx
[Fri Jul 29 09:37:08 2022] UBIFS error (ubi1:1 pid 359): ubifs_decompress: cannot decompress 1247 bytes, compressor lzo, error -22
[Fri Jul 29 09:37:08 2022] UBIFS error (ubi1:1 pid 359): do_readpage: bad data node (block 47, inode 382)
[Fri Jul 29 09:37:08 2022]      magic          0x6101831
[Fri Jul 29 09:37:08 2022]      crc            0x81ac5d7
[Fri Jul 29 09:37:08 2022]      node_type      1 (data node)
[Fri Jul 29 09:37:08 2022]      group_type     0 (no node group)
[Fri Jul 29 09:37:08 2022]      sqnum          2088
[Fri Jul 29 09:37:08 2022]      len            1295
[Fri Jul 29 09:37:08 2022]      key            (382, data, 47)
[Fri Jul 29 09:37:08 2022]      size           4096
[Fri Jul 29 09:37:08 2022]      compr_typ      1
[Fri Jul 29 09:37:08 2022]      data size      1247
[Fri Jul 29 09:37:08 2022]      data (length = 1247):
[Fri Jul 29 09:37:08 2022]      00000000: 27 73 70 6c 61 79 74 72 65 65 2e 63 00 6e 65 77 00 1c 93 fd 7f 01 00 20 00 00 00 00 6d 02 00 39
[Fri Jul 29 09:37:08 2022]      00000020: 84 0e 00 f9 83 0c 00 02 f8 8c 02 00 20 5e 01 80 7b 0d 01 50 5d 00 8c 5d 00 48 5d 00 94 5d 00 18
[Fri Jul 29 09:37:08 2022]      00000040: 5d 00 9c 5d 00 58 5d 00 a0 5c 00 61 00 a8 5d 00 30 5d 00 ac 5d 00 10 5d 00 b4 5d 00 38 5e 00 bc
[Fri Jul 29 09:37:08 2022]      00000060: 7b be 08 48 97 0d 01 28 5d 00 c8 5d 01 08 5d 00 d0 5d 00 40 5d 00 d8 5d 00 80 5d 00 e0 5d 00 88
[Fri Jul 29 09:37:08 2022]      00000080: 5d 00 e8 5d 00 90 5d 00 f0 5d 00 98 5d 00 f8 5d 00 a0 61 0c 7c 0d 01 a8 59 00 08 5d 00 b0 5d 00
[Fri Jul 29 09:37:08 2022]      000000a0: 10 5d 00 b8 5c 00 6e a7 cc 9c ac 0e 66 11 f4 9f 05 01 0b 5d 00 03 6d 06 a0 0d 02 0c 58 00 6d 00
[Fri Jul 29 09:37:08 2022]      000000c0: 10 4d 01 0f 5d 00 05 4d 00 20 4d 01 11 dd 02 34 4d 01 12 5d 00 06 6d 14 a0 bc 08 7d 02 5c 4d 01
[Fri Jul 29 09:37:08 2022]      000000e0: 0e 7c 0d 4d 00 6c dc 02 6d 01 80 cd 07 09 6c 21 4d 01 13 cd 01 a8 4d 01 14 5c 00 6d 0f c0 4d 01
[Fri Jul 29 09:37:08 2022]      00000100: 16 5d 00 0a 7c 1b dc 08 2b 00 00 42 22 a0 ad 0e 05 04 00 b1 16 a8 ec 01 51 00 b0 ec 01 49 1b b8
[Fri Jul 29 09:37:08 2022]      00000120: 27 2d 00 04 0e 11 e6 02 8c 17 61 1e f0 5c 02 7c 15 61 12 c0 ec 01 51 0a c8 27 2d 00 08 0c 57 27
[Fri Jul 29 09:37:08 2022]      00000140: 2d 00 80 0c 0e 4e 01 07 00 b2 0d 60 ae bc 2f 61 1a e0 5d 02 09 dd 1a 30 23 6f 70 90 63 74 28 7d
[Fri Jul 29 09:37:08 2022]      00000160: 35 69 74 01 5e 39 2c 20 06 26 72 69 71 2f 3a 0d 79 73 40 10 55 56 5d 00 05 7c 63 8d 0a 74 00 19
[Fri Jul 29 09:37:08 2022]      00000180: 44 04 57 38 20 6f 66 09 33 6e 08 00 03 72 72 61 79 20 63 47 01 6f 6e 6c ae ac 01 72 01 6c ae bc
[Fri Jul 29 09:37:08 2022]      000001a0: 2c 72 01 b0 83 ef 01 00 04 80 27 5c 00 28 00 00 7d 0b 94 fc 1a 42 00 18 b4 ad 01 ff 40 00 ed 04
[Fri Jul 29 09:37:08 2022]      000001c0: 64 7d 11 ae ad 19 65 7c 53 4d 01 17 5d 00 66 7d 47 ae bd 14 c8 4e 00 dc ae bd 26 c9 4e 00 e4 ae
[Fri Jul 29 09:37:08 2022]      000001e0: ad 49 ca 7c 51 cd 07 cb 71 09 af 0d 02 21 7c 06 4e 00 24 af ad 07 cd 6d 49 af ad 13 ce 6d 49 af
[Fri Jul 29 09:37:08 2022]      00000200: ad 43 cf 6d 49 af bd 1a 2c 42 15 70 af bd 44 2d 4d 01 88 4d 01 15 4d 01 2e 4e 01 a0 af ad 31 2f
[Fri Jul 29 09:37:08 2022]      00000220: 4e 01 ac af ad 28 30 4d 01 bc cd 07 31 4d 01 d0 dd 02 32 4e 01 e0 af bd 11 33 7d 41 af bd 4d 34
[Fri Jul 29 09:37:08 2022]      00000240: 4e 01 08 b0 ad 01 90 4e 01 20 b0 bd 2c 91 4e 01 30 b0 bd 08 92 4e 01 44 b0 ad 10 93 4e 01 5c b0
[Fri Jul 29 09:37:08 2022]      00000260: ad 0a 94 4d 01 6c cd 01 95 4d 01 7c dd 08 96 4e 01 94 b0 ad 64 97 4e 01 a8 b0 ad 1f 98 4e 01 cc
[Fri Jul 29 09:37:08 2022]      00000280: b0 ad 1c 99 7d 11 b0 bd 11 9a 7d 11 b0 bd 2f 9b 4d 01 fc cd 04 9c 4e 01 10 b1 ad 2e 9d 4d 01 28
[Fri Jul 29 09:37:08 2022]      000002a0: 4d 01 1c 4d 01 9e 4e 01 48 b1 ad 8a 9f 4d 01 64 4d 01 1a 6c 35 4d 01 80 4d 01 23 4d 01 a1 4e 01
[Fri Jul 29 09:37:08 2022]      000002c0: a4 b1 bd 11 a6 6c 22 dd 05 a7 4e 01 d8 b1 ad 55 a8 4e 01 e4 b1 bd 29 aa 7d 0e b1 ad 1c f4 4e 01
[Fri Jul 29 09:37:08 2022]      000002e0: 14 b2 0d 02 19 4d 01 f5 7d 20 b2 bd 11 f6 7d 20 b2 bd 23 f7 4d 01 54 cd 04 f8 6c 34 cd 04 f9 4d
[Fri Jul 29 09:37:08 2022]      00000300: 01 84 4d 01 1e 4d 01 fb 6d 10 b2 bc 0e 2a 5c 09 61 00 b0 4d 43 03 de 50 c0 b2 ac 76 6e 64 28 7e
[Fri Jul 29 09:37:08 2022]      00000320: ac 01 6e 03 c8 b2 ac 04 7e 01 cc b2 ac 4c 7e 79 d4 b2 ac 73 7d 01 dc cc 01 6e 00 e4 b2 bc 7d 7d
[Fri Jul 29 09:37:08 2022]      00000340: 28 ec cc 07 7e 43 f0 b2 bc 38 6e 1e 04 b3 bc 0b 6e 54 0c b3 ac 07 6e 30 14 b3 bc 2f 9c 70 cc 04
[Fri Jul 29 09:37:08 2022]      00000360: 6e 54 28 b3 ac 0a 6d 1e 30 dc 02 6d 09 38 cc 01 6d 57 40 cc 04 7e 3d 48 b3 ac 2b 6d 21 54 cc 01
[Fri Jul 29 09:37:08 2022]      00000380: 6d 2a 60 cc 04 6e 2d 68 b3 ac 46 6e 33 78 b3 bc 65 6d 3c 84 cc 0a 7d 25 8c cc 07 7d 2b a8 cc 07
[Fri Jul 29 09:37:08 2022]      000003a0: 6d 3c 98 dd 14 1b 4e 00 a4 b3 bc 5f 6e 42 b0 b3 bd 23 1d 4d 00 b8 cc 01 6d 30 c0 cd 01 1f 7c 29
[Fri Jul 29 09:37:08 2022]      000003c0: cc 01 7d 8c d0 dc 0b 7d 52 dc dd 02 22 6c 28 cc 01 6d 48 ec cd 01 24 6d 42 b3 bd 74 25 7d 2b b4
[Fri Jul 29 09:37:08 2022]      000003e0: ac 40 2a 4c 07 6e 2d 24 b8 af 2e dc bc 02 8d 39 e4 5c 00 7f 3b ec bc 02 27 de 07 5d f0 06 04 41
[Fri Jul 29 09:37:08 2022]      00000400: f1 4c 00 5d 00 09 4d 00 71 4d 00 99 5d 01 f1 4d 00 7d 4d 00 65 4d 00 75 7d 00 f2 0d 00 b5 4d 00
[Fri Jul 29 09:37:08 2022]      00000420: 51 4d 00 19 4d 00 29 6d 01 08 0d 11 b5 4e 00 e9 07 0e 00 c9 05 0e 00 d9 05 bc 0b ed 00 8e dd 00
[Fri Jul 29 09:37:08 2022]      00000440: b6 de 00 07 01 be 00 79 05 ae 3c 98 75 be 3b 70 6c bf 56 a0 f4 03 9d 28 04 cd 2b a4 5d 01 1c dc
[Fri Jul 29 09:37:08 2022]      00000460: 01 6d 00 b4 50 07 03 f5 fe ff 6f 2c 12 be 4e 28 3e ae 4e f8 1c ae 49 18 24 bd 48 10 dc 3a ff 20
[Fri Jul 29 09:37:08 2022]      00000480: 3c fd 03 9e 1f e8 04 ad 3f 11 de 3b b0 70 ae 01 18 67 ae 45 98 09 bd 44 08 cc 3e 61 00 fb 09 54
[Fri Jul 29 09:37:08 2022]      000004a0: 6f 69 92 fe 5e 00 68 66 8d 2c 6f 6d 0a f0 5e 00 40 62 0d 01 fa 5d 00 26 20 0a f3 33 1c fc 03 27
[Fri Jul 29 09:37:08 2022]      000004c0: 2e 00 a4 75 20 00 00 53 0f 00 6d 6c 02 3f 8d 0a 31 ce 04 0d 7e 30 6e 00 91 cd 00 bb 11 00 00
[Fri Jul 29 09:37:08 2022] UBIFS error (ubi1:1 pid 359): do_readpage: cannot read page 47 of inode 382, error -22

Greets
Alex
