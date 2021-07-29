Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48CD3DA9A5
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 19:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhG2RFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 13:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhG2RFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 13:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD4D608FB;
        Thu, 29 Jul 2021 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627578306;
        bh=tanSVsx7ADuqXEdPw5RRp50ATY4l6T4Qv7QD92oqXLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5eTbInk043l3QZy/X/+tmctZYvHGT3qTR5XSteSRIaKfI2AQODu3rY6oA3FMzM7Q
         zRF5kmbDdfDMw+ar3NaYpPLtGIK/wThWBCjD7bfR/ESusGVnvXm8wI8I5rRT1ej0cV
         Ns/H9JaeoasP4XDZan1W5qEBUmCcaq/k/7d7eQQ74WHgFWa2rffb7M9ibQX5/CgUJO
         8O2PY4gtNOwFSDPIP4h+wT2PtClcmlyoP12QYx2fb5Cg6sy0904/PprcErfLFJadtp
         dnj12WjA2RydGW8CXR9WlH2mTWnKdzIwxoEreLGGPyg9/f71ee2+94Oon/Z2WQd/Ph
         U8rWEfscQq+cA==
Date:   Thu, 29 Jul 2021 13:05:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org, axboe@kernel.dk
Subject: Re: [PATCH 5.10] io_uring: fix null-ptr-deref in
 io_sq_offload_start()
Message-ID: <YQLfwGSq+BRFTUzu@sashalap>
References: <20210729142338.1085951-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210729142338.1085951-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 10:23:38PM +0800, Yang Yingliang wrote:
>I met a null-ptr-deref when doing fault-inject test:
>
>[   65.441626][ T8299] general protection fault, probably for non-canonical address 0xdffffc0000000029: 0000 [#1] PREEMPT SMP KASAN
>[   65.443219][ T8299] KASAN: null-ptr-deref in range [0x0000000000000148-0x000000000000014f]
>[   65.444331][ T8299] CPU: 2 PID: 8299 Comm: test Not tainted 5.10.49+ #499
>[   65.445277][ T8299] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>[   65.446614][ T8299] RIP: 0010:io_disable_sqo_submit+0x124/0x260
>[   65.447554][ T8299] Code: 7b 40 89 ee e8 2d b9 9a ff 85 ed 74 40 e8 04 b8 9a ff 49 8d be 48 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 22 01 00 00 49 8b ae 48 01 00 00 48 85 ed 74 0d
>[   65.450860][ T8299] RSP: 0018:ffffc9000122fd70 EFLAGS: 00010202
>[   65.451826][ T8299] RAX: dffffc0000000000 RBX: ffff88801b11f000 RCX: ffffffff81d5d783
>[   65.453166][ T8299] RDX: 0000000000000029 RSI: ffffffff81d5d78c RDI: 0000000000000148
>[   65.454606][ T8299] RBP: 0000000000000002 R08: ffff88810168c280 R09: ffffed1003623e79
>[   65.456063][ T8299] R10: ffffc9000122fd70 R11: ffffed1003623e78 R12: ffff88801b11f040
>[   65.457542][ T8299] R13: ffff88801b11f3c0 R14: 0000000000000000 R15: 000000000000001a
>[   65.458910][ T8299] FS:  00007ffb602e3500(0000) GS:ffff888064100000(0000) knlGS:0000000000000000
>[   65.460533][ T8299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   65.461736][ T8299] CR2: 00007ffb5fe7eb24 CR3: 000000010a619000 CR4: 0000000000750ee0
>[   65.463146][ T8299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>[   65.464618][ T8299] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>[   65.466052][ T8299] PKRU: 55555554
>[   65.466708][ T8299] Call Trace:
>[   65.467304][ T8299]  io_uring_setup+0x2041/0x3ac0
>[   65.468169][ T8299]  ? io_iopoll_check+0x500/0x500
>[   65.469123][ T8299]  ? syscall_enter_from_user_mode+0x1c/0x50
>[   65.470241][ T8299]  do_syscall_64+0x2d/0x70
>[   65.471028][ T8299]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[   65.472099][ T8299] RIP: 0033:0x7ffb5fdec839
>[   65.472925][ T8299] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
>[   65.476465][ T8299] RSP: 002b:00007ffc33539ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
>[   65.478026][ T8299] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffb5fdec839
>[   65.479503][ T8299] RDX: 0000000020ffd000 RSI: 0000000020000080 RDI: 0000000000100001
>[   65.480927][ T8299] RBP: 00007ffc33539f70 R08: 0000000000000000 R09: 0000000000000000
>[   65.482416][ T8299] R10: 0000000000000000 R11: 0000000000000206 R12: 0000555e85531320
>[   65.483845][ T8299] R13: 00007ffc3353a0a0 R14: 0000000000000000 R15: 0000000000000000
>[   65.485331][ T8299] Modules linked in:
>[   65.486000][ T8299] Dumping ftrace buffer:
>[   65.486772][ T8299]    (ftrace buffer empty)
>[   65.487595][ T8299] ---[ end trace a9a5fad3ebb303b7 ]---
>
>If io_allocate_scq_urings() fails in io_uring_create(), 'ctx->sq_data'
>is not set yet, when calling io_sq_offload_start() in io_disable_sqo_submit()
>in error path, it will lead a null-ptr-deref.
>
>The io_disable_sqo_submit() has been removed in mainline by commit
>70aacfe66136 ("io_uring: kill sqo_dead and sqo submission halting"),
>so the bug has been eliminated in mainline, it's a fix only for stable-5.10.

I've added the rest of the io uring folks to this thread. Please do so
in the future using scripts/get_maintainer.pl.

-- 
Thanks,
Sasha
