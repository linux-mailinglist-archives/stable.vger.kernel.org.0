Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20A7454D31
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbhKQSa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbhKQSaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 13:30:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31129C06121D
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 10:27:49 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t5so15486776edd.0
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 10:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OAB3RjQ9ok6KYr4DvNNSxl9pw5vMZEZUC9WA6dNJoB0=;
        b=W8GE3HmtvOYryLzwM7Jpg+pBcVDeobrmTofQsnXY/rp5kxWtTdcUpNnlTpaEKMgF6z
         YpWRjx2gxfwd7dkuHaCBXXvsD6BDqsrg7R4wqleG91xIyxi1S7Cr1SZITOjeTy0w6a8z
         nWCjVZNaVQnYzQtPLuoc+pN3h2HfGiG5xROds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAB3RjQ9ok6KYr4DvNNSxl9pw5vMZEZUC9WA6dNJoB0=;
        b=nkrFPT89i7AjBq55i2+mx33GfFQYaO0BceqbublSvYjW5FgtdI09FHzc1oLJn5+qmn
         WtuS23XBR0hm+CE/3Ts5CtJ1mj+23V8bHEEAHUG44cLFLKZFBNdwAL9dyDuO6WRHMp7b
         qkMpF2s5BF6A8YZhiKSrP2BcPu2xVl8qr7CntcOJb1Ciq07YoyA5D34m5D3zZPadX9a5
         37P49zron1uNMRddl7uI7gbjZQhMycHFMx0jFO20oOm7EjGJ47OBevTBg3OxQQUuTz1c
         eAifQZR1tL9rAlIsgApi1mj+kCT0mvWLVSsiIbAIPy//p2ybB/VrHfpobT4dRkEn+GRB
         lHDg==
X-Gm-Message-State: AOAM530gLA3dCFyJjKiPz7Brh2jyu0BtmYvZ+ThZNuOifa9asE9DMVOq
        inJFrzypzzTkzBiw5NVwDCPH0Qi+sSOwz30e1tgSKiG4xuM=
X-Google-Smtp-Source: ABdhPJx0uO9ROUGbbL8jXwjJ2nl1YPCu7eRop5AmLVPRHJkyvaOkDsqG61lnp9ucIIJQJIYT8M5CoSMfrkPW4I3qxaA=
X-Received: by 2002:a17:906:1c56:: with SMTP id l22mr24171893ejg.208.1637173667594;
 Wed, 17 Nov 2021 10:27:47 -0800 (PST)
MIME-Version: 1.0
References: <CA+QYu4rKUobW5LRKgijLviKjEPAFZ_428Dhin44_Hq2KtWzM+A@mail.gmail.com>
In-Reply-To: <CA+QYu4rKUobW5LRKgijLviKjEPAFZ_428Dhin44_Hq2KtWzM+A@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 17 Nov 2021 12:27:36 -0600
Message-ID: <CAFxkdArJ9qW0EJiFoajAUsamCzpF4XinV4kK-u3JedrrP3Avzw@mail.gmail.com>
Subject: Re: Boot issue on x86_64: kernel 5.15.2 - RIP: 0010:__unwind_start+0x10b/0x1e0
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is definitely still happening with 5.15.3-rc3

On Tue, Nov 16, 2021 at 6:44 AM Bruno Goncalves <bgoncalv@redhat.com> wrote:
>
> Hello,
>
> We've started to see the issue below when booting on x86_64 on recent
> kernel builds from linux-stable-rc. More logs can be found on [1] and
> cki tracker issue [2].
>
> [   24.006329] zram: Added device: zram0
> [   25.075694] systemd[1]:
> /usr/lib/systemd/system/restraintd.service:8: Standard output type
> syslog+console is obsolete, automatically updating to journal+console.
> Please update your unit file, and consider removing the setting
> altogether.
> [   25.342129] BUG: unable to handle page fault for address: ffffb57143fb7de0
> [   25.376757] #PF: supervisor read access in kernel mode
> [   25.402135] #PF: error_code(0x0000) - not-present page
> [   25.426507] PGD 100000067 P4D 100000067 PUD 1001e2067 PMD 31b1c3067 PTE 0
> [   25.461485] Oops: 0000 [#1] SMP PTI
> [   25.477997] CPU: 4 PID: 1 Comm: systemd Tainted: G          I       5.15.2 #1
> [   25.512982] Hardware name: HP ProLiant SL390s G7/, BIOS P69 07/02/2013
> [   25.548041] RIP: 0010:__unwind_start+0x10b/0x1e0
> [   25.570958] Code: af fb ff 85 c0 75 d2 eb c0 65 48 8b 04 25 c0 bb
> 01 00 48 39 c6 0f 84 86 00 00 00 48 8b 86 98 23 00 00 48 8d 78 38 48
> 89 7d 38 <48> 8b 50 28 48 89 55 40 48 8b 40 30 48 89 45 48 48 3d 80 43
> 00 81
> [   25.668824] RSP: 0018:ffffb5714313bc18 EFLAGS: 00010083
> [   25.695397] RAX: ffffb57143fb7db8 RBX: ffffb57143fb7db8 RCX: 0000000000000000
> [   25.733090] RDX: 0000000000000000 RSI: ffff924d03534d00 RDI: ffffb57143fb7df0
> [   25.769626] RBP: ffffb5714313bc38 R08: 0000000000000040 R09: 0000000000001000
> [   25.808015] R10: 8000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   25.841524] R13: ffff924d03535974 R14: 0000000000000155 R15: 0000000000000001
> [   25.878031] FS:  00007f49ec409340(0000) GS:ffff924f0ba80000(0000)
> knlGS:0000000000000000
> [   25.916770] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   25.946918] CR2: ffffb57143fb7de0 CR3: 00000001039ae005 CR4: 00000000000206e0
> [   25.988907] Call Trace:
> [   26.001096]  <TASK>
> [   26.013087]  __get_wchan+0x35/0x80
> [   26.031979]  get_wchan+0x65/0x80
> [   26.047218]  do_task_stat+0xcd9/0xde0
> [   26.064584]  proc_single_show+0x4d/0xb0
> [   26.083925]  seq_read_iter+0x120/0x4b0
> [   26.103266]  seq_read+0xed/0x120
> [   26.118507]  ? security_inode_notifysecctx+0x30/0x50
> [   26.142094]  vfs_read+0x95/0x190
> [   26.158829]  ksys_read+0x4f/0xc0
> [   26.175927]  do_syscall_64+0x3b/0x90
> [   26.194142]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   26.220169] RIP: 0033:0x7f49ecf992e2
> [   26.239468] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 2e 0a 00 e8 95
> e9 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75
> 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89
> 54 24
> [   26.336968] RSP: 002b:00007ffc3fedf998 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000000
> [   26.376294] RAX: ffffffffffffffda RBX: 000055fd5a6a1f30 RCX: 00007f49ecf992e2
> [   26.410402] RDX: 0000000000000400 RSI: 000055fd5a7f2e90 RDI: 0000000000000010
> [   26.447213] RBP: 00007f49ed06d300 R08: 0000000000000010 R09: 0000000000000001
> [   26.481089] R10: 0000000000001000 R11: 0000000000000246 R12: 00007f49ec4090f8
> [   26.517502] R13: 0000000000000d68 R14: 00007f49ed06c700 R15: 0000000000000d68
> [   26.551484]  </TASK>
> [   26.561812] Modules linked in: zram ip_tables xfs radeon
> i2c_algo_bit drm_ttm_helper ttm drm_kms_helper crct10dif_pclmul
> crc32_pclmul crc32c_intel cec ata_generic ghash_clmulni_intel
> serio_raw drm pata_acpi hpwdt
> [   26.657383] CR2: ffffb57143fb7de0
> [   26.673063] ---[ end trace d486977d124663a0 ]---
>
>
> [1] https://datawarehouse.cki-project.org/kcidb/tests/1872788
> [2] https://datawarehouse.cki-project.org/issue/747
>
> Thanks,
> Bruno
>
