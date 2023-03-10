Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691C46B4655
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjCJOmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjCJOmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8658F11F602
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16DE161771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27875C4339C;
        Fri, 10 Mar 2023 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459317;
        bh=mtZnfkdqdEPiBLFF+nKBCY4sT+cXmgwgPsYRwPTaUa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbCujCisxBFoCTVg8zxrdNl16tRkce/cmy/rzt96eQimlUH/IXKXy55VUK8oCKUcZ
         WdsU2tNnA3esvD6qtNaqy+J04gyfisWMj0guq9U7C7+6Y840hysdi6TAlfsn6oqKCj
         W05UZ+hJYr2M0g2a69RiMKUdLokyMPn3x1/iw9p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        George Kennedy <george.kennedy@oracle.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 291/357] ubi: ensure that VID header offset + VID header size <= alloc, size
Date:   Fri, 10 Mar 2023 14:39:40 +0100
Message-Id: <20230310133747.601457493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 1b42b1a36fc946f0d7088425b90d491b4257ca3e ]

Ensure that the VID header offset + VID header size does not exceed
the allocated area to avoid slab OOB.

BUG: KASAN: slab-out-of-bounds in crc32_body lib/crc32.c:111 [inline]
BUG: KASAN: slab-out-of-bounds in crc32_le_generic lib/crc32.c:179 [inline]
BUG: KASAN: slab-out-of-bounds in crc32_le_base+0x58c/0x626 lib/crc32.c:197
Read of size 4 at addr ffff88802bb36f00 by task syz-executor136/1555

CPU: 2 PID: 1555 Comm: syz-executor136 Tainted: G        W
6.0.0-1868 #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29
04/01/2014
Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x85/0xad lib/dump_stack.c:106
  print_address_description mm/kasan/report.c:317 [inline]
  print_report.cold.13+0xb6/0x6bb mm/kasan/report.c:433
  kasan_report+0xa7/0x11b mm/kasan/report.c:495
  crc32_body lib/crc32.c:111 [inline]
  crc32_le_generic lib/crc32.c:179 [inline]
  crc32_le_base+0x58c/0x626 lib/crc32.c:197
  ubi_io_write_vid_hdr+0x1b7/0x472 drivers/mtd/ubi/io.c:1067
  create_vtbl+0x4d5/0x9c4 drivers/mtd/ubi/vtbl.c:317
  create_empty_lvol drivers/mtd/ubi/vtbl.c:500 [inline]
  ubi_read_volume_table+0x67b/0x288a drivers/mtd/ubi/vtbl.c:812
  ubi_attach+0xf34/0x1603 drivers/mtd/ubi/attach.c:1601
  ubi_attach_mtd_dev+0x6f3/0x185e drivers/mtd/ubi/build.c:965
  ctrl_cdev_ioctl+0x2db/0x347 drivers/mtd/ubi/cdev.c:1043
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:870 [inline]
  __se_sys_ioctl fs/ioctl.c:856 [inline]
  __x64_sys_ioctl+0x193/0x213 fs/ioctl.c:856
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3e/0x86 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0x0
RIP: 0033:0x7f96d5cf753d
Code:
RSP: 002b:00007fffd72206f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f96d5cf753d
RDX: 0000000020000080 RSI: 0000000040186f40 RDI: 0000000000000003
RBP: 0000000000400cd0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000400be0
R13: 00007fffd72207e0 R14: 0000000000000000 R15: 0000000000000000
  </TASK>

Allocated by task 1555:
  kasan_save_stack+0x20/0x3d mm/kasan/common.c:38
  kasan_set_track mm/kasan/common.c:45 [inline]
  set_alloc_info mm/kasan/common.c:437 [inline]
  ____kasan_kmalloc mm/kasan/common.c:516 [inline]
  __kasan_kmalloc+0x88/0xa3 mm/kasan/common.c:525
  kasan_kmalloc include/linux/kasan.h:234 [inline]
  __kmalloc+0x138/0x257 mm/slub.c:4429
  kmalloc include/linux/slab.h:605 [inline]
  ubi_alloc_vid_buf drivers/mtd/ubi/ubi.h:1093 [inline]
  create_vtbl+0xcc/0x9c4 drivers/mtd/ubi/vtbl.c:295
  create_empty_lvol drivers/mtd/ubi/vtbl.c:500 [inline]
  ubi_read_volume_table+0x67b/0x288a drivers/mtd/ubi/vtbl.c:812
  ubi_attach+0xf34/0x1603 drivers/mtd/ubi/attach.c:1601
  ubi_attach_mtd_dev+0x6f3/0x185e drivers/mtd/ubi/build.c:965
  ctrl_cdev_ioctl+0x2db/0x347 drivers/mtd/ubi/cdev.c:1043
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:870 [inline]
  __se_sys_ioctl fs/ioctl.c:856 [inline]
  __x64_sys_ioctl+0x193/0x213 fs/ioctl.c:856
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3e/0x86 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0x0

The buggy address belongs to the object at ffff88802bb36e00
  which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes to the right of
  256-byte region [ffff88802bb36e00, ffff88802bb36f00)

The buggy address belongs to the physical page:
page:00000000ea4d1263 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x2bb36
head:00000000ea4d1263 order:1 compound_mapcount:0 compound_pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0010200 ffffea000066c300 dead000000000003 ffff888100042b40
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88802bb36e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88802bb36e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88802bb36f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                    ^
  ffff88802bb36f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88802bb37000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index df521ff0b3280..6fd6c3e01f72f 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -643,6 +643,12 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
+	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
+	    ubi->vid_hdr_alsize)) {
+		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
+		return -EINVAL;
+	}
+
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
-- 
2.39.2



