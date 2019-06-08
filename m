Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F5039DD6
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfFHLoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbfFHLnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 207EE21707;
        Sat,  8 Jun 2019 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994210;
        bh=CxrsVp3lY/RrFqzcWFqD5j0zqFx6EsqJH/ix8qLijOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYPKY6uFh4EsKFM1EXjqTpa9i9JLv6rUl5p1DyokyY1KntJimB5NffFOugGtpUfLm
         xUy1er5STT+Q8diBA0YrS+rqpQsC1iJUBWiYwXu54PISf4lgDhtfTgy5QCnNYVYFWM
         BOlyTpKVrb/m/9+8vWk/9pYJUpBVxhwRowXi//WM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/49] loop: Don't change loop device under exclusive opener
Date:   Sat,  8 Jun 2019 07:42:03 -0400
Message-Id: <20190608114232.8731-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
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
index f1e63eb7cbca..a443910f5d6f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -920,9 +920,20 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
@@ -986,10 +997,15 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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

