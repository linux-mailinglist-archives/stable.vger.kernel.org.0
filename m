Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437473DAD94
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 22:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhG2U2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhG2U2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 16:28:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85DEC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 13:28:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so11938640pjv.3
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 13:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TMtXogLGhmbFujAu02SF8OrwzUqY9rghKS8iOBnW9rc=;
        b=xxENvp9qi7xR8VgltYHgn3RVPEY0dcu+m7JiqegZACGnanJDJwbPIOwd6PhNIavPig
         /L2Xs8L86TsAk64l1dZpPT/kkyMdfX30Mj9hOHUrlfzRk7YooLD7tNA2gjRZ2VDEw+nK
         AmzZyh/HKDZy9qPJryprq9jH9Q08ZTY88Gun59LV6H6IBflkgDSb43Z/p/TtX5tWN3kN
         qaTt7SM+GmOwWUO5zUTLafR5JOqfj8QSMV1Am0K+6UYIvAdsfLcIyW+ciPl2uJ3LC+6c
         vLUTwMTg8F7a2wRjhfznTzkwOK34xF2Sy15uw/5WbT5duQLCP5s9IAqTL6tqUnZzZmQO
         Fbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMtXogLGhmbFujAu02SF8OrwzUqY9rghKS8iOBnW9rc=;
        b=idl76O2Lafa5KEWFw/8nJSiuN7jpe1TBlvi4ApcCizGpZeOYErx53/QZ6wEQ5aFqV1
         iKMJUv60lKnpr+9PjCXVTd7S08xVhW4CCF7KXB0L1w8aRZ008rolMGmH8dtNsAvzi0yJ
         9FlI/s3HhlFffPWi6h96MS6+m7fDbbT5tyKJufQcVe30Q/smU1UcjddNwwJp8qHKdml1
         R+TPQxmGbfJlxFw5MstanM5edKS20Lwsjxnj0NUV49lGBTnHj+EGGStkCXUnKjx9ixld
         +BBig2AWg0rbSzUj2voFJmI3+gcIG6GBfFXk7zPb63xkL3DP9olbjLVNFLIZWkXc+uEq
         qzQw==
X-Gm-Message-State: AOAM530i2oQ/avnAiAfEr0tQWLb5GFfLftggKif24VcYM1v1xSRY71cF
        wOrNaaGXofRisVENYSvUVlRf8A==
X-Google-Smtp-Source: ABdhPJxY7yVrOuidVCKNvDLYr3IzfmAjcHO6nnPFUXZGcrpj/jabMO/flDIuMDvArIOfkA8R8+1aiQ==
X-Received: by 2002:a62:880c:0:b029:327:8e12:853a with SMTP id l12-20020a62880c0000b02903278e12853amr6953615pfd.74.1627590512203;
        Thu, 29 Jul 2021 13:28:32 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x7sm4520712pfn.70.2021.07.29.13.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 13:28:31 -0700 (PDT)
Subject: Re: [PATCH 5.10] io_uring: fix null-ptr-deref in
 io_sq_offload_start()
To:     Yang Yingliang <yangyingliang@huawei.com>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
References: <20210729142338.1085951-1-yangyingliang@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <85ef170c-8efe-e574-951b-81b3f8a62a31@kernel.dk>
Date:   Thu, 29 Jul 2021 14:28:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210729142338.1085951-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 8:23 AM, Yang Yingliang wrote:
> I met a null-ptr-deref when doing fault-inject test:
> 
> [   65.441626][ T8299] general protection fault, probably for non-canonical address 0xdffffc0000000029: 0000 [#1] PREEMPT SMP KASAN
> [   65.443219][ T8299] KASAN: null-ptr-deref in range [0x0000000000000148-0x000000000000014f]
> [   65.444331][ T8299] CPU: 2 PID: 8299 Comm: test Not tainted 5.10.49+ #499
> [   65.445277][ T8299] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [   65.446614][ T8299] RIP: 0010:io_disable_sqo_submit+0x124/0x260
> [   65.447554][ T8299] Code: 7b 40 89 ee e8 2d b9 9a ff 85 ed 74 40 e8 04 b8 9a ff 49 8d be 48 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 22 01 00 00 49 8b ae 48 01 00 00 48 85 ed 74 0d
> [   65.450860][ T8299] RSP: 0018:ffffc9000122fd70 EFLAGS: 00010202
> [   65.451826][ T8299] RAX: dffffc0000000000 RBX: ffff88801b11f000 RCX: ffffffff81d5d783
> [   65.453166][ T8299] RDX: 0000000000000029 RSI: ffffffff81d5d78c RDI: 0000000000000148
> [   65.454606][ T8299] RBP: 0000000000000002 R08: ffff88810168c280 R09: ffffed1003623e79
> [   65.456063][ T8299] R10: ffffc9000122fd70 R11: ffffed1003623e78 R12: ffff88801b11f040
> [   65.457542][ T8299] R13: ffff88801b11f3c0 R14: 0000000000000000 R15: 000000000000001a
> [   65.458910][ T8299] FS:  00007ffb602e3500(0000) GS:ffff888064100000(0000) knlGS:0000000000000000
> [   65.460533][ T8299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   65.461736][ T8299] CR2: 00007ffb5fe7eb24 CR3: 000000010a619000 CR4: 0000000000750ee0
> [   65.463146][ T8299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   65.464618][ T8299] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   65.466052][ T8299] PKRU: 55555554
> [   65.466708][ T8299] Call Trace:
> [   65.467304][ T8299]  io_uring_setup+0x2041/0x3ac0
> [   65.468169][ T8299]  ? io_iopoll_check+0x500/0x500
> [   65.469123][ T8299]  ? syscall_enter_from_user_mode+0x1c/0x50
> [   65.470241][ T8299]  do_syscall_64+0x2d/0x70
> [   65.471028][ T8299]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   65.472099][ T8299] RIP: 0033:0x7ffb5fdec839
> [   65.472925][ T8299] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
> [   65.476465][ T8299] RSP: 002b:00007ffc33539ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> [   65.478026][ T8299] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffb5fdec839
> [   65.479503][ T8299] RDX: 0000000020ffd000 RSI: 0000000020000080 RDI: 0000000000100001
> [   65.480927][ T8299] RBP: 00007ffc33539f70 R08: 0000000000000000 R09: 0000000000000000
> [   65.482416][ T8299] R10: 0000000000000000 R11: 0000000000000206 R12: 0000555e85531320
> [   65.483845][ T8299] R13: 00007ffc3353a0a0 R14: 0000000000000000 R15: 0000000000000000
> [   65.485331][ T8299] Modules linked in:
> [   65.486000][ T8299] Dumping ftrace buffer:
> [   65.486772][ T8299]    (ftrace buffer empty)
> [   65.487595][ T8299] ---[ end trace a9a5fad3ebb303b7 ]---
> 
> If io_allocate_scq_urings() fails in io_uring_create(), 'ctx->sq_data'
> is not set yet, when calling io_sq_offload_start() in io_disable_sqo_submit()
> in error path, it will lead a null-ptr-deref.
> 
> The io_disable_sqo_submit() has been removed in mainline by commit
> 70aacfe66136 ("io_uring: kill sqo_dead and sqo submission halting"),
> so the bug has been eliminated in mainline, it's a fix only for stable-5.10.

Looks fine, it got fixed differently in newer kernels, but this patch can be
safely applied to 5.10 and 5.11 stable.

-- 
Jens Axboe

