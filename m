Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19C317AA75
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCEQYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:24:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726004AbgCEQYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583425493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65G1VOtWWZCvaMvAdW7abwTe7lD47N+L8qs6QmejZ2Q=;
        b=P0ECQZCKXWp9SLxZjgQeDB7Y7o4EnyFbxnIFHGa9rrFwVzhyv+fa84kDZ1vanBau/KWZC6
        YxCk4XPIYp/lbLyZm2n0Z2jyyE7d7/g7zWN5n6DI2tJSF5b1B/oWtmmOQiyIAaf0+FXj1s
        2I95jvBZYpNWyv89A6s53KkzOPpyMhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-A9JiEQfJPOG1YRymGXvUWQ-1; Thu, 05 Mar 2020 11:24:49 -0500
X-MC-Unique: A9JiEQfJPOG1YRymGXvUWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCA8801A1B;
        Thu,  5 Mar 2020 16:24:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D10272A2;
        Thu,  5 Mar 2020 16:24:48 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A84AE84484;
        Thu,  5 Mar 2020 16:24:48 +0000 (UTC)
Date:   Thu, 5 Mar 2020 11:24:48 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <2065777364.10425170.1583425488638.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.EED856DF66.LLEP90YP5M@redhat.com>
References: <cki.EED856DF66.LLEP90YP5M@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l_5.5.7-60528b7.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.6]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.5.7-60528b7.cki (stable-queue)
Thread-Index: kkuOJFuqhkSqHy2lWMvJx4dG0KzmcQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 60528b79e30a - kvm: nVMX: VMWRITE checks unsupported
>             field before read-only field
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
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/03/04/471505
>=20
> One or more kernel tests failed:
>=20
>     s390x:
>      =E2=9D=8C LTP

All instances of similar panics [1] manifest mostly on s390 and at
first glance look like memory corruptions.

I'm looking to confirm, whether this has been fixed by:

  commit 6fcca0fa48118e6d63733eb4644c6cd880c15b8f
  Author: Suren Baghdasaryan <surenb@google.com>
  Date:   Mon Feb 3 13:22:16 2020 -0800

    sched/psi: Fix OOB write when writing 0 bytes to PSI files

[1]=20
[  437.397455] addressing exception: 0005 ilc:2 [#1] SMP      =20
[  437.397464] Modules linked in: sunrpc ghash_s390 prng aes_s390 des_s390 =
libde=20
s qeth_l2 qeth qdio ccwgroup sha512_s390 vfio_ccw vfio_mdev mdev vfio_iommu=
_type=20
1 sha1_s390 vfio ip_tables xfs libcrc32c crc32_vx_s390 sha256_s390 sha_comm=
on da=20
sd_eckd_mod dasd_mod pkey zcrypt                                           =
     =20
[  437.397490] CPU: 3 PID: 1029 Comm: read_all Not tainted 5.5.7-60528b7.ck=
i #1 =20
[  437.397493] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)                =
     =20
[  437.397497] Krnl PSW : 0704e00180000000 00000000bbf4e508 (collect_percpu=
_time=20
s+0xd0/0x240)                                                              =
     =20
[  437.397507]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:=
0 RI:=20
0 EA:3                                                                     =
     =20
[  437.397511] Krnl GPRS: 0000000142374000 0000000142314000 000000000000000=
0 000=20
00000bca4d5a8                                                              =
     =20
[  437.397514]            0000000000000000 0000000000000000 000000014231401=
4 000=20
0000000000000                                                              =
     =20
[  437.397518]            000003e00092fce0 000003e00092fd20 000000000000000=
1 000=20
0000142314000                                                              =
     =20
[  437.397521]            00000001e47d6000 00000001fb07fd40 00000000bbf4e4c=
8 000=20
003e00092fc00                                                              =
     =20
[  437.397539] Krnl Code: 00000000bbf4e4fc: b90400b1            lgr     %r1=
1,%r1=20
                                                                           =
     =20
[  437.397539]            00000000bbf4e500: 41601014            la      %r6=
,20(%=20
r1)                                                                        =
     =20
[  437.397539]           #00000000bbf4e504: 5870b000            l       %r7=
,0(%r=20
11)                                                                        =
     =20
[  437.397539]           >00000000bbf4e508: a7710001            tmll    %r7=
,1   =20
[  437.397539]            00000000bbf4e50c: a774006d            brc     7,0=
00000=20
00bbf4e5e6                                                                 =
     =20
[  437.397539]            00000000bbf4e510: c0e5fffabadc        brasl   %r1=
4,000=20
00000bbea5ac8                                                              =
     =20
[  437.397539]            00000000bbf4e516: d20f80006000        mvc     0(1=
6,%r8=20
),0(%r6)                                                                   =
     =20
[  437.397539]            00000000bbf4e51c: d20780106010        mvc     16(=
8,%r8=20
),16(%r6)                                                                  =
     =20
[  437.397556] Call Trace:                                                 =
     =20
[  437.397559]  [<00000000bbf4e508>] collect_percpu_times+0xd0/0x240       =
     =20
[  437.397561] ([<00000000bbf4e4c8>] collect_percpu_times+0x90/0x240)      =
     =20
[  437.397563]  [<00000000bbf4f380>] psi_show+0x68/0x1c0                   =
     =20
[  437.397568]  [<00000000bc17494c>] seq_read+0xe4/0x4d8                   =
     =20
[  437.397572]  [<00000000bc142dc4>] vfs_read+0x94/0x160                   =
     =20
[  437.397573]  [<00000000bc1431a0>] ksys_read+0x68/0xf8                   =
     =20
[  437.397578]  [<00000000bc75d668>] system_call+0xdc/0x2c8                =
     =20
[  437.397579] Last Breaking-Event-Address:                                =
     =20
[  437.397580]  [<00000000bc75eba8>] __s390_indirect_jump_r14+0x0/0xc      =
     =20
[  437.397583] ---[ end trace 59a09ffb5f96cb2a ]---                

