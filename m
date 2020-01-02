Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18CF12E34F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 08:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgABHbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 02:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgABHbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 02:31:00 -0500
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 662A9215A4;
        Thu,  2 Jan 2020 07:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577950258;
        bh=g6j8DBVZCvHpQ2FoBh/9GmIWHgCmjJEnIdPIYM78lfo=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=JyssFy1FSXMzrw+H7jVeMFTDM36G5iL2KnF+8nYYQdH3qSkxm3TYgjFd0fElLpVvg
         SiiYdOeD4XTYK3w3utgIEd9Gwql+NeipbFXgChAP0afc9PxKFGq9uH17fpj4egYMAL
         /qshGfFmb+4AeD59pfTeFd32VAnq2SOu+FKWALqA=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5869f050-7b3f-b950-bfb6-5601d2b30fbd@roeck-us.net>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net> <5869f050-7b3f-b950-bfb6-5601d2b30fbd@roeck-us.net>
From:   Stephen Boyd <sboyd@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     <linux-clk@vger.kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
User-Agent: alot/0.8.1
Date:   Wed, 01 Jan 2020 23:30:57 -0800
Message-Id: <20200102073058.662A9215A4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(Happy New Year!)

Quoting Guenter Roeck (2020-01-01 19:41:40)
> On 1/1/20 6:44 PM, Guenter Roeck wrote:
> > Hi,
> >=20
> > I see a number of crashes in the latest v5.4.y-queue; please see below
> > for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix me=
mory
> > leak in clk_unregister()").
> >=20
> > The context suggests recovery from a failed driver probe, and it appears
> > that the memory is released twice. Interestingly, I don't see the probl=
em
> > in mainline.
> >=20
>=20
> The reason for not seeing the crash in mainline is that macb_probe()
> doesn't fail there due to unrelated changes in the driver. If I force
> macb_probe() to fail in mainline, I see exactly the same crash.
>=20
> Effectively this means that upstream commit 8247470772be is broken;
> it may fix a memory leak in some situations, but it results in UAF
> and crashes otherwise.
>=20
> Stephen, any comments ? I must admit that I don't understand the clock
> code nor the commit in question; I would have assumed that the call
> to __clk_put() would release the clk data structure, not an explicit
> call to kfree().

The clk that the commit from Kishon is freeing is the first "consumer
handle" that we make when a clk is registered. That is returned to
anyone that calls clk_register(), or if the provider decides to access
clk_hw::clk directly, which is not desired but still exists for
historical reasons. It is also used when drivers call clk_get_parent()
and that API currently fails to reference count or even create a
per-call clk pointer.

The general idea is that each user of clk_get() should get a different
struct clk pointer to use. The problem is we have this semi-internal
struct clk pointer that leaks out of clk_get_parent(), __clk_lookup()
and clk_register().

Maybe someone is calling clk_unregister() twice with the same pointer
they got through different ways? The macb driver does some questionable
things, like calling clk_register() and then putting the returned
pointer into *tx_clk, but only for the sifive implementation. After that
it does even odder things, like calling clk_unregister() on a clk that
probably shouldn't be unregistered, except for on the sifive platforms
that register it. Pretty horrifying that clk_unregister() gives any
consumer the power to destroy a clk from the system!

Can you try this patch? I think by fixing the leak we've discovered more
problems.

----8<----
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/etherne=
t/cadence/macb_main.c
index 9c767ee252ac..7dce403fd27c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4069,7 +4069,7 @@ static int fu540_c000_clk_init(struct platform_device=
 *pdev, struct clk **pclk,
 	mgmt->rate =3D 0;
 	mgmt->hw.init =3D &init;
=20
-	*tx_clk =3D clk_register(NULL, &mgmt->hw);
+	*tx_clk =3D devm_clk_register(&pdev->dev, &mgmt->hw);
 	if (IS_ERR(*tx_clk))
 		return PTR_ERR(*tx_clk);
=20
@@ -4397,7 +4397,6 @@ static int macb_probe(struct platform_device *pdev)
=20
 err_disable_clocks:
 	clk_disable_unprepare(tx_clk);
-	clk_unregister(tx_clk);
 	clk_disable_unprepare(hclk);
 	clk_disable_unprepare(pclk);
 	clk_disable_unprepare(rx_clk);
@@ -4427,7 +4426,6 @@ static int macb_remove(struct platform_device *pdev)
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {
 			clk_disable_unprepare(bp->tx_clk);
-			clk_unregister(bp->tx_clk);
 			clk_disable_unprepare(bp->hclk);
 			clk_disable_unprepare(bp->pclk);
 			clk_disable_unprepare(bp->rx_clk);

>=20
> Guenter
>=20
> > I would suggest to drop that patch from the stable queue.
> >=20
> > Guenter
> >=20
> > ---
> > First traceback is:
> >=20
> > [=C2=A0=C2=A0 19.203547] ------------[ cut here ]------------
> > [=C2=A0=C2=A0 19.204107] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:40=
34 __clk_put+0xfc/0x128

Presumably this is the=20

	WARN_ON_ONCE(IS_ERR(clk))

in __clk_put()? Or is it the exclusive count check that is getting
tricked out because of page poisoning?

I guess we should put that in some sort of text form of warning instead
of a not so helpful line number.

> > [=C2=A0=C2=A0 19.204275] Modules linked in:
> > [=C2=A0=C2=A0 19.204634] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.=
8-rc1-00191-gaf408bc6c96e #1
> > [=C2=A0=C2=A0 19.204790] Hardware name: Xilinx Zynq Platform
> > [=C2=A0=C2=A0 19.204994] [<c0313658>] (unwind_backtrace) from [<c030d69=
8>] (show_stack+0x10/0x14)
> > [=C2=A0=C2=A0 19.205150] [<c030d698>] (show_stack) from [<c1139bdc>] (d=
ump_stack+0xe0/0x10c)
> > [=C2=A0=C2=A0 19.205278] [<c1139bdc>] (dump_stack) from [<c0349098>] (_=
_warn+0xf4/0x10c)
> > [=C2=A0=C2=A0 19.205399] [<c0349098>] (__warn) from [<c0349164>] (warn_=
slowpath_fmt+0xb4/0xbc)
> > [=C2=A0=C2=A0 19.205522] [<c0349164>] (warn_slowpath_fmt) from [<c0956d=
14>] (__clk_put+0xfc/0x128)
> > [=C2=A0=C2=A0 19.205654] [<c0956d14>] (__clk_put) from [<c0b1ea10>] (re=
lease_nodes+0x1c4/0x278)
> > [=C2=A0=C2=A0 19.205780] [<c0b1ea10>] (release_nodes) from [<c0b1a220>]=
 (really_probe+0x108/0x34c)
> > [=C2=A0=C2=A0 19.205908] [<c0b1a220>] (really_probe) from [<c0b1a5dc>] =
(driver_probe_device+0x60/0x174)
> > [=C2=A0=C2=A0 19.206042] [<c0b1a5dc>] (driver_probe_device) from [<c0b1=
a898>] (device_driver_attach+0x58/0x60)
> > [=C2=A0=C2=A0 19.206179] [<c0b1a898>] (device_driver_attach) from [<c0b=
1a924>] (__driver_attach+0x84/0xc0)
> > [=C2=A0=C2=A0 19.206313] [<c0b1a924>] (__driver_attach) from [<c0b18400=
>] (bus_for_each_dev+0x78/0xb8)
> > [=C2=A0=C2=A0 19.206463] [<c0b18400>] (bus_for_each_dev) from [<c0b195e=
8>] (bus_add_driver+0x164/0x1e8)
> > [=C2=A0=C2=A0 19.206590] [<c0b195e8>] (bus_add_driver) from [<c0b1b6fc>=
] (driver_register+0x74/0x108)
> > [=C2=A0=C2=A0 19.206723] [<c0b1b6fc>] (driver_register) from [<c030315c=
>] (do_one_initcall+0x8c/0x3bc)
> > [=C2=A0=C2=A0 19.206857] [<c030315c>] (do_one_initcall) from [<c1a01080=
>] (kernel_init_freeable+0x14c/0x1e8)
> > [=C2=A0=C2=A0 19.206992] [<c1a01080>] (kernel_init_freeable) from [<c11=
547a4>] (kernel_init+0x8/0x118)
> > [=C2=A0=C2=A0 19.207116] [<c11547a4>] (kernel_init) from [<c03010b4>] (=
ret_from_fork+0x14/0x20)
> >=20
> > followed by:
> >=20
> > [=C2=A0=C2=A0 19.209792] 8<--- cut here ---
> > [=C2=A0=C2=A0 19.209926] Unable to handle kernel paging request at virt=
ual address 6b6b6bb3
> > [=C2=A0=C2=A0 19.210117] pgd =3D (ptrval)
> > [=C2=A0=C2=A0 19.210207] [6b6b6bb3] *pgd=3D00000000
> > [=C2=A0=C2=A0 19.210626] Internal error: Oops: 5 [#1] SMP ARM
> > [=C2=A0=C2=A0 19.210807] Modules linked in:
> > [=C2=A0=C2=A0 19.210956] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 5.4.8-rc1-00191-gaf408bc6c96e #1
> > [=C2=A0=C2=A0 19.211090] Hardware name: Xilinx Zynq Platform
> > [=C2=A0=C2=A0 19.211200] PC is at __clk_put+0x104/0x128
> > [=C2=A0=C2=A0 19.211274] LR is at __clk_put+0xfc/0x128
> > [=C2=A0=C2=A0 19.211349] pc : [<c0956d1c>]=C2=A0=C2=A0=C2=A0 lr : [<c09=
56d14>]=C2=A0=C2=A0=C2=A0 psr: 60000053
> > [=C2=A0=C2=A0 19.211446] sp : c7129dd8=C2=A0 ip : 00000000=C2=A0 fp : c=
59f1680
> > [=C2=A0=C2=A0 19.211534] r10: c72fb6ac=C2=A0 r9 : c0b1dbd0=C2=A0 r8 : 0=
0000008
> > [=C2=A0=C2=A0 19.211626] r7 : c7129e04=C2=A0 r6 : c72fb410=C2=A0 r5 : c=
59f0880=C2=A0 r4 : c59f3180
> > [=C2=A0=C2=A0 19.211727] r3 : 7a538c1d=C2=A0 r2 : 6b6b6b6b=C2=A0 r1 : 6=
b6b6b6b=C2=A0 r0 : 00000000
> > [=C2=A0=C2=A0 19.211885] Flags: nZCv=C2=A0 IRQs on=C2=A0 FIQs off=C2=A0=
 Mode SVC_32=C2=A0 ISA ARM=C2=A0 Segment none
> > [=C2=A0=C2=A0 19.212022] Control: 10c5387d=C2=A0 Table: 00204059=C2=A0 =
DAC: 00000051
> > [=C2=A0=C2=A0 19.212152] Process swapper/0 (pid: 1, stack limit =3D 0x(=
ptrval))
> > [=C2=A0=C2=A0 19.212270] Stack: (0xc7129dd8 to 0xc712a000)
> > [=C2=A0=C2=A0 19.212391] 9dc0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c59f1680 c59f0=
880
> > [=C2=A0=C2=A0 19.212608] 9de0: c72fb410 c0b1ea10 ffffffed 00000000 c0b1=
e404 c7128000 c72fb410 a0000053
> > [=C2=A0=C2=A0 19.212822] 9e00: c72fb68c c59f1c80 c59f1480 7a538c1d 0000=
0001 c241e19c c72fb410 c241e1a0
> > [=C2=A0=C2=A0 19.213029] 9e20: 00000000 c1d8a1ac 00000000 ffffffed c1b8=
124c c0b1a220 c72fb410 c1d8a1ac
> > [=C2=A0=C2=A0 19.213240] 9e40: c1d8a1ac c7128000 c1dc347c 00000007 0000=
01f6 c0b1a5dc c1d8a1ac c1d8a1ac
> > [=C2=A0=C2=A0 19.213462] 9e60: c7128000 c72fb410 00000000 c1d8a1ac c712=
8000 c1dc347c 00000007 000001f6
> > [=C2=A0=C2=A0 19.213683] 9e80: c1b8124c c0b1a898 00000000 c1d8a1ac c72f=
b410 c0b1a924 00000000 c1d8a1ac
> > [=C2=A0=C2=A0 19.213899] 9ea0: c0b1a8a0 c0b18400 c70b50d4 c70b50a4 c725=
d210 7a538c1d c70b50d4 c1d8a1ac
> > [=C2=A0=C2=A0 19.214115] 9ec0: c59f0280 c1d6dd50 00000000 c0b195e8 c185=
eb44 c1aab944 00000000 c1d8a1ac
> > [=C2=A0=C2=A0 19.214343] 9ee0: c1aab944 00000000 c1c08468 c0b1b6fc c1dc=
46c0 c1aab944 00000000 c030315c
> > [=C2=A0=C2=A0 19.214555] 9f00: c1959bf0 000001f6 000001f6 c0372600 0000=
0000 c19574b8 c1883c18 00000000
> > [=C2=A0=C2=A0 19.214783] 9f20: c7128000 c03b3f70 c7128000 c1dd1f00 c1c0=
8468 c1ae7870 c1a00590 00000007
> > [=C2=A0=C2=A0 19.215001] 9f40: 000001f6 c03d39b8 00000000 7a538c1d c1dc=
347c c1dd1f00 c1dd1f00 c1ae7850
> > [=C2=A0=C2=A0 19.215214] 9f60: c1ae7870 c1a00590 00000007 c1a01080 0000=
0006 00000006 00000000 c1a00590
> > [=C2=A0=C2=A0 19.215429] 9f80: 00000000 00000000 c115479c 00000000 0000=
0000 00000000 00000000 00000000
> > [=C2=A0=C2=A0 19.215636] 9fa0: 00000000 c11547a4 00000000 c03010b4 0000=
0000 00000000 00000000 00000000
> > [=C2=A0=C2=A0 19.215843] 9fc0: 00000000 00000000 00000000 00000000 0000=
0000 00000000 00000000 00000000
> > [=C2=A0=C2=A0 19.216068] 9fe0: 00000000 00000000 00000000 00000000 0000=
0013 00000000 00000000 00000000
> > [=C2=A0=C2=A0 19.216255] [<c0956d1c>] (__clk_put) from [<c0b1ea10>] (re=
lease_nodes+0x1c4/0x278)
> > [=C2=A0=C2=A0 19.216376] [<c0b1ea10>] (release_nodes) from [<c0b1a220>]=
 (really_probe+0x108/0x34c)
> > [=C2=A0=C2=A0 19.216494] [<c0b1a220>] (really_probe) from [<c0b1a5dc>] =
(driver_probe_device+0x60/0x174)
> > [=C2=A0=C2=A0 19.216617] [<c0b1a5dc>] (driver_probe_device) from [<c0b1=
a898>] (device_driver_attach+0x58/0x60)
> > [=C2=A0=C2=A0 19.216745] [<c0b1a898>] (device_driver_attach) from [<c0b=
1a924>] (__driver_attach+0x84/0xc0)
> > [=C2=A0=C2=A0 19.216867] [<c0b1a924>] (__driver_attach) from [<c0b18400=
>] (bus_for_each_dev+0x78/0xb8)
> > [=C2=A0=C2=A0 19.216993] [<c0b18400>] (bus_for_each_dev) from [<c0b195e=
8>] (bus_add_driver+0x164/0x1e8)
> > [=C2=A0=C2=A0 19.217112] [<c0b195e8>] (bus_add_driver) from [<c0b1b6fc>=
] (driver_register+0x74/0x108)
> > [=C2=A0=C2=A0 19.217233] [<c0b1b6fc>] (driver_register) from [<c030315c=
>] (do_one_initcall+0x8c/0x3bc)
> > [=C2=A0=C2=A0 19.217358] [<c030315c>] (do_one_initcall) from [<c1a01080=
>] (kernel_init_freeable+0x14c/0x1e8)
> > [=C2=A0=C2=A0 19.217500] [<c1a01080>] (kernel_init_freeable) from [<c11=
547a4>] (kernel_init+0x8/0x118)
> > [=C2=A0=C2=A0 19.217624] [<c11547a4>] (kernel_init) from [<c03010b4>] (=
ret_from_fork+0x14/0x20)
>=20
