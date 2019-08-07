Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A407C84B00
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 13:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfHGLqz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 7 Aug 2019 07:46:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49457 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHGLqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 07:46:55 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hvKP3-00075L-NR; Wed, 07 Aug 2019 13:46:49 +0200
Date:   Wed, 7 Aug 2019 13:46:49 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     tglx@linutronix.de, peterz@infradead.org, mingo@kernel.org,
        tj@kernel.org, jiangshanlai@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: NULL ptr deref in wq_worker_sleeping on 4.19
Message-ID: <20190807114649.fjfaj4oytcxaua7o@linutronix.de>
References: <20190719135352.GF4240@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190719135352.GF4240@sasha-vm>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-07-19 09:53:52 [-0400], Sasha Levin wrote:
> Hi folks,
Hi,

> We're seeing a rare panic on boot in wq_worker_sleeping() on boot in
> 4.19 kernels. I wasn't able to reproduce this with 5.2, but I'm not sure
> whether it's because the issue is fixed, or I was just unlucky.
> 
> The panic looks like this:
> 
> [    0.852791] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [    0.853260] PGD 0 P4D 0 [    0.853260] Oops: 0000 [#1] SMP PTI
> [    0.853260] CPU: 7 PID: 49 Comm:  Not tainted 4.19.52-9858d02fd940 #1
> [    0.853260] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  06/02/2017
> [    0.853260] RIP: 0010:kthread_data+0x12/0x30
> [    0.853260] Code: 83 7f 58 00 74 02 0f 0b e9 bb 2d 19 00 0f 0b eb e2 0f 1f 80 00 00 00 00 0f 1f 44 00 00 f6 47 26 20 74 0c 48 8b 87 98 05 00 00 <48> 8b 40 10 c3 0f 0b 48 8b 87 98 05 00 00 48 8b 40 10 c3 90 66 2e
> [    0.853260] RSP: 0000:ffffc900036abe38 EFLAGS: 00010002
> [    0.853260] RAX: 0000000000000000 RBX: ffff8887bfbe17c0 RCX: 0000000000000000
> [    0.853260] RDX: 0000000000000001 RSI: 000000000000000a RDI: ffff8887bbb4bb00
> [    0.853260] RBP: ffffc900036abea0 R08: 0000000000000000 R09: 0000000000000000
> [    0.853260] R10: ffffc9000368bd90 R11: 0000000000000000 R12: ffff8887bbb4bb00
> [    0.853260] R13: 0000000000000000 R14: ffffc900036abe60 R15: 0000000000000000
> [    0.853260] FS:  0000000000000000(0000) GS:ffff8887bfbc0000(0000) knlGS:0000000000000000
> [    0.853260] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.853260] CR2: 0000000000000068 CR3: 00000007df40a000 CR4: 00000000001406e0
> [    0.853260] Call Trace:
> [    0.853260]  wq_worker_sleeping+0xa/0x60
> [    0.853260]  __schedule+0x571/0x8c0
> [    0.853260]  schedule+0x32/0x80
> [    0.853260]  worker_thread+0xc7/0x440
> [    0.853260]  kthread+0xf8/0x130
> [    0.853260]  ret_from_fork+0x35/0x40
> [    0.853260] Modules linked in:
> [    0.853260] CR2: 0000000000000010
> [    0.853260] ---[ end trace 160fda44361ab977 ]---
> 
> I see that this area was recently touched by 6d25be5782e4 ("sched/core,
> workqueues: Distangle worker accounting from rq lock") but I'm not sure
> if it's related.

The change should just move code outside of the scheduler and not lead
to any changed behaviour (except the small detail mentioned in the
changelog, nothing explaining what you have here).

The way the call chain looks is, kthread() allocated the struct kthread
(self) and saved it in current->set_child_tid and this pointer is not
NULL. Everything works out and `threadfn' is invoked which is
worker_thread().
The first thing it does, is to set the special kworker flag via
set_pf_worker() which enables the additional code in the scheduler. Then
it has nothing to do and invokes schedule() which then gets us to
wq_worker_sleeping(). Here it invokes wq_worker_sleeping() which is what
explodes.
Based on the register dump and code dump, RAX is NULL which is
current->set_child_tid (from the begin of ktread()). It adds 0x10 for
the ->date pointer and OOPSes while reading from 0x10.

So everything looks fine, except that `set_child_tid' seems to be zeroed
out. Also, task_struct has a few lines after `set_child_tid' the `comm'
member which seems to contain also 0x00 because the trace contains no
task name. At this point I would have expected "kworker/…".

Based on this two hints it looks like something zeroed that memory area
shortly after it was occupied by the task (aka use after free).

Sebastian
