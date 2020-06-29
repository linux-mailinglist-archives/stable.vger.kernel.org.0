Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F9C20D0C0
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgF2Sfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35CA02468A;
        Mon, 29 Jun 2020 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443986;
        bh=7VlxaRnLEAXuzxc1DqjOaN93RU3LWp7PGuQKVENWRGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hjb/P3hWbOp5rp0qejC78C+JuRJqvFcJicEYiIh1m073CDzK3quy6GUQ4ZfpD46t5
         tSQsDqW2CIK2nf7QJ9I0FDWHZ+FxXhXynL7CvgQtO8IZENDuxEzPXzgIE1Z7rMbJBi
         0IrY9ESK8HCSB5fIHTJN8Gleu46CUggJZoyO3VRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 090/265] loop: replace kill_bdev with invalidate_bdev
Date:   Mon, 29 Jun 2020 11:15:23 -0400
Message-Id: <20200629151818.2493727-91-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit f4bd34b139a3fa2808c4205f12714c65e1548c6c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index da693e6a834e5..418bb4621255a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1289,7 +1289,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
 		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
 	}
 
 	/* I/O need to be drained during transfer transition */
@@ -1320,7 +1320,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
-		/* kill_bdev should have truncated all the pages */
+		/* invalidate_bdev should have truncated all the pages */
 		if (lo->lo_device->bd_inode->i_mapping->nrpages) {
 			err = -EAGAIN;
 			pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
@@ -1565,11 +1565,11 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 		return 0;
 
 	sync_blockdev(lo->lo_device);
-	kill_bdev(lo->lo_device);
+	invalidate_bdev(lo->lo_device);
 
 	blk_mq_freeze_queue(lo->lo_queue);
 
-	/* kill_bdev should have truncated all the pages */
+	/* invalidate_bdev should have truncated all the pages */
 	if (lo->lo_device->bd_inode->i_mapping->nrpages) {
 		err = -EAGAIN;
 		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-- 
2.25.1

