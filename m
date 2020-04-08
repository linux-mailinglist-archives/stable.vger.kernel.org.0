Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA61A1E09
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 11:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHJb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 05:31:27 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36243 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgDHJb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 05:31:27 -0400
Received: by mail-lf1-f65.google.com with SMTP id w145so4629249lff.3
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 02:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=U4FOr2RB0Xkp5M31fPJH/yewnv/w+8CnOr9geW5TqdQ=;
        b=usEOvHbEb3uhYdWzO7P06VtHwKYVXajG3/Yh8MHLDPWNHQGsOWWz3oYULJfVn7D5GL
         nbCAkFDURSXxt4IUtmJxll/BMSayX57NuQWZNGvTo/rLSJy5VmLfqiOggukdSQP8CFfL
         uUrQ+mAesLXmNiW70T6Uq/CK/dBRsZzSb8j7hC2bcHVUG3jsO0fT/OKOEAv4HkZX3OZ4
         j+lU5zR2x9cQrCW8UAa9XCh1cp2BeR4jnIEjFtzbqlZqKAUHIsr95c6/dy5d8yizgBIq
         5LRuvcVIuKKbHJxHmM5em7KpHHgvyoSieMG4cgQgrJF1ZK79yLqOwU9r2lW6u4oDK31I
         Q/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=U4FOr2RB0Xkp5M31fPJH/yewnv/w+8CnOr9geW5TqdQ=;
        b=Vz4VQhXhvWmbWKsHZem6UyPCIg+7E27CP5/PolnbNkIKJU8BCUvBFZntOXIZgQrYpa
         ILSHm/q9hN4U4McJzwb2SQs0T5KTnFC2m3jjGHcPaJIZ+WZBbYfo//VwhgIbcFj7BK/g
         5nvGSGv6HyBHJM2w3fp3/H2AoI/c9Ph4j0AqVbXhDYBzjVAyj56pJLM6xih5B/ElnHNC
         G3B7ZabKacxLd4ZMUVjyfLE4UWw7TM4yoozbGWdBV7S4I2IFWLF+HMoEbLSV8ili90bh
         bsbOtEwqI1BEXPOa0rA6B2iuH3vKTc1qEzbThhxJVJRC8A6tE97iKKshQHMJQ7j6TJyO
         OOTg==
X-Gm-Message-State: AGi0Puavb7iNL+gRWkIg4+2SEKTeR9dsrXEzoXRwbF9gukCIc9MuReRO
        Yt8GnAM6BtYDzHlT8SFi85eNDLGFa+4cIMNK36KAkDbrAy8=
X-Google-Smtp-Source: APiQypKhYSCDUEJUEVy9hktqxHqR/v62qoq+zVwHHwdUO5fOqzCLwr/JZd03yKJMY7UVU9Il3O/JZ2fUDlSTweBlnaY=
X-Received: by 2002:ac2:4da7:: with SMTP id h7mr3527277lfe.95.1586338283132;
 Wed, 08 Apr 2020 02:31:23 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Apr 2020 15:01:11 +0530
Message-ID: <CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=KemTXaXR6UBU94M3hw@mail.gmail.com>
Subject: WARNING: events/ipi.h:36 suspicious rcu_dereference_check() usage!
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rcu@vger.kernel.org, lkft-triage@lists.linaro.org,
        Leo Yan <leo.yan@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>, zanussi@kernel.org,
        svens@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On arm64 qemu_arm64, juno-r2 and dragonboard-410c while running kselftest ftrace
on stable rc 5.5.1-rc1 to till today 5.5.16-rc2 and 5.6  found this
kernel warning.

[  386.349099] kselftest: Running tests in ftrace
[  393.984018]
[  393.984290] =============================
[  393.984781] WARNING: suspicious RCU usage
[  393.988690] 5.6.3-rc2 #1 Not tainted
[  393.992679] -----------------------------
[  393.996327] /usr/src/kernel/include/trace/events/ipi.h:36
suspicious rcu_dereference_check() usage!
[  394.000241]
[  394.000241] other info that might help us debug this:
[  394.000241]
[  394.009094]
[  394.009094] RCU used illegally from idle CPU!
[  394.009094] rcu_scheduler_active = 2, debug_locks = 1
[  394.017084] RCU used illegally from extended quiescent state!
[  394.028187] 1 lock held by swapper/3/0:
[  394.033826]  #0: ffff80001237b6a8 (max_trace_lock){....}, at:
check_critical_timing+0x7c/0x1a8
[  394.037480]
[  394.037480] stack backtrace:
[  394.046158] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.3-rc2 #1
[  394.050584] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[  394.056663] Call trace:
[  394.063515]  dump_backtrace+0x0/0x1e0
[  394.065686]  show_stack+0x24/0x30
[  394.069505]  dump_stack+0xe8/0x150
[  394.072805]  lockdep_rcu_suspicious+0xcc/0x110
[  394.076106]  arch_irq_work_raise+0x208/0x210
[  394.080533]  __irq_work_queue_local+0x5c/0x80
[  394.084959]  irq_work_queue+0x38/0x78
[  394.089212]  __update_max_tr+0x150/0x218
[  394.092858]  update_max_tr_single.part.82+0x98/0x100
[  394.096851]  update_max_tr_single+0x1c/0x28
[  394.101798]  check_critical_timing+0x198/0x1a8
[  394.105705]  stop_critical_timings+0x128/0x148
[  394.110221]  cpuidle_enter_state+0x74/0x4f8
[  394.114645]  cpuidle_enter+0x3c/0x50
[  394.118726]  call_cpuidle+0x44/0x80
[  394.122542]  do_idle+0x22c/0x2d0
[  394.125755]  cpu_startup_entry+0x28/0x48
[  394.129229]  secondary_start_kernel+0x1b4/0x210


metadata:
  git branch: linux-5.5.y and linux-5.6.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.5/65/config

Full test log,
5.6 test logs,
https://lkft.validation.linaro.org/scheduler/job/1350627#L12612
https://lkft.validation.linaro.org/scheduler/job/1350731#L9509

5.5 test logs,
https://lkft.validation.linaro.org/scheduler/job/1322704#L9777
https://lkft.validation.linaro.org/scheduler/job/1153369#L9745
https://lkft.validation.linaro.org/scheduler/job/1351155#L8982
https://lkft.validation.linaro.org/scheduler/job/1351065#L12349

--
Linaro LKFT
https://lkft.linaro.org
