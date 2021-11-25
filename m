Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9217E45D648
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 09:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353010AbhKYIj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 03:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353067AbhKYIhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 03:37:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F0AC061757
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 00:34:14 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqACl-0003DO-4L; Thu, 25 Nov 2021 09:34:07 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqACj-000vSf-Hi; Thu, 25 Nov 2021 09:34:04 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mqACi-00077g-Ho; Thu, 25 Nov 2021 09:34:04 +0100
Date:   Thu, 25 Nov 2021 09:34:00 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     peter.chen@kernel.org, shawnguo@kernel.org, marex@denx.de,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        heiko.thiery@gmail.com, frieder.schrempf@kontron.de,
        stable@vger.kernel.org, kernel@pengutronix.de,
        Gavin Schenk <g.schenk@eckelmann.de>
Subject: [PATCH] usb: chipidea: ci_hdrc_imx: Fix -EPROBE_DEFER handling for
 phy
Message-ID: <20211125083400.h7qoyj52fcn4khum@pengutronix.de>
References: <20210921113754.767631-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mgjk6w5dt4qzncwl"
Content-Disposition: inline
In-Reply-To: <20210921113754.767631-1-festevam@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mgjk6w5dt4qzncwl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

With an old style device tree using fsl,usbphy
devm_usb_get_phy_by_phandle() returning ERR_PTR(-EPROBE_DEFER) results in
ci->usb_phy =3D ERR_PTR(-EPROBE_DEFER) in the chipidea driver which then
chokes on that with

	Unable to handle kernel paging request at virtual address fffffe93

Handle errors other then -ENODEV as was done before v5.15-rc5 in
ci_hdrc_imx_probe().

Fixes: 8253a34bfae3 ("usb: chipidea: ci_hdrc_imx: Also search for 'phys' ph=
andle")
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch became commit 8253a34bfae3278baca52fc1209b7c29270486ca in
v5.15-rc5. On an i.MX25 I experience the following fault:

[    2.248749] 8<--- cut here ---
[    2.259025] Unable to handle kernel paging request at virtual address ff=
fffe93
[    2.273957] pgd =3D (ptrval)
[    2.276764] [fffffe93] *pgd=3D87ffd871, *pte=3D00000000, *ppte=3D00000000
[    2.293989] Internal error: Oops - BUG: 1 [#1] PREEMPT ARM
[    2.299575] Modules linked in:
[    2.302689] CPU: 0 PID: 56 Comm: kworker/u2:1 Not tainted 5.15.0-2021110=
4-1-g93b00c224da8 #1
[    2.311191] Hardware name: Freescale i.MX25 (Device Tree Support)
[    2.317328] Workqueue: events_unbound deferred_probe_work_func
[    2.323258] PC is at ci_hdrc_probe+0x1dc/0x8cc
[    2.327777] LR is at ci_hdrc_probe+0x17c/0x8cc
[    2.332273] pc : [<c06f8110>]    lr : [<c06f80b0>]    psr: a0000013
[    2.338576] sp : c1213a70  ip : c1213a70  fp : c1213aac
[    2.343834] r10: c0e015b8  r9 : c1884c10  r8 : c1830900
[    2.349092] r7 : c1884c00  r6 : c12a7020  r5 : fffffdfb  r4 : c12a6020
[    2.355655] r3 : 00000000  r2 : 0000000a  r1 : 00000000  r0 : fffffdfb
[    2.362217] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 none
[    2.369397] Control: 0005317f  Table: 80004000  DAC: 00000053
[    2.375170] Register r0 information: non-paged memory
[    2.380273] Register r1 information: NULL pointer
[    2.385023] Register r2 information: non-paged memory
[    2.390122] Register r3 information: NULL pointer
[    2.394871] Register r4 information: slab kmalloc-8k start c12a6000 poin=
ter offset 32 size 8192
[    2.403695] Register r5 information: non-paged memory
[    2.408795] Register r6 information: slab kmalloc-8k start c12a6000 poin=
ter offset 4128 size 8192
[    2.417783] Register r7 information: slab kmalloc-512 start c1884c00 poi=
nter offset 0 size 512
[    2.426515] Register r8 information: slab kmalloc-64 start c1830900 poin=
ter offset 0 size 64
[    2.435072] Register r9 information: slab kmalloc-512 start c1884c00 poi=
nter offset 16 size 512
[    2.443887] Register r10 information: non-slab/vmalloc memory
[    2.449686] Register r11 information: non-slab/vmalloc memory
[    2.455480] Register r12 information: non-slab/vmalloc memory
[    2.461277] Process kworker/u2:1 (pid: 56, stack limit =3D 0x(ptrval))
[    2.467678] Stack: (0xc1213a70 to 0xc1214000)
[    2.472085] 3a60:                                     c1213aa4 c1213a80 =
c033f010 c0d03228
[    2.480320] 3a80: c1884c10 00000000 c1884c10 c0db7790 c0dfdbc8 c0da8078 =
00000000 00000000
[    2.488555] 3aa0: c1213acc c1213ab0 c05d3bb4 c06f7f44 c1884c10 00000000 =
c0db7790 c0dfdbc8
[    2.496789] 3ac0: c1213af4 c1213ad0 c05d1150 c05d3b5c c1213af4 c1213ae0 =
c1884c10 c0db7790
[    2.505024] 3ae0: c1884c10 00000001 c1213b2c c1213af8 c05d1578 c05d1080 =
c054ee18 c0df0280
[    2.513257] 3b00: c05cee28 00000000 c0e273ac c0db7790 c1884c10 00000001 =
c0da8078 00000000
[    2.521492] 3b20: c1213b4c c1213b30 c05d1740 c05d14e4 00000001 c0db7790 =
c1213ba4 c1884c10
[    2.529724] 3b40: c1213b6c c1213b50 c05d1ba8 c05d1710 00000000 c1213ba4 =
c05d1afc c0e27380
[    2.537958] 3b60: c1213b9c c1213b70 c05cee1c c05d1b0c c1213b9c c10d559c =
c182c274 c0d03228
[    2.546189] 3b80: c1884c10 c1884c10 c1884c54 00000001 c1213bcc c1213ba0 =
c05d0fb0 c05ced9c
[    2.554421] 3ba0: 00000000 c1884c10 00000001 c0d03228 c1830800 c1884c10 =
c1884c10 c0da8630
[    2.562655] 3bc0: c1213bdc c1213bd0 c05d1db8 c05d0ec8 c1213bfc c1213be0 =
c05cff4c c05d1dac
[    2.570889] 3be0: c1884c10 00000000 c11d2010 c0e27380 c1213c5c c1213c00 =
c05cd5c4 c05cfec8
[    2.579122] 3c00: c1830900 c0d09ac0 c1213c2c c1213c18 c011e04c c011ddd0 =
ffffe000 c1830900
[    2.587355] 3c20: c1213c4c c1213c30 c011f974 c0d03228 c05c9c40 00000002 =
c1830920 c1884c00
[    2.595587] 3c40: 00000000 c1884c10 c0d09ac0 c0d09aa0 c1213c8c c1213c60 =
c05d3634 c05cd1d8
[    2.603818] 3c60: c0df0c80 c1213cc8 c1884c00 00000000 c11c44c0 00000002 =
00000000 c0dfdbc8
[    2.612051] 3c80: c1213cc4 c1213c90 c06f8bf8 c05d3540 00000000 c01d4270 =
00000000 00000000
[    2.620285] 3ca0: c1885a20 c11d2000 c11d2010 c7ef89d8 c1885a20 c0dfdbc8 =
c1213d7c c1213cc8
[    2.628516] 3cc0: c0700728 c06f8810 c117d1e0 00000100 00000000 00000000 =
fffffdfb 00000001
[    2.636747] 3ce0: 0000000a 00000003 c06ffef0 00000000 01010000 00000000 =
00000001 00000000
[    2.644976] 3d00: 00000000 00000000 00000000 ffffffed 00000000 c06f8e50 =
00000000 00000000
[    2.653207] 3d20: 00000000 ffffffed 00000000 c06f8e50 00000000 00000000 =
00000000 ffffffed
[    2.661437] 3d40: 00000000 00000000 00000000 00000000 c06f77e0 c0d03228 =
00000000 c11d2010
[    2.669671] 3d60: c0db7c54 c0dfdbc8 00000000 c11d2010 c1213d9c c1213d80 =
c05d3bb4 c07004d8
[    2.677905] 3d80: c11d2010 00000000 c0db7c54 c0dfdbc8 c1213dc4 c1213da0 =
c05d1150 c05d3b5c
[    2.686137] 3da0: c1213dc4 c1213db0 c11d2010 c0db7c54 c11d2010 00000001 =
c1213dfc c1213dc8
[    2.694372] 3dc0: c05d1578 c05d1080 c073de18 c01d4270 c11d2010 c0db7c54 =
c0e273ac c0db7c54
[    2.702606] 3de0: c11d2010 00000001 00000000 c11d2010 c1213e1c c1213e00 =
c05d1740 c05d14e4
[    2.710841] 3e00: 00000001 c0db7c54 c1213e74 c11d2010 c1213e3c c1213e20 =
c05d1ba8 c05d1710
[    2.719073] 3e20: 00000000 c1213e74 c05d1afc c0dfdbc8 c1213e6c c1213e40 =
c05cee1c c05d1b0c
[    2.727307] 3e40: c1213e6c c10d559c c182c7b4 c0d03228 c11d2010 c11d2010 =
c11d2054 00000001
[    2.735541] 3e60: c1213e9c c1213e70 c05d0fb0 c05ced9c 00000000 c11d2010 =
00000001 c0d03228
[    2.743775] 3e80: c11d2010 c0da83cc c11d2010 c0da8630 c1213eac c1213ea0 =
c05d1db8 c05d0ec8
[    2.752009] 3ea0: c1213ecc c1213eb0 c05cff4c c05d1dac c0da83cc c0da83cc =
c0da83d8 c0dfdbc8
[    2.760243] 3ec0: c1213efc c1213ed0 c05d0518 c05cfec8 c05d0478 c0da83f0 =
c117ff60 c1052e00
[    2.768476] 3ee0: 00000000 c0def8a0 c100641c c1052e0d c1213f3c c1213f00 =
c0133a14 c05d0488
[    2.776710] 3f00: c117ff78 c0133f44 c1213f3c c117ffa0 c01d45b4 c1008a00 =
c1008a00 c1008a14
[    2.784943] 3f20: c0d41f00 c117ff78 c1008a40 c117ff60 c1213f74 c1213f40 =
c0133f04 c0133820
[    2.793176] 3f40: c1008a00 c1212000 c1213f74 c126afc0 c1212000 c12602c0 =
c0133cbc c117ff60
[    2.801411] 3f60: 00000000 c110be88 c1213fac c1213f78 c013c1b8 c0133ccc =
c12602dc c12602dc
[    2.809641] 3f80: 00000000 c126afc0 c013c03c 00000000 00000000 00000000 =
00000000 00000000
[    2.817871] 3fa0: 00000000 c1213fb0 c01000d8 c013c04c 00000000 00000000 =
00000000 00000000
[    2.826100] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    2.834330] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
00000000 00000000
[    2.842539] Backtrace:
[    2.845026] [<c06f7f34>] (ci_hdrc_probe) from [<c05d3bb4>] (platform_pro=
be+0x68/0xc8)
[    2.853018]  r10:00000000 r9:00000000 r8:c0da8078 r7:c0dfdbc8 r6:c0db779=
0 r5:c1884c10
[    2.860889]  r4:00000000
[    2.863450] [<c05d3b4c>] (platform_probe) from [<c05d1150>] (really_prob=
e+0xe0/0x464)
[    2.871387]  r7:c0dfdbc8 r6:c0db7790 r5:00000000 r4:c1884c10
[    2.877084] [<c05d1070>] (really_probe) from [<c05d1578>] (__driver_prob=
e_device+0xa4/0x22c)
[    2.885623]  r7:00000001 r6:c1884c10 r5:c0db7790 r4:c1884c10
[    2.891317] [<c05d14d4>] (__driver_probe_device) from [<c05d1740>] (driv=
er_probe_device+0x40/0xe8)
[    2.900384]  r9:00000000 r8:c0da8078 r7:00000001 r6:c1884c10 r5:c0db7790=
 r4:c0e273ac
[    2.908163] [<c05d1700>] (driver_probe_device) from [<c05d1ba8>] (__devi=
ce_attach_driver+0xac/0x124)
[    2.917400]  r7:c1884c10 r6:c1213ba4 r5:c0db7790 r4:00000001
[    2.923092] [<c05d1afc>] (__device_attach_driver) from [<c05cee1c>] (bus=
_for_each_drv+0x90/0xdc)
[    2.931978]  r7:c0e27380 r6:c05d1afc r5:c1213ba4 r4:00000000
[    2.937669] [<c05ced8c>] (bus_for_each_drv) from [<c05d0fb0>] (__device_=
attach+0xf8/0x198)
[    2.946027]  r6:00000001 r5:c1884c54 r4:c1884c10
[    2.950673] [<c05d0eb8>] (__device_attach) from [<c05d1db8>] (device_ini=
tial_probe+0x1c/0x20)
[    2.959292]  r6:c0da8630 r5:c1884c10 r4:c1884c10
[    2.963941] [<c05d1d9c>] (device_initial_probe) from [<c05cff4c>] (bus_p=
robe_device+0x94/0x9c)
[    2.972634] [<c05cfeb8>] (bus_probe_device) from [<c05cd5c4>] (device_ad=
d+0x3fc/0x8bc)
[    2.980676]  r7:c0e27380 r6:c11d2010 r5:00000000 r4:c1884c10
[    2.986368] [<c05cd1c8>] (device_add) from [<c05d3634>] (platform_device=
_add+0x104/0x250)
[    2.994671]  r10:c0d09aa0 r9:c0d09ac0 r8:c1884c10 r7:00000000 r6:c1884c0=
0 r5:c1830920
[    3.002540]  r4:00000002
[    3.005099] [<c05d3530>] (platform_device_add) from [<c06f8bf8>] (ci_hdr=
c_add_device+0x3f8/0x4c4)
[    3.014095]  r10:c0dfdbc8 r9:00000000 r8:00000002 r7:c11c44c0 r6:0000000=
0 r5:c1884c00
[    3.021965]  r4:c1213cc8 r3:c0df0c80
[    3.025566] [<c06f8800>] (ci_hdrc_add_device) from [<c0700728>] (ci_hdrc=
_imx_probe+0x260/0x5c0)
[    3.034394]  r10:c0dfdbc8 r9:c1885a20 r8:c7ef89d8 r7:c11d2010 r6:c11d200=
0 r5:c1885a20
[    3.042259]  r4:00000000
[    3.044818] [<c07004c8>] (ci_hdrc_imx_probe) from [<c05d3bb4>] (platform=
_probe+0x68/0xc8)
[    3.053122]  r9:c11d2010 r8:00000000 r7:c0dfdbc8 r6:c0db7c54 r5:c11d2010=
 r4:00000000
[    3.060900] [<c05d3b4c>] (platform_probe) from [<c05d1150>] (really_prob=
e+0xe0/0x464)
[    3.068833]  r7:c0dfdbc8 r6:c0db7c54 r5:00000000 r4:c11d2010
[    3.074524] [<c05d1070>] (really_probe) from [<c05d1578>] (__driver_prob=
e_device+0xa4/0x22c)
[    3.083058]  r7:00000001 r6:c11d2010 r5:c0db7c54 r4:c11d2010
[    3.088750] [<c05d14d4>] (__driver_probe_device) from [<c05d1740>] (driv=
er_probe_device+0x40/0xe8)
[    3.097813]  r9:c11d2010 r8:00000000 r7:00000001 r6:c11d2010 r5:c0db7c54=
 r4:c0e273ac
[    3.105589] [<c05d1700>] (driver_probe_device) from [<c05d1ba8>] (__devi=
ce_attach_driver+0xac/0x124)
[    3.114824]  r7:c11d2010 r6:c1213e74 r5:c0db7c54 r4:00000001
[    3.120516] [<c05d1afc>] (__device_attach_driver) from [<c05cee1c>] (bus=
_for_each_drv+0x90/0xdc)
[    3.129399]  r7:c0dfdbc8 r6:c05d1afc r5:c1213e74 r4:00000000
[    3.135093] [<c05ced8c>] (bus_for_each_drv) from [<c05d0fb0>] (__device_=
attach+0xf8/0x198)
[    3.143448]  r6:00000001 r5:c11d2054 r4:c11d2010
[    3.148096] [<c05d0eb8>] (__device_attach) from [<c05d1db8>] (device_ini=
tial_probe+0x1c/0x20)
[    3.156713]  r6:c0da8630 r5:c11d2010 r4:c0da83cc
[    3.161361] [<c05d1d9c>] (device_initial_probe) from [<c05cff4c>] (bus_p=
robe_device+0x94/0x9c)
[    3.170054] [<c05cfeb8>] (bus_probe_device) from [<c05d0518>] (deferred_=
probe_work_func+0xa0/0xe8)
[    3.179108]  r7:c0dfdbc8 r6:c0da83d8 r5:c0da83cc r4:c0da83cc
[    3.184800] [<c05d0478>] (deferred_probe_work_func) from [<c0133a14>] (p=
rocess_one_work+0x204/0x4ac)
[    3.194041]  r10:c1052e0d r9:c100641c r8:c0def8a0 r7:00000000 r6:c1052e0=
0 r5:c117ff60
[    3.201912]  r4:c0da83f0 r3:c05d0478
[    3.205515] [<c0133810>] (process_one_work) from [<c0133f04>] (worker_th=
read+0x248/0x494)
[    3.213795]  r10:c117ff60 r9:c1008a40 r8:c117ff78 r7:c0d41f00 r6:c1008a1=
4 r5:c1008a00
[    3.221662]  r4:c1008a00
[    3.224221] [<c0133cbc>] (worker_thread) from [<c013c1b8>] (kthread+0x17=
c/0x18c)
[    3.231741]  r10:c110be88 r9:00000000 r8:c117ff60 r7:c0133cbc r6:c12602c=
0 r5:c1212000
[    3.239608]  r4:c126afc0
[    3.242169] [<c013c03c>] (kthread) from [<c01000d8>] (ret_from_fork+0x14=
/0x3c)
[    3.249481] Exception stack(0xc1213fb0 to 0xc1213ff8)
[    3.254582] 3fa0:                                     00000000 00000000 =
00000000 00000000
[    3.262814] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    3.271041] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    3.277710]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c013c03c
[    3.285574]  r4:c126afc0
[    3.288153] Code: 1a00015c e596014c e3500000 0a00010a (e5903098)
[    4.308986] ---[ end trace 88d80045989927f2 ]---

The problem is that in instruction e5903098 ("ldr r3, [r0, 0x98]") r0 is
dereferenced but it holds ERR_PTR(EPROBE_DEFER).

On Tue, Sep 21, 2021 at 08:37:54AM -0300, Fabio Estevam wrote:
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci=
_hdrc_imx.c
> index 8b7bc10b6e8b..f1d100671ee6 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -420,11 +420,16 @@ static int ci_hdrc_imx_probe(struct platform_device=
 *pdev)
>  	data->phy =3D devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
>  	if (IS_ERR(data->phy)) {
>  		ret =3D PTR_ERR(data->phy);
> -		/* Return -EINVAL if no usbphy is available */
> -		if (ret =3D=3D -ENODEV)
> -			data->phy =3D NULL;
> -		else
> -			goto err_clk;
> +		if (ret =3D=3D -ENODEV) {
> +			data->phy =3D devm_usb_get_phy_by_phandle(dev, "phys", 0);
> +			if (IS_ERR(data->phy)) {
> +				ret =3D PTR_ERR(data->phy);
> +				if (ret =3D=3D -ENODEV)
> +					data->phy =3D NULL;
> +				else
> +					goto err_clk;
> +			}
> +		}
>  	}
> =20
>  	pdata.usb_phy =3D data->phy;

The reason is that devm_usb_get_phy_by_phandle() in the first context
line here returned -EPROBE_DEFER but the new code doesn't jump to
err_clk any more in this case but happily hands an error pointer in
pdata.usb_phy to the chipidea driver.

For reference: The relevant part of the involved .dts looks as follows:

	#include "imx25.dtsi"
	...

	&usbhost1 {
		pinctrl-names =3D "default";
		pinctrl-0 =3D <&pinctrl_usbhost1>;
		vbus-supply =3D <&reg_usb5V>;
		phy_type =3D "serial";
		dr_mode =3D "host";
		disable-over-current;
		status =3D "okay";
	};

together with imx25.dtsi still using fsl,usbphy.

Note that 8253a34bfae3278baca52fc1209b7c29270486ca was already
backportet to some stable kernels:

$ git log --oneline --source ^linus/master $(git for-each-ref --format '%(r=
efname)' refs/remotes/stable/linux\*) --grep=3D8253a34bfae3278baca52fc1209b=
7c29270486ca
b3265b88e83b    refs/remotes/stable/linux-5.10.y usb: chipidea: ci_hdrc_imx=
: Also search for 'phys' phandle
66dd03b10e1c    refs/remotes/stable/linux-5.14.y usb: chipidea: ci_hdrc_imx=
: Also search for 'phys' phandle

Best regards
Uwe

 drivers/usb/chipidea/ci_hdrc_imx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_h=
drc_imx.c
index f1d100671ee6..45e81ba68d22 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -429,6 +429,8 @@ static int ci_hdrc_imx_probe(struct platform_device *pd=
ev)
 				else
 					goto err_clk;
 			}
+		} else {
+			goto err_clk;
 		}
 	}
=20
--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--mgjk6w5dt4qzncwl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmGfSnUACgkQwfwUeK3K
7Al38Qf/ehdGkgrruPGCa97WzmdgTC81r+e7BylQmSjEv4B5u3f2bWe3BWcCS3bg
u21Se33b1u/DMx5/Yxq9saWOopq/Btt+lBxiiNoyqCwgM5GA/WzD5AUQnDG2Limf
Ilst20lydPIq1TlFcWfDxClVNbx0HR+Tzzr/9kMKq8Vk7wpmmkQ7UeeG3S5M3Od5
fYobaJk0EZ3IDcNPhJGZUGglltX2I+k1wIThujmb5HLHvB13EsB4qwwQJ77ieYqY
Z/8LB8VfK/w9nVEDdTsEJEdzYxKQ/ICYw8AKur2BTVaP42Z8Ca44wCkkz20U+p7j
YMxYw6t/UruISu5WURxl70u9ns3Y/g==
=WbC+
-----END PGP SIGNATURE-----

--mgjk6w5dt4qzncwl--
