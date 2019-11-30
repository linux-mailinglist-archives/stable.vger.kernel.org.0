Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FC310DF74
	for <lists+stable@lfdr.de>; Sat, 30 Nov 2019 22:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfK3V4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Nov 2019 16:56:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726981AbfK3V4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Nov 2019 16:56:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575151009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QcH/lJ3fRgpZPQbN5bHrq0qgyiP2WbJdkAfGc4iDCaE=;
        b=VAcHlKk6cAy4LkUgijhBbrX/ajBqcEc4suWmtsk7Q6enflabmFbmLrZdReYxv/q4iPiHEC
        nMD+EebW3cdLGF0Sv4ZMabXIpKz5/OnLoCLeZc3N6zROU/69aUxaydW4n8UlLCsIYVM++4
        HYK2FlJ+wtqjMgBvM9BbtZCem7nSbXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-B12LsOtRNpmI0L9dTXHchQ-1; Sat, 30 Nov 2019 16:56:45 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C871800D55;
        Sat, 30 Nov 2019 21:56:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA1B10002D0;
        Sat, 30 Nov 2019 21:56:44 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A4274E572;
        Sat, 30 Nov 2019 21:56:43 +0000 (UTC)
Date:   Sat, 30 Nov 2019 16:56:43 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.6C6A189643.3T2ZUWEMOI@redhat.com>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.3.13-3b5f971.cki_(stable-queue)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.13-3b5f971.cki (stable-queue)
Thread-Index: 8Ofpy4LCtsBgdjcJ+gOLLKeKbbAOdg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: B12LsOtRNpmI0L9dTXHchQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
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
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.=
git
>             Commit: 3b5f97139acc - KVM: PPC: Book3S HV: Flush link stack =
on
>             guest exit to host kernel
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
>   https://artifacts.cki-project.org/pipelines/314344
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C LTP

I suspect kernel bug.

There were couple of 'math' runtest related failures in recent couple days.
In all cases, some data file used by test was missing. Presumably because
binary that generates it crashed.

I managed to reproduce one failure with this CKI build, which I believe
is the same problem.

We crash early during load, before any LTP code runs:

(gdb) r
Starting program: /mnt/testarea/ltp/testcases/bin/genasin

Program received signal SIGBUS, Bus error.
dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7ffffff=
fe760, auxv=3D<optimized out>) at rtld.c:1362
1362        switch (ph->p_type)
(gdb) bt
#0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7ff=
fffffe760, auxv=3D<optimized out>) at rtld.c:1362
#1  0x00007ffff7fcf3c8 in _dl_sysdep_start (start_argptr=3D<optimized out>,=
 dl_main=3D0x7ffff7fb37b0 <dl_main>) at ../elf/dl-sysdep.c:253
#2  0x00007ffff7fb1d1c in _dl_start_final (arg=3Darg@entry=3D0x7fffffffee20=
, info=3Dinfo@entry=3D0x7fffffffe870) at rtld.c:445
#3  0x00007ffff7fb2f5c in _dl_start (arg=3D0x7fffffffee20) at rtld.c:537
#4  0x00007ffff7fb14d8 in _start () from /lib64/ld64.so.2
(gdb) f 0
#0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7ff=
fffffe760, auxv=3D<optimized out>) at rtld.c:1362
1362        switch (ph->p_type)
(gdb) l
1357      /* And it was opened directly.  */
1358      ++main_map->l_direct_opencount;
1359
1360      /* Scan the program header table for the dynamic section.  */
1361      for (ph =3D phdr; ph < &phdr[phnum]; ++ph)
1362        switch (ph->p_type)
1363          {
1364          case PT_PHDR:
1365            /* Find out the load address.  */
1366            main_map->l_addr =3D (ElfW(Addr)) phdr - ph->p_vaddr;

(gdb) p ph
$1 =3D (const Elf64_Phdr *) 0x10000040

(gdb) p *ph
Cannot access memory at address 0x10000040

(gdb) info proc map
process 1110670
Mapped address spaces:

          Start Addr           End Addr       Size     Offset objfile
          0x10000000         0x10010000    0x10000        0x0 /mnt/testarea=
/ltp/testcases/bin/genasin
          0x10010000         0x10030000    0x20000        0x0 /mnt/testarea=
/ltp/testcases/bin/genasin
      0x7ffff7f90000     0x7ffff7fb0000    0x20000        0x0 [vdso]
      0x7ffff7fb0000     0x7ffff7fe0000    0x30000        0x0 /usr/lib64/ld=
-2.30.so
      0x7ffff7fe0000     0x7ffff8000000    0x20000    0x20000 /usr/lib64/ld=
-2.30.so
      0x7ffffffd0000     0x800000000000    0x30000        0x0 [stack]

(gdb) x/1x 0x10000040
0x10000040:     Cannot access memory at address 0x10000040

# /mnt/testarea/ltp/testcases/bin/genasin
Bus error (core dumped)

However, as soon as I copy that binary somewhere else, it works fine:

# cp /mnt/testarea/ltp/testcases/bin/genasin /tmp
# /tmp/genasin
# echo $?
0

# cp /mnt/testarea/ltp/testcases/bin/genasin /mnt/testarea/ltp/testcases/bi=
n/genasin2
# /mnt/testarea/ltp/testcases/bin/genasin2
# echo $?
0

# /mnt/testarea/ltp/testcases/bin/genasin
Bus error (core dumped)

# diff /mnt/testarea/ltp/testcases/bin/genasin /mnt/testarea/ltp/testcases/=
bin/genasin2; echo $?
0

# lscpu
Architecture:                    ppc64le
Byte Order:                      Little Endian
CPU(s):                          160
On-line CPU(s) list:             0-159
Thread(s) per core:              4
Core(s) per socket:              20
Socket(s):                       2
NUMA node(s):                    2
Model:                           2.2 (pvr 004e 1202)
Model name:                      POWER9, altivec supported
Frequency boost:                 enabled
CPU max MHz:                     3800.0000
CPU min MHz:                     2166.0000
L1d cache:                       1.3 MiB
L1i cache:                       1.3 MiB
L2 cache:                        10 MiB
L3 cache:                        200 MiB
NUMA node0 CPU(s):               0-79
NUMA node8 CPU(s):               80-159
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Mitigation; RFI Flush, L1D private per thr=
ead
Vulnerability Spec store bypass: Mitigation; Kernel entry/exit barrier (eie=
io)
Vulnerability Spectre v1:        Mitigation; __user pointer sanitization, o=
ri31 speculation barrier enabled
Vulnerability Spectre v2:        Mitigation; Indirect branch cache disabled=
, Software link stack flush
Vulnerability Tsx async abort:   Not affected

