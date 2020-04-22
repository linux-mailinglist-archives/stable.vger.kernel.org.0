Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07091B3F98
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgDVKjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgDVKV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84CB820784;
        Wed, 22 Apr 2020 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550889;
        bh=dUEfWMtiuAicjjPNhOpc86+qxyFCQ0oSenl0428WBpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX6nY0SfEYtGO83Mv+V/OD/k+Uw1TMYOPwYZoIv2nDNntFSW72ml+5kyOKjRLjfyM
         Qt8TQKWNZC2NLjS2TOaYWTdA72huSwzPYnHMZio0ufq41G3FAA9Gq+MWm6riivQ2EM
         pTF8Q3gmmrqYNvCmIHQdbVToW9C9Lg4HQwywjlVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jason Dillaman <dillaman@redhat.com>
Subject: [PATCH 5.6 016/166] rbd: avoid a deadlock on header_rwsem when flushing notifies
Date:   Wed, 22 Apr 2020 11:55:43 +0200
Message-Id: <20200422095050.121296682@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 0e4e1de5b63fa423b13593337a27fd2d2b0bcf77 upstream.

rbd_unregister_watch() flushes notifies and therefore cannot be called
under header_rwsem because a header update notify takes header_rwsem to
synchronize with "rbd map".  If mapping an image fails after the watch
is established and a header update notify sneaks in, we deadlock when
erroring out from rbd_dev_image_probe().

Move watch registration and unregistration out of the critical section.
The only reason they were put there was to make header_rwsem management
slightly more obvious.

Fixes: 811c66887746 ("rbd: fix rbd map vs notify races")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jason Dillaman <dillaman@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4554,6 +4554,10 @@ static void cancel_tasks_sync(struct rbd
 	cancel_work_sync(&rbd_dev->unlock_work);
 }
 
+/*
+ * header_rwsem must not be held to avoid a deadlock with
+ * rbd_dev_refresh() when flushing notifies.
+ */
 static void rbd_unregister_watch(struct rbd_device *rbd_dev)
 {
 	cancel_tasks_sync(rbd_dev);
@@ -6964,6 +6968,9 @@ static void rbd_dev_image_release(struct
  * device.  If this image is the one being mapped (i.e., not a
  * parent), initiate a watch on its header object before using that
  * object to get detailed information about the rbd image.
+ *
+ * On success, returns with header_rwsem held for write if called
+ * with @depth == 0.
  */
 static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 {
@@ -6993,6 +7000,9 @@ static int rbd_dev_image_probe(struct rb
 		}
 	}
 
+	if (!depth)
+		down_write(&rbd_dev->header_rwsem);
+
 	ret = rbd_dev_header_info(rbd_dev);
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
@@ -7044,6 +7054,8 @@ static int rbd_dev_image_probe(struct rb
 err_out_probe:
 	rbd_dev_unprobe(rbd_dev);
 err_out_watch:
+	if (!depth)
+		up_write(&rbd_dev->header_rwsem);
 	if (need_watch)
 		rbd_unregister_watch(rbd_dev);
 err_out_format:
@@ -7107,12 +7119,9 @@ static ssize_t do_rbd_add(struct bus_typ
 		goto err_out_rbd_dev;
 	}
 
-	down_write(&rbd_dev->header_rwsem);
 	rc = rbd_dev_image_probe(rbd_dev, 0);
-	if (rc < 0) {
-		up_write(&rbd_dev->header_rwsem);
+	if (rc < 0)
 		goto err_out_rbd_dev;
-	}
 
 	if (rbd_dev->opts->alloc_size > rbd_dev->layout.object_size) {
 		rbd_warn(rbd_dev, "alloc_size adjusted to %u",


