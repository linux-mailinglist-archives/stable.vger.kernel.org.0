Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80438E62B7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJ0NqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:46:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60509 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbfJ0NqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:46:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A2C421BA9;
        Sun, 27 Oct 2019 09:46:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CVl9aN
        rgBhixYPpeE7yCGyT+Xry1clWISwJ1dXTyo8s=; b=W+wEdNjOt1bSYdDwye1tJV
        bhw6T2KAPWljAdiP/N9+Vs5C2FJvyu/RZVnyvm/FY1XiGSP/tcQmRhOjdtxSoQBs
        76oCQE3uftI6VlFPIbD+CA/NrGAiGoogHc29FKFMNg2sCjwAgbscXCoHqXR7qSLB
        xL0FrvlKDzzH6K5njWdugK60n4zGGOcvbfl1ciDkRKCQQxd7pvVIrXLHuSu+adQL
        3vZ2LKVwNGYR04fJFgONBVwam4oV1bOksO/DNjgAWC8IHSmGQzT+jceeewLC/BTQ
        J4wkZutPO75d6JOf9+yfmYXscQXu7+CWEvHe5BySPXFBnj3SXceJ5Ik/n6MZRm/A
        ==
X-ME-Sender: <xms:oJ-1XQUyGxREHXcQNKdLm8x00WNofUvuvIRMBr_mUiSiwiVI8c2Y5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejjedrvdeguddrvddvle
    drvdefvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:oJ-1XY2_RRLTxleo2KGaDgmcuxiWW06966lLcQV1VehmpiL4onBJKw>
    <xmx:oJ-1XfYpcg96WY9XnXUe-E2hSiaDLoDGFlxYEyueCT-Lm8pSjO31vA>
    <xmx:oJ-1XTrrFTccoVDZ6dk9z-vLP3vx0YXTV3yPA4SNTqpj9mLWTH8mrw>
    <xmx:oZ-1XQtuDpV4sn5njppPCDhbF9y3aJY_H44IIok3yXWTpznsA1pL4Q>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A8138005B;
        Sun, 27 Oct 2019 09:46:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] zram: fix race between backing_dev_show and backing_dev_store" failed to apply to 4.14-stable tree
To:     chenwandun@huawei.com, akpm@linux-foundation.org, axboe@kernel.dk,
        minchan@kernel.org, sergey.senozhatsky.work@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:46:06 +0100
Message-ID: <15721839663649@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7daefe4231e57381d92c2e2ad905a899c28e402 Mon Sep 17 00:00:00 2001
From: Chenwandun <chenwandun@huawei.com>
Date: Fri, 18 Oct 2019 20:20:14 -0700
Subject: [PATCH] zram: fix race between backing_dev_show and backing_dev_store

CPU0:				       CPU1:
backing_dev_show		       backing_dev_store
    ......				   ......
    file = zram->backing_dev;
    down_read(&zram->init_lock);	   down_read(&zram->init_init_lock)
    file_path(file, ...);		   zram->backing_dev = backing_dev;
    up_read(&zram->init_lock);		   up_read(&zram->init_lock);

gets the value of zram->backing_dev too early in backing_dev_show, which
resultin the value being NULL at the beginning, and not NULL later.

backtrace:
  d_path+0xcc/0x174
  file_path+0x10/0x18
  backing_dev_show+0x40/0xb4
  dev_attr_show+0x20/0x54
  sysfs_kf_seq_show+0x9c/0x10c
  kernfs_seq_show+0x28/0x30
  seq_read+0x184/0x488
  kernfs_fop_read+0x5c/0x1a4
  __vfs_read+0x44/0x128
  vfs_read+0xa0/0x138
  SyS_read+0x54/0xb4

Link: http://lkml.kernel.org/r/1571046839-16814-1-git-send-email-chenwandun@huawei.com
Signed-off-by: Chenwandun <chenwandun@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d58a359a6622..4285e75e52c3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -413,13 +413,14 @@ static void reset_bdev(struct zram *zram)
 static ssize_t backing_dev_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct file *file;
 	struct zram *zram = dev_to_zram(dev);
-	struct file *file = zram->backing_dev;
 	char *p;
 	ssize_t ret;
 
 	down_read(&zram->init_lock);
-	if (!zram->backing_dev) {
+	file = zram->backing_dev;
+	if (!file) {
 		memcpy(buf, "none\n", 5);
 		up_read(&zram->init_lock);
 		return 5;

