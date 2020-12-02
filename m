Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C8E2CB401
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 05:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgLBEqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 23:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLBEqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 23:46:37 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58683C0617A6
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 20:45:57 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id i13so71219oou.11
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 20:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8KxEb62cuyYX7rvTRZibtFXDnRArB2vZulPU2/YsgyU=;
        b=mjK5r9lgi0VXMpyEjYjVTmljkOoabcD9SQLiTNEF4Gu9XcsQheS2yarSgso9DMqufn
         YM6UU6Nf/HN37zBcz+WCyVy2pyOpYu93+SNBV8KwLFcj0nZ9vHkfQIQRaNyak1cUUPaF
         2y1onfVSzKfucVV5lFPxUPV3qaIFJG2uC9DxnTA7w4rMptfuNBjeXA5LRk+MXvHnAsHR
         pZK0HXBuNZvL/SCH7fgmO7ca4zEknMd5Mcc0k3fW2J5EW8C5rpdth7skEidHw5HWP6Wg
         uY/6yx8FTWYflhuxqDfbpXDXpSBzrr4YEJ9zo1qQLYWOO/CaIheBBJVR1IjvNb53TKpi
         vK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8KxEb62cuyYX7rvTRZibtFXDnRArB2vZulPU2/YsgyU=;
        b=Mohs1MHg4Rosf9WvsYUuBikJyu2glT2trH7Ixe6OKRxw3n0Fw7Xtj0iRv7Vfj1K8lk
         xpWApfbx1+R6b1qCv81XwKwOmENcCE6svfE8nvncrCGltdwA1BCp2lhvCsUYYaC5tVWZ
         HBAPd1WfeZhicrti2PUcMfBHirn5j5Hz1xReiF0TF2aCwgz75el4ySXJzTr2TfmyKtOH
         bjOSNuvCG6nIYGl5o/PnUGkQouPqUk1tcgJKCk25kGXwaBk4YmOxroFg6ySh6tpol1ox
         X9oiRko36Fk38DYvoq8WsFX27tYGe/g8vQdN6U5GhzK9pTps0cvlDKVfJY7N6el0O/DC
         GC9Q==
X-Gm-Message-State: AOAM532b/7mp3duiUQDdrztgUdUKqUW5SmjsSIQ1+J+vyk71BnZ5zw47
        MdiBSI6yIFDG3V7QEyftnq/b+7L0OfNyU6sXbwbqZd7PJ20luW5Y
X-Google-Smtp-Source: ABdhPJzZVvvOHzXb8bSwzhSrV4k6EGJHttBxXh62TaUQwvHkDaaWkKmfbu8XOQDyZia1N9DGzRG0x2Fpl6VhhgwjhV4=
X-Received: by 2002:a4a:abc9:: with SMTP id o9mr416695oon.1.1606884355665;
 Tue, 01 Dec 2020 20:45:55 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 10:15:44 +0530
Message-ID: <CA+G9fYupbQK02Yor=U-80JEdkwacZ7bi3RKt3+D=e+qZ-o0uCA@mail.gmail.com>
Subject: [arm64] db410c: BUG: Invalid wait context
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, rcu@vger.kernel.org,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running kselftests on arm64 db410c platform "BUG: Invalid wait context"
noticed at different runs this specific platform running stable-rc 5.9.12-rc1.

While running these two test cases we have noticed this BUG and not easily
reproducible.

# selftests: bpf: test_xdp_redirect.sh
# selftests: net: ip6_gre_headroom.sh

[  245.694901] kauditd_printk_skb: 100 callbacks suppressed
[  245.694913] audit: type=1334 audit(251.699:25757): prog-id=12883 op=LOAD
[  245.735658] audit: type=1334 audit(251.743:25758): prog-id=12884 op=LOAD
[  245.801299] audit: type=1334 audit(251.807:25759): prog-id=12885 op=LOAD
[  245.832034] audit: type=1334 audit(251.839:25760): prog-id=12886 op=LOAD
[  245.888601]
[  245.888631] =============================
[  245.889156] [ BUG: Invalid wait context ]
[  245.893071] 5.9.12-rc1 #1 Tainted: G        W
[  245.897056] -----------------------------
[  245.902091] pool/1279 is trying to lock:
[  245.906083] ffff000032fc1218
(&child->perf_event_mutex){+.+.}-{3:3}, at:
perf_event_exit_task+0x34/0x3a8
[  245.910085] other info that might help us debug this:
[  245.919539] context-{4:4}
[  245.924484] 1 lock held by pool/1279:
[  245.927087]  #0: ffff8000127819b8 (rcu_read_lock){....}-{1:2}, at:
dput+0x54/0x460
[  245.930739] stack backtrace:
[  245.938203] CPU: 1 PID: 1279 Comm: pool Tainted: G        W
5.9.12-rc1 #1
[  245.941243] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[  245.948621] Call trace:
[  245.955390]  dump_backtrace+0x0/0x1f8
[  245.957560]  show_stack+0x2c/0x38
[  245.961382]  dump_stack+0xec/0x158
[  245.964679]  __lock_acquire+0x59c/0x15c8
[  245.967978]  lock_acquire+0x124/0x4d0
[  245.972058]  __mutex_lock+0xa4/0x970
[  245.975615]  mutex_lock_nested+0x54/0x70
[  245.979261]  perf_event_exit_task+0x34/0x3a8
[  245.983168]  do_exit+0x394/0xad8
[  245.987420]  do_group_exit+0x4c/0xa8
[  245.990633]  get_signal+0x16c/0xb40
[  245.994193]  do_notify_resume+0x2ec/0x678
[  245.997404]  work_pending+0x8/0x200

and BUG in an other run,

[ 1012.068407] audit: type=1700 audit(1018.803:25886): dev=eth0 prom=0
old_prom=256 auid=4294967295 uid=0 gid=0 ses=4294967295
[ 1012.250561] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
[ 1012.251298] IPv6: ADDRCONF(NETDEV_CHANGE): h1: link becomes ready
[ 1012.252559]
[ 1012.261892] =============================
[ 1012.263453] [ BUG: Invalid wait context ]
[ 1012.267363] 5.9.12-rc1 #1 Tainted: G        W
[ 1012.271354] -----------------------------
[ 1012.276389] systemd/454 is trying to lock:
[ 1012.280381] ffff00003985a918 (&mm->mmap_lock){++++}-{3:3}, at:
__might_fault+0x60/0xa8
[ 1012.284378] other info that might help us debug this:
[ 1012.292275] context-{4:4}
[ 1012.297396] 1 lock held by systemd/454:
[ 1012.299997]  #0: ffff8000127d1f38 (rcu_read_lock){....}-{1:2}, at:
path_init+0x40/0x718
[ 1012.303649] stack backtrace:
[ 1012.311638] CPU: 2 PID: 454 Comm: systemd Tainted: G        W
  5.9.12-rc1 #1
[ 1012.314760] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[ 1012.322139] Call trace:
[ 1012.329084]  dump_backtrace+0x0/0x1f8
[ 1012.331254]  show_stack+0x2c/0x38
[ 1012.335075]  dump_stack+0xec/0x158
[ 1012.338371]  __lock_acquire+0x59c/0x15c8
[ 1012.341672]  lock_acquire+0x124/0x4d0
[ 1012.345751]  __might_fault+0x84/0xa8
[ 1012.349311]  cp_new_stat+0x114/0x1b8
[ 1012.352956]  __do_sys_newfstat+0x44/0x70
[ 1012.356513]  __arm64_sys_newfstat+0x24/0x30
[ 1012.358652] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[ 1012.360424]  el0_svc_common.constprop.3+0x7c/0x198
[ 1012.370575]  do_el0_svc+0x34/0xa0
[ 1012.375437]  el0_sync_handler+0x16c/0x210
[ 1012.378824]  el0_sync+0x140/0x180


Full test log links,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.11-153-gfb49ad2107f4/testrun/3516257/suite/linux-log-parser/test/check-kernel-bug-1997042/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.11-153-gfb49ad2107f4/testrun/3515038/suite/linux-log-parser/test/check-kernel-bug-1996797/log

metadata:
  git branch: linux-5.9.y
  git commit: fb49ad2107f4b740257c84ec2991fc6afb447f53
  git describe: v5.9.11-153-gfb49ad2107f4
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-5.9/44/config

-- 
Linaro LKFT
https://lkft.linaro.org
