Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B9E6A3E29
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 10:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjB0JUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 04:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjB0JUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 04:20:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAED1EFC7
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 01:16:35 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWZcN-0000V3-V8; Mon, 27 Feb 2023 10:16:24 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWZcM-000aum-O8; Mon, 27 Feb 2023 10:16:22 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWZcM-000gvp-28; Mon, 27 Feb 2023 10:16:22 +0100
Date:   Mon, 27 Feb 2023 10:16:21 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        stable@vger.kernel.org, thierry.reding@gmail.com,
        tobetter@gmail.com, neil.armstrong@linaro.org, khilman@baylibre.com
Subject: Re: [PATCH] pwm: core: Zero-initialize the temp state
Message-ID: <20230227091621.ocxwbb6f7z5vysvx@pengutronix.de>
References: <20230226091752.wtnj7oqzmn6azahl@pengutronix.de>
 <20230227024830.2753712-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5yo3cleygtrpjkl5"
Content-Disposition: inline
In-Reply-To: <20230227024830.2753712-1-kamatam@amazon.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5yo3cleygtrpjkl5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sun, Feb 26, 2023 at 06:48:30PM -0800, Munehisa Kamata wrote:
> On Sun, 2023-02-26 09:17:52 +0000, Uwe Kleine-K=F6nig <u.kleine-koenig@pe=
ngutronix.de> wrote:
> > On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> > > Zero-initialize the on-stack structure to avoid unexpected behaviors.=
 Some
> > > drivers may not set or initialize all the values in pwm_state through=
 their
> > > .get_state() callback and therefore some random values may remain the=
re and
> > > be set into pwm->state eventually.
> > >=20
> > > This actually caused regression on ODROID-N2+ as reported in [1]; ker=
nel
> > > fails to boot due to random panic or hang-up.
> > >=20
> > > [1] https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360
> >=20
> > Looking through the report I wonder what actually made the machine fail
> > to boot. Doesn't this paper over a problem that should be fixed (also)
> > somewhere else?
>=20
> Yes, you're right and I think the commit message could have described more
> details. This patch is for ensuring all drivers see zeroed state same as
> before, but I still don't fully understand how it ends up such random-ish
> crashes. There could be another or bigger problem that should be fixed.
>=20
> > Which driver is the one that the problem occur for?
>=20
> It's pwm-meson and seems to be caused by random polarity value somehow. If
> meson_pwm_get_state() sets polarity to zero instead, I don't see the
> problem. According the comment, looks like the driver does not set polari=
ty
> by design.
>=20
>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
drivers/pwm/pwm-meson.c?h=3Dv6.2&id=3Dc9c3395d5e3dcc6daee66c6908354d47bf98c=
b0c#n9
>=20
> Before commit c73a3107624d, the memory was kcalloc'ed and always zeroed,
> but I don't know if the driver was (is) assuming that. I'm adding Meson S=
oC
> people to CC.
>=20
> Apart from how polarity should be handled in the driver, I'm very puzzled
> by the crashes I've observed so far. There seems to be some patterns, but
> they don't seem obviously related to PWM.
>=20
> [    1.360542] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40:2) =
Detected
> [    1.363906] Insufficient stack space to handle exception!
> [    1.363913] ESR: 0x0000000096000047 -- DABT (current EL)
> [    1.363917] FAR: 0xffff800009a47ff0
> [    1.363920] Task stack:     [0xffff800009a48000..0xffff800009a4c000]
> [    1.363923] IRQ stack:      [0xffff8000099a8000..0xffff8000099ac000]
> [    1.363927] Overflow stack: [0xffff000077b76100..0xffff000077b77100]
> [    1.363931] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.2.0-odroid-arm=
64 #47
> [    1.363938] Hardware name: Hardkernel ODROID-N2Plus (DT)
> [    1.363941] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    1.363947] pc : __do_kernel_fault+0x4/0x180
> [    1.363961] lr : do_page_fault+0xd0/0x3d0
> [    1.363968] sp : ffff800009a48020
> [    1.363970] x29: ffff800009a48020 x28: ffff000002948000 x27: 000000000=
0000000
> [    1.363980] x26: 0000000000000000 x25: 0000000000000000 x24: 000000000=
0000000
> [    1.363987] x23: 0000000096000004 x22: ffff800009a48110 x21: 00000000f=
fffffff
> [    1.363994] x20: ffff800009a48110 x19: 00000000ffffffff x18: 000000000=
000001c
> [    1.364001] x17: 00000000863047f6 x16: ffff800009860a80 x15: 000000000=
0000003
> [    1.364008] x14: 00000000000003ef x13: 0000000000000000 x12: 000000000=
0000279
> [    1.364015] x11: 0000000000000001 x10: 0000000000000001 x9 : 000000000=
0000400
> [    1.364021] x8 : ffff000077b7fc40 x7 : ffff000077b7fbc0 x6 : ffff80000=
94f7990
> [    1.364028] x5 : 0000000000000000 x4 : ffff000002948000 x3 : 000100000=
0000000
> [    1.364035] x2 : ffff800009a48110 x1 : 0000000096000004 x0 : 00000000f=
fffffff
> [    1.364043] Kernel panic - not syncing: kernel stack overflow
> [    1.364047] SMP: stopping secondary CPUs
>=20
> Another example:
>=20
> [    1.360997] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40:2) =
Detected
> [    1.364333] Unable to handle kernel NULL pointer dereference at virtua=
l address 0000000000000000
> [    1.364435] Unable to handle kernel paging request at virtual address =
0000000008003388
> [    1.367470] Internal error: Oops - Undefined instruction: 000000000200=
0000 [#1] PREEMPT SMP
> [    1.367483] Modules linked in:
> [    1.367490] CPU: 2 PID: 66 Comm: kworker/u12:1 Not tainted 6.2.0-odroi=
d-arm64 #47
> [    1.367498] Hardware name: Hardkernel ODROID-N2Plus (DT)
> [    1.367502] Workqueue: events_unbound async_run_entry_fn
> [    1.367516] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    1.367523] pc : arch_timer_handler_phys+0x0/0x44
> [    1.367535] lr : handle_percpu_devid_irq+0x84/0x140
> [    1.367543] sp : ffff8000099abf70
> [    1.367546] x29: ffff8000099abf70 x28: ffff000002a40000 x27: 000000000=
0000006
> [    1.367556] x26: ffff800009d208a4 x25: ffff800009d20b44 x24: 000000000=
0000008
> [    1.367565] x23: ffff8000094f8b50 x22: 000000000000000b x21: ffff00000=
2829000
> [    1.367573] x20: ffff800008f89fb0 x19: ffff00000282a600 x18: ffff00000=
21792e8
> [    1.367581] x17: ffff80006e685000 x16: ffff8000099ac000 x15: 000000000=
0004000
> [    1.367589] x14: ffff800009d27bde x13: ffff800009d2887b x12: 000000000=
0000308
> [    1.367597] x11: 0000000000000a92 x10: 0000000000000068 x9 : ef01a5948=
f440b31
> [    1.367606] x8 : 0000000000003273 x7 : ffff800009d262a8 x6 : 000000003=
754d375
> [    1.367614] x5 : ffff80006e685000 x4 : ffff8000099abf70 x3 : ffff80006=
e685000
> [    1.367622] x2 : ffff800008c26c30 x1 : ffff000077b83a00 x0 : 000000000=
000000b
> [    1.367630] Call trace:
> [    1.367633]  arch_timer_handler_phys+0x0/0x44
> [    1.367641]  generic_handle_domain_irq+0x2c/0x44
> [    1.367650]  gic_handle_irq+0x44/0xc4
> [    1.367659]  call_on_irq_stack+0x2c/0x5c
> [    1.367666]  do_interrupt_handler+0x80/0x84
> [    1.367672]  el1_interrupt+0x34/0x70
> [    1.367682]  el1h_64_irq_handler+0x18/0x2c
> [    1.367686]  el1h_64_irq+0x64/0x68
> [    1.367690]  HUF_decompress4X1_usingDTable_internal_default+0x2fc/0xd60
> [    1.367702]  HUF_decompress4X_hufOnly_wksp_bmi2+0xec/0x140
> [    1.367711]  ZSTD_decodeLiteralsBlock+0x580/0x630
> [    1.367717]  ZSTD_decompressBlock_internal.part.0+0x5c/0x1b4
> [    1.367723]  ZSTD_decompressBlock_internal+0x1c/0x30
> [    1.367729]  ZSTD_decompressContinue.part.0+0x364/0x444
> [    1.367734]  ZSTD_decompressContinueStream+0x98/0x180
> [    1.367738]  ZSTD_decompressStream+0x5b0/0x8c0
> [    1.367743]  zstd_decompress_stream+0x10/0x20
> [    1.367751]  unzstd+0x290/0x37c
> [    1.367760]  unpack_to_rootfs+0x174/0x298
> [    1.367767]  do_populate_rootfs+0x84/0x1dc
> [    1.367773]  async_run_entry_fn+0x34/0x150
> [    1.367778]  process_one_work+0x1d0/0x320
> [    1.367785]  worker_thread+0x14c/0x444
>=20
> Perhaps, the driver or the PWM core could do something wrong based on the
> invalid polarity and corrupt certain memory location, but I'm still not
> able to relate the random value to these crashes.

I can imagine that the compiler creates code (a jump table) that relies
on .polarity being either PWM_POLARITY_NORMAL or PWM_POLARITY_INVERSED
and that exibits UB if that isn't true. (I think the compiler is allowed
to do that.)

Looking at the driver, there are several problems:

 - The driver does just

   	if (state->polarity =3D=3D PWM_POLARITY_INVERSED)
   		duty =3D period - duty;

   which is broken because each period is supposed to start with the
   active part. (You could argue this being ridiculous and I'd agree.
   But that's what we have and just doing it differently in a driver is
   wrong.) The fix is to check if the hardware actually emits normal or
   inversed polarity and refuse the other one. Then in .get_state() set
   the appropriate polarity.

 - In meson_pwm_calc() we have:

   	unsigned int duty, ...;
  =20
   	duty =3D state->duty_cycle;

   which is wrong for state->duty_cycle > U32_MAX. The same for period.

 - After period is fixed to be proper u64, fin_freq * (u64)period might
   overflow.

 - harmless: The check

   	duty_cnt =3D div64_u64(fin_freq * (u64)duty,
   			     NSEC_PER_SEC * (pre_div + 1));
   	if (duty_cnt > 0xffff)
   		...

   never triggers, as duty <=3D period (after fixing the first issue) and
   we already know that

   	div64_u64(fin_freq * (u64)period, NSEC_PER_SEC * (pre_div + 1)) <=3D 0x=
ffff.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5yo3cleygtrpjkl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmP8dOIACgkQwfwUeK3K
7AlYFQgAic5LU6duEAwyhsi92+l0u8icDUlAfL6Z0kbF1GjD4SDpuQpgHZiewc9f
3ivlQqdpeeyh6qL+Mj/S7TXtTM5keOdjc5/n5sENP8UIfeYIXjlWDq1RZ8DLeCO4
QKz0mh6Uvcd/XiQwOebB/5rXStJa7oYAArxQyCCN7YhDLqchf3Ofyk1YVJlztzQ7
tbF4zg49oYawGsAkGDEOAkxnhjLfFF1RGwX/QEZrfto5cagf5+fYCRdZTMmZQmve
GRI3u5F9YniJNFy5MJdma1TMJQLjmQ3F8iHx0DSiwqMClWzhu36BKsPxQmMrw2LH
mDR8xwokuUiWTTlT2WZHHAyOJ7OqFA==
=EsFn
-----END PGP SIGNATURE-----

--5yo3cleygtrpjkl5--
