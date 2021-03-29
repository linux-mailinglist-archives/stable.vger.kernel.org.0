Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314E34C8E4
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhC2IYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233755AbhC2IXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C8161554;
        Mon, 29 Mar 2021 08:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006227;
        bh=ySD/AyLDmWAgThpEcTD75lQI0DPswwRh7FMECb82zJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f68r67dyOYCTDTeJxlfDFS+jYszq9p6+3kiLQYcSUa3LgaxmfLG35HNAxG5sWUBHI
         Lqu4LNtJxR7itu0wW9lBVjsWW8+44UDiN+O72XnVsnFypgD98j+dLcmpKl+tZnG9Rh
         BVK7eQNA7IGnojj0Pffs5QzaHISEJArbrsILSgkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com,
        Zqiang <qiang.zhang@windriver.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/221] bpf: Fix umd memory leak in copy_process()
Date:   Mon, 29 Mar 2021 09:58:15 +0200
Message-Id: <20210329075634.616257885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit f60a85cad677c4f9bb4cadd764f1d106c38c7cf8 ]

The syzbot reported a memleak as follows:

BUG: memory leak
unreferenced object 0xffff888101b41d00 (size 120):
  comm "kworker/u4:0", pid 8, jiffies 4294944270 (age 12.780s)
  backtrace:
    [<ffffffff8125dc56>] alloc_pid+0x66/0x560
    [<ffffffff81226405>] copy_process+0x1465/0x25e0
    [<ffffffff81227943>] kernel_clone+0xf3/0x670
    [<ffffffff812281a1>] kernel_thread+0x61/0x80
    [<ffffffff81253464>] call_usermodehelper_exec_work
    [<ffffffff81253464>] call_usermodehelper_exec_work+0xc4/0x120
    [<ffffffff812591c9>] process_one_work+0x2c9/0x600
    [<ffffffff81259ab9>] worker_thread+0x59/0x5d0
    [<ffffffff812611c8>] kthread+0x178/0x1b0
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30

unreferenced object 0xffff888110ef5c00 (size 232):
  comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
  backtrace:
    [<ffffffff8154a0cf>] kmem_cache_zalloc
    [<ffffffff8154a0cf>] __alloc_file+0x1f/0xf0
    [<ffffffff8154a809>] alloc_empty_file+0x69/0x120
    [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0
    [<ffffffff8154ab22>] alloc_file_pseudo+0xb2/0x140
    [<ffffffff81559218>] create_pipe_files+0x138/0x2e0
    [<ffffffff8126c793>] umd_setup+0x33/0x220
    [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30

After the UMD process exits, the pipe_to_umh/pipe_from_umh and
tgid need to be released.

Fixes: d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
Reported-by: syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210317030915.2865-1-qiang.zhang@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/usermode_driver.h       |  1 +
 kernel/bpf/preload/bpf_preload_kern.c | 19 +++++++++++++++----
 kernel/usermode_driver.c              | 21 +++++++++++++++------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/usermode_driver.h b/include/linux/usermode_driver.h
index 073a9e0ec07d..ad970416260d 100644
--- a/include/linux/usermode_driver.h
+++ b/include/linux/usermode_driver.h
@@ -14,5 +14,6 @@ struct umd_info {
 int umd_load_blob(struct umd_info *info, const void *data, size_t len);
 int umd_unload_blob(struct umd_info *info);
 int fork_usermode_driver(struct umd_info *info);
+void umd_cleanup_helper(struct umd_info *info);
 
 #endif /* __LINUX_USERMODE_DRIVER_H__ */
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 79c5772465f1..53736e52c1df 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -60,9 +60,12 @@ static int finish(void)
 			 &magic, sizeof(magic), &pos);
 	if (n != sizeof(magic))
 		return -EPIPE;
+
 	tgid = umd_ops.info.tgid;
-	wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
-	umd_ops.info.tgid = NULL;
+	if (tgid) {
+		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+		umd_cleanup_helper(&umd_ops.info);
+	}
 	return 0;
 }
 
@@ -80,10 +83,18 @@ static int __init load_umd(void)
 
 static void __exit fini_umd(void)
 {
+	struct pid *tgid;
+
 	bpf_preload_ops = NULL;
+
 	/* kill UMD in case it's still there due to earlier error */
-	kill_pid(umd_ops.info.tgid, SIGKILL, 1);
-	umd_ops.info.tgid = NULL;
+	tgid = umd_ops.info.tgid;
+	if (tgid) {
+		kill_pid(tgid, SIGKILL, 1);
+
+		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+		umd_cleanup_helper(&umd_ops.info);
+	}
 	umd_unload_blob(&umd_ops.info);
 }
 late_initcall(load_umd);
diff --git a/kernel/usermode_driver.c b/kernel/usermode_driver.c
index 0b35212ffc3d..bb7bb3b478ab 100644
--- a/kernel/usermode_driver.c
+++ b/kernel/usermode_driver.c
@@ -139,13 +139,22 @@ static void umd_cleanup(struct subprocess_info *info)
 	struct umd_info *umd_info = info->data;
 
 	/* cleanup if umh_setup() was successful but exec failed */
-	if (info->retval) {
-		fput(umd_info->pipe_to_umh);
-		fput(umd_info->pipe_from_umh);
-		put_pid(umd_info->tgid);
-		umd_info->tgid = NULL;
-	}
+	if (info->retval)
+		umd_cleanup_helper(umd_info);
+}
+
+/**
+ * umd_cleanup_helper - release the resources which were allocated in umd_setup
+ * @info: information about usermode driver
+ */
+void umd_cleanup_helper(struct umd_info *info)
+{
+	fput(info->pipe_to_umh);
+	fput(info->pipe_from_umh);
+	put_pid(info->tgid);
+	info->tgid = NULL;
 }
+EXPORT_SYMBOL_GPL(umd_cleanup_helper);
 
 /**
  * fork_usermode_driver - fork a usermode driver
-- 
2.30.1



