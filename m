Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A851D5B5857
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiILK2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiILK2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:28:41 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D839B9C;
        Mon, 12 Sep 2022 03:28:39 -0700 (PDT)
Received: from mercury (unknown [185.122.133.20])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D03A56601FE5;
        Mon, 12 Sep 2022 11:28:37 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1662978518;
        bh=vPsKRiYy0nZnB40FtC/crO35pXfpHPIoWvK2ZW3Jbsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXqVLwWVbHwQQeuQJIi9DuAWEpEnNDq28CNYm8wZWWSLQDOltzyqxGVKh6JzWWlwU
         fS8dqwhOu8qFcxGcEykIbCUlHghoG/RZzOkcrwgzcQ0A7MtMJqcrstT0jAKMijGe0C
         oqKq3h6ZGul0XgUGg42Irpi/RznJ+tVWD1caXDcnjuUz/ilJKl3llBn9K1AVA3PCSj
         EYS92HSgk2fc584x0mssl/p6Y7BCZNa9KtnkZ92pjC9cQcyveQZc3aZSaAOmWLs3mJ
         WLnPGWPiNah62pMZ2r9v/7bODGw0MpIUXRcjCC/jsLCNMLlX5b2wuEYgzNWjexmcbU
         rdfTwAEFFPNkw==
Received: by mercury (Postfix, from userid 1000)
        id CFDCD106335C; Sun, 11 Sep 2022 14:33:46 +0200 (CEST)
Date:   Sun, 11 Sep 2022 14:33:46 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in
 __power_supply_is_system_supplied
Message-ID: <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ua5n5ln7ikkh4lj7"
Content-Disposition: inline
In-Reply-To: <20220905172428.105564-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ua5n5ln7ikkh4lj7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 05, 2022 at 07:24:28PM +0200, Jason A. Donenfeld wrote:
> Fix the following OOPS:
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0010 [#1] PREEMPT SMP
> CPU: 14 PID: 1156 Comm: upowerd Tainted: G S   U             6.0.0-rc1+ #=
366
> Hardware name: LENOVO 20Y5CTO1WW/20Y5CTO1WW, BIOS N40ET36W (1.18 ) 07/19/=
2022
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff88815350bd08 EFLAGS: 00010212
> RAX: ffff88810207d620 RBX: ffff88815350bd7c RCX: 000000000000394e
> RDX: ffff88815350bd10 RSI: 0000000000000004 RDI: ffff888111722c00
> RBP: ffff88815350bd68 R08: ffff8881187a8af8 R09: ffff8881187a8af8
> R10: 0000000000000000 R11: 000000000000005f R12: ffffffff8162d0b0
> R13: ffff88810159a038 R14: ffffffff823b3768 R15: ffff88810159a000
> FS:  00007fd1f0958140(0000) GS:ffff88901f780000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000152c7a004 CR4: 0000000000770ee0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __power_supply_is_system_supplied+0x26/0x40
>  class_for_each_device+0xa5/0xd0
>  ? acpi_battery_get_state+0x4e/0x1f0
>  power_supply_is_system_supplied+0x26/0x40
>  acpi_battery_get_property+0x301/0x310
>  power_supply_show_property+0xa5/0x1d0
>  dev_attr_show+0x10/0x30
>  sysfs_kf_seq_show+0x78/0xc0
>  seq_read_iter+0xfd/0x3e0
>  vfs_read+0x1cb/0x290
>  ksys_read+0x4e/0xc0
>  do_syscall_64+0x2b/0x50
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fd1f0bed70c
> Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 39 a4 f8 ff 41 8=
9 c0 48 8b 54 24 18 48 8b 74 24 10 8b 7c 24 08 31 c0 0f 05 <48> 3d 00 f0 ff=
 ff 77 34 44 89 c7 48 89 44 24 08 e8 8f a4 f8 ff 48
> RSP: 002b:00007ffc8d3f27e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd1f0bed70c
> RDX: 0000000000001000 RSI: 000055957d534850 RDI: 000000000000000c
> RBP: 000055957d50b1d0 R08: 0000000000000000 R09: 0000000000001000
> R10: 000000000000006f R11: 0000000000000246 R12: 00007ffc8d3f2910
> R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000c
>  </TASK>
>=20
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff88815350bd08 EFLAGS: 00010212
> RAX: ffff88810207d620 RBX: ffff88815350bd7c RCX: 000000000000394e
> RDX: ffff88815350bd10 RSI: 0000000000000004 RDI: ffff888111722c00
> RBP: ffff88815350bd68 R08: ffff8881187a8af8 R09: ffff8881187a8af8
> R10: 0000000000000000 R11: 000000000000005f R12: ffffffff8162d0b0
> R13: ffff88810159a038 R14: ffffffff823b3768 R15: ffff88810159a000
> FS:  00007fd1f0958140(0000) GS:ffff88901f780000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000152c7a004 CR4: 0000000000770ee0
>=20
> The disassembly of the top function in the stack trace is:
>=20
> .text:0000000000000000 __power_supply_is_system_supplied proc near
> .text:0000000000000000                                         ; DATA XRE=
F: power_supply_is_system_supplied+12=E2=86=93o
> .text:0000000000000000
> .text:0000000000000000 var_8           =3D qword ptr -8
> .text:0000000000000000
> .text:0000000000000000                 sub     rsp, 8
> .text:0000000000000004                 mov     rdi, [rdi+78h]
> .text:0000000000000008                 inc     dword ptr [rsi]
> .text:000000000000000A                 mov     [rsp+8+var_8], 0
> .text:0000000000000012                 mov     rax, [rdi]
> .text:0000000000000015                 cmp     dword ptr [rax+8], 1
> .text:0000000000000019                 jz      short loc_2A
> .text:000000000000001B                 mov     rdx, rsp
> .text:000000000000001E                 mov     esi, 4
> .text:0000000000000023                 call    qword ptr [rax+30h]
> .text:0000000000000026                 test    eax, eax
> .text:0000000000000028                 jz      short loc_31
> .text:000000000000002A
> .text:000000000000002A loc_2A:                                 ; CODE XRE=
F: __power_supply_is_system_supplied+19=E2=86=91j
> .text:000000000000002A                 xor     eax, eax
> .text:000000000000002C                 add     rsp, 8
> .text:0000000000000030                 retn
> .text:0000000000000031 ; ------------------------------------------------=
---------------------------
> .text:0000000000000031
> .text:0000000000000031 loc_31:                                 ; CODE XRE=
F: __power_supply_is_system_supplied+28=E2=86=91j
> .text:0000000000000031                 mov     eax, dword ptr [rsp+8+var_=
8]
> .text:0000000000000034                 add     rsp, 8
> .text:0000000000000038                 retn
> .text:0000000000000038 __power_supply_is_system_supplied endp
>=20
> So presumably `call    qword ptr [rax+30h]` is jumping to NULL.
>=20
> Cc: stable@vger.kernel.org
> Acked-by: Rafael J. Wysocki <rafael@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/power/supply/power_supply_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/sup=
ply/power_supply_core.c
> index 4b5fb172fa99..aa4c97f11588 100644
> --- a/drivers/power/supply/power_supply_core.c
> +++ b/drivers/power/supply/power_supply_core.c
> @@ -349,7 +349,7 @@ static int __power_supply_is_system_supplied(struct d=
evice *dev, void *data)
>  	unsigned int *count =3D data;
> =20
>  	(*count)++;
> -	if (psy->desc->type !=3D POWER_SUPPLY_TYPE_BATTERY)
> +	if (psy->desc->type !=3D POWER_SUPPLY_TYPE_BATTERY && psy->desc->get_pr=
operty)
>  		if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE,
>  					&ret))
>  			return ret.intval;

Thanks, queued into power-supply's fixes branch. But I'm curioous
how you triggered this. Which power-supply driver does not add
a get_property function?

-- Sebastian

--ua5n5ln7ikkh4lj7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmMd1aoACgkQ2O7X88g7
+poYOQ//VFZgMEe52+39lTF9TA1HeaUgfTP+vySwmdUOg0qpAafRF6ww3AXMMRHj
K7+JV/8iC4lwErytIG65xorFxdA8Ou4h5b2mybZkYs7aQT9iAes5WQITu1jTfsi3
Bv0DfBAg/Ar7e98n/S/keSmNsd81D/GhI7btl4Ou0vzhq+rrDxjeUPP8Ozlcw0BF
nINc7qZjKA00BqYIo8uKWRPmq2fqQQO94LN61b521netLa/K0BxQnp9NgW7r598W
QSZ1S0FdS41t53Tgph8DWeZWvTT4wu3JHjR5Its8UdRMf6WgGIRvofMBR6XaXzHd
2Po0kFT3sLO5VMuXLfGjN3HIrsPkHH1evNewFYe3aZqzPw1oIbteqOdNAiU5jRwI
AJV85eHjxX+1lgruApv0FyTPEtAxkYGkzmA72Q2DTs5hVlmJgseVY7tlOCLaFQDz
pDKxCbxpsnPqEpY5XZmMXyDqoP2omwcm0usrASSwfr5MWio1k4WxiMOH6gVGvN4A
P6AhhCgOoNtXITSXH6Hz09SQuX1mgK3eDgayZwq2kmz3wxilMCenowdPjtXOLxMu
cDZJhWZ3Nm7fZdw2kalv6Q6ggvV+Zs7Ygv19pLpHJdM4l0yWZdXh2zOugVFTWge0
8kD0vD//6s6MUealORrl2Q7fsysT2R45f9A3uTidaQMQER6uBr8=
=e/gD
-----END PGP SIGNATURE-----

--ua5n5ln7ikkh4lj7--
