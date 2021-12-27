Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6020B480090
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhL0PrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbhL0PpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C61F3610A3;
        Mon, 27 Dec 2021 15:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC76C36AE7;
        Mon, 27 Dec 2021 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619907;
        bh=OduGwsVMtaAyxKhsqw/jmafB/T9q5TLjrfSjbVmIJqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBC8+5WXoHfFw8v8FEOW4GMNQPs7eM9oRw5ktVGtk2gAZLp52CFX1+plw+s5UGVqY
         rNmbLRr14N1LVUV9u5cGbAAavmd9RKiQ9+2X1IytUKxoSndZm9jKj2ficSMoRCS66e
         YYlsyyzMLGmc4DDkSjpsMeb9s8lj7Fqs6UVbouWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Marco Elver <elver@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 111/128] kfence: fix memory leak when cat kfence objects
Date:   Mon, 27 Dec 2021 16:31:26 +0100
Message-Id: <20211227151335.224672444@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 0129ab1f268b6cf88825eae819b9b84aa0a85634 upstream.

Hulk robot reported a kmemleak problem:

    unreferenced object 0xffff93d1d8cc02e8 (size 248):
      comm "cat", pid 23327, jiffies 4624670141 (age 495992.217s)
      hex dump (first 32 bytes):
        00 40 85 19 d4 93 ff ff 00 10 00 00 00 00 00 00  .@..............
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      backtrace:
         seq_open+0x2a/0x80
         full_proxy_open+0x167/0x1e0
         do_dentry_open+0x1e1/0x3a0
         path_openat+0x961/0xa20
         do_filp_open+0xae/0x120
         do_sys_openat2+0x216/0x2f0
         do_sys_open+0x57/0x80
         do_syscall_64+0x33/0x40
         entry_SYSCALL_64_after_hwframe+0x44/0xa9
    unreferenced object 0xffff93d419854000 (size 4096):
      comm "cat", pid 23327, jiffies 4624670141 (age 495992.217s)
      hex dump (first 32 bytes):
        6b 66 65 6e 63 65 2d 23 32 35 30 3a 20 30 78 30  kfence-#250: 0x0
        30 30 30 30 30 30 30 37 35 34 62 64 61 31 32 2d  0000000754bda12-
      backtrace:
         seq_read_iter+0x313/0x440
         seq_read+0x14b/0x1a0
         full_proxy_read+0x56/0x80
         vfs_read+0xa5/0x1b0
         ksys_read+0xa0/0xf0
         do_syscall_64+0x33/0x40
         entry_SYSCALL_64_after_hwframe+0x44/0xa9

I find that we can easily reproduce this problem with the following
commands:

	cat /sys/kernel/debug/kfence/objects
	echo scan > /sys/kernel/debug/kmemleak
	cat /sys/kernel/debug/kmemleak

The leaked memory is allocated in the stack below:

    do_syscall_64
      do_sys_open
        do_dentry_open
          full_proxy_open
            seq_open            ---> alloc seq_file
      vfs_read
        full_proxy_read
          seq_read
            seq_read_iter
              traverse          ---> alloc seq_buf

And it should have been released in the following process:

    do_syscall_64
      syscall_exit_to_user_mode
        exit_to_user_mode_prepare
          task_work_run
            ____fput
              __fput
                full_proxy_release  ---> free here

However, the release function corresponding to file_operations is not
implemented in kfence.  As a result, a memory leak occurs.  Therefore,
the solution to this problem is to implement the corresponding release
function.

Link: https://lkml.kernel.org/r/20211206133628.2822545-1-libaokun1@huawei.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -578,6 +578,7 @@ static const struct file_operations obje
 	.open = open_objects,
 	.read = seq_read,
 	.llseek = seq_lseek,
+	.release = seq_release,
 };
 
 static int __init kfence_debugfs_init(void)


