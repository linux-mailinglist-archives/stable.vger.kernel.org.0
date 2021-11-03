Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269E8443BE1
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 04:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhKCDg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 23:36:58 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39748 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhKCDg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 23:36:56 -0400
Received: by mail-pf1-f178.google.com with SMTP id x64so981838pfd.6;
        Tue, 02 Nov 2021 20:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZbGWXGGPaE+MkbRuqBpdFuAMQBkQChExRWu2Gblej3U=;
        b=E/Y/6hB1wKOhHb792EHVvJkunfSzeJ6awI9WkWR7Cw7F6IplaOOYW1AH5bY03kT4yT
         wn9Pz2W1lVbVH7FZ7s39C3m00tq9uzcYZcI1kaT8JvxYjAG4d1aZQ8LsZMJ8pPy28vV+
         XPNPhGz31yS4V+ue1ABDT/Rgg4y3b8BBe47EyQzO6ynpOhwt9LY8FRVFRKK/xHoShDXj
         0tLp+1COQwrPLB4ekiC397rkjDH2Sycd0emb3rrXYxT8BOAye0XjNULPew8N73aPbpzh
         NRgaUFip2a5ON5syYRi73YrDzz7PAfq+sLMy9ylOhIz4QLyKqh95VOvKPywntGuJ6QeQ
         DpWQ==
X-Gm-Message-State: AOAM532OCM0eRgtxUnSfD0R1G2CdIb5M/HPmu8sKsNTXhs/s3QhsxpLf
        vTiH997mh5rOdoGAX5CofKw=
X-Google-Smtp-Source: ABdhPJyBHsTNY+azOFquH1stpGLn1grWwy9pWoAJld++XQGC14AGY1OpFtwklJZzL55HzCMTeH9CdA==
X-Received: by 2002:a05:6a00:22c2:b0:481:1f34:d8eb with SMTP id f2-20020a056a0022c200b004811f34d8ebmr12212874pfj.38.1635910460006;
        Tue, 02 Nov 2021 20:34:20 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:28c6:b7fe:a27f:fce6? ([2601:647:4000:d7:28c6:b7fe:a27f:fce6])
        by smtp.gmail.com with ESMTPSA id p14sm247501pjl.32.2021.11.02.20.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:34:19 -0700 (PDT)
Message-ID: <dafce913-35dc-ea07-8d91-c1e7b9f234bc@acm.org>
Date:   Tue, 2 Nov 2021 20:34:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 2/2] scsi: core: remove command size deduction from
 scsi_setup_scsi_cmnd
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
 <20211103003719.1041490-2-tadeusz.struk@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211103003719.1041490-2-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/21 17:37, Tadeusz Struk wrote:
> [   21.105583][ T1822] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> [   21.106749][ T1822] CPU: 0 PID: 1822 Comm: repro Not tainted 5.15.0 #1
> [   21.107678][ T1822] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
> [   21.109004][ T1822] RIP: 0010:scsi_queue_rq+0xf09/0x2180
> [   21.112499][ T1822] RSP: 0018:ffffc90000d0f098 EFLAGS: 00010246
> [   21.113347][ T1822] RAX: dffffc0000000000 RBX: ffff888107b0d408 RCX: 0000000000000000
> [   21.114448][ T1822] RDX: ffff888107168000 RSI: 0000000000000000 RDI: 0000000000000000
> [   21.115553][ T1822] RBP: ffffc90000d0f150 R08: ffffffff82a96d37 R09: ffff888107b0d410
> [   21.116683][ T1822] R10: ffffed1020f61a85 R11: 0000000000000000 R12: 1ffff11020f61a7f
> [   21.117793][ T1822] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888107b0d3fc
> [   21.118894][ T1822] FS:  00007f5bfac9f640(0000) GS:ffff88811b200000(0000) knlGS:0000000000000000
> [   21.120132][ T1822] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   21.121050][ T1822] CR2: 0000000020001000 CR3: 0000000109acb000 CR4: 0000000000150eb0
> [   21.123125][ T1822] Call Trace:
> [   21.124020][ T1822]  blk_mq_dispatch_rq_list+0x7c7/0x12d0
> [   21.125486][ T1822]  ? __kasan_check_write+0x14/0x20
> [   21.126794][ T1822]  ? do_raw_spin_lock+0x9a/0x230
> [   21.128023][ T1822]  ? blk_mq_get_driver_tag+0x920/0x920
> [   21.129345][ T1822]  __blk_mq_sched_dispatch_requests+0x244/0x380
> [   21.130826][ T1822]  ? blk_mq_sched_dispatch_requests+0x160/0x160
> [   21.132241][ T1822]  ? _find_next_bit+0x1ec/0x210
> [   21.133376][ T1822]  blk_mq_sched_dispatch_requests+0xf0/0x160
> [   21.134724][ T1822]  __blk_mq_run_hw_queue+0xe8/0x160
> [   21.135878][ T1822]  ? __list_splice+0x100/0x100
> [   21.136902][ T1822]  __blk_mq_delay_run_hw_queue+0x252/0x5d0
> [   21.138115][ T1822]  blk_mq_run_hw_queue+0x1dd/0x3b0
> [   21.139184][ T1822]  ? blk_mq_dispatch_rq_list+0x12d0/0x12d0
> [   21.140322][ T1822]  ? _raw_spin_unlock+0x13/0x30
> [   21.141273][ T1822]  ? blk_mq_request_bypass_insert+0xcf/0xe0
> [   21.142414][ T1822]  blk_mq_sched_insert_request+0x1ff/0x3e0
> [   21.143531][ T1822]  ? timekeeping_get_ns+0xb1/0xc0
> [   21.144462][ T1822]  ? blk_mq_sched_try_insert_merge+0x240/0x240
> [   21.145592][ T1822]  ? update_io_ticks+0x17c/0x190
> [   21.146472][ T1822]  ? blk_account_io_start+0x21c/0x260
> [   21.147421][ T1822]  blk_execute_rq_nowait+0x173/0x1e0
> [   21.148356][ T1822]  ? blk_execute_rq+0x540/0x540
> [   21.149247][ T1822]  ? asan.module_ctor+0x10/0x10
> [   21.150066][ T1822]  blk_execute_rq+0x15c/0x540
> [   21.150869][ T1822]  ? cap_capable+0x2ca/0x330
> [   21.151653][ T1822]  ? blk_execute_rq_nowait+0x1e0/0x1e0
> [   21.152539][ T1822]  ? ns_capable_common+0x8f/0xf0
> [   21.153348][ T1822]  ? capable+0x1c/0x20
> [   21.153984][ T1822]  sg_io+0x97c/0x1370
> [   21.154614][ T1822]  ? scsi_ioctl_block_when_processing_errors+0x1e0/0x1e0
> [   21.155712][ T1822]  ? in_compat_syscall+0xd0/0xd0
> [   21.156488][ T1822]  ? futex_wait+0x4fb/0x640
> [   21.157175][ T1822]  scsi_ioctl+0xe16/0x28e0
> [   21.157836][ T1822]  ? __kasan_check_read+0x11/0x20
> [   21.158596][ T1822]  ? get_sg_io_hdr+0x10a0/0x10a0
> [   21.159347][ T1822]  ? __fsnotify_parent+0x4ee/0x710
> [   21.160111][ T1822]  ? do_futex+0x3f2/0x1030
> [   21.160764][ T1822]  ? futex_exit_release+0x70/0x70
> [   21.161494][ T1822]  ? do_vfs_ioctl+0xafa/0x1af0
> [   21.162168][ T1822]  ? scsi_host_in_recovery+0xb9/0x160
> [   21.162921][ T1822]  ? vfs_write+0x397/0x580
> [   21.163547][ T1822]  ? scsi_ioctl_block_when_processing_errors+0xae/0x1e0
> [   21.164521][ T1822]  sd_ioctl+0x134/0x170
> [   21.165087][ T1822]  blkdev_ioctl+0x362/0x6e0
> [   21.165724][ T1822]  ? blkdev_compat_ptr_ioctl+0xf0/0xf0
> [   21.166470][ T1822]  ? fput_many+0x5e/0x1d0
> [   21.167059][ T1822]  ? __restore_fpregs_from_fpstate+0xb5/0x160
> [   21.167873][ T1822]  block_ioctl+0xb0/0xf0
> [   21.168437][ T1822]  vfs_ioctl+0xa7/0xf0
> [   21.168970][ T1822]  __x64_sys_ioctl+0x10d/0x150
> [   21.169602][ T1822]  do_syscall_64+0x3d/0xb0
> [   21.170176][ T1822]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   21.180158][ T1822] ---[ end trace 8b086e334adef6d2 ]---
> [   21.191043][ T1822] Kernel panic - not syncing: Fatal exception
> [   21.191728][ T1822] Kernel Offset: disabled

Please clean the above call stack up by removing all unnecessary 
information (timestamps, "[ T1822]", function names with "? " in front 
and register values).

Thanks,

Bart.
