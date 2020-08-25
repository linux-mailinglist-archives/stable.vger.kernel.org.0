Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1F2514DD
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgHYI7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 04:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbgHYI7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 04:59:22 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78328C061574
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 01:59:22 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id s81so2653225vkb.3
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 01:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=uzg01uDRjZSL1zQZLuUMIirKoxGve7i+aoN9VUy7JS4=;
        b=aLOCULakRAaAe6JDEgBcire0KjQVWBkRmQqQ+RV8N2jugN0WqgwHnvWW/6nI0R/Mpa
         Ltckmq6bdWA2O7QXu/sSFNfzNlllUr6nQNMlxG4vXK7v6XO8+9/1JAhYuphMYSYL+QDy
         GLHsBGeBInMQVKAyIA+PXWBurYEN4NuXyu5v9Gg81GVQ4b+cOoIKLYsfu/nh8yAAigNB
         ykx/78LT3UqyKcxW/X6ayoNq7xCNdKbFjszx7cv5EhoWCbq314I3osRdFSB+u5+AFDAw
         4Zo34Kq0xamXrkt9ZmaUag1maAbRUDNXWHmURhxHu7QUlf427GKAK/RNQuYurbOhW0D5
         YbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=uzg01uDRjZSL1zQZLuUMIirKoxGve7i+aoN9VUy7JS4=;
        b=iMvvgqz5iGjqg5HtSOLFuvAKE0cZTve+gq7+Qow/4btGlSV+PtSuzpbzXgL5Vj5Led
         7DdfewVDURqWj2qXu0OxBOl1tg6lbcqIA9lQYUktRsWT6vP8d64lbyDLYe28KKB5BYi6
         2qLhrsOYg5kD1JlPTYRVxU1tS5NYg6drhjomnfwolhP2BbXxefA6nQ4N7qgHKQKig6jI
         nXQSAilSFRttFvMmBBbutSPiyGBe7twv6G1T9RUpZUpBwa47SaEuUt9ZD4Jf+bT70p/Z
         0Vlq+weIeCK0ZswHcwIVo7q9ncUaNSTs4HW7RsEj/oAGm3vQoFKyn/FemX6STgGOy65s
         723A==
X-Gm-Message-State: AOAM532ODE+4eJ70EI/uOTidDG9DjpJjdZbKgWCICtP9L6xfwX6jsSUi
        ReBkpRmkTkP4hIsUv1dLB9Xpd1BYYMSiOvcZ5Gb7kk/0OIi7IKOx
X-Google-Smtp-Source: ABdhPJxzS6E4QzGD1XT5F6g1gi702DSH0TQnEh7jGTIjRGOZqid86wvIrN6bsHSowGZ8T1rZKzEX5IXZGUq3NLFmM3s=
X-Received: by 2002:a1f:6282:: with SMTP id w124mr4825767vkb.46.1598345960893;
 Tue, 25 Aug 2020 01:59:20 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 14:29:08 +0530
Message-ID: <CA+G9fYvi6KSGcZMr4ejFfHee2_NBdXBkYvMm=sVyb174qQ9Dtg@mail.gmail.com>
Subject: arm64: Unable to handle kernel paging request at virtual address 800036ac1000
To:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Leo Yan <leo.yan@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP tracing ftrace-stress-test kernel on arm64 dragonboard
bd410c got panic on stable rc 4.14 branch. I will run git bisect
starting from 4.14
and get back to you on this email thread.

metadata:
  git branch: linux-4.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel-config:
https://builds.tuxbuild.com/ia1EnWmxGbTrk8uPt4w3tA/kernel.config

steps to reproduce:
# Boot arm64 db410c with trace configs enabled.
# cd /opt/ltp
# ./runltp -f tracing

ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
[   55.868262] Unable to handle kernel paging request at virtual
address 800036ac1000
[   55.868317] Mem abort info:
[   55.874729]   Exception class = DABT (current EL), IL = 32 bits
[   55.877427]   SET = 0, FnV = 0
[   55.883323]   EA = 0, S1PTW = 0
[   55.886445] Data abort info:
[   55.889487]   ISV = 0, ISS = 0x00000004
[   55.892613]   CM = 0, WnR = 0
[   55.896173] user pgtable: 4k pages, 48-bit VAs, pgd = ffff8000248f1000
[   55.899307] [0000800036ac1000] *pgd=0000000000000000
[   55.905730] Internal error: Oops: 96000004 [#2] PREEMPT SMP
[   55.910849] Modules linked in: rfkill snd_soc_hdmi_codec crc32_ce
adv7511 msm mdt_loader drm_kms_helper snd_soc_lpass_apq8016
snd_soc_msm8916_analog snd_soc_lpass_cpu snd_soc_apq8016_sbc
snd_soc_msm8916_digital snd_soc_lpass_platform msm_rng rng_core drm
fuse
[   55.916860] Process sh (pid: 3279, stack limit = 0xffff00000f648000)
[   55.939065] CPU: 2 PID: 3279 Comm: sh Tainted: G      D
4.14.195-rc2 #1
[   55.945662] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   55.952690] task: ffff80003b6e5400 task.stack: ffff00000f648000
[   55.959636] pc : get_trace_buf+0x14/0x40
[   55.965274] lr : __trace_array_vprintk+0x84/0x298
[   55.969436] sp : ffff000008013cc0 pstate : 000001c5
[   55.974039] x29: ffff000008013cc0 x28: 0000000000000104
[   55.978726] x27: ffff00000960bb40 x26: ffff0000093c7000
[   55.984282] x25: 0000000000000105 x24: ffff000008081c74
[   55.989577] x23: ffff0000081be314 x22: ffff0000093f3000
[   55.994873] x21: ffff80003b6e5400 x20: ffff80000eb05200
[   56.000167] x19: 0000000000000000 x18: 0000ffffa14fca70
[   56.005462] x17: 0000ffffa146ec18 x16: ffff00000829a3d8
[   56.010758] x15: 0000000000000040 x14: ffff0000081ccb34
[   56.016053] x13: ffff0000081cc8d4 x12: ffff0000081cc6d0
[   56.021348] x11: ffff0000081a8b88 x10: ffff0000081a8ae4
[   56.026643] x9 : ffff0000081fc3bc x8 : ffff0000093f3000
[   56.031938] x7 : ffff800009f33404 x6 : ffff0000090810d0
[   56.037234] x5 : ffff000008013d50 x4 : 0000800036ac1000
[   56.042528] x3 : ffff000008013d50 x2 : 0000800036ac1000
[   56.047823] x1 : 0000000000000000 x0 : ffff000009609000
[   56.053119] Call trace:
[   56.058410]  get_trace_buf+0x14/0x40
[   56.060583]  trace_array_printk_buf+0x60/0x68
[   56.064404]  update_max_tr_single.part.0+0xfc/0x128
[   56.068657]  update_max_tr_single+0x14/0x20
[   56.073346]  check_critical_timing+0x188/0x198
[   56.077512]  stop_critical_timings.part.0+0xf0/0x110
[   56.082026]  trace_hardirqs_on+0x34/0x40
[   56.087145]  __do_softirq+0xf4/0x3f4
[   56.091051]  irq_exit+0xdc/0x120
[   56.094612]  __handle_domain_irq+0x70/0xc0
[   56.097822]  gic_handle_irq+0x58/0xb0
[   56.101728]  el1_irq+0xb4/0x12c
[   56.105458]  rb_commit+0x38/0x270
[   56.108412]  ftrace_trace_userstack+0x150/0x200
[   56.111886]  trace_buffer_unlock_commit_regs+0xcc/0x150
[   56.116229]  trace_event_buffer_commit+0x6c/0x238
[   56.121436]  trace_event_raw_event_ipi_raise+0x64/0x98
[   56.126299]  smp_cross_call+0xc0/0xf0
[   56.131329]  arch_send_call_function_ipi_mask+0x24/0x30
[   56.135066]  smp_call_function_many+0x2ac/0x348
[   56.140098]  smp_call_function+0x48/0x90
[   56.144610]  kick_all_cpus_sync+0x28/0x30
[   56.148779]  aarch64_insn_patch_text+0xb0/0xc0
[   56.152688]  arch_jump_label_transform+0x70/0x80
[   56.157029]  __jump_label_update+0x84/0xa0
[   56.161800]  jump_label_update+0xdc/0x110
[   56.165706]  static_key_slow_inc_cpuslocked+0xbc/0xe8
[   56.169788]  static_key_slow_inc+0x24/0x38
[   56.174821]  tracepoint_probe_register_prio+0x20c/0x278
[   56.178816]  tracepoint_probe_register+0x38/0x48
[   56.183938]  trace_event_reg+0x88/0x98
[   56.188795]  __ftrace_event_enable_disable+0x15c/0x2e8
[   56.192358]  __ftrace_set_clr_event_nolock+0xd4/0x130
[   56.197478]  system_enable_write+0xac/0xf0
[   56.202600]  __vfs_write+0x48/0x130
[   56.206589]  vfs_write+0xb0/0x1b8
[   56.209974]  SyS_write+0x5c/0xc8
[   56.213446]  __sys_trace_return+0x0/0x4
[   56.216751] Code: d538d082 f944d401 ab020024 54000140 (b8626823)
[   56.220326] ---[ end trace 32d8a6bcfff49065 ]---
[   56.226558] Kernel panic - not syncing: Fatal exception in interrupt
[   56.231256] SMP: stopping secondary CPUs
[   57.331332] SMP: failed to stop secondary CPUs 0-3
[   57.331366] Kernel Offset: disabled
[   57.335011] CPU features: 0x0002005
[   57.338396] Memory Limit: none
[   57.341888] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.194-52-g376e60828efb/testrun/3114304/suite/linux-log-parser/test/check-kernel-oops-1705703/log

https://lkft.validation.linaro.org/scheduler/job/1705703#L2155

-- 
Linaro LKFT
https://lkft.linaro.org
