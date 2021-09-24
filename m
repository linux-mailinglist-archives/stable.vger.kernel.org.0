Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADF4175B5
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbhIXNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:31:31 -0400
Received: from mout.gmx.net ([212.227.17.20]:55629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344509AbhIXNb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
        s=badeba3b8450; t=1632490187;
        bh=DFSefilhraRmcDYtR1JwTbD7OMt5GAX7CLYIifQAll8=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:References:Date:In-Reply-To;
        b=OKh9sH/zXtTRwUc/6uItrV7xsEyYgC8QbPzVkTj71vM5X4EJyZ8vcev3NjDSmhdrp
         1FP/ZwbMv2bKIy4KCiyOpQX7YE0Q7dy1rPYvp2/98gjxSYJw6DKzqXzZHaNHLCQO8M
         lTqiGyOJ9dVTqHZU23pN2R7LFW7SWf0kX8nGyXJ4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M89Gt-1mYPyT3JSN-005Kmt; Fri, 24
 Sep 2021 15:29:46 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
 <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
 <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
 <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
Message-ID: <50bd6224-0f01-ca50-af0e-f79b933e7998@gmx.de>
Date:   Fri, 24 Sep 2021 15:29:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZvN7fgQ+0nS+cw3X/TFiyM9pyHfKUGSQle/tEG+Zz3UX2VMoMaZ
 D0YkZE0pcwObN5y1yoByixbPrp9fL5gHWdOwAyT8egW4B2uALhVK6qMS8s6pEDM8nv7Q/G1
 nNVam8IH3gqct7TNH1/RqYjVhUP9d9VAe+mK54O+6fVP0+JcjfIUYLn/KAA7fGsoovz2JFY
 81hdHFhcCVg7t6yRmHJKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fyIbybALCR8=:g+t9GWme8xAAd64oaA617W
 x9Kkq6IDdsG+/C4UiSpl5dQZmHxx8EsnM7jPgTjdq1Tx3l+92rvloItLdrdE8sC/NsDYKcOty
 EHcJA3+NTGhLVbNbIh6gNAO2sJQHvTYLHd1P/eEH8jjTAWHIxp2EtV17YO5EuImnRL7vinfzw
 pYxiMRAF8av0vOQ68IhAnyyI3RW6Ga9wpzdgZ/lB4vU7+T7JGA51rYclDqDsENdzyIqV7g5Km
 vXK6xbRELoDHTEVGblRKDn7+IRcxMqPpofI1mg/cXLBCtSjbW4jK8NGu7fhK6hmZvNCwz1zt9
 qLFZKiZwFFz6udhg596MCL1IiZWK3wXinB9NNur31x2ys6y9KsfhNM0DQAk2WM/x+7bRVVooB
 LxcPiQ+L0wSp6iBOY7JvvbAG7oso5AmpGPl7kBSlqSU2tEwZqeQCeUqK32x8uzPJN8N5DCZTG
 53cTCT1e6O4RP+00i77oEkFHUN2ab9oG4HOXYtxpeqZv5MgmrcmX0YdeA30cjgMcTopNzDpmh
 Tbt4QV7hPOwV2oxupvPdVBuLIWxpvE0EFTMavK1Cx0Ur9r2SjVXUmxX1wvB+wV6DIiMkn2UJQ
 SEQX0cTlIDx7z3y0I3SU19AkWDLYRPjU3SHRXotEDRLYH0o45HatBJ8z8OR8/aUUaBzZwyvMC
 NWgBzZjP3wMSkodybkot+PRjuiDHhBJkqJlJL7eQgIbROgdipN+CF2bQGvHBL9ClszWZOS92X
 XIMj+l31xkOP9Zab8WgELWo3wMbR/jD+Pj/BTMfLrjvOliwK+64XBCvoSwwd+T0zqy3b5P7Ef
 a17lQNuf91fHuYuUsVrV16HhYo2F8eEEQ1N0kWl9DcOxAGZ1kSxTiIqb5lSZT4xxxZU1u8uV+
 bCFhCpfSIOIzDbVxO0tJl0PHMfGmbfMazEbkKRy6phMWUlmSzk/fFb8oBD88Sa3JcUTr4YqkL
 /LR5Y5Mv6IV1y8ZQlslxFKFTx7886WMnEAKRV+rE9AEJWwwuzcLn9j7V+Glaruz6t6xhUSIB6
 24U+tV36VMBV8kZRXd/ecthYNGAQ2tAVJm5XABvVj+1MiHBC5qOQ38RBr3GWT5tf2B7/SdX5o
 igpNZLonsTEB34=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 14.09.21 at 02:31, Jarkko Sakkinen wrote:
> On Mon, 2021-09-13 at 22:53 +0200, Lino Sanfilippo wrote:
>> Hi,
>>
>>> Gesendet: Montag, 13. September 2021 um 22:25 Uhr
>>> Von: "Jarkko Sakkinen" <jarkko@kernel.org>
>>> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de, jgg@=
ziepe.ca
>>> Cc: p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org, linux-k=
ernel@vger.kernel.org, stable@vger.kernel.org
>>> Betreff: Re: [PATCH] tpm: fix potential NULL pointer access in tpm_del=
_char_device()
>>>
>>> On Fri, 2021-09-10 at 20:04 +0200, Lino Sanfilippo wrote:
>>>> In tpm_del_char_device() make sure that chip->ops is still valid.
>>>> This check is needed since in case of a system shutdown
>>>> tpm_class_shutdown() has already been called and set chip->ops to NUL=
L.
>>>> This leads to a NULL pointer access as soon as tpm_del_char_device()
>>>> tries to access chip->ops in case of TPM 2.
>>>>
>>>> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>>>> ---
>>>
>>> Have you been able to reproduce this in some environment?
>>>
>>> /Jarkko
>>>
>>>
>>
>> Yes, this bug is reproducable on my system that is running a 5.10 raspb=
erry kernel.
>> I use a SLB 9670 which is connected via SPI.
>
> Can you confirm that the lates mainline kernel has also this
> issue here? That is lacking in this fix.
>
> It's obvious that the issue does not scale to every system,
> so it would nice to know the difference that triggers the
> issue, before applying this, and it also needs to be
> documented to the commit message.
>

Sorry for the long delay in replying. I have tried to get a recent mainlin=
e kernel running
on my hardware but so far without success. Concerning the circumstances un=
der which this
bug triggers and if this also applies to the current mainline code please =
take a look at
the kernel dump on my system:

[  174.078277] 8<--- cut here ---
[  174.078288] Unable to handle kernel NULL pointer dereference at virtual=
 address 00000034
[  174.078293] pgd =3D 557a5fc9
[  174.078300] [00000034] *pgd=3D031cf003, *pmd=3D00000000
[  174.078317] Internal error: Oops: 206 [#1] SMP ARM
[  174.078323] Modules linked in: tpm_tis_spi tpm_tis_core tpm spidev gpio=
_pca953x mcp320x rtc_pcf2127 industrialio regmap_i2c regmap_spi 8021q garp=
 stp llc ftdi_sio6
[  174.078441] CPU: 3 PID: 1 Comm: systemd-shutdow Tainted: G        WC   =
     5.10.27-rt36-C4LS+ #1
[  174.078448] Hardware name: BCM2835
[  174.078451] PC is at tpm_chip_start+0x1c/0xc0 [tpm]
[  174.078492] LR is at tpm_chip_unregister+0xc0/0xe0 [tpm]
[  174.078525] pc : [<bf244080>]    lr : [<bf2447c8>]    psr: 20000013
[  174.078529] sp : c1903c38  ip : c1903c50  fp : c1903c4c
[  174.078533] r10: c1aca054  r9 : c0e77b28  r8 : c311c000
[  174.078537] r7 : 00000000  r6 : bf262010  r5 : c323fbf8  r4 : c323f800
[  174.078541] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c323f800
[  174.078546] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segmen=
t none
[  174.078553] Control: 30c5383d  Table: 02a47980  DAC: f7bd3313
[  174.078556] Process systemd-shutdow (pid: 1, stack limit =3D 0xa0551b1d=
)
[  174.078561] Stack: (0xc1903c38 to 0xc1904000)
[  174.078566] 3c20:                                                      =
 c323f800 c323fbf8
[  174.078574] 3c40: c1903c64 c1903c50 bf2447c8 bf244070 c323f800 c3498800=
 c1903c7c c1903c68
[  174.078581] 3c60: bf260190 bf244714 c3498800 c3498800 c1903c94 c1903c80=
 c08b9fa8 bf26017c
[  174.078588] 3c80: c3498800 00000000 c1903cb4 c1903c98 c0862b20 c08b9f7c=
 c1aaf730 c3498800
[  174.078595] 3ca0: c12fc9d0 00000000 c1903cc4 c1903cb8 c0862bf4 c0862a1c=
 c1903ce4 c1903cc8
[  174.078602] 3cc0: c08612d0 c0862be0 c3498800 00005744 c08ba298 00000000=
 c1903d2c c1903ce8
[  174.078609] 3ce0: c085c61c c0861200 ffffe000 c13404c0 c0781f40 c0e77b28=
 c1903d2c c1205048
[  174.078616] 3d00: c0332c3c c3498800 00000000 c08ba298 c13fdd7c c1356018=
 c0e77b28 c1aca054
[  174.078623] 3d20: c1903d44 c1903d30 c085c8d0 c085c498 c3498800 00000000=
 c1903d5c c1903d48
[  174.078630] 3d40: c08ba294 c085c8c0 c311c000 00000000 c1903d6c c1903d60=
 c08ba2b0 c08ba25c
[  174.078638] 3d60: c1903d9c c1903d70 c085bb90 c08ba2a4 c1903d8c c369a080=
 c369a114 c1205048
[  174.078645] 3d80: c1903da4 c311c000 c311c000 00000000 c1903dbc c1903da0=
 c08ba748 c085bb2c
[  174.078651] 3da0: c311c380 c311c000 00000000 c13fdd7c c1903ddc c1903dc0=
 bf168534 c08ba718
[  174.078659] 3dc0: c1aca000 c1a75010 c1aca010 c13fdd7c c1903df4 c1903de0=
 bf168588 bf16850c
[  174.078666] 3de0: c1aca014 c1a75010 c1903e04 c1903df8 c0863ca0 bf168578=
 c1903e3c c1903e08
[  174.078673] 3e00: c085fc90 c0863c80 c1903e3c c0e77b18 c0248888 00000000=
 00000000 8855a600
[  174.078680] 3e20: c120f1cc fee1dead c1902000 00000058 c1903e4c c1903e40=
 c0249eb0 c085fb00
[  174.078687] 3e40: c1903e64 c1903e50 c0249fa0 c0249e78 01234567 00000000=
 c1903f94 c1903e68
[  174.078694] 3e60: c024a244 c0249f90 c1903ed4 c2ec5180 00000024 c1903f58=
 00000005 c0441f50
[  174.078701] 3e80: c1903ec4 c1903e90 c0441d94 c0498350 00000000 c1903ea0=
 c0739fa4 00000024
[  174.078708] 3ea0: c2ec5180 c1903f58 c1903ed4 c2ec5180 00000005 00000000=
 c1903f4c c1903ec8
[  174.078715] 3ec0: c0441f50 c0425938 c1903ed0 c1903ed4 00000000 00000005=
 00000000 00000024
[  174.078722] 3ee0: c1903eec 00000005 c020007c bec81250 00000004 bec81f62=
 00000010 bec81264
[  174.078729] 3f00: 00000005 bec8131c 0000000a b6d0ef50 00000001 c0200e70=
 ffffe000 c13404c0
[  174.078736] 3f20: 00000000 c04673e8 c1903f4c c1205048 c2ec5180 bec8128c=
 00000000 00000000
[  174.078743] 3f40: c1903f94 c1903f50 c04420d0 c0441eb4 00000000 c13404c0=
 00000000 00000000
[  174.078750] 3f60: c1903f94 c1205048 c0332c3c c1205048 bec8131c 00000000=
 00000000 00000000
[  174.078757] 3f80: 00000058 c0200204 c1903fa4 c1903f98 c024a398 c024a13c=
 00000000 c1903fa8
[  174.078764] 3fa0: c0200040 c024a38c 00000000 00000000 fee1dead 28121969=
 01234567 8855a600
[  174.078771] 3fc0: 00000000 00000000 00000000 00000058 00000fff bec81be8=
 00000000 00456b80
[  174.078778] 3fe0: 00468e3c bec81b68 004534a8 b6e4ba38 60000010 fee1dead=
 00000000 00000000
[  174.078782] Backtrace:
[  174.078786] [<bf244064>] (tpm_chip_start [tpm]) from [<bf2447c8>] (tpm_=
chip_unregister+0xc0/0xe0 [tpm])
[  174.078853]  r5:c323fbf8 r4:c323f800
[  174.078855] [<bf244708>] (tpm_chip_unregister [tpm]) from [<bf260190>] =
(tpm_tis_spi_remove+0x20/0x30 [tpm_tis_spi])
[  174.078899]  r5:c3498800 r4:c323f800
[  174.078901] [<bf260170>] (tpm_tis_spi_remove [tpm_tis_spi]) from [<c08b=
9fa8>] (spi_drv_remove+0x38/0x50)
[  174.078923]  r5:c3498800 r4:c3498800
[  174.078926] [<c08b9f70>] (spi_drv_remove) from [<c0862b20>] (device_rel=
ease_driver_internal+0x110/0x1c4)
[  174.078942]  r5:00000000 r4:c3498800
[  174.078945] [<c0862a10>] (device_release_driver_internal) from [<c0862b=
f4>] (device_release_driver+0x20/0x24)
[  174.078959]  r7:00000000 r6:c12fc9d0 r5:c3498800 r4:c1aaf730
[  174.078962] [<c0862bd4>] (device_release_driver) from [<c08612d0>] (bus=
_remove_device+0xdc/0x108)
[  174.078973] [<c08611f4>] (bus_remove_device) from [<c085c61c>] (device_=
del+0x190/0x428)
[  174.078989]  r7:00000000 r6:c08ba298 r5:00005744 r4:c3498800
[  174.078992] [<c085c48c>] (device_del) from [<c085c8d0>] (device_unregis=
ter+0x1c/0x30)
[  174.079009]  r10:c1aca054 r9:c0e77b28 r8:c1356018 r7:c13fdd7c r6:c08ba2=
98 r5:00000000
[  174.079013]  r4:c3498800
[  174.079015] [<c085c8b4>] (device_unregister) from [<c08ba294>] (spi_unr=
egister_device+0x44/0x48)
[  174.079030]  r5:00000000 r4:c3498800
[  174.079033] [<c08ba250>] (spi_unregister_device) from [<c08ba2b0>] (__u=
nregister+0x18/0x20)
[  174.079048]  r5:00000000 r4:c311c000
[  174.079050] [<c08ba298>] (__unregister) from [<c085bb90>] (device_for_e=
ach_child+0x70/0xb4)
[  174.079064] [<c085bb20>] (device_for_each_child) from [<c08ba748>] (spi=
_unregister_controller+0x3c/0x134)
[  174.079081]  r6:00000000 r5:c311c000 r4:c311c000
[  174.079083] [<c08ba70c>] (spi_unregister_controller) from [<bf168534>] =
(bcm2835_spi_remove+0x34/0x6c [spi_bcm2835])
[  174.079104]  r7:c13fdd7c r6:00000000 r5:c311c000 r4:c311c380
[  174.079107] [<bf168500>] (bcm2835_spi_remove [spi_bcm2835]) from [<bf16=
8588>] (bcm2835_spi_shutdown+0x1c/0x38 [spi_bcm2835])
[  174.079130]  r7:c13fdd7c r6:c1aca010 r5:c1a75010 r4:c1aca000
[  174.079132] [<bf16856c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<c0=
863ca0>] (platform_drv_shutdown+0x2c/0x30)
[  174.079150]  r5:c1a75010 r4:c1aca014
[  174.079153] [<c0863c74>] (platform_drv_shutdown) from [<c085fc90>] (dev=
ice_shutdown+0x19c/0x24c)
[  174.079164] [<c085faf4>] (device_shutdown) from [<c0249eb0>] (kernel_re=
start_prepare+0x44/0x48)
[  174.079183]  r10:00000058 r9:c1902000 r8:fee1dead r7:c120f1cc r6:8855a6=
00 r5:00000000
[  174.079186]  r4:00000000
[  174.079189] [<c0249e6c>] (kernel_restart_prepare) from [<c0249fa0>] (ke=
rnel_restart+0x1c/0x60)
[  174.079203] [<c0249f84>] (kernel_restart) from [<c024a244>] (__do_sys_r=
eboot+0x114/0x1f8)
[  174.079218]  r5:00000000 r4:01234567
[  174.079221] [<c024a130>] (__do_sys_reboot) from [<c024a398>] (sys_reboo=
t+0x18/0x1c)
[  174.079238]  r8:c0200204 r7:00000058 r6:00000000 r5:00000000 r4:0000000=
0
[  174.079241] [<c024a380>] (sys_reboot) from [<c0200040>] (ret_fast_sysca=
ll+0x0/0x28)
[  174.079254] Exception stack(0xc1903fa8 to 0xc1903ff0)
[  174.079260] 3fa0:                   00000000 00000000 fee1dead 28121969=
 01234567 8855a600
[  174.079267] 3fc0: 00000000 00000000 00000000 00000058 00000fff bec81be8=
 00000000 00456b80
[  174.079273] 3fe0: 00468e3c bec81b68 004534a8 b6e4ba38
[  174.079280] Code: e52de004 e8bd4000 e5903410 e1a04000 (e5932034)
[  174.079285] ---[ end trace 33e1042219f38210 ]---
[  174.879428] Kernel panic - not syncing:
[  174.879432] Attempted to kill init! exitcode=3D0x0000000b


Note that before this bug happens all pre_shutdown handlers have already b=
een executed
including tpm_class_shutdown() which sets chip->ops to NULL.

So this bug is triggered when the bcm2835 drivers shutdown() function is c=
alled since this
driver does something quite unusual: it unregisters the spi controller in =
its shutdown()
handler.

This eventually results in a call to tpm_del_char_device(). This is not pr=
oblematic unless we have
TPM2, since in this case tpm_chip_start() is called and chip->ops is acces=
sed again, resulting in
the NULL pointer access.

So to make it short the combination of
- the tpm chips pre_shutdown handler setting chip->ops to NULL
- the use of the bcm2835 driver with the spi controller deregistration in =
its shutdown function
- the use of TPM 2

results in the situation in which this bug can trigger.

AFAICS this is still the case in the mainline code. Also note that with th=
e
freescale LPSPI controller driver there is another driver that unregisters=
 the spi
controller in its shutdown function.


Please let me know if you need further information.

Regards,
Lino

