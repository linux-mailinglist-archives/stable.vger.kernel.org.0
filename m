Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93849EE159
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfKDNf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:35:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727236AbfKDNfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 08:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572874554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPy70Kw/HjSMTavaFiQwqQT9FawO2a7L/uSZuHqJiQU=;
        b=V13fjH/xQpl4R0Yrcu1bkeohfs/QWCS2YS07ndERmJDuj7QZev3OzhKkxz+TU2ZjYv8BiA
        P3kxCgbE5/ia+ArecygxZ2FcAgL6x2SQEdZZ1zgo0BtABAZkOWJ2A2mRb5aITvGNHcwCaY
        SUzwi8p+s5oymGdVrKNP7aJ9grUeQU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-4F934xzQO9KDdZraJIdqIg-1; Mon, 04 Nov 2019 08:35:53 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2860107ACC2;
        Mon,  4 Nov 2019 13:35:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E840226FAF;
        Mon,  4 Nov 2019 13:35:51 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA0AF18095FF;
        Mon,  4 Nov 2019 13:35:51 +0000 (UTC)
Date:   Mon, 4 Nov 2019 08:35:51 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        alsa-devel@alsa-project.org, LTP Mailing List <ltp@lists.linux.it>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com>
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kern?=
 =?utf-8?Q?el_5.3.9-rc1-dfe283e.cki_(stable)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.4]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.9-rc1-dfe283e.cki (stable)
Thread-Index: n/mewoQ8yG2QJ+7KLfbnKocCzfhA1w==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 4F934xzQO9KDdZraJIdqIg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
>             Commit: dfe283e9fdac - Linux 5.3.9-rc1
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://artifacts.cki-project.org/pipelines/262380
>=20
> One or more kernel tests failed:
>=20
>     x86_64:
>      =E2=9D=8C LTP lite
>

Not a 5.3 -stable regression.

Failure comes from test that sanity checks all /proc files by doing
1k read from each. There are couple issues it hits wrt. snd_hda_*.

Example reproducer:
  dd if=3D/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access of=3Dout.txt =
count=3D1 bs=3D1024 iflag=3Dnonblock

It's slow and triggers soft lockups [1]. And it also requires lot
of memory, triggering OOMs on smaller VMs:
0x0000000024f0437b-0x000000001a32b1c8 1073745920 seq_read+0x131/0x400 pages=
=3D262144 vmalloc vpages N0=3D262144

I'm leaning towards skipping all regmap entries in this test.
Comments are welcomed.

Regards,
Jan

[1]
[15341.137116] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [dd:636573=
]
[15341.144141] Modules linked in: nls_utf8 isofs dummy minix binfmt_misc nf=
sv3 nfs_acl nfs lockd grace fscache sctp rds brd vfat fat btrfs xor zstd_co=
mpress raid6_pq zstd_decompress loop tu
n ip6table_nat ip6_tables xt_conntrack iptable_filter xt_MASQUERADE xt_comm=
ent iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth brid=
ge stp llc overlay fuse snd_hda_codec_r
ealtek snd_hda_codec_generic sunrpc ledtrig_audio snd_hda_codec_hdmi snd_hd=
a_intel snd_hda_codec edac_mce_amd kvm_amd snd_hda_core ccp snd_hwdep snd_p=
cm kvm snd_timer irqbypass joydev snd c
rct10dif_pclmul crc32_pclmul soundcore broadcom bcm_phy_lib ghash_clmulni_i=
ntel sp5100_tco fam15h_power k10temp tg3 wmi_bmof pcspkr i2c_piix4 acpi_cpu=
freq ip_tables xfs libcrc32c radeon ata
_generic i2c_algo_bit pata_acpi drm_kms_helper firewire_ohci ttm crc32c_int=
el serio_raw pata_atiixp firewire_core drm crc_itu_t wmi [last unloaded: ca=
n]
[15341.223635] CPU: 2 PID: 636573 Comm: dd Tainted: G             L    5.3.=
9-rc1-dfe283e.cki #1
[15341.232073] Hardware name: AMD Pike/Pike, BIOS RPK1506A 09/03/2014
[15341.238467] RIP: 0010:regmap_readable+0x15/0x60
[15341.242996] Code: 25 28 00 00 00 75 07 48 83 c4 10 5b 5d c3 e8 92 08 a6 =
ff 66 90 0f 1f 44 00 00 48 83 bf b0 01 00 00 00 74 31 8b 97 48 01 00 00 <39=
> f2 0f 92 c0 85 d2 0f 95 c2 20 d0 75 1
d 48 83 7f 70 00 74 01 c3
[15341.261765] RSP: 0018:ffffb3b100697dc8 EFLAGS: 00000282 ORIG_RAX: ffffff=
ffffffff13
[15341.269330] RAX: 0000000000000000 RBX: ffff8d1a63773400 RCX: 00000000000=
00b41
[15341.276723] RDX: 000000000fffffff RSI: 000000000f3b4139 RDI: ffff8d1a637=
73400
[15341.283858] RBP: 000000000f3b4139 R08: 0000000000000000 R09: 00000000000=
00000
[15341.290989] R10: 000000000000000f R11: ffff8d19901fffff R12: 00000000000=
00079
[15341.298114] R13: 000000000f3b4139 R14: 00000000ffffffff R15: 00000000000=
0006e
[15341.305501] FS:  00007f4e067a0580(0000) GS:ffff8d1a6aa80000(0000) knlGS:=
0000000000000000
[15341.313583] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15341.319322] CR2: 00007f5083682dc0 CR3: 00000001287dc000 CR4: 00000000000=
406e0
[15341.326462] Call Trace:
[15341.328912]  regmap_volatile+0x4f/0xa0
[15341.332667]  regmap_access_show+0x70/0x100
[15341.336997]  seq_read+0xcd/0x400
[15341.340247]  full_proxy_read+0x57/0x70
[15341.343997]  vfs_read+0x9d/0x150
[15341.347231]  ksys_read+0x5f/0xe0
[15341.350473]  do_syscall_64+0x5f/0x1a0
[15341.354166]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[15341.359216] RIP: 0033:0x7f4e066823c2
[15341.362795] Code: c0 e9 c2 fe ff ff 50 48 8d 3d c2 0d 0a 00 e8 b5 f1 01 =
00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48=
> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 0
0 48 83 ec 28 48 89 54 24
[15341.381852] RSP: 002b:00007ffc6ad30e88 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000000
[15341.389427] RAX: ffffffffffffffda RBX: 0000000000000400 RCX: 00007f4e066=
823c2
[15341.396568] RDX: 0000000000000400 RSI: 0000561bc69f0000 RDI: 00000000000=
00000
[15341.403979] RBP: 0000561bc69f0000 R08: 0000561bc69efb60 R09: 00000000000=
000c0
[15341.411111] R10: 0000561bc69f0000 R11: 0000000000000246 R12: fffffffffff=
fffff
[15341.418244] R13: 0000000000000000 R14: 0000000000000000 R15: fffffffffff=
fffff

