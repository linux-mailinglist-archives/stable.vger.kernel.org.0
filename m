Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6320DCA3
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbgF2URG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgF2TaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9926E252FA;
        Mon, 29 Jun 2020 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445126;
        bh=8euyUPe8CX/B7NiyUwLEEjwKHYVM6pZzMIrEAdXaoQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT71gaH6wmkU3VSwdaGKSoL8mwFO6d+m+XACB9Up7HRCtXREXoWJYikqvLmY3s16/
         TRfVLriEJrOEiupEsyuej/22YQCM0iWk/QpwxUrzdd/eg8oQ27sErzMtv5mCLmSiLP
         rOku/eYEn+9GId8vziUipUreFp1k4k9fZ1vMOF/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 33/78] loop: replace kill_bdev with invalidate_bdev
Date:   Mon, 29 Jun 2020 11:37:21 -0400
Message-Id: <20200629153806.2494953-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

commit f4bd34b139a3fa2808c4205f12714c65e1548c6c upstream.

When a filesystem is mounted on a loop device and on a loop ioctl
LOOP_SET_STATUS64, because of kill_bdev, buffer_head mappings are getting
destroyed.
kill_bdev
  truncate_inode_pages
    truncate_inode_pages_range
      do_invalidatepage
        block_invalidatepage
          discard_buffer  -->clear BH_Mapped flag

sb_bread
  __bread_gfp
  bh = __getblk_gfp
  -->discard_buffer clear BH_Mapped flag
  __bread_slow
    submit_bh
      submit_bh_wbc
        BUG_ON(!buffer_mapped(bh))  --> hit this BUG_ON

Fixes: 5db470e229e2 ("loop: drop caches if offset or block_size are changed")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 453e3728e6573..c6157ccb94989 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1110,7 +1110,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
 		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
 	}
 
 	/* I/O need to be drained during transfer transition */
@@ -1380,12 +1380,12 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 
 	if (lo->lo_queue->limits.logical_block_size != arg) {
 		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
 	}
 
 	blk_mq_freeze_queue(lo->lo_queue);
 
-	/* kill_bdev should have truncated all the pages */
+	/* invalidate_bdev should have truncated all the pages */
 	if (lo->lo_queue->limits.logical_block_size != arg &&
 			lo->lo_device->bd_inode->i_mapping->nrpages) {
 		err = -EAGAIN;
-- 
2.25.1

