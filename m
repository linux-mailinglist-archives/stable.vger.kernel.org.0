Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7FA3C6D6A
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhGMJcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10475 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbhGMJcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPFd60VZ2zccyp;
        Tue, 13 Jul 2021 17:26:34 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:50 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:49 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Mauricio Faria de Oliveira" <mfo@canonical.com>,
        Eric Desrochers <eric.desrochers@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 1/7] loop: fix I/O error on fsync() in detached loop devices
Date:   Tue, 13 Jul 2021 17:18:31 +0800
Message-ID: <1626167917-11972-2-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
References: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Faria de Oliveira <mfo@canonical.com>

commit 4ceddce55eb35d15b0f87f5dcf6f0058fd15d3a4 upstream.

There's an I/O error on fsync() in a detached loop device
if it has been previously attached.

The issue is write cache is enabled in the attach path in
loop_configure() but it isn't disabled in the detach path;
thus it remains enabled in the block device regardless of
whether it is attached or not.

Now fsync() can get an I/O request that will just be failed
later in loop_queue_rq() as device's state is not 'Lo_bound'.

So, disable write cache in the detach path.

Do so based on the queue flag, not the loop device flag for
read-only (used to enable) as the queue flag can be changed
via sysfs even on read-only loop devices (e.g., losetup -r.)

Test-case:

    # DEV=/dev/loop7

    # IMG=/tmp/image
    # truncate --size 1M $IMG

    # losetup $DEV $IMG
    # losetup -d $DEV

Before:

    # strace -e fsync parted -s $DEV print 2>&1 | grep fsync
    fsync(3)                                = -1 EIO (Input/output error)
    Warning: Error fsyncing/closing /dev/loop7: Input/output error
    [  982.529929] blk_update_request: I/O error, dev loop7, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0

After:

    # strace -e fsync parted -s $DEV print 2>&1 | grep fsync
    fsync(3)                                = 0

Co-developed-by: Eric Desrochers <eric.desrochers@canonical.com>
Signed-off-by: Eric Desrochers <eric.desrochers@canonical.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Tested-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 06d44ae..f0fa0c8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1224,6 +1224,9 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 		goto out_unlock;
 	}
 
+	if (test_bit(QUEUE_FLAG_WC, &lo->lo_queue->queue_flags))
+		blk_queue_write_cache(lo->lo_queue, false, false);
+
 	/* freeze request queue during the transition */
 	blk_mq_freeze_queue(lo->lo_queue);
 
-- 
1.7.12.4

