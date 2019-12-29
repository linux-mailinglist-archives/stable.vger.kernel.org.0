Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993B112C59E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfL2Rir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfL2Rdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4615C20722;
        Sun, 29 Dec 2019 17:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640832;
        bh=c15sxyYB7SoT9Non22x2h0tkHHoK/8IWuGc80z7r14I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPkzb87b2jBEzBJrZySSHVUUqY3+IzuK+b61fTAIHOp33r0LhCNArt0QvVOi00GJb
         oDxGWxKKKGJKBgj6MrLGHpJmtdUWL1qNhS48BtIBnA+95C3+WxTi4bKaAXNGsVAd7L
         sM8YoTBTq9jSBGxYCaW1DeMhvV8yXjh050Uu1iB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/219] bcache: fix static checker warning in bcache_device_free()
Date:   Sun, 29 Dec 2019 18:19:19 +0100
Message-Id: <20191229162532.327225338@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 14d381cc6d74..2d60bcdb5b9c 100644
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



