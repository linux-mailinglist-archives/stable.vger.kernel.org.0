Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FD3277F20
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 06:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgIYEnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 00:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIYEnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 00:43:19 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256FFC0613CE
        for <stable@vger.kernel.org>; Thu, 24 Sep 2020 21:43:19 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id q26so491421uaa.12
        for <stable@vger.kernel.org>; Thu, 24 Sep 2020 21:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4DqUHsC8QKTnOAjY1Qg/yQG+iS44vpBPggcD5kS49A=;
        b=vJ8MULsdIOYhmDS86rWTlD4sGzyY5Pa2gW+8z7fSrTwXYJu23LFbBI09gFmee5Z5ZP
         MUFyVgJZY1J1JMyB72fvg9Ubtp/WeCsTF8l6ltDBN8ulgYcsY+IBBysg4KI0PY2UnONe
         6QFCWMvdjLqEbEFy3b/xLk65k2QXIZSDTZXg+y+SMNF75sTQM8iLVNWXkobESKPH2u8I
         Q2/AnDJEM2erm3wuM7BUSlMOaGCD719YG7E4q6uCAMjX6IjGmzQ95lsemIZ5c0anWIx7
         kXjQ2gxkPoaASkIjmNB3RHB8w8vmficBWivGgGjYd/ZRy6INe3Bi4ADuhoNL9UbKwGvk
         MGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4DqUHsC8QKTnOAjY1Qg/yQG+iS44vpBPggcD5kS49A=;
        b=Ho2Bc8dm0YFh2EkfVGABYLHJlDkCpRtGwjJjEakIX5tRA0/QA5uc9drs4Kbe2fHymW
         xqhAN4/sQZX2ADIBa4qCmsP5598Fv66jwjYMAIjOtWx9WDEPZ/Xy4vSvzlum475211uF
         LIXWGIipf9ZdgLNH5ki31rQZlfi38ZEaI4aeRGC+bPRSQww6YbJq1/mhru7lqRsd8fNM
         9ne9KhoKhc0O0SN3393c9kJ//Q4nElY2FXorYvyl6qFWUcA3uROvxPVlq0qPaheacLsi
         VWR/wI8jErX8pJA2+gkDpAFLyhQT6oviyU7y7CMdTCRglqT016p9yFlt9IwL0U/AuZlM
         jGUg==
X-Gm-Message-State: AOAM5308hNYagePFvIIDoqh3VQN+wLyle9BFC3s7+jJuu6qvwqtsYdK7
        vM40sck85jlq5wdmN7mvLtZbnyqsIsNii9gfA1+g5w==
X-Google-Smtp-Source: ABdhPJz8DZSpFMurO8H9TsI0CcnpZmWotH+js0nxnyVdRPaRcd7HhMxUirGN2fsjMZ5JBtmFGlbYwJ0H/Q/9sk0Nntw=
X-Received: by 2002:ab0:d93:: with SMTP id i19mr1514416uak.7.1601008997083;
 Thu, 24 Sep 2020 21:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180823023839.GA13343@shao2-debian> <20180828195347.GA228832@joelaf.mtv.corp.google.com>
In-Reply-To: <20180828195347.GA228832@joelaf.mtv.corp.google.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 25 Sep 2020 10:13:05 +0530
Message-ID: <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
Subject: [stable 4.19] [PANIC]: tracing: Centralize preemptirq tracepoints and
 unify their usage
To:     Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From stable rc 4.18.1 onwards to today's stable rc 4.19.147

There are two problems  while running LTP tracing tests
1) kernel panic  on i386, qemu_i386, x86_64 and qemu_x86_64 [1]
2) " segfault at 0 ip " and "Code: Bad RIP value" on x86_64 and qemu_x86_64 [2]
Please refer to the full test logs from below links.

The first bad commit found by git bisect.
   commit: c3bc8fd637a9623f5c507bd18f9677effbddf584
   tracing: Centralize preemptirq tracepoints and unify their usage

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

easily reproducible on qemu
steps to reproduce:
    # Boot qemu x86_64 with trace configs enabled.
    # cd /opt/ltp
    # ./runltp -f tracing

metadata:
  git branch: linux-4.19.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  make_kernelversion: 4.19.147
  kernel-config:
https://builds.tuxbuild.com/lOpUmeYR2e1pzvYdlLgGqw/kernel.config


Crash log on qemu_i386
---------------------------------

ftrace-stress-test 1 TINFO: Start pid15=2414
/opt/ltp/testcases/bin/ftrace_stress/ftrace_buffer_size_kb.sh
ftrace-stress-test 1 TINFO: Start pid16=2415
/opt/ltp/testcases/bin/ftrace_stress/ftrace_tracing_cpumask.sh
ftrace-stress-test 1 TINFO: Start pid17=2416
/opt/ltp/testcases/bin/ftrace_stress/ftrace_set_ftrace_filter.sh
[   38.479869] Scheduler tracepoints stat_sleep, stat_iowait,
stat_blocked and stat_runtime require the kernel parameter
schedstats=enable or kernel.sched_schedstats=1
Sep 23 18:39:40 intel-core2-32 user.warn kernel: [   38.479869]
Scheduler tracepoints stat_sleep, stat_iowait, stat_blocked and
stat_runtime require the kernel parameter schedstats=enable or
kernel.sched_schedstats=1
[   38.549712] cat[2583]: segfault at 0 ip b7f81767 sp bfbb3a20 error
4 in ld-2.27.so[b7f6c000+25000]
[   38.550427] sh[2582]: segfault at 467 ip b7fba0d8 sp bfacdb04 error
4 in ld-2.27.so[b7f9f000+25000]
[   38.551386] Code: 50 8d 86 84 62 ff ff 50 e8 86 a9 ff ff 83 c4 10
89 c2 83 f8 ff 0f 84 72 01 00 00 8b b6 e4 08 00 00 83 fe 10 0f 86 56
01 00 00 <81> 38 6c 64 2e 73 0f 85 1d 01 00 00 81 78 04 6f 2d 31 2e 0f
85 10
[   38.552710] Code: 40 38 d5 74 ea 80 fd 00 74 12 c1 e9 10 40 38 d1
74 dd 80 f9 00 74 05 40 38 d5 74 d3 31 c0 eb cf 66 90 8b 4c 24 04 8b
54 24 08 <8a> 01 3a 02 75 09 41 42 84 c0 75 f4 31 c0 c3 b8 01 00 00 00
b9 ff
[   38.556010] systemd-journal[1327]: segfault at 5e ip b7c61e12 sp
bff45044 error 6 in libc-2.27.so[b7b29000+1cc000]
[   38.558971] sh[2584]: segfault at 0 ip b7f30c15 sp bfbce710 error 14
[   38.559387] audit: type=1701 audit(1600886380.372:3):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2582
comm=\"sh\" exe=\"/bin/bash.bash\" sig=11 res=1
[   38.559411] audit: type=1701 audit(1600886380.372:4):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2583
comm=\"cat\" exe=\"/bin/cat.coreutils\" sig=11 res=1
[   38.560079] Code: 66 0f 7f 5c 3a f0 72 30 66 0f 6f 54 38 10 83 e9
20 66 0f 6f 5c 38 20 66 0f 6f cb 66 0f 3a 0f da 08 66 0f 3a 0f d4 08
8d 7f 20 <66> 0f 7f 54 3a e0 66 0f 7f 5c 3a f0 73 a0 8d 49 20 01 cf 01
fa 8d
[   38.560811] audit: type=1701 audit(1600886380.373:5):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=1327
comm=\"systemd-journal\" exe=\"/lib/systemd/systemd-journald\" sig=11
res=1
[   38.561615] Code: Bad RIP value.
[   38.564712] Core dump to |/bin/false pipe failed
[   38.566144] Core dump to |/bin/false pipe failed
[   38.566213] Core dump to |/bin/false pipe failed
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.549712]
cat[2583]: segfault at 0 ip b7f81767 sp bfbb3a20 error 4 in
ld-2.27.so[b7f6c000+25000]
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.550427]
sh[2582]: segfault at 467 ip b7fba0d8 sp bfacdb04 error 4 in
ld-2.27.so[b7f9f000+25000]
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.551386] Code:
50 8d 86 84 62 ff ff 50 e8 86 a9 ff ff 83 c4 10 89 c2 83 f8 ff 0f 84
72 01 00 00 8b b6 e4 08 00 00 83 fe 10 0f 86 56 01 00 00 <81> 38 6c 64
2e 73 0f 85 1d 01 00 00 81 78 04 6f 2d 31 2e 0f 85 10
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.552710] Code:
40 38 d5 74 ea 80 fd 00 74 12 c1 e9 10 40 38 d1 74 dd 80 f9 00 74 05
40 38 d5 74 d3 31 c0 eb cf 66 90 8b 4c 24 04 8b 54 24 08 <8a> 01 3a 02
75 09 41 42 84 c0 75[   38.582519] systemd[1]: segfault at 1 ip
b7de036e sp bfd888e0 error 7 in
libsystemd-shared-237.so[b7cd4000+1e2000]
 f4 31 c0 c3 b8 [   38.584227] Code: 46 18 83 e0 1f 83 c8 20 88 46 18
89 f0 e8 ba da ff ff 85 c0 89 c3 0f 88 e0 00 00 00 8b 44 24 24 31 db
85 c0 74 06 8b 44 24 24 <89> 30 83 c4 0c 89 d8 5b 5e 5f 5d c3 8d b6 00
00 00 00 8d 83 1c 1c
01 00 00 00 b9 ff
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.556010]
systemd-journal[1327]: segfau[   38.587783] systemd[1]: segfault at 0
ip b7a9fbe3 sp bfd88000 error 7 in libc-2.27.so[b79e5000+1cc000]
lt at 5e ip b7c6[   38.589349] Code: 14 8b 4c 24 10 8b 5c 24 0c b8 72
00 00 00 65 ff 15 10 00 00 00 5b 5e 3d 01 f0 ff ff 0f 83 75 e3 f5 ff
c3 66 90 66 90 55 57 56 <53> 83 ec 1c 8b 5c 24 30 8b 4c 24 34 8b 54 24
38 8b 74 24 3c 65 8b
1e12 sp bff45044 error 6 in libc-2.27.so[b7b29000+1cc000]
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.558971]
sh[2584]: segfault at 0 ip b7f30c15 sp bfbce710 error 14
Sep 23 18:39:40 intel-core2-32 user.notice kernel: [   38.559387]
audit: type=1701 audit(1600886380.372:3): auid=4294967295 uid=0 gid=0
ses=4294967295 subj=kernel pid=2582 comm=\"sh\" exe=\"/bin/bash.bash\"
sig=11 res=1
Sep 23 18:39:40 intel-core2-32 user.notice kernel: [   38.559411]
audit: type=1701 audit(1600886380.372:4): auid=4294967295 uid=0 gid=0
ses=4294967295 subj=kernel pid=2583 comm=\"cat\"
exe=\"/bin/cat.coreutils\" sig=11 res=1
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.560079] Code:
66 0f 7f 5c 3a f0 72 30 66 0f 6f 54 38 10 83 e9 20 66 0f 6f 5c 38 20
66 0f 6f [   38.598779] Core dump to |/bin/false pipe failed
cb 66 0f 3a 0f da 08 66 0f 3a 0f d4 08 8d 7f 20 <66> 0f 7f 54 3a e0 66
0f 7f 5c 3a f0 73 a0 8d 49 20 01 cf 01 fa[   38.600281] Core dump to
|/bin/false pipe failed
 8d
Sep 23 18:39:40 intel-core2-32 user.notice kernel: [   38.560811]
audit: type=1701 audit(1600886380.373:5): auid=4294967295 uid=0 gid=0
ses=4294967295 subj=kernel pid=1327 comm=\"systemd-j[   38.602831]
Core dump to |/bin/false pipe failed
ournal\" exe=\"/li[   38.603778] Kernel panic - not syncing: Attempted
to kill init! exitcode=0x0000000b
[   38.603778]
[   38.604715] CPU: 3 PID: 1 Comm: systemd Not tainted 4.19.147 #1
[   38.605408] Core dump to |/bin/false pipe failed
b/[sy s t e3m8d./6s0y4s7t1e5m] Hardware name: QEMU Standard PC (i440FX
+ PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[   38.604715] Call Trace:
[   38.604715]  dump_stack+0x6e/0x9e
[   38.604715]  panic+0x94/0x1d1
[   38.608596]  do_exit.cold+0x8d/0xa6
[   38.608596]  do_group_exit+0x36/0xa0
[   38.608596]  get_signal+0x131/0x6c0
[   38.608596]  do_signal+0x29/0x5a0
[   38.608596]  ? trace_buffer_unlock_commit_regs+0x54/0x80
d-[j o u rna3ld\"8. s60i8g5=96]  ? trace_event_buffer_commit+0x5d/0x1c0
[   38.608596]  ? trace_event_buffer_reserve+0x50/0x80
1[1   r e3s8=1
Sep 23.608596]  exit_to_usermode_loop+0x8f/0x100
[   38.608596]  ? __do_page_fault+0x470/0x470
[   38.608596]  prepare_exit_to_usermode+0x57/0x80
[   38.608596]  resume_userspace+0xd/0x12
[  1 8 :3389.:604805 9i6n]t eElI-P: 0xb7a9fbe3
[   38.608596] Code: 14 8b 4c 24 10 8b 5c 24 0c b8 72 00 00 00 65 ff
15 10 00 00 00 5b 5e 3d 01 f0 ff ff 0f 83 75 e3 f5 ff c3 66 90 66 90
55 57 56 <53> 83 ec 1c 8b 5c 24 30 8b 4c 24 34 8b 54 24 38 8b 74 24 3c
65 8b
[   38.617637] EAX: 00000000 EBX: b7efb2e4 ECX: 00000000 EDX: 00000a1d
[   38.617637] ESI: bfd88100 EDI: bfd88180 EBP: 00000000 ESP: bfd88000
[   38.617637] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
core2-32 user.info kernel: [   38.561615] Code: Bad RIP value.
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.564712] Core
dump to |/bin/false pipe failed
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.566144] Core
dump to |/bin/false pipe failed
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.566213] Core
dump to |/bin/false pipe failed
Sep 23 18:39:40 intel-core2-32 user.emerg kernel: [   38.582519]
systemd[1]: segfault at 1 ip b7de036e sp bfd888e0 error 7 in
libsystemd-shared-237.so[b7cd4000+1e2000]
Sep 23 18:39:40 intel-core2-32 user.emerg kernel: [   38.584227] Code:
46 18 83 e0 1f 83 c8 20 88 46 18 89 f0 e8 ba da ff ff 85 c0 89 c3 0f
88 e0 00 00 00 8b 44 24 24 31 db 85 c0 74 06 8b 44 24 24 <89> 30 83 c4
0c 89 d8 5b 5e 5f 5d c3 8d b6 00 00 00 00 8d 83 1c 1c
Sep 23 18:39:40 intel-core2-32 user.emerg kernel: [   38.587783]
systemd[1]: segfault at 0 ip b7a9fbe3 sp bfd88000 error 7 in
libc-2.27.so[b79e5000+1cc000]
Sep 23 18:39:40 intel-core2-32 user.emerg kernel: [   38.589349] Code:
14 8b 4c 24 10 8b 5c 24 0c b8 72 00 00 00 65 ff 15 10 00 00 00 5b 5e
3d 01 f0 ff ff 0f 83 75 e3 f5 ff c3 66 90 66 90 55 57 56 <53> 83 ec 1c
8b 5c 24 30 8b 4c 24 34 8b 54 24 38 8b 74 24 3c 65 8b
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.598779] Core
dump to |/bin/false pipe failed
Sep 23 18:39:40 intel-core2-32 user.info kernel: [   38.600281] Core
dump to |/bin/false pipe failed
[   38.617637] Kernel Offset: 0x10c00000 from 0xc1000000 (relocation
range: 0xc0000000-0xf77fdfff)
[   38.617637] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b
[   38.617637]  ]---
[   38.622610] ------------[ cut here ]------------
[   38.622610] sched: Unexpected reschedule of offline CPU#0!
[   38.622610] WARNING: CPU: 3 PID: 1 at arch/x86/kernel/smp.c:128
native_smp_send_reschedule+0x3b/0x50
[   38.622610] Modules linked in:
[   38.622610] CPU: 3 PID: 1 Comm: systemd Not tainted 4.19.147 #1
[   38.622610] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[   38.622610] EIP: native_smp_send_reschedule+0x3b/0x50
[   38.622610] Code: 8b 15 20 4a b8 d2 8b 4a 18 ba fd 00 00 00 e8 a4
02 b0 00 c9 c3 8d b4 26 00 00 00 00 8d 76 00 50 68 24 a7 a8 d2 e8 9f
f3 01 00 <0f> 0b 58 5a c9 c3 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
90 0f
[   38.622610] EAX: 0000002e EBX: f456d800 ECX: f51eab88 EDX: 00000007
[   38.622610] ESI: d2dfcf00 EDI: 00000000 EBP: f4d1dca4 ESP: f4d1dc9c
[   38.622610] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010092
[   38.622610] CR0: 80050033 CR2: 00000000 CR3: 33f02000 CR4: 003406d0
[   38.622610] Call Trace:
[   38.622610]  try_to_wake_up+0x38b/0x400
[   38.622610]  ? wait_woken+0x70/0x70
[   38.622610]  default_wake_function+0x10/0x20
[   38.622610]  autoremove_wake_function+0x14/0x40
[   38.622610]  __wake_up_common+0x6b/0x130
[   38.622610]  __wake_up_common_lock+0x77/0xb0
[   38.622610]  __wake_up+0x12/0x20
[   38.622610]  wake_up_klogd_work_func+0x66/0x70
[   38.622610]  irq_work_run_list+0x48/0x80
[   38.622610]  ? setup_data_read+0xd0/0xd0
[   38.622610]  irq_work_run+0x25/0x40
[   38.622610]  flush_smp_call_function_queue+0x66/0xe0
[   38.622610]  generic_smp_call_function_single_interrupt+0x12/0x2a
[   38.622610]  smp_call_function_interrupt+0x3a/0xd0
[   38.622610]  call_function_interrupt+0xd7/0xdc
[   38.622610] EIP: panic+0x194/0x1d1
[   38.622610] Code: 83 c3 64 eb b7 83 3d 4c d5 e1 d2 00 74 05 e8 e6
f7 01 00 68 80 d5 e1 d2 68 f8 04 a9 d2 e8 47 7c 05 00 e8 42 28 0d 00
fb 31 db <58> 5a 39 fb 7c 18 83 f6 01 8b 15 40 d5 e1 d2 89 f0 e8 31 0d
ae 00
[   38.622610] EAX: d1ccf04e EBX: 00000000 ECX: 40000000 EDX: 80000000
[   38.622610] ESI: 00000000 EDI: 00000000 EBP: f4d1de20 ESP: f4d1de08
[   38.622610] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00000246
[   38.622610]  ? panic+0x191/0x1d1
[   38.622610]  do_exit.cold+0x8d/0xa6
[   38.622610]  do_group_exit+0x36/0xa0
[   38.622610]  get_signal+0x131/0x6c0
[   38.622610]  do_signal+0x29/0x5a0
[   38.622610]  ? trace_buffer_unlock_commit_regs+0x54/0x80
[   38.622610]  ? trace_event_buffer_commit+0x5d/0x1c0
[   38.622610]  ? trace_event_buffer_reserve+0x50/0x80
[   38.622610]  exit_to_usermode_loop+0x8f/0x100
[   38.622610]  ? __do_page_fault+0x470/0x470
[   38.622610]  prepare_exit_to_usermode+0x57/0x80
[   38.622610]  resume_userspace+0xd/0x12
[   38.622610] EIP: 0xb7a9fbe3
[   38.622610] Code: 14 8b 4c 24 10 8b 5c 24 0c b8 72 00 00 00 65 ff
15 10 00 00 00 5b 5e 3d 01 f0 ff ff 0f 83 75 e3 f5 ff c3 66 90 66 90
55 57 56 <53> 83 ec 1c 8b 5c 24 30 8b 4c 24 34 8b 54 24 38 8b 74 24 3c
65 8b
[   38.622610] EAX: 00000000 EBX: b7efb2e4 ECX: 00000000 EDX: 00000a1d
[   38.622610] ESI: bfd88100 EDI: bfd88180 EBP: 00000000 ESP: bfd88000
[   38.622610] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
[   38.622610] ---[ end trace 16b4da0e9552fc5a ]---


Crash log on qemu_x86_64
-------------------------------------

ftrace-stress-test 1 TINFO: Start pid16=2519
/opt/ltp/testcases/bin/ftrace_stress/ftrace_tracing_cpumask.sh
ftrace-stress-test 1 TINFO: Start pid17=2520
/opt/ltp/testcases/bin/ftrace_stress/ftrace_set_ftrace_filter.sh
[   37.455928] Scheduler tracepoints stat_sleep, stat_iowait,
stat_blocked and stat_runtime require the kernel parameter
schedstats=enable or kernel.sched_schedstats=1
Sep 23 18:30:46 intel-corei7-64 user.warn kernel: [   37.455928]
Scheduler tracepoints stat_sleep, stat_iowait, stat_blocked and
stat_runtime require the kernel parameter schedstats=enable or
kernel.sched_schedstats=1
Sep 23 18:30:46 intel-corei7-64 daemon.info avahi-daemon[2069]:
Withdrawing address record for 10.66.17.129 on enp0s3.
Sep 23 18:30:46 intel-corei7-64 daemon.warn avahi-daemon[2069]: Host
name conflict, retrying with intel-corei7-74
Sep 23 18:30:46 intel-corei7-64 daemon.info avahi-daemon[2069]:
Registering new address record for fe80::1b53:d658:9c7c:5b03 on
enp0s3.*.
Sep 23 18:30:46 intel-corei7-64 daemon.info avahi-daemon[2069]:
Registering new address record for 10.66.17.129 on enp0s3.IPv4.
[   38.065573] cat[2507]: segfault at 0 ip 00007ff47cb93810 sp
00007fff74060ce8 error 14
[   38.065833] sh[2519]: segfault at 0 ip 000000000042bc9e sp
00007fffeae3b3c0 error 7
[   38.065894]  in libc-2.27.so[7ff47cad2000+1aa000]
[   38.067380] cat[2532]: segfault at 0 ip 00007f5565234810 sp
00007fffcf0bb1b8 error 14
[   38.067698]  in bash.bash[400000+f3000]
[   38.068171] Code: 41 56 45 31 f6 41 55 41 54 41 bc c8 00 00 00 55
53 48 81 ec 68 0e 00 00 c7 05 8a 49 2d 00 00 00 00 00 48 8d ac 24 e0
01 00 00 <66> 89 74 24 50 48 8d 5c 24 50 48 89 6c 24 20 c7 05 99 49 2d
00 fe
[   38.069425] Code: Bad RIP value.
[   38.069821] klogd[2071]: segfault at 1ff ip 00007fc2806db17b sp
00007ffed1ee9f10 error 6
[   38.070702] audit: type=1701 audit(1600885846.865:3):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2519
comm=\"sh\" exe=\"/bin/bash.bash\" sig=11 res=1
[   38.071592]  in libc-2.27.so[7f5565173000+1aa000]
[   38.072685]  in libc-2.27.so[7fc28065c000+1aa000]
[   38.073082] Code: 48 29 d8 31 f6 48 8d 3c 19 49 39 d5 40 0f 95 c6
48 83 cb 01 48 83 c8 01 49 89 7d 60 48 c1 e6 02 48 89 da 48 09 f2 48
89 51 08 <48> 89 47 08 e9 95 fe ff ff 48 8d 3d 9d af 0f 00 e8 60 ca ff
ff 48
[   38.075649] audit: type=1701 audit(1600885846.868:4):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2071
comm=\"klogd\" exe=\"/bin/busybox.nosuid\" sig=11 res=1
[   38.076574] Code: Bad RIP value.
[   38.079615] sh[2518]: segfault at ff ip 00007f580bee417b sp
00007ffce56b4180 error 6 in libc-2.27.so[7f580be65000+1aa000]
[   38.087568] Code: 48 29 d8 31 f6 48 8d 3c 19 49 39 d5 40 0f 95 c6
48 83 cb 01 48 83 c8 01 49 89 7d 60 48 c1 e6 02 48 89 da 48 09 f2 48
89 51 08 <48> 89 47 08 e9 95 fe ff ff 48 8d 3d 9d af 0f 00 e8 60 ca ff
ff 48
[   38.094737] cat[2699]: segfault at 0 ip 00007f1d6e9d6030 sp
00007ffdbad5e380 error 14 in ld-2.27.so[7f1d6e9d5000+25000]
[   38.097246] Code: Bad RIP value.
[   38.101982] audit: type=1701 audit(1600885846.898:6):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2532
comm=\"cat\" exe=\"/bin/cat.coreutils\" sig=11 res=1
[   38.102536] Core dump to |/bin/false pipe failed
[   38.105603] Core dump to |/bin/false pipe failed
ftrace_stack_max_size.sh: line 26:  2698 Segmentation fault      cat
\"$TRACING_PATH\"/stack_max_size > /dev/null
ftrace_trace_pipe.sh: line 36:  2507 Segmentation fault      (core
dumped) cat \"$TRACING_PATH\"/trace_pipe > /dev/null
ftrace_trace.sh: line 25:  2532 Segmentation fault      (core dumped)
cat \"$TRACING_PATH\"/trace > /dev/null
ftrace_trace_stat.sh: line 44:  2699 Segmentation fault      (core
dumped) cat \"$TRACING_PATH\"/trace_stat/function${cpu} > /dev/null
2>&1
Sep 23 18:30:49 intel-corei7-64 daemon.info avahi-daemon[2069]: Server
startup complete. Host name is intel-corei7-74.local. Local service
cookie is 673226982.
Sep 23 18:30:49 intel-corei7-64 daemon.info avahi-daemon[2069]:
Service \"intel-corei7-74\" (/services/ssh.service) successfully
established.
Sep 23 18:30:49 intel-corei7-64 daemon.info avahi-daemon[2069]:
Service \"intel-corei7-74\" (/services/sftp-ssh.service) successfully
established.
[   48.755576] show_signal_msg: 4 callbacks suppressed
[   48.755753] sh[2912]: segfault at 1 ip 000000000047098f sp
00007ffe9f95d980 error 4 in bash.bash[400000+f3000]
[   48.760451] Code: 8b 41 20 8b 41 14 48 89 cf 4c 89 45 a8 44 8b 79
20 44 8b 71 08 89 43 14 e8 be 3b fc ff 4c 8b 45 a8 41 83 fc 13 77 34
44 89 e0 <ff> 24 c5 e0 fb 4b 00 66 2e 0f 1f 84 00 00 00 00 00 44 89 f7
e8 58
[   48.769218] audit: type=1701 audit(1600885857.562:10):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2912
comm=\"sh\" exe=\"/bin/bash.bash\" sig=11 res=1
[   48.774574] systemd[1]: segfault at 0 ip 00007fb40e076853 sp
00007ffeaa93ee50 error 7 in
libsystemd-shared-237.so[7fb40df64000+1a3000]
[   48.779661] Code: 9b 63 05 00 e8 be b8 f2 ff 66 0f 1f 44 00 00 41
f6 44 24 28 1f 0f 85 84 04 00 00 41 8b 06 41 f6 44 24 29 01 0f 85 25
04 00 00 <41> 89 44 24 70 be 01 00 00 00 4c 89 e7 e8 0b b7 ff ff 85 c0
0f 88
[   48.784452] ftrace_stress_t[2479]: segfault at 0 ip
0000000000446999 sp 00007ffeabb6ab00 error 7 in
bash.bash[400000+f3000]
[   48.789662] Code: 90 48 8b 1b 48 85 db 0f 84 54 02 00 00 44 3b 6b
08 75 ee 8b 74 24 18 44 89 ef e8 42 eb fe ff 8b 44 24 18 31 d2 3d ff
ff 00 00 <89> 43 0c 0f 94 c2 89 53 10 0f 84 68 02 00 00 8b 7c 24 1c 83
05 e5
[   48.836666] Core dump to |/bin/false pipe failed
[   48.897839] systemd-journal[1442]: segfault at 24 ip
00007f2600e10913 sp 00007ffe69ebb798 error 6 in
libc-2.27.so[7f2600cdf000+1aa000]
[   48.903524] Code: 47 d4 4c 89 4f dc 4c 89 57 e4 4c 89 5f ec 48 89
4f f4 89 57 fc c3 90 4c 8b 4e dc 4c 8b 56 e4 4c 8b 5e ec 48 8b 4e f4
8b 56 fc <4c> 89 4f dc 4c 89 57 e4 4c 89 5f ec 48 89 4f f4 89 57 fc c3
66 0f
[   48.918479] audit: type=1701 audit(1600885857.686:11):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2914
comm=\"systemd\" exe=\"/lib/systemd/systemd\" sig=11 res=1
[   48.921093] audit: type=1701 audit(1600885857.705:12):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=1442
comm=\"systemd-journal\" exe=\"/lib/systemd/systemd-journald\" sig=11
res=1
[   48.927551] audit: type=1701 audit(1600885857.723:13):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2479
comm=\"ftrace_stress_t\" exe=\"/bin/bash.bash\" sig=11 res=1
ftrace_stack_trace.sh: line 35:  2912 Segmentation fault      cat
\"$TRACING_PATH\"/stack_trace > /dev/null
[   49.101773] (agetty): 41 output lines suppressed due to ratelimiting
[   49.382601] systemd[2806]: serial-getty@ttyS1.service: Failed to
connect stdout to the journal socket, ignoring: Connection refused
Sep 23 18:30:58 intel-corei7-64 authpriv.err agetty[2805]: /dev/ttyS2: not a tty
Sep 23 18:30:58 intel-corei7-64 authpriv.err agetty[2806]: /dev/ttyS1: not a tty
[   49.707082] audit: type=1701 audit(1600885858.503:14):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2919
comm=\"dynamic_debug01\" exe=\"/bin/bash.bash\" sig=11 res=1
[   49.707084] ltp-pan[2314]: segfault at 1 ip 00000000004037b0 sp
00007ffeb10df110 error 7 in ltp-pan[400000+7000]
[   49.711151] Code: e8 c5 e0 ff ff 48 85 c0 0f 85 9a 04 00 00 8b bc
24 d8 00 00 00 e8 80 e0 ff ff 83 7c 24 38 00 74 09 8b 7c 24 30 e8 70
e0 ff ff <44> 89 2b 48 8b 3d 5e 4b 20 00 44 89 ee c7 43 04 00 00 00 00
49 8b
[   49.715540] Core dump to |/bin/false pipe failed
[   49.718565] Core dump to |/bin/false pipe failed
[   49.722630] Core dump to |/bin/false pipe failed
[   49.805761] Core dump to |/bin/false pipe failed
[   49.807855] Core dump to |/bin/false pipe failed
[   49.810211] Core dump to |/bin/false pipe failed
[   49.812494] Core dump to |/bin/false pipe failed
[   49.815536] Core dump to |/bin/false pipe failed
[   49.818732] Core dump to |/bin/false pipe failed
[   49.822770] Core dump to |/bin/false pipe failed
[   49.826468] Core dump to |/bin/false pipe failed
[   49.830480] Core dump to |/bin/false pipe failed
[   50.651176] avahi-daemon (2069) used greatest stack depth: 12184 bytes left
[   74.858293] show_signal_msg: 22 callbacks suppressed
[   74.858310] dbus-daemon[2096]: segfault at 1ff ip 00007f86246c717b
sp 00007ffc0e7b6b40 error 6 in libc-2.27.so[7f8624648000+1aa000]
[   74.859556] systemd-logind[2074]: Failed to abandon session scope,
ignoring: Connection timed out
[   74.860273] Code: 48 29 d8 31 f6 48 8d 3c 19 49 39 d5 40 0f 95 c6
48 83 cb 01 48 83 c8 01 49 89 7d 60 48 c1 e6 02 48 89 da 48 09 f2 48
89 51 08 <48> 89 47 08 e9 95 fe ff ff 48 8d 3d 9d af 0f 00 e8 60 ca ff
ff 48
[   74.871558] audit: type=1701 audit(1600885883.668:28):
auid=4294967295 uid=996 gid=994 ses=4294967295 subj=kernel pid=2096
comm=\"dbus-daemon\" exe=\"/usr/bin/dbus-daemon\" sig=11 res=1
Sep 23 18:31:23 intel-corei7-64 [   74.877646] NetworkManager[2098]:
segfault at 0 ip 00007fe5d0fb30d5 sp 00007fff3c9695e0 error 7 in
libc-2.27.so[7fe5d0f36000+1aa000]
authpriv.notice polkitd[2161]: Lost the name org[   74.881756] Code:
4c 0f be 04 0e 4c 3b 05 29 02 33 00 4c 89 c7 73 34 48 83 f9 3f 0f 87
ea 03 00 00 48 8d 04 ce 49 83 c4 10 83 c7 01 48 8b 50 40 <49> 89 14 24
4c 89 60 40 40 88 3c 0e 48 83 c4 48 5b 5d 41 5c 41 5d
.freedesktop.PolicyKit1 - exiting[   74.887291] audit: type=1701
audit(1600885883.684:29): auid=4294967295 uid=0 gid=0 ses=4294967295
subj=kernel pid=2098 comm=\"NetworkManager\"
exe=\"/usr/sbin/NetworkManager\" sig=11 res=1
[   74.891439] Core dump to |/bin/false pipe failed
[   74.896814] NetworkManager (2098) used greatest stack depth: 11912 bytes left
[  258.966773] isc-worker0000[2169]: segfault at 4 ip 000000000043bc05
sp 00007f59aab33c78 error 7 in dhclient[400000+5b000]
[  258.969115] Code: 00 00 00 00 00 b8 03 00 06 00 48 85 ff 74 0b 48
85 f6 74 06 48 83 3f 00 74 0b c3 66 2e 0f 1f 84 00 00 00 00 00 48 89
37 31 c0 <83> 46 1c 01 c3 66 0f 1f 44 00 00 e9 cb 7d fc ff 90 66 2e 0f
1f 84
[  258.972803] audit: type=1701 audit(1600886067.769:30):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=2162
comm=\"isc-worker0000\" exe=\"/sbin/dhclient\" sig=11 res=1
[  258.975070] Core dump to |/bin/false pipe failed
[  353.027171] kworker/dying (1398) used greatest stack depth: 11904 bytes left


Full test log links,
[1] https://lkft.validation.linaro.org/scheduler/job/1784423#L1656
[2] https://lkft.validation.linaro.org/scheduler/job/1784270#L1582


The git bisect confirms the first bad patch to cause these problems.

---
commit c3bc8fd637a9623f5c507bd18f9677effbddf584
Author: Joel Fernandes (Google) <joel@joelfernandes.org>
Date:   Mon Jul 30 15:24:23 2018 -0700

    tracing: Centralize preemptirq tracepoints and unify their usage

    This patch detaches the preemptirq tracepoints from the tracers and
    keeps it separate.

    Advantages:
    * Lockdep and irqsoff event can now run in parallel since they no longer
    have their own calls.

    * This unifies the usecase of adding hooks to an irqsoff and irqson
    event, and a preemptoff and preempton event.
      3 users of the events exist:
      - Lockdep
      - irqsoff and preemptoff tracers
      - irqs and preempt trace events

    The unification cleans up several ifdefs and makes the code in preempt
    tracer and irqsoff tracers simpler. It gets rid of all the horrific
    ifdeferry around PROVE_LOCKING and makes configuration of the different
    users of the tracepoints more easy and understandable. It also gets rid
    of the time_* function calls from the lockdep hooks used to call into
    the preemptirq tracer which is not needed anymore. The negative delta in
    lines of code in this patch is quite large too.

    In the patch we introduce a new CONFIG option PREEMPTIRQ_TRACEPOINTS
    as a single point for registering probes onto the tracepoints. With
    this,
    the web of config options for preempt/irq toggle tracepoints and its
    users becomes:

     PREEMPT_TRACER   PREEMPTIRQ_EVENTS  IRQSOFF_TRACER PROVE_LOCKING
           |                 |     \         |           |
           \    (selects)    /      \        \ (selects) /
          TRACE_PREEMPT_TOGGLE       ----> TRACE_IRQFLAGS
                          \                  /
                           \ (depends on)   /
                         PREEMPTIRQ_TRACEPOINTS

    Other than the performance tests mentioned in the previous patch, I also
    ran the locking API test suite. I verified that all tests cases are
    passing.

    I also injected issues by not registering lockdep probes onto the
    tracepoints and I see failures to confirm that the probes are indeed
    working.

    This series + lockdep probes not registered (just to inject errors):
    [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
    [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
    [    0.000000]        sirq-safe-A => hirqs-on/12:FAILED|FAILED|  ok  |
    [    0.000000]        sirq-safe-A => hirqs-on/21:FAILED|FAILED|  ok  |
    [    0.000000]          hard-safe-A + irqs-on/12:FAILED|FAILED|  ok  |
    [    0.000000]          soft-safe-A + irqs-on/12:FAILED|FAILED|  ok  |
    [    0.000000]          hard-safe-A + irqs-on/21:FAILED|FAILED|  ok  |
    [    0.000000]          soft-safe-A + irqs-on/21:FAILED|FAILED|  ok  |
    [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |

    With this series + lockdep probes registered, all locking tests pass:

    [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
    [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
    [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
    [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
    [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
    [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
    [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |

    Link: http://lkml.kernel.org/r/20180730222423.196630-4-joel@joelfernandes.org

    Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Reviewed-by: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
    Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

 include/linux/ftrace.h            |  11 +-
 include/linux/irqflags.h          |  11 +-
 include/linux/lockdep.h           |   8 +-
 include/linux/preempt.h           |   2 +-
 include/trace/events/preemptirq.h |  23 ++--
 init/main.c                       |   5 +-
 kernel/locking/lockdep.c          |  35 +++---
 kernel/sched/core.c               |   2 +-
 kernel/trace/Kconfig              |  22 +++-
 kernel/trace/Makefile             |   2 +-
 kernel/trace/trace_irqsoff.c      | 231 ++++++++++----------------------------
 kernel/trace/trace_preemptirq.c   |  72 ++++++++++++
 12 files changed, 195 insertions(+), 229 deletions(-)
 create mode 100644 kernel/trace/trace_preemptirq.c

-- 
Linaro LKFT
https://lkft.linaro.org
