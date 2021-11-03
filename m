Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAEB443A81
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 01:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhKCAkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 20:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbhKCAkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 20:40:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DABC061203
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 17:37:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o14so1346833plg.5
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 17:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJrytAQ63T44khLSnSGbFhf8bBshErqFBGjST2aRFj0=;
        b=zTNA2Pzrz1bEg4D+deJCQi1Pc2jVhWoOpsMmn40zZRTMgXZWpEfTTLMs7hfwTXZ3Xv
         wKoxSMuSqZvfYb5JapDHABwNQWUOUhvxuP4Hh+C6juqwIJPphXth8MzA7HfW/dlurNiA
         SVCh1LbJZLXQpV8R7KYX1Lc3zTSOMY09Xb5EYM7Ja6lH33/exJi9JrTVdphup/9iH0Uv
         NalJLH+XSbIPFmyu4DNcBgZDAjtDcnz4NOzIbU4/T8YQE3G1PRXJhxKC5fmynEV7Vh7G
         KodkFWMTQmxm0hG7BG8NKGIJ1z1EfJsZVc1Q/tTZ/DVwX8S/KpPsoIBvtBlyhuRqqOvk
         9avg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJrytAQ63T44khLSnSGbFhf8bBshErqFBGjST2aRFj0=;
        b=gs3UkCc+dscuzxnugeu3wKfHRGtZtCZmkcV3TYdz7Syqv/+Wpv6fvtJosHWxIK+JKK
         dxneLwoDHdV3MGqA11rnq0WhjvQZW53Av0Pkjpylrj1PfwVaAheuEEWYUyKQF+5gP1lU
         8wK/ptkHjQn2iQGH0IayX+uWbghHx8DpoL6tDdvjpzXT44mon2FXDkRb7PRLN4Kimkri
         6jZ6SX5GYomhZtRl755lCAGMa4FRwvqU6sA8jgOGRKE4qYzKLKuz7+91zhzCNxgZoNqk
         g6tgNn14zyrdGl9UdVPUJtenOhdAUDWs/tYLADwnrWm/G311K3mQ51tPD51Sb7jhhNGj
         W3ng==
X-Gm-Message-State: AOAM5334PapkKYtaTHM9B8j0jL60CM1TPTGzFa1GlVia6THoI+CsfYbZ
        63DXQihvfgcUB+c2xnZCKHjiiA==
X-Google-Smtp-Source: ABdhPJxReJFFQV9OpIfK9bBVGNNkD/R+FpJjf0MbpIcFqcXx0KTPNsW3WGculTKshrr5vQ7vwcOS8g==
X-Received: by 2002:a17:90b:3a85:: with SMTP id om5mr11043099pjb.28.1635899867419;
        Tue, 02 Nov 2021 17:37:47 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id n20sm219159pgc.10.2021.11.02.17.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:37:46 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     linux-scsi@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
Subject: [PATCH 2/2] scsi: core: remove command size deduction from scsi_setup_scsi_cmnd
Date:   Tue,  2 Nov 2021 17:37:19 -0700
Message-Id: <20211103003719.1041490-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
References: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No need to deduce command size in scsi_setup_scsi_cmnd() anymore
as appropriate checks have been added to scsi_fill_sghdr_rq() function
and the cmd_len should never be zero here.
The code to do that wasn't correct anyway, as it used uninitialized
cmd->cmnd, which caused a null-ptr-deref if the command size was zero
as in the trace below. Fix this by removing the uneeded code.

[   21.105583][ T1822] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   21.106749][ T1822] CPU: 0 PID: 1822 Comm: repro Not tainted 5.15.0 #1
[   21.107678][ T1822] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
[   21.109004][ T1822] RIP: 0010:scsi_queue_rq+0xf09/0x2180
[   21.112499][ T1822] RSP: 0018:ffffc90000d0f098 EFLAGS: 00010246
[   21.113347][ T1822] RAX: dffffc0000000000 RBX: ffff888107b0d408 RCX: 0000000000000000
[   21.114448][ T1822] RDX: ffff888107168000 RSI: 0000000000000000 RDI: 0000000000000000
[   21.115553][ T1822] RBP: ffffc90000d0f150 R08: ffffffff82a96d37 R09: ffff888107b0d410
[   21.116683][ T1822] R10: ffffed1020f61a85 R11: 0000000000000000 R12: 1ffff11020f61a7f
[   21.117793][ T1822] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888107b0d3fc
[   21.118894][ T1822] FS:  00007f5bfac9f640(0000) GS:ffff88811b200000(0000) knlGS:0000000000000000
[   21.120132][ T1822] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.121050][ T1822] CR2: 0000000020001000 CR3: 0000000109acb000 CR4: 0000000000150eb0
[   21.123125][ T1822] Call Trace:
[   21.124020][ T1822]  blk_mq_dispatch_rq_list+0x7c7/0x12d0
[   21.125486][ T1822]  ? __kasan_check_write+0x14/0x20
[   21.126794][ T1822]  ? do_raw_spin_lock+0x9a/0x230
[   21.128023][ T1822]  ? blk_mq_get_driver_tag+0x920/0x920
[   21.129345][ T1822]  __blk_mq_sched_dispatch_requests+0x244/0x380
[   21.130826][ T1822]  ? blk_mq_sched_dispatch_requests+0x160/0x160
[   21.132241][ T1822]  ? _find_next_bit+0x1ec/0x210
[   21.133376][ T1822]  blk_mq_sched_dispatch_requests+0xf0/0x160
[   21.134724][ T1822]  __blk_mq_run_hw_queue+0xe8/0x160
[   21.135878][ T1822]  ? __list_splice+0x100/0x100
[   21.136902][ T1822]  __blk_mq_delay_run_hw_queue+0x252/0x5d0
[   21.138115][ T1822]  blk_mq_run_hw_queue+0x1dd/0x3b0
[   21.139184][ T1822]  ? blk_mq_dispatch_rq_list+0x12d0/0x12d0
[   21.140322][ T1822]  ? _raw_spin_unlock+0x13/0x30
[   21.141273][ T1822]  ? blk_mq_request_bypass_insert+0xcf/0xe0
[   21.142414][ T1822]  blk_mq_sched_insert_request+0x1ff/0x3e0
[   21.143531][ T1822]  ? timekeeping_get_ns+0xb1/0xc0
[   21.144462][ T1822]  ? blk_mq_sched_try_insert_merge+0x240/0x240
[   21.145592][ T1822]  ? update_io_ticks+0x17c/0x190
[   21.146472][ T1822]  ? blk_account_io_start+0x21c/0x260
[   21.147421][ T1822]  blk_execute_rq_nowait+0x173/0x1e0
[   21.148356][ T1822]  ? blk_execute_rq+0x540/0x540
[   21.149247][ T1822]  ? asan.module_ctor+0x10/0x10
[   21.150066][ T1822]  blk_execute_rq+0x15c/0x540
[   21.150869][ T1822]  ? cap_capable+0x2ca/0x330
[   21.151653][ T1822]  ? blk_execute_rq_nowait+0x1e0/0x1e0
[   21.152539][ T1822]  ? ns_capable_common+0x8f/0xf0
[   21.153348][ T1822]  ? capable+0x1c/0x20
[   21.153984][ T1822]  sg_io+0x97c/0x1370
[   21.154614][ T1822]  ? scsi_ioctl_block_when_processing_errors+0x1e0/0x1e0
[   21.155712][ T1822]  ? in_compat_syscall+0xd0/0xd0
[   21.156488][ T1822]  ? futex_wait+0x4fb/0x640
[   21.157175][ T1822]  scsi_ioctl+0xe16/0x28e0
[   21.157836][ T1822]  ? __kasan_check_read+0x11/0x20
[   21.158596][ T1822]  ? get_sg_io_hdr+0x10a0/0x10a0
[   21.159347][ T1822]  ? __fsnotify_parent+0x4ee/0x710
[   21.160111][ T1822]  ? do_futex+0x3f2/0x1030
[   21.160764][ T1822]  ? futex_exit_release+0x70/0x70
[   21.161494][ T1822]  ? do_vfs_ioctl+0xafa/0x1af0
[   21.162168][ T1822]  ? scsi_host_in_recovery+0xb9/0x160
[   21.162921][ T1822]  ? vfs_write+0x397/0x580
[   21.163547][ T1822]  ? scsi_ioctl_block_when_processing_errors+0xae/0x1e0
[   21.164521][ T1822]  sd_ioctl+0x134/0x170
[   21.165087][ T1822]  blkdev_ioctl+0x362/0x6e0
[   21.165724][ T1822]  ? blkdev_compat_ptr_ioctl+0xf0/0xf0
[   21.166470][ T1822]  ? fput_many+0x5e/0x1d0
[   21.167059][ T1822]  ? __restore_fpregs_from_fpstate+0xb5/0x160
[   21.167873][ T1822]  block_ioctl+0xb0/0xf0
[   21.168437][ T1822]  vfs_ioctl+0xa7/0xf0
[   21.168970][ T1822]  __x64_sys_ioctl+0x10d/0x150
[   21.169602][ T1822]  do_syscall_64+0x3d/0xb0
[   21.170176][ T1822]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   21.180158][ T1822] ---[ end trace 8b086e334adef6d2 ]---
[   21.191043][ T1822] Kernel panic - not syncing: Fatal exception
[   21.191728][ T1822] Kernel Offset: disabled

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
Fixes: 2ceda20f0a99a74a82b78870f3b3e5fa93087a7f
Reported-by: syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 drivers/scsi/scsi_lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf..e026da7549be 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1174,8 +1174,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	}
 
 	cmd->cmd_len = scsi_req(req)->cmd_len;
-	if (cmd->cmd_len == 0)
-		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = scsi_req(req)->retries;
-- 
2.31.1

