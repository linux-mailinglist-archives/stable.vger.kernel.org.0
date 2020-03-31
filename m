Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5651990D8
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgCaJOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731864AbgCaJOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3487121473;
        Tue, 31 Mar 2020 09:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646094;
        bh=thWdoLTQq2MkWCR3icR/UgA6IqKkV55aau8BBzxPWb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo2xo9YAV5QqMyQC/LKsfna6o1ob9gYQQY0u1EJRWX9lP0qKJs96Ebh8BI8YmhPU4
         oUnLZseVDuvsb5WOzB6jQXAuJdclSUKBVkUmp29tvt/HrJbHUqIsIKh7ZU85GWe/KG
         fmmKbplHht1hbnP1RzQ4w6l872A6m0DCnob4X1MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+ab4dae63f7d310641ded@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 082/155] RDMA/core: Fix missing error check on dev_set_name()
Date:   Tue, 31 Mar 2020 10:58:42 +0200
Message-Id: <20200331085427.499207575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit f2f2b3bbf0d9f8d090b9a019679223b2bd1c66c4 upstream.

If name memory allocation fails the name will be left empty and
device_add_one() will crash:

  kobject: (0000000004952746): attempted to be registered with empty name!
  WARNING: CPU: 0 PID: 329 at lib/kobject.c:234 kobject_add_internal+0x7ac/0x9a0 lib/kobject.c:234
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 0 PID: 329 Comm: syz-executor.5 Not tainted 5.6.0-rc2-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x197/0x210 lib/dump_stack.c:118
   panic+0x2e3/0x75c kernel/panic.c:221
   __warn.cold+0x2f/0x3e kernel/panic.c:582
   report_bug+0x289/0x300 lib/bug.c:195
   fixup_bug arch/x86/kernel/traps.c:174 [inline]
   fixup_bug arch/x86/kernel/traps.c:169 [inline]
   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
  RIP: 0010:kobject_add_internal+0x7ac/0x9a0 lib/kobject.c:234
  Code: 1a 98 ca f9 e9 f0 f8 ff ff 4c 89 f7 e8 6d 98 ca f9 e9 95 f9 ff ff e8 c3 f0 8b f9 4c 89 e6 48 c7 c7 a0 0e 1a 89 e8 e3 41 5c f9 <0f> 0b 41 bd ea ff ff ff e9 52 ff ff ff e8 a2 f0 8b f9 0f 0b e8 9b
  RSP: 0018:ffffc90005b27908 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  RDX: 0000000000040000 RSI: ffffffff815eae46 RDI: fffff52000b64f13
  RBP: ffffc90005b27960 R08: ffff88805aeba480 R09: ffffed1015d06659
  R10: ffffed1015d06658 R11: ffff8880ae8332c7 R12: ffff8880a37fd000
  R13: 0000000000000000 R14: ffff888096691780 R15: 0000000000000001
   kobject_add_varg lib/kobject.c:390 [inline]
   kobject_add+0x150/0x1c0 lib/kobject.c:442
   device_add+0x3be/0x1d00 drivers/base/core.c:2412
   add_one_compat_dev drivers/infiniband/core/device.c:901 [inline]
   add_one_compat_dev+0x46a/0x7e0 drivers/infiniband/core/device.c:857
   rdma_dev_init_net+0x2eb/0x490 drivers/infiniband/core/device.c:1120
   ops_init+0xb3/0x420 net/core/net_namespace.c:137
   setup_net+0x2d5/0x8b0 net/core/net_namespace.c:327
   copy_net_ns+0x29e/0x5a0 net/core/net_namespace.c:468
   create_new_namespaces+0x403/0xb50 kernel/nsproxy.c:108
   unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:229
   ksys_unshare+0x444/0x980 kernel/fork.c:2955
   __do_sys_unshare kernel/fork.c:3023 [inline]
   __se_sys_unshare kernel/fork.c:3021 [inline]
   __x64_sys_unshare+0x31/0x40 kernel/fork.c:3021
   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Link: https://lore.kernel.org/r/20200309193200.GA10633@ziepe.ca
Cc: stable@kernel.org
Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in net namespace")
Reported-by: syzbot+ab4dae63f7d310641ded@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -899,7 +899,9 @@ static int add_one_compat_dev(struct ib_
 	cdev->dev.parent = device->dev.parent;
 	rdma_init_coredev(cdev, device, read_pnet(&rnet->net));
 	cdev->dev.release = compatdev_release;
-	dev_set_name(&cdev->dev, "%s", dev_name(&device->dev));
+	ret = dev_set_name(&cdev->dev, "%s", dev_name(&device->dev));
+	if (ret)
+		goto add_err;
 
 	ret = device_add(&cdev->dev);
 	if (ret)


