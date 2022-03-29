Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A874EA949
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 10:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiC2Id1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 04:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiC2IdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 04:33:21 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4886EC74;
        Tue, 29 Mar 2022 01:31:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so14243649pga.0;
        Tue, 29 Mar 2022 01:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=BwEH8cAogfesmpmdPkr5kXu4rb67r/3s0WyVWQsv/vc=;
        b=bfRcQnLl7+gXZZDmNsi/MstDIUsJ3nfGg4PAq+z3f/UPacnryzhrE/WjJDii45tW8J
         2Qjvhs/o65NScw6EcrojeXYETnpr4+5XOVa/L0jPahDX5dJbkR7Aqq4w/4V/ARtMlV2N
         6GO4EW/yFQzsHGf9wUdbssUS4EZ2kFG8r0Pb0Dq0SqB4GPkw21SO55h1Wq3erJ/UGbFi
         YVlsqzNqr3uGbMJ3ZJuHeqfUHyq1ZCJWBpQnfuYox044k7IrylmGPkAjzdU2rvFHL2Fd
         IxY1v9tXuSz7TEFX7fPbTUj8dZ4nEFuSbf7fu9wvhNlt8eoxvR1A78OIS1sg529uY3wa
         LX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=BwEH8cAogfesmpmdPkr5kXu4rb67r/3s0WyVWQsv/vc=;
        b=fU91c3KReUUoe3LK6Q95QOa+JS/QF3BBYAXCTEOvE0kr5GkOLt4FpQgwPI2ivyfWaE
         jcqMcId8AE++e6gzxDiSwYMUTTq5IZQeHH1Qqw2yXwYca1GGuksOqNjFfpeh5nuPMafC
         f5Rr2bW7x9ijt+7TSWsNRpjqcyJXBhw+ycE6uubNIsTZU3QwGr3J+yeJmiYVAPuFOSPz
         pAXaztRwnGqG5YEaRp/81/oRQrzpFPYMRpwMwFvioQ8xT/dfQrKHzhe6ZbXexi1jZey+
         bSxiMKXNDBFpnDzyZM7r4P55JhrAmYXmYLpwqyumZkk4AUfmShutyQnEPVZuf/hDRdlc
         STwQ==
X-Gm-Message-State: AOAM532xp3Y4L46AAxq+fhkfo6OQzo745ipCO5sLlJLJ/pwZ56mwsvts
        ZPgjpoKHvgY1ku+lSojwPMQ=
X-Google-Smtp-Source: ABdhPJyAuUEtOmIKUFW25H0UGsqMoNj9TQ6I8rg61j2YcPT49wVc6qxJ0cY8Uh+J8Haxq/nQzttEZg==
X-Received: by 2002:a63:d916:0:b0:385:fe06:a1db with SMTP id r22-20020a63d916000000b00385fe06a1dbmr1217302pgg.446.1648542698546;
        Tue, 29 Mar 2022 01:31:38 -0700 (PDT)
Received: from localhost (58-6-255-110.tpgi.com.au. [58.6.255.110])
        by smtp.gmail.com with ESMTPSA id n3-20020a056a0007c300b004fa3e9f59cdsm17922413pfu.39.2022.03.29.01.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 01:31:38 -0700 (PDT)
Date:   Tue, 29 Mar 2022 18:31:33 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/rtas: Keep MSR RI set when calling RTAS
To:     Laurent Dufour <ldufour@linux.ibm.com>, mpe@ellerman.id.au
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
References: <20220317110601.86917-1-ldufour@linux.ibm.com>
In-Reply-To: <20220317110601.86917-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1648542633.wzscjm967w.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Laurent Dufour's message of March 17, 2022 9:06 pm:
> RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
> mode (MSR[SF] unset).
>=20
> The change in MSR is done in enter_rtas() in a relatively complex way,
> since the MSR value could be hardcoded.
>=20
> Furthermore, a panic has been reported when hitting the watchdog interrup=
t
> while running in RTAS, this leads to the following stack trace:
>=20
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
>=20
> This happens because MSR[RI] is unset when entering RTAS but there is no
> valid reason to not set it here.
>=20
> Fixing this by reviewing the way MSR is compute before calling RTAS. Now =
a
> hardcoded value meaning real mode, 32 bits and Recoverable Interrupt is
> loaded.
>=20
> In addition a check is added in do_enter_rtas() to detect calls made with
> MSR[RI] unset, as we are forcing it on later.

This looks okay to me, I would just adjust the comment about watchdog
irq. It's more like NMI (SRESET or MCE), watchdog irq could be confusing=20
for the soft-NMI timer.

Otherwise I think it's okay.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Cc: stable@vger.kernel.org
> Suggested-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/powerpc/kernel/entry_64.S | 18 ++++++------------
>  arch/powerpc/kernel/rtas.c     |  5 +++++
>  2 files changed, 11 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_6=
4.S
> index 9581906b5ee9..fbc8dfe7da9f 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -330,22 +330,16 @@ _GLOBAL(enter_rtas)
>  	clrldi	r4,r4,2			/* convert to realmode address */
>         	mtlr	r4
> =20
> -	li	r0,0
> -	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
> -	andc	r0,r6,r0
> -=09
> -        li      r9,1
> -        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
> -	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
> -	andc	r6,r0,r9
> -
>  __enter_rtas:
> -	sync				/* disable interrupts so SRR0/1 */
> -	mtmsrd	r0			/* don't get trashed */
> -
>  	LOAD_REG_ADDR(r4, rtas)
>  	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
>  	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
> +
> +	/* RTAS runs in 32bits real mode but we may hit watchdog irq */
> +	LOAD_REG_IMMEDIATE(r6, MSR_ME|MSR_RI)
> +
> +	li      r0,0
> +	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
>  =09
>  	mtspr	SPRN_SRR0,r5
>  	mtspr	SPRN_SRR1,r6
> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
> index 1f42aabbbab3..d7775b8c8853 100644
> --- a/arch/powerpc/kernel/rtas.c
> +++ b/arch/powerpc/kernel/rtas.c
> @@ -49,6 +49,11 @@ void enter_rtas(unsigned long);
> =20
>  static inline void do_enter_rtas(unsigned long args)
>  {
> +	unsigned long msr;
> +
> +	msr =3D mfmsr();
> +	BUG_ON(!(msr & MSR_RI));
> +
>  	enter_rtas(args);
> =20
>  	srr_regs_clobbered(); /* rtas uses SRRs, invalidate */
> --=20
> 2.35.1
>=20
>=20
