Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7BF4EAC05
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 13:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiC2LQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiC2LQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:16:02 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977BD488BD;
        Tue, 29 Mar 2022 04:14:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KSRln5flVz4xL3;
        Tue, 29 Mar 2022 22:14:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1648552454;
        bh=sYGzRkByZxRM+KlLfgd4bf0gz2saMlv8hEBL9dhOeNc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nrE/aBL/hKGYxvIkk4nO+Me8jKZkgy3Y+wz6Uy6v2yWOc+Tb9sJyf6Lw/qggu0gbU
         3QXlry8iKgN3AxBDyzg9elBXb3gT5hx3SIJ/ZUhURXh8BEw3jVbSTHLOYngoEM5YJC
         RR0TcPzfbcITqh3q2fowlMw5mU+Q6Wl6KUMzMEbDNrLJUlqEzK2XH3mWNRrjueviBZ
         7Dyu8h9weE9TnZWaz9uCYwvNon63B3JQIWKYVyX09Zy96ctObou5brCZgXdBrJqeEo
         f0FkmQWYZ1n1nSog31Qq7lcoQAKsVFzAhhBuMJ4FgYomehW0WhMrIeOGQ6OOK0BKSX
         m240nOWIO4r9w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/rtas: Keep MSR RI set when calling RTAS
In-Reply-To: <8e3175ff-afba-e2a2-4fe6-0f964da0fa4b@linux.ibm.com>
References: <20220317110601.86917-1-ldufour@linux.ibm.com>
 <1648542633.wzscjm967w.astroid@bobo.none>
 <8e3175ff-afba-e2a2-4fe6-0f964da0fa4b@linux.ibm.com>
Date:   Tue, 29 Mar 2022 22:14:10 +1100
Message-ID: <87pmm5f1tp.fsf@mpe.ellerman.id.au>
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
> On 29/03/2022, 10:31:33, Nicholas Piggin wrote:
>> Excerpts from Laurent Dufour's message of March 17, 2022 9:06 pm:
>>> RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
>>> mode (MSR[SF] unset).
>>>
>>> The change in MSR is done in enter_rtas() in a relatively complex way,
>>> since the MSR value could be hardcoded.
>>>
>>> Furthermore, a panic has been reported when hitting the watchdog interr=
upt
>>> while running in RTAS, this leads to the following stack trace:
>>>
>>> [69244.027433][   C24] watchdog: CPU 24 Hard LOCKUP
>>> [69244.027442][   C24] watchdog: CPU 24 TB:997512652051031, last heartb=
eat TB:997504470175378 (15980ms ago)
>>> [69244.027451][   C24] Modules linked in: chacha_generic(E) libchacha(E=
) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) =
libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_=
rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) de=
s_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) cam=
ellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) a=
lgif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_=
rpcgss(E)
>>> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_dia=
g(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) ne=
tlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscach=
e(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10di=
f_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) c=
onfigfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(=
E) t10_pi(E)
>>> [69244.027555][   C24]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) g=
f128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E)=
 raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E)=
 dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
>>> [69244.027587][   C24] Supported: No, Unreleased kernel
>>> [69244.027600][   C24] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tai=
nted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-=
SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
>>> [69244.027609][   C24] NIP:  000000001fb41050 LR: 000000001fb4104c CTR:=
 0000000000000000
>>> [69244.027612][   C24] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G  =
          E  X     (5.14.21-150400.71.1.bz196362_2-default)
>>> [69244.027615][   C24] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 4880=
0002  XER: 20040020
>>> [69244.027625][   C24] CFAR: 000000000000011c IRQMASK: 1
>>> [69244.027625][   C24] GPR00: 0000000000000003 ffffffffffffffff 0000000=
000000001 00000000000050dc
>>> [69244.027625][   C24] GPR04: 000000001ffb6100 0000000000000020 0000000=
000000001 000000001fb09010
>>> [69244.027625][   C24] GPR08: 0000000020000000 0000000000000000 0000000=
000000000 0000000000000000
>>> [69244.027625][   C24] GPR12: 80040000072a40a8 c00000000ff8b680 0000000=
000000007 0000000000000034
>>> [69244.027625][   C24] GPR16: 000000001fbf6e94 000000001fbf6d84 0000000=
01fbd1db0 000000001fb3f008
>>> [69244.027625][   C24] GPR20: 000000001fb41018 ffffffffffffffff 0000000=
00000017f fffffffffffff68f
>>> [69244.027625][   C24] GPR24: 000000001fb18fe8 000000001fb3e000 0000000=
01fb1adc0 000000001fb1cf40
>>> [69244.027625][   C24] GPR28: 000000001fb26000 000000001fb460f0 0000000=
01fb17f18 000000001fb17000
>>> [69244.027663][   C24] NIP [000000001fb41050] 0x1fb41050
>>> [69244.027696][   C24] LR [000000001fb4104c] 0x1fb4104c
>>> [69244.027699][   C24] Call Trace:
>>> [69244.027701][   C24] Instruction dump:
>>> [69244.027723][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXX=
XXXXX XXXXXXXX XXXXXXXX
>>> [69244.027728][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXX=
XXXXX XXXXXXXX XXXXXXXX
>>> [69244.027762][T87504] Oops: Unrecoverable System Reset, sig: 6 [#1]
>>> [69244.028044][T87504] LE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048=
 NUMA pSeries
>>> [69244.028089][T87504] Modules linked in: chacha_generic(E) libchacha(E=
) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) =
libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_=
rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) de=
s_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) cam=
ellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) a=
lgif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_=
rpcgss(E)
>>> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_dia=
g(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) ne=
tlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscach=
e(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10di=
f_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) c=
onfigfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(=
E) t10_pi(E)
>>> [69244.028171][T87504]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) g=
f128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E)=
 raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E)=
 dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
>>> [69244.028307][T87504] Supported: No, Unreleased kernel
>>> [69244.028385][T87504] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tai=
nted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-=
SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
>>> [69244.028408][T87504] NIP:  000000001fb41050 LR: 000000001fb4104c CTR:=
 0000000000000000
>>> [69244.028418][T87504] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G  =
          E  X     (5.14.21-150400.71.1.bz196362_2-default)
>>> [69244.028429][T87504] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 4880=
0002  XER: 20040020
>>> [69244.028444][T87504] CFAR: 000000000000011c IRQMASK: 1
>>> [69244.028444][T87504] GPR00: 0000000000000003 ffffffffffffffff 0000000=
000000001 00000000000050dc
>>> [69244.028444][T87504] GPR04: 000000001ffb6100 0000000000000020 0000000=
000000001 000000001fb09010
>>> [69244.028444][T87504] GPR08: 0000000020000000 0000000000000000 0000000=
000000000 0000000000000000
>>> [69244.028444][T87504] GPR12: 80040000072a40a8 c00000000ff8b680 0000000=
000000007 0000000000000034
>>> [69244.028444][T87504] GPR16: 000000001fbf6e94 000000001fbf6d84 0000000=
01fbd1db0 000000001fb3f008
>>> [69244.028444][T87504] GPR20: 000000001fb41018 ffffffffffffffff 0000000=
00000017f fffffffffffff68f
>>> [69244.028444][T87504] GPR24: 000000001fb18fe8 000000001fb3e000 0000000=
01fb1adc0 000000001fb1cf40
>>> [69244.028444][T87504] GPR28: 000000001fb26000 000000001fb460f0 0000000=
01fb17f18 000000001fb17000
>>> [69244.028534][T87504] NIP [000000001fb41050] 0x1fb41050
>>> [69244.028543][T87504] LR [000000001fb4104c] 0x1fb4104c
>>> [69244.028549][T87504] Call Trace:
>>> [69244.028554][T87504] Instruction dump:
>>> [69244.028561][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXX=
XXXXX XXXXXXXX XXXXXXXX
>>> [69244.028575][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXX=
XXXXX XXXXXXXX XXXXXXXX
>>> [69244.028607][T87504] ---[ end trace 3ddec07f638c34a2 ]---
>>>
>>> This happens because MSR[RI] is unset when entering RTAS but there is no
>>> valid reason to not set it here.
>>>
>>> Fixing this by reviewing the way MSR is compute before calling RTAS. No=
w a
>>> hardcoded value meaning real mode, 32 bits and Recoverable Interrupt is
>>> loaded.
>>>
>>> In addition a check is added in do_enter_rtas() to detect calls made wi=
th
>>> MSR[RI] unset, as we are forcing it on later.
>>=20
>> This looks okay to me, I would just adjust the comment about watchdog
>> irq. It's more like NMI (SRESET or MCE), watchdog irq could be confusing=
=20
>> for the soft-NMI timer.
>>=20
>> Otherwise I think it's okay.
>>=20
>> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>
> Thanks Nick,
>
> I agree about comment watchdog irq.
> Michael, could you fix that comment below when applying?

I can.

But the changelog also needs to mention that what we're doing is legal
per PAPR, and reference the relevant sections.

I think that's section "7.2.1 Machine State", in particular:

  R1=E2=80=937.2.1=E2=80=939. If called with MSR[RI]equal to 1, then RTAS m=
ust protect
  its own critical regions from recursion by setting the MSR[RI] bit to
  0 when in the critical regions.

That language appears to go back to PAPR+ Version 1.0, so that should
cover all PAPR systems.

We also had RTAS on pre-PAPR systems, but I don't think we support any
of those anymore (on 64-bit).

Would also be good to know what machines you've tested this on.

cheers
