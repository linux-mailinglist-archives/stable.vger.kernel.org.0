Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E6210E593
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 06:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLBFqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 00:46:47 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37345 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfLBFqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 00:46:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47RDdG73XDz9sNx;
        Mon,  2 Dec 2019 16:46:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1575265603;
        bh=B+FQnkVuwPIY8u8J60CbDV7Nb4472pZsaQxisci+JSo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z7SpYTKusmHLF4lnxPzcpbGwT0kxZvJAMjCJho3IXex6tvW9ESDUO30zW19WrkSy0
         IzYC0fU5ZPnchkm9BeZVU7ji7d5yFA1GK0LhEgu/0SzQwxJOr1MwH3jO9q5dj3Freg
         bufmW2abuna36hd2+bmbkclX5BLIGKMePgukT/uOm7wd/SfhUqhRcAxCrOks4SOn7j
         mGjpJtzxamYSDajIOVHqsbxIhZR1m+L+qfa7WBOHxP375CyPuTalilXs+p+Vt3Rm1o
         FxDPz+z54luIqMOArnZtPaES01q5ztYQYHbqhERdoSYnHIHVAWZsQOPOau3+Pnl7pO
         ESnibXzHnEzbQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: =?utf-8?Q?=E2=9D=8C?= FAIL: Test report for kernel
 5.3.13-3b5f971.cki (stable-queue)
In-Reply-To: <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com> <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com>
Date:   Mon, 02 Dec 2019 16:46:40 +1100
Message-ID: <8736e3ffen.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

Jan Stancek <jstancek@redhat.com> writes:
> ----- Original Message -----
>>=20
>> Hello,
>>=20
>> We ran automated tests on a recent commit from this kernel tree:
>>=20
>>        Kernel repo:
>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue=
.git
>>             Commit: 3b5f97139acc - KVM: PPC: Book3S HV: Flush link stack=
 on
>>             guest exit to host kernel

I can't find this commit, I assume it's roughly the same as:

  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t/commit/?h=3Dlinux-5.3.y&id=3D0815f75f90178bc7e1933cf0d0c818b5f3f5a20c

>> The results of these automated tests are provided below.
>>=20
>>     Overall result: FAILED (see details below)
>>              Merge: OK
>>            Compile: OK
>>              Tests: FAILED
>>=20
>> All kernel binaries, config files, and logs are available for download h=
ere:
>>=20
>>   https://artifacts.cki-project.org/pipelines/314344
>>=20
>> One or more kernel tests failed:
>>=20
>>     ppc64le:
>>      =E2=9D=8C LTP
>
> I suspect kernel bug.

Looks that way, but I can't reproduce it on a machine here.

I have the same CPU revision and am booting the exact kernel binary &
modules linked above.

> There were couple of 'math' runtest related failures in recent couple day=
s.
> In all cases, some data file used by test was missing. Presumably because
> binary that generates it crashed.
>
> I managed to reproduce one failure with this CKI build, which I believe
> is the same problem.
>
> We crash early during load, before any LTP code runs:
>
> (gdb) r
> Starting program: /mnt/testarea/ltp/testcases/bin/genasin

What is this /mnt/testarea? Looks like it's setup by some of the beaker
scripts or something?

I'm running LTP out of /home, which is ext4 directly on disk.

I tried getting the tests-beaker stuff working on my machine, but I
couldn't find all the libraries and so on it requires.


> Program received signal SIGBUS, Bus error.
> dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7ffff=
fffe760, auxv=3D<optimized out>) at rtld.c:1362
> 1362        switch (ph->p_type)
> (gdb) bt
> #0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7=
fffffffe760, auxv=3D<optimized out>) at rtld.c:1362
> #1  0x00007ffff7fcf3c8 in _dl_sysdep_start (start_argptr=3D<optimized out=
>, dl_main=3D0x7ffff7fb37b0 <dl_main>) at ../elf/dl-sysdep.c:253
> #2  0x00007ffff7fb1d1c in _dl_start_final (arg=3Darg@entry=3D0x7fffffffee=
20, info=3Dinfo@entry=3D0x7fffffffe870) at rtld.c:445
> #3  0x00007ffff7fb2f5c in _dl_start (arg=3D0x7fffffffee20) at rtld.c:537
> #4  0x00007ffff7fb14d8 in _start () from /lib64/ld64.so.2
> (gdb) f 0
> #0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7=
fffffffe760, auxv=3D<optimized out>) at rtld.c:1362
> 1362        switch (ph->p_type)
> (gdb) l
> 1357      /* And it was opened directly.  */
> 1358      ++main_map->l_direct_opencount;
> 1359
> 1360      /* Scan the program header table for the dynamic section.  */
> 1361      for (ph =3D phdr; ph < &phdr[phnum]; ++ph)
> 1362        switch (ph->p_type)
> 1363          {
> 1364          case PT_PHDR:
> 1365            /* Find out the load address.  */
> 1366            main_map->l_addr =3D (ElfW(Addr)) phdr - ph->p_vaddr;
>
> (gdb) p ph
> $1 =3D (const Elf64_Phdr *) 0x10000040
>
> (gdb) p *ph
> Cannot access memory at address 0x10000040
>
> (gdb) info proc map
> process 1110670
> Mapped address spaces:
>
>           Start Addr           End Addr       Size     Offset objfile
>           0x10000000         0x10010000    0x10000        0x0 /mnt/testar=
ea/ltp/testcases/bin/genasin
>           0x10010000         0x10030000    0x20000        0x0 /mnt/testar=
ea/ltp/testcases/bin/genasin
>       0x7ffff7f90000     0x7ffff7fb0000    0x20000        0x0 [vdso]
>       0x7ffff7fb0000     0x7ffff7fe0000    0x30000        0x0 /usr/lib64/=
ld-2.30.so
>       0x7ffff7fe0000     0x7ffff8000000    0x20000    0x20000 /usr/lib64/=
ld-2.30.so
>       0x7ffffffd0000     0x800000000000    0x30000        0x0 [stack]
>
> (gdb) x/1x 0x10000040
> 0x10000040:     Cannot access memory at address 0x10000040

Yeah that's weird.

> # /mnt/testarea/ltp/testcases/bin/genasin
> Bus error (core dumped)
>
> However, as soon as I copy that binary somewhere else, it works fine:
>
> # cp /mnt/testarea/ltp/testcases/bin/genasin /tmp
> # /tmp/genasin
> # echo $?
> 0

Is /tmp a real disk or tmpfs?

cheers

> # cp /mnt/testarea/ltp/testcases/bin/genasin /mnt/testarea/ltp/testcases/=
bin/genasin2
> # /mnt/testarea/ltp/testcases/bin/genasin2
> # echo $?
> 0
>
> # /mnt/testarea/ltp/testcases/bin/genasin
> Bus error (core dumped)
>
> # diff /mnt/testarea/ltp/testcases/bin/genasin /mnt/testarea/ltp/testcase=
s/bin/genasin2; echo $?
> 0
>
> # lscpu
> Architecture:                    ppc64le
> Byte Order:                      Little Endian
> CPU(s):                          160
> On-line CPU(s) list:             0-159
> Thread(s) per core:              4
> Core(s) per socket:              20
> Socket(s):                       2
> NUMA node(s):                    2
> Model:                           2.2 (pvr 004e 1202)
> Model name:                      POWER9, altivec supported
> Frequency boost:                 enabled
> CPU max MHz:                     3800.0000
> CPU min MHz:                     2166.0000
> L1d cache:                       1.3 MiB
> L1i cache:                       1.3 MiB
> L2 cache:                        10 MiB
> L3 cache:                        200 MiB
> NUMA node0 CPU(s):               0-79
> NUMA node8 CPU(s):               80-159
> Vulnerability Itlb multihit:     Not affected
> Vulnerability L1tf:              Not affected
> Vulnerability Mds:               Not affected
> Vulnerability Meltdown:          Mitigation; RFI Flush, L1D private per t=
hread
> Vulnerability Spec store bypass: Mitigation; Kernel entry/exit barrier (e=
ieio)
> Vulnerability Spectre v1:        Mitigation; __user pointer sanitization,=
 ori31 speculation barrier enabled
> Vulnerability Spectre v2:        Mitigation; Indirect branch cache disabl=
ed, Software link stack flush
> Vulnerability Tsx async abort:   Not affected
