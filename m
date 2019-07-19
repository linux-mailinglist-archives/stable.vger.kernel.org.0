Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B670F6E6E5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 15:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfGSNxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 09:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfGSNxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 09:53:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2373220873;
        Fri, 19 Jul 2019 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563544433;
        bh=PWY0uoVGOh2PIWiAEFdra9jU7XP0LdTkL6CqbiecmhI=;
        h=Date:From:To:Cc:Subject:From;
        b=JgHCo4v2VcpkMOr8kI0jFODeODS1YOtg9AsqQnJyqBNCHNCTlFh5NFtHqcs1vxwpx
         qQyCpne+/nfzZ34ku+t1vzhuDvt6A54gDCZrOViO30B6wcPFaTuEiRE7CUfMulmqBA
         F08wF7Cj2BPP37/60P6QY8I77v78jM+kWN3bJ7gs=
Date:   Fri, 19 Jul 2019 09:53:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     tglx@linutronix.de, bigeasy@linutronix.de, peterz@infradead.org,
        mingo@kernel.org, tj@kernel.org, jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: NULL ptr deref in wq_worker_sleeping on 4.19
Message-ID: <20190719135352.GF4240@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

We're seeing a rare panic on boot in wq_worker_sleeping() on boot in
4.19 kernels. I wasn't able to reproduce this with 5.2, but I'm not sure
whether it's because the issue is fixed, or I was just unlucky.

The panic looks like this:

[    0.852791] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[    0.853260] PGD 0 P4D 0 
[    0.853260] Oops: 0000 [#1] SMP PTI
[    0.853260] CPU: 7 PID: 49 Comm:  Not tainted 4.19.52-9858d02fd940 #1
[    0.853260] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  06/02/2017
[    0.853260] RIP: 0010:kthread_data+0x12/0x30
[    0.853260] Code: 83 7f 58 00 74 02 0f 0b e9 bb 2d 19 00 0f 0b eb e2 0f 1f 80 00 00 00 00 0f 1f 44 00 00 f6 47 26 20 74 0c 48 8b 87 98 05 00 00 <48> 8b 40 10 c3 0f 0b 48 8b 87 98 05 00 00 48 8b 40 10 c3 90 66 2e
[    0.853260] RSP: 0000:ffffc900036abe38 EFLAGS: 00010002
[    0.853260] RAX: 0000000000000000 RBX: ffff8887bfbe17c0 RCX: 0000000000000000
[    0.853260] RDX: 0000000000000001 RSI: 000000000000000a RDI: ffff8887bbb4bb00
[    0.853260] RBP: ffffc900036abea0 R08: 0000000000000000 R09: 0000000000000000
[    0.853260] R10: ffffc9000368bd90 R11: 0000000000000000 R12: ffff8887bbb4bb00
[    0.853260] R13: 0000000000000000 R14: ffffc900036abe60 R15: 0000000000000000
[    0.853260] FS:  0000000000000000(0000) GS:ffff8887bfbc0000(0000) knlGS:0000000000000000
[    0.853260] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.853260] CR2: 0000000000000068 CR3: 00000007df40a000 CR4: 00000000001406e0
[    0.853260] Call Trace:
[    0.853260]  wq_worker_sleeping+0xa/0x60
[    0.853260]  __schedule+0x571/0x8c0
[    0.853260]  schedule+0x32/0x80
[    0.853260]  worker_thread+0xc7/0x440
[    0.853260]  kthread+0xf8/0x130
[    0.853260]  ret_from_fork+0x35/0x40
[    0.853260] Modules linked in:
[    0.853260] CR2: 0000000000000010
[    0.853260] ---[ end trace 160fda44361ab977 ]---

I see that this area was recently touched by 6d25be5782e4 ("sched/core,
workqueues: Distangle worker accounting from rq lock") but I'm not sure
if it's related.

--
Thanks,
Sasha
