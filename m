Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B38625A629
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIBHMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIBHMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 03:12:16 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D853C061244
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 00:12:15 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id q200so983953vke.6
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 00:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SEzpeK753sJURuHDIzrZ/qFxc1Lh7UGZF/GgLRYCkCM=;
        b=ogdniylquktIWWcx/CiD2ETV2IjwzhBnhmH+fvBC1q1T9+AZCnI5ZodAd3mfZz24HE
         KQgaVUVURPxvEEQQHGHSRUZl8/EVgpAe7mcP0NXj5lOLMr1uUNpz588TR3zhTHkS4D9O
         Dx56n/0/C7enpvCwvutzdwatERoH5yigxFfprIQmV62EiYFMF6bOATsKc4dFaER6qLF/
         9WMSTEG6ZHwO74s/UwNKcdGvR0neVM/+503dJhe/32ufW65DpuHr7ZoO01RrO8She7m4
         Q7VAGJhwKF7UuqWYthCwajh/mXuvPPGRiXnTJmkXlQv1j3A0lpN1enAINoSqwa5JKc5M
         PmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=SEzpeK753sJURuHDIzrZ/qFxc1Lh7UGZF/GgLRYCkCM=;
        b=IjM32w+YpWlwMREgNkmo2NXsadpjASyLGxvlMWXwPhQ3u7viOr6LT7jMIKVlN2jfKn
         ThOVpookaBV49chOki1sR29AEpul1I3674658UR3ACFheNPsY/sZUq7jrveGnFsPNgUX
         3M3YI0J1JfKI7THDuo0VPAeCSLy/b+NZ+rVnWWDwPHBZWPpacFNRHEJIxBwtMbpf1It8
         TQWAS4U0Iw/F6Kkyhxc6s3tlbZhB1VwAypl44Qo8xaW6PwBwTaxnb+PnttPFaJFg2/bx
         KGNspNvOM+3ueNfPN7xeHytNPV3QFixkDvrubfSTWYcEqGfPwEWYoh+U5WGEH9M7cCaY
         15Iw==
X-Gm-Message-State: AOAM530Now5XOyejHv+a55ACMjCIyZ4+LWp1Dpicx5qQd8qj4c6XhHf7
        Kqn2tKlX7+HiMjBJD3kvAmyvTjc4cvW048/DPSfkNA==
X-Google-Smtp-Source: ABdhPJw0yZ3mTL+QhTgsWQPRx8SmaQ0nPtY0zd0gCDOtoeKoODOIZkzEinp27ciHr5B9NF3XRO7IYvqQT+xnJ7GYgxA=
X-Received: by 2002:a1f:e443:: with SMTP id b64mr4444219vkh.17.1599030732489;
 Wed, 02 Sep 2020 00:12:12 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Sep 2020 12:42:01 +0530
Message-ID: <CA+G9fYu6p_UuQ5=ZozAMz8XgFfedWPFJ0VRj=9CaZ-zRSuyJkA@mail.gmail.com>
Subject: BUG: KASAN: use-after-free in prepare_ftrace_return+0x88/0x140
To:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, linux-mm <linux-mm@kvack.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Leo Yan <leo.yan@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP tracing on arm64 juno with kasan config enabled
this kernel BUG triggered.

metadata:
  git branch: linux-4.14.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel-config:
https://builds.tuxbuild.com/oTHtWrmNsVQa9iuCfXJTQA/kernel.config

steps to reproduce:
# Boot arm64 juno with trace configs enabled ^.
# cd /opt/ltp
# ./runltp -f tracing

ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
[  137.218462] ==================================================================
[  137.225924] BUG: KASAN: use-after-free in prepare_ftrace_return+0x88/0x140
[  137.232999] Read of size 8 at addr ffff80090202e0c8 by task sh/3123
[  137.239460]
[  137.241144] CPU: 2 PID: 3123 Comm: sh Not tainted 4.14.194 #1
[  137.247086] Hardware name: ARM Juno development board (r2) (DT)
[  137.253202] Call trace:
[  137.255850]  dump_backtrace+0x0/0x230
[  137.259703]
[  137.261381] Allocated by task 297879680:
[  137.265510] Unable to handle kernel paging request at virtual
address ffff20000bf29bc0
[  137.273626] Mem abort info:
[  137.276609]   Exception class = DABT (current EL), IL = 32 bits
[  137.282721]   SET = 0, FnV = 0
[  137.285963]   EA = 0, S1PTW = 0
[  137.289289] Data abort info:
[  137.292357]   ISV = 0, ISS = 0x00000007
[  137.296380]   CM = 0, WnR = 0
[  137.299537] swapper pgtable: 4k pages, 48-bit VAs, pgd = ffff20000afb8000
[  137.306520] [ffff20000bf29bc0] *pgd=00000009ffffe003,
*pud=00000009ffffd003, *pmd=0000000994f00003, *pte=0000000000000000
[  137.318072] Internal error: Oops: 96000007 [#1] PREEMPT SMP
[  137.323849] Modules linked in: crc32_ce crct10dif_ce fuse
[  137.329831] Process sh (pid: 3123, stack limit = 0xffff800902050000)
[  137.336389] CPU: 2 PID: 3123 Comm: sh Not tainted 4.14.194 #1
[  137.342328] Hardware name: ARM Juno development board (r2) (DT)
[  137.348444] task: ffff800911c14880 task.stack: ffff800902050000
[  137.354572] pc : depot_fetch_stack+0x14/0x38
[  137.359045] lr : print_track.isra.0+0x48/0x74
[  137.363593] sp : ffff80090202df20 pstate : 200001c5
[  137.368661] x29: ffff80090202df20 x28: ffff200009e0e090
[  137.374356] x27: ffff8009096ec200 x26: ffff200009e0e1c4
[  137.380052] x25: ffff80090202e0ec x24: ffff80090202e0e0
[  137.385746] x23: ffff8009365b6e00 x22: ffff200009adc7d0
[  137.391441] x21: 0000000011c14880 x20: ffff200009ac76b0
[  137.397136] x19: ffff80090202e0e4 x18: 0000000000000000
[  137.402830] x17: 0000000000000000 x16: 0000000000000000
[  137.408523] x15: 0000000000000000 x14: 3d3d3d3d3d3d3d3d
[  137.414218] x13: 3d3d3d3d3d3d3d3d x12: 1ffff00120405b89
[  137.419912] x11: ffff100120405b89 x10: dfff200000000000
[  137.425606] x9 : ffff100120405b8a x8 : 0000000000000004
[  137.431301] x7 : 0000000000000001 x6 : 0000000000000003
[  137.436994] x5 : ffff100120405b89 x4 : 0000000000000000
[  137.442688] x3 : 00000000001f8009 x2 : ffff20000af69b78
[  137.448382] x1 : ffff80090202df58 x0 : 0000000000003ff0
[  137.454079] Call trace:
[  137.456722] Code: f0014322 912de042 d3557800 d37c2400 (f8637842)
[  137.463087] ---[ end trace 81665fb4c270025f ]---
[  137.467908] note: sh[3123] exited with preempt_count 2

full test log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/build/v4.14.195-92-g54fa008d06cd/testrun/3149565/suite/linux-log-parser/test/check-kernel-bug-1727638/log

-- 
Linaro LKFT
https://lkft.linaro.org
