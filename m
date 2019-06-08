Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64DC39F05
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfFHLkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbfFHLkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68891214AF;
        Sat,  8 Jun 2019 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994045;
        bh=5WrzRmktvtoacaifBKzTHnPxqni8nLRu1tw6NXnlKWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoiPA0B6i6DcHDragFgA7nIHoApOcXq+r1PqNfZLR7/G3w2h3np7o8yy9H0N4oSCb
         Nudyj0j9EEx/8X2Z2CO0V46K3deDZs+Fx5+g06pKhMZgtxk4JT15ysOkOf5YfcVsn0
         9CkkwJRaAOVryie8wqkDg4TSCHvNiJF/y/WxKsok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 35/70] loop: Don't change loop device under exclusive opener
Date:   Sat,  8 Jun 2019 07:39:14 -0400
Message-Id: <20190608113950.8033-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 33ec3e53e7b1869d7851e59e126bdb0fe0bd1982 ]

Loop module allows calling LOOP_SET_FD while there are other openers of
the loop device. Even exclusive ones. This can lead to weird
consequences such as kernel deadlocks like:

mount_bdev()				lo_ioctl()
  udf_fill_super()
    udf_load_vrs()
      sb_set_blocksize() - sets desired block size B
      udf_tread()
        sb_bread()
          __bread_gfp(bdev, block, B)
					  loop_set_fd()
					    set_blocksize()
            - now __getblk_slow() indefinitely loops because B != bdev
              block size

Fix the problem by disallowing LOOP_SET_FD ioctl when there are
exclusive openers of a loop device.

[Deliberately chosen not to CC stable as a user with priviledges to
trigger this race has other means of taking the system down and this
has a potential of breaking some weird userspace setup]

Reported-and-tested-by: syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bf1c61cab8eb..21349a17f7f5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -919,9 +919,20 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (!file)
 		goto out;
 
+	/*
+	 * If we don't hold exclusive handle for the device, upgrade to it
+	 * here to avoid changing device under exclusive owner.
+	 */
+	if (!(mode & FMODE_EXCL)) {
+		bdgrab(bdev);
+		error = blkdev_get(bdev, mode | FMODE_EXCL, loop_set_fd);
+		if (error)
+			goto out_putf;
+	}
+
 	error = mutex_lock_killable(&loop_ctl_mutex);
 	if (error)
-		goto out_putf;
+		goto out_bdev;
 
 	error = -EBUSY;
 	if (lo->lo_state != Lo_unbound)
@@ -985,10 +996,15 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan)
 		loop_reread_partitions(lo, bdev);
+	if (!(mode & FMODE_EXCL))
+		blkdev_put(bdev, mode | FMODE_EXCL);
 	return 0;
 
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
+out_bdev:
+	if (!(mode & FMODE_EXCL))
+		blkdev_put(bdev, mode | FMODE_EXCL);
 out_putf:
 	fput(file);
 out:
-- 
2.20.1

