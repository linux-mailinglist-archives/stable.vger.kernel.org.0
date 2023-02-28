Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CB6A55FD
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjB1Jj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 04:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1JjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 04:39:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B803840F0
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 01:39:20 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWwS2-0007yZ-28; Tue, 28 Feb 2023 10:39:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWwS0-000pur-QQ; Tue, 28 Feb 2023 10:39:12 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pWwS0-000yvW-1b; Tue, 28 Feb 2023 10:39:12 +0100
Date:   Tue, 28 Feb 2023 10:39:11 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     khilman@baylibre.com, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, neil.armstrong@linaro.org,
        stable@vger.kernel.org, thierry.reding@gmail.com
Subject: Re: [PATCH] pwm: core: Zero-initialize the temp state
Message-ID: <20230228093911.bh2sbp4tyfir2z5g@pengutronix.de>
References: <20230227091621.ocxwbb6f7z5vysvx@pengutronix.de>
 <20230228085328.909555-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hbotrjaiixoeedfa"
Content-Disposition: inline
In-Reply-To: <20230228085328.909555-1-kamatam@amazon.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hbotrjaiixoeedfa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Feb 28, 2023 at 12:53:28AM -0800, Munehisa Kamata wrote:
> On Mon, 2023-02-27 09:16:21 +0000, Uwe Kleine-K=F6nig wrote:
> > On Sun, Feb 26, 2023 at 06:48:30PM -0800, Munehisa Kamata wrote:
> > > On Sun, 2023-02-26 09:17:52 +0000, Uwe Kleine-K=F6nig <u.kleine-koeni=
g@pengutronix.de> wrote:
> > > > On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> > > > > Zero-initialize the on-stack structure to avoid unexpected behavi=
ors. Some
> > > > > drivers may not set or initialize all the values in pwm_state thr=
ough their
> > > > > .get_state() callback and therefore some random values may remain=
 there and
> > > > > be set into pwm->state eventually.
> > > > >=20
> > > > > This actually caused regression on ODROID-N2+ as reported in [1];=
 kernel
> > > > > fails to boot due to random panic or hang-up.
> > > > >=20
> > > > > [1] https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360
> > > >=20
> > > > Looking through the report I wonder what actually made the machine =
fail
> > > > to boot. Doesn't this paper over a problem that should be fixed (al=
so)
> > > > somewhere else?
> > >=20
> > > Yes, you're right and I think the commit message could have described=
 more
> > > details. This patch is for ensuring all drivers see zeroed state same=
 as
> > > before, but I still don't fully understand how it ends up such random=
-ish
> > > crashes. There could be another or bigger problem that should be fixe=
d.
> > >=20
> > > > Which driver is the one that the problem occur for?
> > >=20
> > > It's pwm-meson and seems to be caused by random polarity value someho=
w. If
> > > meson_pwm_get_state() sets polarity to zero instead, I don't see the
> > > problem. According the comment, looks like the driver does not set po=
larity
> > > by design.
> > >=20
> > >  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/drivers/pwm/pwm-meson.c?h=3Dv6.2&id=3Dc9c3395d5e3dcc6daee66c6908354d47b=
f98cb0c#n9
> > >=20
> > > Before commit c73a3107624d, the memory was kcalloc'ed and always zero=
ed,
> > > but I don't know if the driver was (is) assuming that. I'm adding Mes=
on SoC
> > > people to CC.
> > >=20
> > > Apart from how polarity should be handled in the driver, I'm very puz=
zled
> > > by the crashes I've observed so far. There seems to be some patterns,=
 but
> > > they don't seem obviously related to PWM.
> > >=20
> > > [    1.360542] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40=
:2) Detected
> > > [    1.363906] Insufficient stack space to handle exception!
> > > [    1.363913] ESR: 0x0000000096000047 -- DABT (current EL)
> > > [    1.363917] FAR: 0xffff800009a47ff0
> > > [    1.363920] Task stack:     [0xffff800009a48000..0xffff800009a4c00=
0]
> > > [    1.363923] IRQ stack:      [0xffff8000099a8000..0xffff8000099ac00=
0]
> > > [    1.363927] Overflow stack: [0xffff000077b76100..0xffff000077b7710=
0]
> > > [    1.363931] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.2.0-odroid=
-arm64 #47
> > > [    1.363938] Hardware name: Hardkernel ODROID-N2Plus (DT)
> > > [    1.363941] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
> > > [    1.363947] pc : __do_kernel_fault+0x4/0x180
> > > [    1.363961] lr : do_page_fault+0xd0/0x3d0
> > > [    1.363968] sp : ffff800009a48020
> > > [    1.363970] x29: ffff800009a48020 x28: ffff000002948000 x27: 00000=
00000000000
> > > [    1.363980] x26: 0000000000000000 x25: 0000000000000000 x24: 00000=
00000000000
> > > [    1.363987] x23: 0000000096000004 x22: ffff800009a48110 x21: 00000=
000ffffffff
> > > [    1.363994] x20: ffff800009a48110 x19: 00000000ffffffff x18: 00000=
0000000001c
> > > [    1.364001] x17: 00000000863047f6 x16: ffff800009860a80 x15: 00000=
00000000003
> > > [    1.364008] x14: 00000000000003ef x13: 0000000000000000 x12: 00000=
00000000279
> > > [    1.364015] x11: 0000000000000001 x10: 0000000000000001 x9 : 00000=
00000000400
> > > [    1.364021] x8 : ffff000077b7fc40 x7 : ffff000077b7fbc0 x6 : ffff8=
000094f7990
> > > [    1.364028] x5 : 0000000000000000 x4 : ffff000002948000 x3 : 00010=
00000000000
> > > [    1.364035] x2 : ffff800009a48110 x1 : 0000000096000004 x0 : 00000=
000ffffffff
> > > [    1.364043] Kernel panic - not syncing: kernel stack overflow
> > > [    1.364047] SMP: stopping secondary CPUs
> > >=20
> > > Another example:
> > >=20
> > > [    1.360997] soc soc0: Amlogic Meson G12B (S922X) Revision 29:c (40=
:2) Detected
> > > [    1.364333] Unable to handle kernel NULL pointer dereference at vi=
rtual address 0000000000000000
> > > [    1.364435] Unable to handle kernel paging request at virtual addr=
ess 0000000008003388
> > > [    1.367470] Internal error: Oops - Undefined instruction: 00000000=
02000000 [#1] PREEMPT SMP
> > > [    1.367483] Modules linked in:
> > > [    1.367490] CPU: 2 PID: 66 Comm: kworker/u12:1 Not tainted 6.2.0-o=
droid-arm64 #47
> > > [    1.367498] Hardware name: Hardkernel ODROID-N2Plus (DT)
> > > [    1.367502] Workqueue: events_unbound async_run_entry_fn
> > > [    1.367516] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
> > > [    1.367523] pc : arch_timer_handler_phys+0x0/0x44
> > > [    1.367535] lr : handle_percpu_devid_irq+0x84/0x140
> > > [    1.367543] sp : ffff8000099abf70
> > > [    1.367546] x29: ffff8000099abf70 x28: ffff000002a40000 x27: 00000=
00000000006
> > > [    1.367556] x26: ffff800009d208a4 x25: ffff800009d20b44 x24: 00000=
00000000008
> > > [    1.367565] x23: ffff8000094f8b50 x22: 000000000000000b x21: ffff0=
00002829000
> > > [    1.367573] x20: ffff800008f89fb0 x19: ffff00000282a600 x18: ffff0=
000021792e8
> > > [    1.367581] x17: ffff80006e685000 x16: ffff8000099ac000 x15: 00000=
00000004000
> > > [    1.367589] x14: ffff800009d27bde x13: ffff800009d2887b x12: 00000=
00000000308
> > > [    1.367597] x11: 0000000000000a92 x10: 0000000000000068 x9 : ef01a=
5948f440b31
> > > [    1.367606] x8 : 0000000000003273 x7 : ffff800009d262a8 x6 : 00000=
0003754d375
> > > [    1.367614] x5 : ffff80006e685000 x4 : ffff8000099abf70 x3 : ffff8=
0006e685000
> > > [    1.367622] x2 : ffff800008c26c30 x1 : ffff000077b83a00 x0 : 00000=
0000000000b
> > > [    1.367630] Call trace:
> > > [    1.367633]  arch_timer_handler_phys+0x0/0x44
> > > [    1.367641]  generic_handle_domain_irq+0x2c/0x44
> > > [    1.367650]  gic_handle_irq+0x44/0xc4
> > > [    1.367659]  call_on_irq_stack+0x2c/0x5c
> > > [    1.367666]  do_interrupt_handler+0x80/0x84
> > > [    1.367672]  el1_interrupt+0x34/0x70
> > > [    1.367682]  el1h_64_irq_handler+0x18/0x2c
> > > [    1.367686]  el1h_64_irq+0x64/0x68
> > > [    1.367690]  HUF_decompress4X1_usingDTable_internal_default+0x2fc/=
0xd60
> > > [    1.367702]  HUF_decompress4X_hufOnly_wksp_bmi2+0xec/0x140
> > > [    1.367711]  ZSTD_decodeLiteralsBlock+0x580/0x630
> > > [    1.367717]  ZSTD_decompressBlock_internal.part.0+0x5c/0x1b4
> > > [    1.367723]  ZSTD_decompressBlock_internal+0x1c/0x30
> > > [    1.367729]  ZSTD_decompressContinue.part.0+0x364/0x444
> > > [    1.367734]  ZSTD_decompressContinueStream+0x98/0x180
> > > [    1.367738]  ZSTD_decompressStream+0x5b0/0x8c0
> > > [    1.367743]  zstd_decompress_stream+0x10/0x20
> > > [    1.367751]  unzstd+0x290/0x37c
> > > [    1.367760]  unpack_to_rootfs+0x174/0x298
> > > [    1.367767]  do_populate_rootfs+0x84/0x1dc
> > > [    1.367773]  async_run_entry_fn+0x34/0x150
> > > [    1.367778]  process_one_work+0x1d0/0x320
> > > [    1.367785]  worker_thread+0x14c/0x444
> > >=20
> > > Perhaps, the driver or the PWM core could do something wrong based on=
 the
> > > invalid polarity and corrupt certain memory location, but I'm still n=
ot
> > > able to relate the random value to these crashes.
> >=20
> > I can imagine that the compiler creates code (a jump table) that relies
> > on .polarity being either PWM_POLARITY_NORMAL or PWM_POLARITY_INVERSED
> > and that exibits UB if that isn't true. (I think the compiler is allowed
> > to do that.)
> >=20
> > Looking at the driver, there are several problems:
> >=20
> >  - The driver does just
> >=20
> >    	if (state->polarity =3D=3D PWM_POLARITY_INVERSED)
> >    		duty =3D period - duty;
> >=20
> >    which is broken because each period is supposed to start with the
> >    active part. (You could argue this being ridiculous and I'd agree.
> >    But that's what we have and just doing it differently in a driver is
> >    wrong.) The fix is to check if the hardware actually emits normal or
> >    inversed polarity and refuse the other one. Then in .get_state() set
> >    the appropriate polarity.
>=20
> Looking at the comment in the source, I'm not sure if such checking is=20
> possible with this hardware.

If I understand the situation right the driver claims to support both
polarities, but if inverted polarity (i.e.

                    ___            ___            ___            ___
	\__________/   \__________/   \__________/   \__________/   \
	^              ^              ^              ^              ^

) is requested it just emits a wave form with normal polarity and
duty_cycle adapted to match the "activity average" (i.e.

         ___            ___            ___            ___           =20
	/   \__________/   \__________/   \__________/   \__________/
	^              ^              ^              ^              ^

). That it's impossible to determine the polarity is obvious then.
That's like a fruiterer who ships apples no matter if apples or oranges
where ordered and who should look at a shipped fruit and tell if this
belongs to a shipment of apples or oranges.

So the actual problem is not "the driver cannot determine polarity", but
"the driver must not fake support for inverted polarity".

> From pwm-meson.c:
>  * The hardware has no "polarity" setting. This driver reverses the period
>  * cycles (the low length is inverted with the high length) for
>  * PWM_POLARITY_INVERSED. This means that .get_state cannot read the pola=
rity
>  * from the hardware.
>=20
> As far as I see, there seems to be some drivers that hard-code polarity in
> .get_state() without getting it from hardware. Perhaps, we could do that
> instead?

This is the right thing to do for hardware that only supports a single
polarity. This should be matched by

	if (state->polarity !=3D PWM_POLARITY_INVERSED)
		return -EINVAL;

in .apply(). (Depending on which polarity is actually supported, the
test has to be adapted.)

> Honestly, I don't understand how it's a bad idea here.

For dimming a LED it doesn't matter. If you drive a motor and need to
sync the PWM signal to something else (another PWM or an enable GPIO) it
might matter. (Of course today's PWM framework doesn't support such a
synchronization and if I hadn't marked the period starts above there
would be no way to distinguish the above wave forms. It might only be
identified by an external observer while the wave configuration changes
and even that is hardware dependant. That's why I wrote about polarity
being ridiculous in an earlier mail.)

> >  - In meson_pwm_calc() we have:
> >=20
> >    	unsigned int duty, ...;
> >   =20
> >    	duty =3D state->duty_cycle;
> >=20
> >    which is wrong for state->duty_cycle > U32_MAX. The same for period.
> >=20
> >  - After period is fixed to be proper u64, fin_freq * (u64)period might
> >    overflow.
> >=20
> >  - harmless: The check
> >=20
> >    	duty_cnt =3D div64_u64(fin_freq * (u64)duty,
> >    			     NSEC_PER_SEC * (pre_div + 1));
> >    	if (duty_cnt > 0xffff)
> >    		...
> >=20
> >    never triggers, as duty <=3D period (after fixing the first issue) a=
nd
> >    we already know that
> >=20
> >    	div64_u64(fin_freq * (u64)period, NSEC_PER_SEC * (pre_div + 1)) <=
=3D 0xffff.
>=20
> Ah, I believe this requires a separate fix.

Yes. Three separate changes even, I'd say.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--hbotrjaiixoeedfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmP9y7kACgkQwfwUeK3K
7Amf0wf+M7701A/awejWRO37aa+/WBlZ9oGztWqszH418+jAOLnUMyUKNbIlSwg3
2SmVm2y+TnsQTQS3FLXfmhNXwl0jttuz7uM8zZav9JKYXqWd6r8FIbPqadCNIYVL
6jO4HowG2DJXrcsHxCbr1g3QsA5BgAnVTQ0f3YnQ+k5gb2dendmw2XFa4RaiGOFT
Mxg2EQSGmsz4Oet2dHN6XKoakCKDnoj1oQo0fZ85tiKYh0Stv4BEf/9hiS7ciSuE
Uvy7YRugRy2gKNrdig9a3vnq+EFQCfaNQ9TF6dOEQwARkH4ClIbzmEowCRc7qAf8
j+1jcykUwSfOlSa/Mhrm85LIu8bEgA==
=bhp5
-----END PGP SIGNATURE-----

--hbotrjaiixoeedfa--
