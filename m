Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB811AC9EA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395271AbgDPP3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898397AbgDPNn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DC5420732;
        Thu, 16 Apr 2020 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044636;
        bh=8LTmd6JUlMihxqUDuTkjRkz1pyjSdNwMgCWlWgkyDm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBmJDnEyCqrCXexeIkG3D3JLCqCDfu6JPnXLm2wzsrXQ4WX5CymzAa0V3xbOnYKWY
         nZ/HSpkFSzvraXYOgRjiw3CWyrACKety1zB3TRqGO+XPDF/CtVPYMKK+tP/Sr7+e8S
         TzA66y9hexA6C/3uubbOCJkuAx4J8GTG2DYaucI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/232] debugfs: Check module state before warning in {full/open}_proxy_open()
Date:   Thu, 16 Apr 2020 15:22:13 +0200
Message-Id: <20200416131320.790142880@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 275678e7a9be6a0ea9c1bb493e48abf2f4a01be5 ]

When the module is being removed, the module state is set to
MODULE_STATE_GOING. At this point, try_module_get() fails.
And when {full/open}_proxy_open() is being called,
it calls try_module_get() to try to hold module reference count.
If it fails, it warns about the possibility of debugfs file leak.

If {full/open}_proxy_open() is called while the module is being removed,
it fails to hold the module.
So, It warns about debugfs file leak. But it is not the debugfs file
leak case. So, this patch just adds module state checking routine
in the {full/open}_proxy_open().

Test commands:
    #SHELL1
    while :
    do
        modprobe netdevsim
        echo 1 > /sys/bus/netdevsim/new_device
        modprobe -rv netdevsim
    done

    #SHELL2
    while :
    do
        cat /sys/kernel/debug/netdevsim/netdevsim1/ports/0/ipsec
    done

Splat looks like:
[  298.766738][T14664] debugfs file owner did not clean up at exit: ipsec
[  298.766766][T14664] WARNING: CPU: 2 PID: 14664 at fs/debugfs/file.c:312 full_proxy_open+0x10f/0x650
[  298.768595][T14664] Modules linked in: netdevsim(-) openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 n][  298.771343][T14664] CPU: 2 PID: 14664 Comm: cat Tainted: G        W         5.5.0+ #1
[  298.772373][T14664] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  298.773545][T14664] RIP: 0010:full_proxy_open+0x10f/0x650
[  298.774247][T14664] Code: 48 c1 ea 03 80 3c 02 00 0f 85 c1 04 00 00 49 8b 3c 24 e8 e4 b5 78 ff 84 c0 75 2d 4c 89 ee 48
[  298.776782][T14664] RSP: 0018:ffff88805b7df9b8 EFLAGS: 00010282[  298.777583][T14664] RAX: dffffc0000000008 RBX: ffff8880511725c0 RCX: 0000000000000000
[  298.778610][T14664] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8880540c5c14
[  298.779637][T14664] RBP: 0000000000000000 R08: fffffbfff15235ad R09: 0000000000000000
[  298.780664][T14664] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffc06b5000
[  298.781702][T14664] R13: ffff88804c234a88 R14: ffff88804c22dd00 R15: ffffffff8a1b5660
[  298.782722][T14664] FS:  00007fafa13a8540(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[  298.783845][T14664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  298.784672][T14664] CR2: 00007fafa0e9cd10 CR3: 000000004b286005 CR4: 00000000000606e0
[  298.785739][T14664] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  298.786769][T14664] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  298.787785][T14664] Call Trace:
[  298.788237][T14664]  do_dentry_open+0x63c/0xf50
[  298.788872][T14664]  ? open_proxy_open+0x270/0x270
[  298.789524][T14664]  ? __x64_sys_fchdir+0x180/0x180
[  298.790169][T14664]  ? inode_permission+0x65/0x390
[  298.790832][T14664]  path_openat+0xc45/0x2680
[  298.791425][T14664]  ? save_stack+0x69/0x80
[  298.791988][T14664]  ? save_stack+0x19/0x80
[  298.792544][T14664]  ? path_mountpoint+0x2e0/0x2e0
[  298.793233][T14664]  ? check_chain_key+0x236/0x5d0
[  298.793910][T14664]  ? sched_clock_cpu+0x18/0x170
[  298.794527][T14664]  ? find_held_lock+0x39/0x1d0
[  298.795153][T14664]  do_filp_open+0x16a/0x260
[ ... ]

Fixes: 9fd4dcece43a ("debugfs: prevent access to possibly dead file_operations at file open")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20200218043150.29447-1-ap420073@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 8fd45eb894243..b43960794922d 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -175,8 +175,13 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 	if (r)
 		goto out;
 
-	real_fops = fops_get(real_fops);
-	if (!real_fops) {
+	if (!fops_get(real_fops)) {
+#ifdef MODULE
+		if (real_fops->owner &&
+		    real_fops->owner->state == MODULE_STATE_GOING)
+			goto out;
+#endif
+
 		/* Huh? Module did not clean up after itself at exit? */
 		WARN(1, "debugfs file owner did not clean up at exit: %pd",
 			dentry);
@@ -305,8 +310,13 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	if (r)
 		goto out;
 
-	real_fops = fops_get(real_fops);
-	if (!real_fops) {
+	if (!fops_get(real_fops)) {
+#ifdef MODULE
+		if (real_fops->owner &&
+		    real_fops->owner->state == MODULE_STATE_GOING)
+			goto out;
+#endif
+
 		/* Huh? Module did not cleanup after itself at exit? */
 		WARN(1, "debugfs file owner did not clean up at exit: %pd",
 			dentry);
-- 
2.20.1



