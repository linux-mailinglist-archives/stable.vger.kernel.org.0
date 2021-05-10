Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33FF378199
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhEJK14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhEJK1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BFF261494;
        Mon, 10 May 2021 10:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642358;
        bh=I/n9PoSx55KDiaivv3SZ/kwDuKmVfhtXa6dPR98VnEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwCRz3cCkV1+X7GyU7khaINR+0YbPEHrYKtfyg+l/LXQLJInEWryeNGYiNQ1hOtCv
         9NNAiNzKvgzGFE3d3eMWTxv2A1obV0f6WzYTqiPziH1SyxHAWu4idnmiypByTPiNbu
         vmF1ilSGxmdfr/nZR/4nf8RMDTewyv3DoEofYi14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Sasha Levin <sashal@kernel.org>, Hao Sun <sunhao.th@gmail.com>
Subject: [PATCH 5.4 063/184] tty: n_gsm: check error while registering tty devices
Date:   Mon, 10 May 2021 12:19:17 +0200
Message-Id: <20210510101952.271030474@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 0a360e8b65d62fe1a994f0a8da4f8d20877b2100 ]

Add the error path for registering tty devices and roll back in case of error
in bid to avoid the UAF like the below one reported.

Plus syzbot reported general protection fault in cdev_del() on Sep 24, 2020
and both cases are down to the kobject_put() in tty_cdev_add().

 ------------[ cut here ]------------
 refcount_t: underflow; use-after-free.
 WARNING: CPU: 1 PID: 8923 at lib/refcount.c:28
 refcount_warn_saturate+0x1cf/0x210 -origin/lib/refcount.c:28
 Modules linked in:
 CPU: 1 PID: 8923 Comm: executor Not tainted 5.12.0-rc5+ #8
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
 1.13.0-1ubuntu1.1 04/01/2014
 RIP: 0010:refcount_warn_saturate+0x1cf/0x210 -origin/lib/refcount.c:28
 Code: 4f ff ff ff e8 32 fa b5 fe 48 c7 c7 3d f8 f6 86 e8 d6 ab c6 fe
 c6 05 7c 34 67 04 01 48 c7 c7 68 f8 6d 86 31 c0 e8 81 2e 9d fe <0f> 0b
 e9 22 ff ff ff e8 05 fa b5 fe 48 c7 c7 3e f8 f6 86 e8 a9 ab
 RSP: 0018:ffffc90001633c60 EFLAGS: 00010246
 RAX: 15d08b2e34b77800 RBX: 0000000000000003 RCX: ffff88804c056c80
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000003 R08: ffffffff813767aa R09: 0001ffffffffffff
 R10: 0001ffffffffffff R11: ffff88804c056c80 R12: ffff888040b7d000
 R13: ffff88804c206938 R14: ffff88804c206900 R15: ffff888041b18488
 FS:  00000000022c9940(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f9f9b122008 CR3: 0000000044b4b000 CR4: 0000000000750ee0
 PKRU: 55555554
 Call Trace:
  __refcount_sub_and_test -origin/./include/linux/refcount.h:283 [inline]
  __refcount_dec_and_test -origin/./include/linux/refcount.h:315 [inline]
  refcount_dec_and_test -origin/./include/linux/refcount.h:333 [inline]
  kref_put -origin/./include/linux/kref.h:64 [inline]
  kobject_put+0x17b/0x180 -origin/lib/kobject.c:753
  cdev_del+0x4b/0x50 -origin/fs/char_dev.c:597
  tty_unregister_device+0x99/0xd0 -origin/drivers/tty/tty_io.c:3343
  gsmld_detach_gsm -origin/drivers/tty/n_gsm.c:2409 [inline]
  gsmld_close+0x6c/0x140 -origin/drivers/tty/n_gsm.c:2478
  tty_ldisc_close -origin/drivers/tty/tty_ldisc.c:488 [inline]
  tty_ldisc_kill -origin/drivers/tty/tty_ldisc.c:636 [inline]
  tty_ldisc_release+0x1b6/0x400 -origin/drivers/tty/tty_ldisc.c:809
  tty_release_struct+0x19/0xb0 -origin/drivers/tty/tty_io.c:1714
  tty_release+0x9ad/0xa00 -origin/drivers/tty/tty_io.c:1885
  __fput+0x260/0x4e0 -origin/fs/file_table.c:280
  ____fput+0x11/0x20 -origin/fs/file_table.c:313
  task_work_run+0x8e/0x110 -origin/kernel/task_work.c:140
  tracehook_notify_resume -origin/./include/linux/tracehook.h:189 [inline]
  exit_to_user_mode_loop -origin/kernel/entry/common.c:174 [inline]
  exit_to_user_mode_prepare+0x16b/0x1a0 -origin/kernel/entry/common.c:208
  __syscall_exit_to_user_mode_work -origin/kernel/entry/common.c:290 [inline]
  syscall_exit_to_user_mode+0x20/0x40 -origin/kernel/entry/common.c:301
  do_syscall_64+0x45/0x80 -origin/arch/x86/entry/common.c:56
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
Reported-and-tested-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Link: https://lore.kernel.org/r/20210412035758.1974-1-hdanton@sina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 75408b9f232d..38eb49ba361f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2377,8 +2377,18 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 		/* Don't register device 0 - this is the control channel and not
 		   a usable tty interface */
 		base = mux_num_to_base(gsm); /* Base for this MUX */
-		for (i = 1; i < NUM_DLCI; i++)
-			tty_register_device(gsm_tty_driver, base + i, NULL);
+		for (i = 1; i < NUM_DLCI; i++) {
+			struct device *dev;
+
+			dev = tty_register_device(gsm_tty_driver,
+							base + i, NULL);
+			if (IS_ERR(dev)) {
+				for (i--; i >= 1; i--)
+					tty_unregister_device(gsm_tty_driver,
+								base + i);
+				return PTR_ERR(dev);
+			}
+		}
 	}
 	return ret;
 }
-- 
2.30.2



