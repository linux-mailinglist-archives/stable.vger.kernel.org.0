Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5DD13341B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgAGVX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgAGVA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5227B2077B;
        Tue,  7 Jan 2020 21:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430857;
        bh=WhSVxVp3AZb+Zjctd27Ove9es0wWxTvm7Xk0qqFHkwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejScTPwFEk1j9xk0L9ES0U68NLJUDHBgcNJ+sNG2sXj1m+MYPReZ1LueUzJWMQHsd
         0Qrg6Kame9PuFGqNdv5xXTelIN21x0ZVlzL24cmeT5M7dd1Gr4Ai1R32cLBQRLL0sd
         Qu73BqPLkegy94ipdGygvSah3vXaBOB5RT/PURO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gang He <ghe@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 088/191] ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less
Date:   Tue,  7 Jan 2020 21:53:28 +0100
Message-Id: <20200107205337.708010706@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <GHe@suse.com>

commit b73eba2a867e10b9b4477738677341f3307c07bb upstream.

Because ocfs2_get_dlm_debug() function is called once less here, ocfs2
file system will trigger the system crash, usually after ocfs2 file
system is unmounted.

This system crash is caused by a generic memory corruption, these crash
backtraces are not always the same, for exapmle,

    ocfs2: Unmounting device (253,16) on (node 172167785)
    general protection fault: 0000 [#1] SMP PTI
    CPU: 3 PID: 14107 Comm: fence_legacy Kdump:
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
    RIP: 0010:__kmalloc+0xa5/0x2a0
    Code: 00 00 4d 8b 07 65 4d 8b
    RSP: 0018:ffffaa1fc094bbe8 EFLAGS: 00010286
    RAX: 0000000000000000 RBX: d310a8800d7a3faf RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000dc0 RDI: ffff96e68fc036c0
    RBP: d310a8800d7a3faf R08: ffff96e6ffdb10a0 R09: 00000000752e7079
    R10: 000000000001c513 R11: 0000000004091041 R12: 0000000000000dc0
    R13: 0000000000000039 R14: ffff96e68fc036c0 R15: ffff96e68fc036c0
    FS:  00007f699dfba540(0000) GS:ffff96e6ffd80000(0000) knlGS:00000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 000055f3a9d9b768 CR3: 000000002cd1c000 CR4: 00000000000006e0
    Call Trace:
     ext4_htree_store_dirent+0x35/0x100 [ext4]
     htree_dirblock_to_tree+0xea/0x290 [ext4]
     ext4_htree_fill_tree+0x1c1/0x2d0 [ext4]
     ext4_readdir+0x67c/0x9d0 [ext4]
     iterate_dir+0x8d/0x1a0
     __x64_sys_getdents+0xab/0x130
     do_syscall_64+0x60/0x1f0
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f699d33a9fb

This regression problem was introduced by commit e581595ea29c ("ocfs: no
need to check return value of debugfs_create functions").

Link: http://lkml.kernel.org/r/20191225061501.13587-1-ghe@suse.com
Fixes: e581595ea29c ("ocfs: no need to check return value of debugfs_create functions")
Signed-off-by: Gang He <ghe@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/dlmglue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3282,6 +3282,7 @@ static void ocfs2_dlm_init_debug(struct
 
 	debugfs_create_u32("locking_filter", 0600, osb->osb_debug_root,
 			   &dlm_debug->d_filter_secs);
+	ocfs2_get_dlm_debug(dlm_debug);
 }
 
 static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)


