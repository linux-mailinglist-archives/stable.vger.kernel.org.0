Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174D12E1E2F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgLWPeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgLWPef (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66DAE23371;
        Wed, 23 Dec 2020 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737649;
        bh=PYQsgOD9N/AodpfwR8UQ6zdkT19rv7GcP8maEXE6IDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaIvyzGd7fe/SEt9g7NZ960yjJkVzF0qHaZqTlgaaKIcnJBY3nm0R5lsBf7eo+UaP
         HXkqiFbwymtL3r8PfbVd7LPmsCkjz8/FQhr0DcYzmu8Nkd3N5m6TNzfRk4NyXG6IGg
         ieTL94466ggw/w5Jodqi6F9nOnY/KrZQC+EDsT+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1e46a0864c1a6e9bd3d8@syzkaller.appspotmail.com,
        "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.10 40/40] md: fix a warning caused by a race between concurrent md_ioctl()s
Date:   Wed, 23 Dec 2020 16:33:41 +0100
Message-Id: <20201223150517.462984079@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dae R. Jeong <dae.r.jeong@kaist.ac.kr>

commit c731b84b51bf7fe83448bea8f56a6d55006b0615 upstream.

Syzkaller reports a warning as belows.
WARNING: CPU: 0 PID: 9647 at drivers/md/md.c:7169
...
Call Trace:
...
RIP: 0010:md_ioctl+0x4017/0x5980 drivers/md/md.c:7169
RSP: 0018:ffff888096027950 EFLAGS: 00010293
RAX: ffff88809322c380 RBX: 0000000000000932 RCX: ffffffff84e266f2
RDX: 0000000000000000 RSI: ffffffff84e299f7 RDI: 0000000000000007
RBP: ffff888096027bc0 R08: ffff88809322c380 R09: ffffed101341a482
R10: ffff888096027940 R11: ffff88809a0d240f R12: 0000000000000932
R13: ffff8880a2c14100 R14: ffff88809a0d2268 R15: ffff88809a0d2408
 __blkdev_driver_ioctl block/ioctl.c:304 [inline]
 blkdev_ioctl+0xece/0x1c10 block/ioctl.c:606
 block_ioctl+0xee/0x130 fs/block_dev.c:1930
 vfs_ioctl fs/ioctl.c:46 [inline]
 file_ioctl fs/ioctl.c:509 [inline]
 do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
 ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
 __do_sys_ioctl fs/ioctl.c:720 [inline]
 __se_sys_ioctl fs/ioctl.c:718 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

This is caused by a race between two concurrenct md_ioctl()s closing
the array.
CPU1 (md_ioctl())                   CPU2 (md_ioctl())
------                              ------
set_bit(MD_CLOSING, &mddev->flags);
did_set_md_closing = true;
                                    WARN_ON_ONCE(test_bit(MD_CLOSING,
                                            &mddev->flags));
if(did_set_md_closing)
    clear_bit(MD_CLOSING, &mddev->flags);

Fix the warning by returning immediately if the MD_CLOSING bit is set
in &mddev->flags which indicates that the array is being closed.

Fixes: 065e519e71b2 ("md: MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop")
Reported-by: syzbot+1e46a0864c1a6e9bd3d8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dae R. Jeong <dae.r.jeong@kaist.ac.kr>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7590,8 +7590,11 @@ static int md_ioctl(struct block_device
 			err = -EBUSY;
 			goto out;
 		}
-		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
-		set_bit(MD_CLOSING, &mddev->flags);
+		if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
+			mutex_unlock(&mddev->open_mutex);
+			err = -EBUSY;
+			goto out;
+		}
 		did_set_md_closing = true;
 		mutex_unlock(&mddev->open_mutex);
 		sync_blockdev(bdev);


