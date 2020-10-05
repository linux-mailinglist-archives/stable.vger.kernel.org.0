Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5728398F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgJEP1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgJEP1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:27:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D10D20874;
        Mon,  5 Oct 2020 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911628;
        bh=TVjdzA8A4qh+hbFHWkyB9LfVKMPoF7AJk4WcfA3JS7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZ3ZeTNsEjrzPV6zY2gM7O02K13fi6E0bXklwlDTEdQHnzLKw0f0tlMr7YuiiSQ3P
         fpe6g3I51EsXMGYNcB8YpN9YV2QygitsYujqDWmvPcuoJ46AFkdBjdTp18FIwEbLnf
         o7t19yQcvF8ap3SlMNLwZEgCJ0GdxqKBT4RYIi5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/38] nvme-core: get/put ctrl and transport module in nvme_dev_open/release()
Date:   Mon,  5 Oct 2020 17:26:34 +0200
Message-Id: <20201005142109.502047700@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 52a3974feb1a3eec25d8836d37a508b67b0a9cd0 ]

Get and put the reference to the ctrl in the nvme_dev_open() and
nvme_dev_release() before and after module get/put for ctrl in char
device file operations.

Introduce char_dev relase function, get/put the controller and module
which allows us to fix the potential Oops which can be easily reproduced
with a passthru ctrl (although the problem also exists with pure user
access):

Entering kdb (current=0xffff8887f8290000, pid 3128) on processor 30 Oops: (null)
due to oops @ 0xffffffffa01019ad
CPU: 30 PID: 3128 Comm: bash Tainted: G        W  OE     5.8.0-rc4nvme-5.9+ #35
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.4
RIP: 0010:nvme_free_ctrl+0x234/0x285 [nvme_core]
Code: 57 10 a0 e8 73 bf 02 e1 ba 3d 11 00 00 48 c7 c6 98 33 10 a0 48 c7 c7 1d 57 10 a0 e8 5b bf 02 e1 8
RSP: 0018:ffffc90001d63de0 EFLAGS: 00010246
RAX: ffffffffa05c0440 RBX: ffff8888119e45a0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8888177e9550 RDI: ffff8888119e43b0
RBP: ffff8887d4768000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffc90001d63c90 R12: ffff8888119e43b0
R13: ffff8888119e5108 R14: dead000000000100 R15: ffff8888119e5108
FS:  00007f1ef27b0740(0000) GS:ffff888817600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa05c0470 CR3: 00000007f6bee000 CR4: 00000000003406e0
Call Trace:
 device_release+0x27/0x80
 kobject_put+0x98/0x170
 nvmet_passthru_ctrl_disable+0x4a/0x70 [nvmet]
 nvmet_passthru_enable_store+0x4c/0x90 [nvmet]
 configfs_write_file+0xe6/0x150
 vfs_write+0xba/0x1e0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x52/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f1ef1eb2840
Code: Bad RIP value.
RSP: 002b:00007fffdbff0eb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f1ef1eb2840
RDX: 0000000000000002 RSI: 00007f1ef27d2000 RDI: 0000000000000001
RBP: 00007f1ef27d2000 R08: 000000000000000a R09: 00007f1ef27b0740
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f1ef2186400
R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000

With this patch fix we take the module ref count in nvme_dev_open() and
release that ref count in newly introduced nvme_dev_release().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 33dad9774da01..9ea3d8e611005 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2605,10 +2605,24 @@ static int nvme_dev_open(struct inode *inode, struct file *file)
 		return -EWOULDBLOCK;
 	}
 
+	nvme_get_ctrl(ctrl);
+	if (!try_module_get(ctrl->ops->module))
+		return -EINVAL;
+
 	file->private_data = ctrl;
 	return 0;
 }
 
+static int nvme_dev_release(struct inode *inode, struct file *file)
+{
+	struct nvme_ctrl *ctrl =
+		container_of(inode->i_cdev, struct nvme_ctrl, cdev);
+
+	module_put(ctrl->ops->module);
+	nvme_put_ctrl(ctrl);
+	return 0;
+}
+
 static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 {
 	struct nvme_ns *ns;
@@ -2669,6 +2683,7 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 static const struct file_operations nvme_dev_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_dev_open,
+	.release	= nvme_dev_release,
 	.unlocked_ioctl	= nvme_dev_ioctl,
 	.compat_ioctl	= nvme_dev_ioctl,
 };
-- 
2.25.1



