Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A074257F5E2
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiGXPqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 11:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGXPqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 11:46:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D559631B
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 08:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43518B80D70
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 15:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98068C3411E;
        Sun, 24 Jul 2022 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658677560;
        bh=s3NIGpCvMOg+adEmPEqMHu1IGC7XiB6+Sk3UDOQD4sY=;
        h=Subject:To:Cc:From:Date:From;
        b=V8awD0JZWGi1ya7jWdgzalXQ7wjH50PATuRGJM41qlIDMBZZJEqy4yVEIt0YFfm/P
         QBiM0+PatH07G9wyID0/yQxOLQEaM7/HssA/640nqCQ4k18fZTf6fCMdstRxJHlR1e
         JoegpaKFaQ7mqicZVDAnM0awtYUFVxMZpm0Xkhu8=
Subject: FAILED: patch "[PATCH] ipc: Free mq_sysctls if ipc namespace creation failed" failed to apply to 5.10-stable tree
To:     legion@kernel.org, ebiederm@xmission.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jul 2022 17:45:54 +0200
Message-ID: <165867755494217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db7cfc380900bc4243b09623fd72fabe0a8ff23b Mon Sep 17 00:00:00 2001
From: Alexey Gladkov <legion@kernel.org>
Date: Wed, 22 Jun 2022 22:07:29 +0200
Subject: [PATCH] ipc: Free mq_sysctls if ipc namespace creation failed

The problem that Dmitry Vyukov pointed out is that if setup_ipc_sysctls fails,
mq_sysctls must be freed before return.

executing program
BUG: memory leak
unreferenced object 0xffff888112fc9200 (size 512):
  comm "syz-executor237", pid 3648, jiffies 4294970469 (age 12.270s)
  hex dump (first 32 bytes):
    ef d3 60 85 ff ff ff ff 0c 9b d2 12 81 88 ff ff  ..`.............
    04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814b6eb3>] kmemdup+0x23/0x50 mm/util.c:129
    [<ffffffff82219a9b>] kmemdup include/linux/fortify-string.h:456 [inline]
    [<ffffffff82219a9b>] setup_mq_sysctls+0x4b/0x1c0 ipc/mq_sysctl.c:89
    [<ffffffff822197f2>] create_ipc_ns ipc/namespace.c:63 [inline]
    [<ffffffff822197f2>] copy_ipcs+0x292/0x390 ipc/namespace.c:91
    [<ffffffff8127de7c>] create_new_namespaces+0xdc/0x4f0 kernel/nsproxy.c:90
    [<ffffffff8127e89b>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<ffffffff8123f92e>] ksys_unshare+0x2fe/0x600 kernel/fork.c:3165
    [<ffffffff8123fc42>] __do_sys_unshare kernel/fork.c:3236 [inline]
    [<ffffffff8123fc42>] __se_sys_unshare kernel/fork.c:3234 [inline]
    [<ffffffff8123fc42>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3234
    [<ffffffff845aab45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845aab45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

BUG: memory leak
unreferenced object 0xffff888112fd5f00 (size 256):
  comm "syz-executor237", pid 3648, jiffies 4294970469 (age 12.270s)
  hex dump (first 32 bytes):
    00 92 fc 12 81 88 ff ff 00 00 00 00 01 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816fea1b>] kmalloc include/linux/slab.h:605 [inline]
    [<ffffffff816fea1b>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff816fea1b>] __register_sysctl_table+0x7b/0x7f0 fs/proc/proc_sysctl.c:1344
    [<ffffffff82219b7a>] setup_mq_sysctls+0x12a/0x1c0 ipc/mq_sysctl.c:112
    [<ffffffff822197f2>] create_ipc_ns ipc/namespace.c:63 [inline]
    [<ffffffff822197f2>] copy_ipcs+0x292/0x390 ipc/namespace.c:91
    [<ffffffff8127de7c>] create_new_namespaces+0xdc/0x4f0 kernel/nsproxy.c:90
    [<ffffffff8127e89b>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<ffffffff8123f92e>] ksys_unshare+0x2fe/0x600 kernel/fork.c:3165
    [<ffffffff8123fc42>] __do_sys_unshare kernel/fork.c:3236 [inline]
    [<ffffffff8123fc42>] __se_sys_unshare kernel/fork.c:3234 [inline]
    [<ffffffff8123fc42>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3234
    [<ffffffff845aab45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845aab45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

BUG: memory leak
unreferenced object 0xffff888112fbba00 (size 256):
  comm "syz-executor237", pid 3648, jiffies 4294970469 (age 12.270s)
  hex dump (first 32 bytes):
    78 ba fb 12 81 88 ff ff 00 00 00 00 01 00 00 00  x...............
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816fef49>] kmalloc include/linux/slab.h:605 [inline]
    [<ffffffff816fef49>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff816fef49>] new_dir fs/proc/proc_sysctl.c:978 [inline]
    [<ffffffff816fef49>] get_subdir fs/proc/proc_sysctl.c:1022 [inline]
    [<ffffffff816fef49>] __register_sysctl_table+0x5a9/0x7f0 fs/proc/proc_sysctl.c:1373
    [<ffffffff82219b7a>] setup_mq_sysctls+0x12a/0x1c0 ipc/mq_sysctl.c:112
    [<ffffffff822197f2>] create_ipc_ns ipc/namespace.c:63 [inline]
    [<ffffffff822197f2>] copy_ipcs+0x292/0x390 ipc/namespace.c:91
    [<ffffffff8127de7c>] create_new_namespaces+0xdc/0x4f0 kernel/nsproxy.c:90
    [<ffffffff8127e89b>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<ffffffff8123f92e>] ksys_unshare+0x2fe/0x600 kernel/fork.c:3165
    [<ffffffff8123fc42>] __do_sys_unshare kernel/fork.c:3236 [inline]
    [<ffffffff8123fc42>] __se_sys_unshare kernel/fork.c:3234 [inline]
    [<ffffffff8123fc42>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3234
    [<ffffffff845aab45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845aab45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

BUG: memory leak
unreferenced object 0xffff888112fbb900 (size 256):
  comm "syz-executor237", pid 3648, jiffies 4294970469 (age 12.270s)
  hex dump (first 32 bytes):
    78 b9 fb 12 81 88 ff ff 00 00 00 00 01 00 00 00  x...............
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816fef49>] kmalloc include/linux/slab.h:605 [inline]
    [<ffffffff816fef49>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff816fef49>] new_dir fs/proc/proc_sysctl.c:978 [inline]
    [<ffffffff816fef49>] get_subdir fs/proc/proc_sysctl.c:1022 [inline]
    [<ffffffff816fef49>] __register_sysctl_table+0x5a9/0x7f0 fs/proc/proc_sysctl.c:1373
    [<ffffffff82219b7a>] setup_mq_sysctls+0x12a/0x1c0 ipc/mq_sysctl.c:112
    [<ffffffff822197f2>] create_ipc_ns ipc/namespace.c:63 [inline]
    [<ffffffff822197f2>] copy_ipcs+0x292/0x390 ipc/namespace.c:91
    [<ffffffff8127de7c>] create_new_namespaces+0xdc/0x4f0 kernel/nsproxy.c:90
    [<ffffffff8127e89b>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<ffffffff8123f92e>] ksys_unshare+0x2fe/0x600 kernel/fork.c:3165
    [<ffffffff8123fc42>] __do_sys_unshare kernel/fork.c:3236 [inline]
    [<ffffffff8123fc42>] __se_sys_unshare kernel/fork.c:3234 [inline]
    [<ffffffff8123fc42>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3234
    [<ffffffff845aab45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845aab45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Reported-by: syzbot+b4b0d1b35442afbf6fd2@syzkaller.appspotmail.com
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Link: https://lkml.kernel.org/r/000000000000f5004705e1db8bad@google.com
Link: https://lkml.kernel.org/r/20220622200729.2639663-1-legion@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 754f3237194a..e1fcaedba4fa 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -64,7 +64,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 		goto fail_put;
 
 	if (!setup_ipc_sysctls(ns))
-		goto fail_put;
+		goto fail_mq;
 
 	sem_init_ns(ns);
 	msg_init_ns(ns);
@@ -72,6 +72,9 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
 	return ns;
 
+fail_mq:
+	retire_mq_sysctls(ns);
+
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);

