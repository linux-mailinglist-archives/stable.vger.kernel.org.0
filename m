Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB169CCFE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjBTNpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjBTNpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:45:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C234A1D912
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6076B60EAC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704D2C4339B;
        Mon, 20 Feb 2023 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900691;
        bh=RgHim53wj18PyS3NDRuVTKDtBuASTc6OCoPMCjLxUJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvDSIawoIzqx2XwXZ7plZiGqZeF13mKcokDQdNkYWuhfX7auN/K9tueq6/WAkGfuU
         uJ/LnUEJSnDn9aTJKIRJJwr5H1dw1CNGDR9Mx3EIooVICX8c5z1ku9m2vc0kRI3qiL
         MU5ttp+po3vo6/1o8yMltzIPSe+CTUtbTl5coMXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        George Kennedy <george.kennedy@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/156] vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF
Date:   Mon, 20 Feb 2023 14:34:35 +0100
Message-Id: <20230220133603.715598489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 226fae124b2dac217ea5436060d623ff3385bc34 ]

After a call to console_unlock() in vcs_read() the vc_data struct can be
freed by vc_deallocate(). Because of that, the struct vc_data pointer
load must be done at the top of while loop in vcs_read() to avoid a UAF
when vcs_size() is called.

Syzkaller reported a UAF in vcs_size().

BUG: KASAN: use-after-free in vcs_size (drivers/tty/vt/vc_screen.c:215)
Read of size 4 at addr ffff8881137479a8 by task 4a005ed81e27e65/1537

CPU: 0 PID: 1537 Comm: 4a005ed81e27e65 Not tainted 6.2.0-rc5 #1
Hardware name: Red Hat KVM, BIOS 1.15.0-2.module
Call Trace:
  <TASK>
__asan_report_load4_noabort (mm/kasan/report_generic.c:350)
vcs_size (drivers/tty/vt/vc_screen.c:215)
vcs_read (drivers/tty/vt/vc_screen.c:415)
vfs_read (fs/read_write.c:468 fs/read_write.c:450)
...
  </TASK>

Allocated by task 1191:
...
kmalloc_trace (mm/slab_common.c:1069)
vc_allocate (./include/linux/slab.h:580 ./include/linux/slab.h:720
     drivers/tty/vt/vt.c:1128 drivers/tty/vt/vt.c:1108)
con_install (drivers/tty/vt/vt.c:3383)
tty_init_dev (drivers/tty/tty_io.c:1301 drivers/tty/tty_io.c:1413
     drivers/tty/tty_io.c:1390)
tty_open (drivers/tty/tty_io.c:2080 drivers/tty/tty_io.c:2126)
chrdev_open (fs/char_dev.c:415)
do_dentry_open (fs/open.c:883)
vfs_open (fs/open.c:1014)
...

Freed by task 1548:
...
kfree (mm/slab_common.c:1021)
vc_port_destruct (drivers/tty/vt/vt.c:1094)
tty_port_destructor (drivers/tty/tty_port.c:296)
tty_port_put (drivers/tty/tty_port.c:312)
vt_disallocate_all (drivers/tty/vt/vt_ioctl.c:662 (discriminator 2))
vt_ioctl (drivers/tty/vt/vt_ioctl.c:903)
tty_ioctl (drivers/tty/tty_io.c:2776)
...

The buggy address belongs to the object at ffff888113747800
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 424 bytes inside of
  1024-byte region [ffff888113747800, ffff888113747c00)

The buggy address belongs to the physical page:
page:00000000b3fe6c7c refcount:1 mapcount:0 mapping:0000000000000000
     index:0x0 pfn:0x113740
head:00000000b3fe6c7c order:3 compound_mapcount:0 subpages_mapcount:0
     compound_pincount:0
anon flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
raw: 0017ffffc0010200 ffff888100042dc0 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888113747880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888113747900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888113747980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                   ^
  ffff888113747a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888113747a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Disabling lock debugging due to kernel taint

Fixes: ac751efa6a0d ("console: rename acquire/release_console_sem() to console_lock/unlock()")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Link: https://lore.kernel.org/r/1674577014-12374-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 778f83ea2249..e61fd04a0d8d 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -265,10 +265,6 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	uni_mode = use_unicode(inode);
 	attr = use_attributes(inode);
-	ret = -ENXIO;
-	vc = vcs_vc(inode, &viewed);
-	if (!vc)
-		goto unlock_out;
 
 	ret = -EINVAL;
 	if (pos < 0)
@@ -288,6 +284,11 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		ssize_t orig_count;
 		long p = pos;
 
+		ret = -ENXIO;
+		vc = vcs_vc(inode, &viewed);
+		if (!vc)
+			goto unlock_out;
+
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop
 		 * could sleep.
-- 
2.39.0



