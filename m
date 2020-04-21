Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231FB1B2DE4
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgDUROB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:14:01 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:45323 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgDUROB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:14:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 12BD91941E9E;
        Tue, 21 Apr 2020 13:07:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wN00Wy
        2XaheJu9qVwJyKJxaG50pybX3ALfpm+xkqfDk=; b=cXdQdIdlhgcm7PCS3nsisR
        ywmL/ZUAlEg/mpXjB5+Yi76Vc688Xp54Q5C54bILLLBmXRvJIT1MgpdghMJMzEEZ
        7bl4qkyZqVq1/QHLdxhi1ehXCYv0Y9UE679aAZn1uBVlhwpx1DZDOyojAMMWpylK
        SWMuJVNn6RTn1VOHvULzUb9g5RGZcBz290Qnxj7ZmjLBsSQZFQMN/jH+jRy81WEq
        F327Xse3MgNrgqn59vlEnSvowiw+f7NvA95ZUJHDm88JnT8IyUo47FNdru23HLPj
        Sz/Q5aId7B6OT2o06efV9aMy6OQZXJSTSONPIeYr1GAjZQqQYDgyLSRgrole+5Cg
        ==
X-ME-Sender: <xms:PiifXnSgnA2xoINmYB722WtNW1JS6wzVoBXtcrMIpFZvyBHPvKzSvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PiifXlDk3hpv_4iGjZaAjCqwlotFasDy3wOI_UJM2-3riZKywBwe9w>
    <xmx:PiifXjHUXll1ighMDAnDi7d05HPi8g2Z-7-5ZUNQeiuzpl4giDlKqQ>
    <xmx:PiifXkoA5LjRAr8Q-jubjiguX4AonECZccH28nQBsst3y5OtPTJ43w>
    <xmx:PyifXmijAEsiuDpL0C64vzmidBSZHMrsOT0hh0nnpWChRxe_hd9QTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A34EE328006A;
        Tue, 21 Apr 2020 13:07:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rbd: avoid a deadlock on header_rwsem when flushing notifies" failed to apply to 4.14-stable tree
To:     idryomov@gmail.com, dillaman@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:06:59 +0200
Message-ID: <1587488819218166@kroah.com>
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

From 0e4e1de5b63fa423b13593337a27fd2d2b0bcf77 Mon Sep 17 00:00:00 2001
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 13 Mar 2020 11:20:51 +0100
Subject: [PATCH] rbd: avoid a deadlock on header_rwsem when flushing notifies

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

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 1e0a6b19ae0d..ff2377e6d12c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4527,6 +4527,10 @@ static void cancel_tasks_sync(struct rbd_device *rbd_dev)
 	cancel_work_sync(&rbd_dev->unlock_work);
 }
 
+/*
+ * header_rwsem must not be held to avoid a deadlock with
+ * rbd_dev_refresh() when flushing notifies.
+ */
 static void rbd_unregister_watch(struct rbd_device *rbd_dev)
 {
 	cancel_tasks_sync(rbd_dev);
@@ -6907,6 +6911,9 @@ static void rbd_dev_image_release(struct rbd_device *rbd_dev)
  * device.  If this image is the one being mapped (i.e., not a
  * parent), initiate a watch on its header object before using that
  * object to get detailed information about the rbd image.
+ *
+ * On success, returns with header_rwsem held for write if called
+ * with @depth == 0.
  */
 static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 {
@@ -6936,6 +6943,9 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 		}
 	}
 
+	if (!depth)
+		down_write(&rbd_dev->header_rwsem);
+
 	ret = rbd_dev_header_info(rbd_dev);
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
@@ -6987,6 +6997,8 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 err_out_probe:
 	rbd_dev_unprobe(rbd_dev);
 err_out_watch:
+	if (!depth)
+		up_write(&rbd_dev->header_rwsem);
 	if (need_watch)
 		rbd_unregister_watch(rbd_dev);
 err_out_format:
@@ -7050,12 +7062,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
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

