Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5807D3287B4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhCAR2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236769AbhCARSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F5864F8F;
        Mon,  1 Mar 2021 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617228;
        bh=gRIT0VF9fiR/03qrO6Qr37uVPBAtkSGVbL9WsCTeM3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+vBbocXZMUopPl7NmY8Keh8v1EVySB9MDA9y4JlgfONHq/qeNktFuSae5ajqNL3d
         0wf45OaEistfq7Ei2aK6rf1IFxNOdHZB27DPTngOECOUeJHvS4lpnQOjz6GyfKPxXH
         m22zsL/OATyQEdDAiOEo5Qha/Ejp5k8yFI/JOOQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com,
        Takeshi Misawa <jeliantsurux@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 247/247] net: qrtr: Fix memory leak in qrtr_tun_open
Date:   Mon,  1 Mar 2021 17:14:27 +0100
Message-Id: <20210301161043.797217519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>

commit fc0494ead6398609c49afa37bc949b61c5c16b91 upstream.

If qrtr_endpoint_register() failed, tun is leaked.
Fix this, by freeing tun in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff88811848d680 (size 64):
  comm "syz-executor684", pid 10171, jiffies 4294951561 (age 26.070s)
  hex dump (first 32 bytes):
    80 dd 0a 84 ff ff ff ff 00 00 00 00 00 00 00 00  ................
    90 d6 48 18 81 88 ff ff 90 d6 48 18 81 88 ff ff  ..H.......H.....
  backtrace:
    [<0000000018992a50>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000018992a50>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000018992a50>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<0000000003a453ef>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000dec38ac8>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<0000000079094996>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<000000004096d290>] do_open fs/namei.c:3252 [inline]
    [<000000004096d290>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8e64241>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<00000000a3299422>] do_sys_openat2+0xed/0x230 fs/open.c:1172
    [<000000002c1bdcef>] do_sys_open fs/open.c:1188 [inline]
    [<000000002c1bdcef>] __do_sys_openat fs/open.c:1204 [inline]
    [<000000002c1bdcef>] __se_sys_openat fs/open.c:1199 [inline]
    [<000000002c1bdcef>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1199
    [<00000000f3a5728f>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000004b38b7ec>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Reported-by: syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Link: https://lore.kernel.org/r/20210221234427.GA2140@DESKTOP
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/tun.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -31,6 +31,7 @@ static int qrtr_tun_send(struct qrtr_end
 static int qrtr_tun_open(struct inode *inode, struct file *filp)
 {
 	struct qrtr_tun *tun;
+	int ret;
 
 	tun = kzalloc(sizeof(*tun), GFP_KERNEL);
 	if (!tun)
@@ -43,7 +44,16 @@ static int qrtr_tun_open(struct inode *i
 
 	filp->private_data = tun;
 
-	return qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	ret = qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	filp->private_data = NULL;
+	kfree(tun);
+	return ret;
 }
 
 static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)


