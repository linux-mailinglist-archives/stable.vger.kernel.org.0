Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07288119848
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfLJVi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbfLJVfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED98E24655;
        Tue, 10 Dec 2019 21:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013715;
        bh=+mJtfdZ/m/8YdlF0bimkvFs+ZilsuQaB+cO9fGqJGZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8aq5sbtNpniErcGYMxmZNJNT+s8QXptbk8ovQGP2P2Ep6QwrjeYAX7ghDqwHspOq
         k5cZ9fEHaS+VjEAvWhEGEYhu8MuB7NNUOd+8vRhDIShSHxHJR7BwApuElwJyWaUphm
         ZKPwa95U2r9/cau97hpw0VAex6M0ne2nXO81nU7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 143/177] bcache: fix static checker warning in bcache_device_free()
Date:   Tue, 10 Dec 2019 16:31:47 -0500
Message-Id: <20191210213221.11921-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 2d8869518a525c9bce5f5268419df9dfbe3dfdeb ]

Commit cafe56359144 ("bcache: A block layer cache") leads to the
following static checker warning:

    ./drivers/md/bcache/super.c:770 bcache_device_free()
    warn: variable dereferenced before check 'd->disk' (see line 766)

drivers/md/bcache/super.c
   762  static void bcache_device_free(struct bcache_device *d)
   763  {
   764          lockdep_assert_held(&bch_register_lock);
   765
   766          pr_info("%s stopped", d->disk->disk_name);
                                      ^^^^^^^^^
Unchecked dereference.

   767
   768          if (d->c)
   769                  bcache_device_detach(d);
   770          if (d->disk && d->disk->flags & GENHD_FL_UP)
                    ^^^^^^^
Check too late.

   771                  del_gendisk(d->disk);
   772          if (d->disk && d->disk->queue)
   773                  blk_cleanup_queue(d->disk->queue);
   774          if (d->disk) {
   775                  ida_simple_remove(&bcache_device_idx,
   776                                    first_minor_to_idx(d->disk->first_minor));
   777                  put_disk(d->disk);
   778          }
   779

It is not 100% sure that the gendisk struct of bcache device will always
be there, the warning makes sense when there is problem in block core.

This patch tries to remove the static checking warning by checking
d->disk to avoid NULL pointer deferences.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 14d381cc6d747..2d60bcdb5b9c1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -747,20 +747,28 @@ static inline int idx_to_first_minor(int idx)
 
 static void bcache_device_free(struct bcache_device *d)
 {
+	struct gendisk *disk = d->disk;
+
 	lockdep_assert_held(&bch_register_lock);
 
-	pr_info("%s stopped", d->disk->disk_name);
+	if (disk)
+		pr_info("%s stopped", disk->disk_name);
+	else
+		pr_err("bcache device (NULL gendisk) stopped");
 
 	if (d->c)
 		bcache_device_detach(d);
-	if (d->disk && d->disk->flags & GENHD_FL_UP)
-		del_gendisk(d->disk);
-	if (d->disk && d->disk->queue)
-		blk_cleanup_queue(d->disk->queue);
-	if (d->disk) {
+
+	if (disk) {
+		if (disk->flags & GENHD_FL_UP)
+			del_gendisk(disk);
+
+		if (disk->queue)
+			blk_cleanup_queue(disk->queue);
+
 		ida_simple_remove(&bcache_device_idx,
-				  first_minor_to_idx(d->disk->first_minor));
-		put_disk(d->disk);
+				  first_minor_to_idx(disk->first_minor));
+		put_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.20.1

