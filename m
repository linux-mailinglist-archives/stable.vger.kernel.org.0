Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070ED3A6F36
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhFNTgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:36:53 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:39823 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235269AbhFNTgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:36:50 -0400
Date:   Mon, 14 Jun 2021 19:21:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1623698516;
        bh=8aPQKPWWUHtic0SGoCH7J29PZKWShsuStdA0XbDGBN8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=R8UJLYI+Eotv8eJ0dm2tFZbJ6pFeMYtvv+Z+NyG5SiJItKjqg0VghXPmpCU9rKw4x
         96hcDzJVa30t1dqE++PV6b5VWiFaMvBTeN/yypbGDm6M/G/TtRGjfbjQ/+mbgKThWe
         Jd4v3HlLDSy8TLzFMKpFmtKrt7FyqiD9I/gAMlxY=
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Adam Edge <baronedge@protonmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Reply-To: Adam Edge <baronedge@protonmail.com>
Subject: Regression after 5.7.19 causing major freezes on CPU loads
Message-ID: <HnYKcqmY_z0ERb5qOOUauOLY1vt6nxuKHXzuKVrZ297elyqtzpsWTrjUUnlIDG7mQUYnJMfS8HkFceFMf0Fd_GLzOMghgf4btNt9YhwwZK0=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

After I've upgraded from 5.7.11 (didn't have access to this machine for
about 10 months) to 5.12.10, I've noticed that anytime I used all my
cores to, for example, compile a project, the system would degrade
significantly in performance and applications would start to stutter.
Compiles are also about 3-4x slower on kernels with the regression vs.
without. After debugging this for the past 24 hours or so, I've narrowed
it down to a change between 5.7.19 and 5.8.1. Sadly, bisect does not
help, because trying to run any of the 5.8 RC kernels causes the kernel
to be stuck before init, without any apparent errors on the screen (and
I don't have a serial cable to dump the kernel output to). I'm listing
all the information I know and my system information below.

Reproduction steps (dunno if this helps, but):
1. Boot with kernel with the regression
2. Do something that uses all cores, like compiling the Linux kernel
3. Observe long compile times and stuttering applications (which doesn't
happen even on full load with a working kernel)

Regression between kernel versions:
5.7 - working
5.7.11 - working
5.7.19 - working
5.8.1 - broken
5.8.18 - broken
5.12.10 - broken
8ecfa36cd4db3275bf3b6c6f32c7e3c6bb537de2 (master on 2021-06-13) - broken

System information:
Gentoo Linux 17.1 amd64

CPU info:
processor    : 7
vendor_id    : GenuineIntel
cpu family    : 6
model        : 60
model name    : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping    : 3
microcode    : 0x27
cpu MHz        : 2042.008
cache size    : 8192 KB
physical id    : 0
siblings    : 8
core id        : 3
cpu cores    : 4
apicid        : 7
initial apicid    : 7
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
abm cpuid_fault epb invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow
vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep
bmi2 erms invpcid xsaveopt dtherm ida arat pln pts md_clear flush_l1d
vmx flags    : vnmi preemption_timer invvpid ept_x_only ept_ad ept_1gb
flexpriority tsc_offset vtpr mtf vapic ept vpid unrestricted_guest ple
shadow_vmcs
bugs        : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
mds swapgs itlb_multihit srbds
bogomips    : 7199.96
clflush size    : 64
cache_alignment    : 64
address sizes    : 39 bits physical, 48 bits virtual
power management:

RAM: 16GiB
GPU: VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
Redwood XT [Radeon HD 5670/5690/5730]
cat /proc/sys/kernel/tainted: 0

Thanks in advance.

Best Regards,
Adam Edge
