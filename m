Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B855187DB
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 17:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiECPKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiECPKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 11:10:20 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C7735A9B;
        Tue,  3 May 2022 08:06:46 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kt3Fw4K0Pz4xXk;
        Wed,  4 May 2022 01:06:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1651590404;
        bh=Dgg0y2YAJVCYq+A7nlozqofEZc1GspCWNF8o1AxIhDk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oOj5zvnan2Y/BMYEpzl5Az0MK3LSXnm9Hl0SuV96bsd1io91AjtKlq4SX1yV6iLvd
         VPqPSG64Jl4UNBj9/Fhnb0iMsGHn6qOzrTiKdy99kLv6mUDg5ppeRtSEWiJCmZKzKW
         LYaQC2WhJ9AJjpfRegXbTRn2gdmWqTZcRUSpWXQF0bo5zFdstIk7j9VNGQO3G2TgsH
         3S29CDT+RNxq9v1fbWp+uO+1oATO/8o1WwIO9ZeHe92UfFt7xUcw8uJcRMKJIO3Cek
         xwHV8E8EvrIyBohVYTVFefLXaxdmi7Sz5So1X4nVaLST8pOpH1Ebzzn/Byyy30yXne
         00KbkEONIoFJQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
In-Reply-To: <20220401140634.65726-1-ldufour@linux.ibm.com>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
Date:   Wed, 04 May 2022 01:06:41 +1000
Message-ID: <87r15aveny.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Laurent Dufour <ldufour@linux.ibm.com> writes:
> RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
> mode (MSR[SF] unset).

Probably also worth mentioning that it runs in big endian mode :)

It is specified in PAPR (R1-7.2.1-6).

> The change in MSR is done in enter_rtas() in a relatively complex way,
> since the MSR value could be hardcoded.
>
> Furthermore, a panic has been reported when hitting the watchdog interrupt
> while running in RTAS, this leads to the following stack trace:
>
> [69244.027433][   C24] watchdog: CPU 24 Hard LOCKUP
> [69244.027442][   C24] watchdog: CPU 24 TB:997512652051031, last heartbea=
t TB:997504470175378 (15980ms ago)
> [69244.027451][   C24] Modules linked in: chacha_generic(E) libchacha(E) =
xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) li=
bpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rn=
g(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_=
generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camel=
lia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) alg=
if_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rp=
cgss(E)
> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(=
E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netl=
ink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(=
E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_=
vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) con=
figfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E)=
 t10_pi(E)
> [69244.027555][   C24]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf1=
28mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) r=
aid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) d=
m_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
> [69244.027587][   C24] Supported: No, Unreleased kernel
> [69244.027600][   C24] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Taint=
ed: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP=
4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
> [69244.027609][   C24] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0=
000000000000000
> [69244.027612][   C24] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G    =
        E  X     (5.14.21-150400.71.1.bz196362_2-default)
> [69244.027615][   C24] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 488000=
02  XER: 20040020
> [69244.027625][   C24] CFAR: 000000000000011c IRQMASK: 1
> [69244.027625][   C24] GPR00: 0000000000000003 ffffffffffffffff 000000000=
0000001 00000000000050dc
> [69244.027625][   C24] GPR04: 000000001ffb6100 0000000000000020 000000000=
0000001 000000001fb09010
> [69244.027625][   C24] GPR08: 0000000020000000 0000000000000000 000000000=
0000000 0000000000000000
> [69244.027625][   C24] GPR12: 80040000072a40a8 c00000000ff8b680 000000000=
0000007 0000000000000034
> [69244.027625][   C24] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001=
fbd1db0 000000001fb3f008
> [69244.027625][   C24] GPR20: 000000001fb41018 ffffffffffffffff 000000000=
000017f fffffffffffff68f
> [69244.027625][   C24] GPR24: 000000001fb18fe8 000000001fb3e000 000000001=
fb1adc0 000000001fb1cf40
> [69244.027625][   C24] GPR28: 000000001fb26000 000000001fb460f0 000000001=
fb17f18 000000001fb17000
> [69244.027663][   C24] NIP [000000001fb41050] 0x1fb41050
> [69244.027696][   C24] LR [000000001fb4104c] 0x1fb4104c
> [69244.027699][   C24] Call Trace:
> [69244.027701][   C24] Instruction dump:
> [69244.027723][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXX=
XXX XXXXXXXX XXXXXXXX
> [69244.027728][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXX=
XXX XXXXXXXX XXXXXXXX
> [69244.027762][T87504] Oops: Unrecoverable System Reset, sig: 6 [#1]
> [69244.028044][T87504] LE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048 N=
UMA pSeries
> [69244.028089][T87504] Modules linked in: chacha_generic(E) libchacha(E) =
xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) li=
bpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rn=
g(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_=
generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camel=
lia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) alg=
if_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rp=
cgss(E)
> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(=
E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netl=
ink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(=
E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_=
vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) con=
figfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E)=
 t10_pi(E)
> [69244.028171][T87504]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf1=
28mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) r=
aid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) d=
m_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
> [69244.028307][T87504] Supported: No, Unreleased kernel
> [69244.028385][T87504] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Taint=
ed: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP=
4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
> [69244.028408][T87504] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0=
000000000000000
> [69244.028418][T87504] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G    =
        E  X     (5.14.21-150400.71.1.bz196362_2-default)
> [69244.028429][T87504] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 488000=
02  XER: 20040020
> [69244.028444][T87504] CFAR: 000000000000011c IRQMASK: 1
> [69244.028444][T87504] GPR00: 0000000000000003 ffffffffffffffff 000000000=
0000001 00000000000050dc
> [69244.028444][T87504] GPR04: 000000001ffb6100 0000000000000020 000000000=
0000001 000000001fb09010
> [69244.028444][T87504] GPR08: 0000000020000000 0000000000000000 000000000=
0000000 0000000000000000
> [69244.028444][T87504] GPR12: 80040000072a40a8 c00000000ff8b680 000000000=
0000007 0000000000000034
> [69244.028444][T87504] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001=
fbd1db0 000000001fb3f008
> [69244.028444][T87504] GPR20: 000000001fb41018 ffffffffffffffff 000000000=
000017f fffffffffffff68f
> [69244.028444][T87504] GPR24: 000000001fb18fe8 000000001fb3e000 000000001=
fb1adc0 000000001fb1cf40
> [69244.028444][T87504] GPR28: 000000001fb26000 000000001fb460f0 000000001=
fb17f18 000000001fb17000
> [69244.028534][T87504] NIP [000000001fb41050] 0x1fb41050
> [69244.028543][T87504] LR [000000001fb4104c] 0x1fb4104c
> [69244.028549][T87504] Call Trace:
> [69244.028554][T87504] Instruction dump:
> [69244.028561][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXX=
XXX XXXXXXXX XXXXXXXX
> [69244.028575][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXX=
XXX XXXXXXXX XXXXXXXX
> [69244.028607][T87504] ---[ end trace 3ddec07f638c34a2 ]---
>
> This happens because MSR[RI] is unset when entering RTAS but there is no
> valid reason to not set it here.
>
> RTAS is expected to be called with MSR[RI] as specified in PAPR+ section
> "7.2.1 Machine State":
>
>  R1=E2=80=937.2.1=E2=80=939. If called with MSR[RI] equal to 1, then RTAS=
 must protect its
>  own critical regions from recursion by setting the MSRRI bit to 0 when in
>  the critical regions.
>
> Fixing this by reviewing the way MSR is compute before calling RTAS. Now a
> hardcoded value meaning real mode, 32 bits and Recoverable Interrupt is
> loaded.
>
> In addition a check is added in do_enter_rtas() to detect calls made with
> MSR[RI] unset, as we are forcing it on later.
>
> This patch has been tested on the following machines:
> Power KVM Guest
>   P8 S822L (host Ubuntu kernel 5.11.0-49-generic)
> PowerVM LPAR
>   P8 9119-MME (FW860.A1)
>   p9 9008-22L (FW950.00)
>   P10 9080-HEX (FW1010.00)
>
> Changes in V2:
>  - Change comment in code to indicate NMI (Nick's comment)
>  - Add reference to PAPR+ in the change log (Michael's comment)
>
> Cc: stable@vger.kernel.org
> Suggested-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/powerpc/kernel/entry_64.S | 20 ++++++++------------
>  arch/powerpc/kernel/rtas.c     |  5 +++++
>  2 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_6=
4.S
> index 9581906b5ee9..65cb14b56f8d 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -330,22 +330,18 @@ _GLOBAL(enter_rtas)
>  	clrldi	r4,r4,2			/* convert to realmode address */
>         	mtlr	r4
>=20=20
> -	li	r0,0
> -	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
> -	andc	r0,r6,r0
> -=09
> -        li      r9,1
> -        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
> -	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
> -	andc	r6,r0,r9
=20
One advantage of the old method is it can adapt to new MSR bits being
set by the kernel.

For example we used to use RTAS on powernv, and this code didn't need
updating to cater to MSR_HV being set. We will probably never use RTAS
on bare-metal again, so that's OK.

But your change might break secure virtual machines, because it clears
MSR_S whereas the old code didn't. I think SVMs did use RTAS, but I
don't know whether it matters if it's called with MSR_S set or not?

Not sure if anyone will remember, or has a working setup they can test.
Maybe for now we just copy MSR_S from the kernel MSR the way the
current code does.

>  __enter_rtas:
> -	sync				/* disable interrupts so SRR0/1 */
> -	mtmsrd	r0			/* don't get trashed */
> -
>  	LOAD_REG_ADDR(r4, rtas)
>  	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
>  	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
> +
> +	/* RTAS runs in 32bits real mode but let MSR[]RI on as we may hit

"32-bit big endian real mode"

> +	 * NMI (SRESET or MCE). RTAS should disable RI in its critical
> +	 * regions (as specified in PAPR+ section 7.2.1). */
> +	LOAD_REG_IMMEDIATE(r6, MSR_ME|MSR_RI)
> +
> +	li      r0,0
> +	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
>=20=20=09
>  	mtspr	SPRN_SRR0,r5
>  	mtspr	SPRN_SRR1,r6
> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
> index 1f42aabbbab3..d7775b8c8853 100644
> --- a/arch/powerpc/kernel/rtas.c
> +++ b/arch/powerpc/kernel/rtas.c
> @@ -49,6 +49,11 @@ void enter_rtas(unsigned long);
>=20=20
>  static inline void do_enter_rtas(unsigned long args)
>  {
> +	unsigned long msr;
> +
> +	msr =3D mfmsr();
> +	BUG_ON(!(msr & MSR_RI));

I'm not sure about this.

We call RTAS in some low-level places, so if we ever hit this BUG_ON
then it might cause us to crash badly, or recursively BUG.

A WARN_ON_ONCE() might be safer?

cheers
