Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373FD40B417
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhINQE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 12:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhINQE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 12:04:58 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6915C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 09:03:40 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso4826630ooi.3
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 09:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l0MyXzKBzk1dY8ILG1nYSZ2zTboPIlUatUw24VtakfU=;
        b=Qtus+ZSa/Q2wqssvOYI7hIwRciGGNSdODE+lAJd89kiuFIddC+z435oQgDH2kYQmCV
         umB5QBsFYfoSwW73m77I045mCegVu+u2yArJHJk44mxsyfN+RZ/o39mr92rzhYPM9eeV
         lsWACOT1s63d+XiiS4DmjTV39LBf6bWAifKsaLTv0CteEqvxokatLaIKSZy31fDvSSEh
         SueRadSzex/xLGwYTuf7lkmt8bR9z5o4QIchMc3hoyLO9fMNE/G0hvdxliTdomJjvdQn
         urtmzDcIictuwhOFoR55UDkC6hDD+RC0YwbqxpKTbYHnOe38JP78+MR00SKSf4Ug142s
         7HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=l0MyXzKBzk1dY8ILG1nYSZ2zTboPIlUatUw24VtakfU=;
        b=1TPjDN5ILqqPw5pQyDLh60vksHEvz+kfcqRptQPGAgeXOw6tQZUZ7+bImiS5yZo/0N
         StnXCGWRmMhtWGWviAkuRBZrk9YekD202d43+WtLEGzpcGYZBJkTGDzARl4UWnuB8COf
         AZ4vvZK/xHAFKRoYNSY9niXtTyw/8qMz5MzOTsxp8TWC+qZSxGTzev2ox6ymCMD1bdJ/
         IMJJDiPzAZ6VNjs2xNVMjMhr08pAhsCx6HMurI9Zuq7qdhSmQa2qZD2Du9toQUJ1/SXi
         sVyfgOhw8XWCho3gVN9/BRyBpRMDXllARO7PE381IXV4/pMhquA7kX6uGxtTDPOvVUDE
         dRLA==
X-Gm-Message-State: AOAM530AE2KAieJuk9x9G0egvnPehOhToPrQaDzo0MOxqLA/Tj9qK6E2
        /imMeuGZIvTpyQZYeJt+EDo=
X-Google-Smtp-Source: ABdhPJxw/73ASQigr+FCtRaADnxFGRLq6xuI68XG2LeGRrzqqB6mCyG44NdbgJkWDExoYvsENWOZrA==
X-Received: by 2002:a4a:7452:: with SMTP id t18mr6510662ooe.20.1631635419932;
        Tue, 14 Sep 2021 09:03:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a1sm2726966otr.33.2021.09.14.09.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:03:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: ppc crashes in v4.14.y-queue and v4.19.y-queue
Message-ID: <87cbd9ce-161e-7c15-fbf4-66abd2540bed@roeck-us.net>
Date:   Tue, 14 Sep 2021 09:03:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I see the following crashes in v4.14.y-queue and v4.19.y-queue.
Please let me know if I need to bisect.

Thanks,
Guenter

---
v4.14.y:

BUG: Kernel NULL pointer dereference at 0x000000c0
Faulting instruction address: 0xc0069d04
Oops: Kernel access of bad area, sig: 11 [#1]
BE MPC8544 DS
Modules linked in:
CPU: 0 PID: 473 Comm: kworker/0:1 Not tainted 4.14.247-rc1-00101-gd73a5c779001 #1
Workqueue: events __blk_release_queue
task: ce510ea0 task.stack: ce1f0000
NIP:  c0069d04 LR: c0565384 CTR: c0069cd4
REGS: ce1f1d30 TRAP: 0300   Not tainted  (4.14.247-rc1-00101-gd73a5c779001)
MSR:  00029000 <CE,EE,ME>  CR: 42002402  XER: 20000000
DEAR: 000000c0 ESR: 00000000
GPR00: c056951c ce1f1de0 ce510ea0 ce2e1530 ceac0000 00000000 ce511320 f2050c9c
GPR08: 00000001 5a5a5a5a cea752e8 97cae497 22002402 00000000 c0074dac ce23a518
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c0f661c0 fffffef7
GPR24: c1010000 ce1f0000 00000000 00000000 ce2e1530 00000000 ce2e1520 ce2e1530
NIP [c0069d04] pwq_unbound_release_workfn+0x30/0x184
LR [c0565384] blk_mq_free_rqs+0x90/0x130
Call Trace:
[ce1f1de0] [c056a3a8] blk_mq_exit_sched+0xc0/0xe8 (unreliable)
[ce1f1e00] [ceaa7ea8] 0xceaa7ea8
[ce1f1e20] [c056951c] blk_mq_sched_tags_teardown+0x64/0xa0
[ce1f1e40] [c056a3b0] blk_mq_exit_sched+0xc8/0xe8
[ce1f1e60] [c054a24c] elevator_exit+0x98/0xc0
[ce1f1e80] [c05581cc] __blk_release_queue+0x58/0x13c
[ce1f1e90] [c006e8a4] process_one_work+0x2e4/0x6bc
[ce1f1ed0] [c006f18c] worker_thread+0x17c/0x46c
[ce1f1f10] [c0074ecc] kthread+0x120/0x15c
[ce1f1f40] [c001345c] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
9421ffe0 93c10018 3bc3fff0 93e1001c 7c7f1b78 9361000c 93a10014 8123fff0
83a3ff94 8363ff90 7c1e4840 418200f4 <813d00c0> 71290002 41820144 93810010
---[ end trace be33d503d2af084b ]---

BUG: Kernel NULL pointer dereference at 0x00000180
Faulting instruction address: 0xc00000000006e5c4
Oops: Kernel access of bad area, sig: 11 [#1]
BE SMP NR_CPUS=24 QEMU e500
Modules linked in:
CPU: 0 PID: 498 Comm: kworker/0:1 Not tainted 4.14.247-rc1-00101-gd73a5c779001 #1
Workqueue: events .__blk_release_queue
task: c00000003e1ddd40 task.stack: c00000003e540000
NIP:  c00000000006e5c4 LR: c0000000005dc204 CTR: c00000000006e594
REGS: c00000003e543530 TRAP: 0300   Not tainted  (4.14.247-rc1-00101-gd73a5c779001)
MSR:  0000000080009000 <EE,ME>  CR: 24002844  XER: 20000000
DEAR: 0000000000000180 ESR: 0000000000000000 SOFTE: 1
GPR00: c0000000005e0dfc c00000003e5437b0 c000000001380a00 c00000000712bba8
GPR04: c000000007180000 0000000000000000 000000004563074d 00000000857e8f62
GPR08: 000000003de9d000 0000000000000000 c00000000006e594 c0000000011d0a00
GPR12: 0000000044002842 c00000003fff5000 c00000000007ac78 c00000003e3d1af8
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 c00000003f00b140 c00000000138a940
GPR24: 0000000000000000 c00000000124a640 0000000000000000 0000000000000000
GPR28: c00000000712bba8 c00000000712bb88 0000000000000000 c00000000712bba8
NIP [c00000000006e5c4] .pwq_unbound_release_workfn+0x30/0x1c0
LR [c0000000005dc204] .blk_mq_free_rqs+0x9c/0x14c
Call Trace:
[c00000003e5437b0] [c00000003e543840] 0xc00000003e543840 (unreliable)
[c00000003e543850] [c000000000218980] .kfree+0xe4/0x3f4
[c00000003e5438f0] [c0000000005e0dfc] .blk_mq_sched_free_tags+0x28/0x54
[c00000003e543970] [c0000000005e0f1c] .blk_mq_sched_tags_teardown+0x48/0x78
[c00000003e543a00] [c0000000005e2030] .blk_mq_exit_sched+0xf4/0x114
[c00000003e543aa0] [c0000000005be008] .elevator_exit+0xb8/0xf0
[c00000003e543b30] [c0000000005cdba8] .__blk_release_queue+0x64/0x190
[c00000003e543bb0] [c000000000072604] .process_one_work+0x324/0x894
[c00000003e543c90] [c000000000072be0] .worker_thread+0x6c/0x4f0
[c00000003e543d70] [c00000000007ae28] .kthread+0x1b0/0x1b8
[c00000003e543e30] [c000000000000a00] .ret_from_kernel_thread+0x58/0xd8
Instruction dump:
fba1ffe8 3ba3ffe0 fbe1fff8 7c7f1b78 fb61ffd8 fbc1fff0 f821ff61 e923ffe0
ebc3ff78 7fbd4840 eb63ff70 419e0124 <813e0180> 71290002 41820180 7c0802a6
---[ end trace a1c724264250a495 ]---


v4.19.y:

BUG: Unable to handle kernel data access at 0x6b6b6b8f
Faulting instruction address: 0xc05fef28
Oops: Kernel access of bad area, sig: 11 [#1]
BE SMP NR_CPUS=24 MPC8544 DS
Modules linked in:
CPU: 0 PID: 21 Comm: kworker/0:1 Tainted: G        W         4.19.207-rc1-00121-gae1a50dc8893 #1
Workqueue: events __blk_release_queue
NIP:  c05fef28 LR: c0603e3c CTR: 00000000
REGS: ce143d30 TRAP: 0300   Tainted: G        W          (4.19.207-rc1-00121-gae1a50dc8893)
MSR:  00029000 <CE,EE,ME>  CR: 84002404  XER: 00000000
DEAR: 6b6b6b8f ESR: 00000000
GPR00: c0603e3c ce143de0 ce131ee0 cea4e8a0 cea4a890 00000000 00021000 00000000
GPR08: 00000001 6b6b6b6b ceb26008 00001780 44002802 00000000 c0080784 ce113d88
GPR16: 00000000 00000000 00000000 00000000 c10b0e2c c10b0e04 fffffef7 00000402
GPR24: c1160000 00000000 c11627ec 00000000 cea4e8a0 cea591d8 cea4a890 00000001
NIP [c05fef28] blk_mq_free_rqs+0x34/0x130
LR [c0603e3c] blk_mq_sched_tags_teardown+0x64/0xa0
Call Trace:
[ce143e00] [c0603e3c] blk_mq_sched_tags_teardown+0x64/0xa0
[ce143e20] [c06046a4] blk_mq_exit_sched+0xc8/0xe8
[ce143e40] [c05e1bcc] elevator_exit+0x98/0xc0
[ce143e60] [c05ea85c] blk_exit_queue+0x30/0x50
[ce143e70] [c05f09f0] __blk_release_queue+0x50/0x15c
[ce143e80] [c0079d9c] process_one_work+0x2b0/0x6b0
[ce143ec0] [c007a6f0] worker_thread+0x19c/0x49c
[ce143f10] [c00808c4] kthread+0x140/0x17c
[ce143f40] [c001534c] ret_from_kernel_thread+0x14/0x1c
Instruction dump:
7c0802a6 93c10018 7c9e2378 90010024 93810010 93a10014 93e1001c 8124005c
2c090000 41820084 81230004 7c7c1b78 <81290024> 2c090000 41820070 81240000
---[ end trace df2545c1cd678853 ]---
