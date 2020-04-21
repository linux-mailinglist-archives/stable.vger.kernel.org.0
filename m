Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118021B2DDE
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUROA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:14:00 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48733 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgDURN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:13:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B8C01941E09;
        Tue, 21 Apr 2020 13:07:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XotD6Z
        0F15wkPTwFQl+yUx8jYjPH3nbK2N2VrkYaIOI=; b=1iGbkKmNqZnd7cRpMDyjjY
        oI3zKh91u3bmyPW0nKSzaXSOjHexToMmSGwfgIAM9PMY/IrUlt6vUpTMfYM6LPLd
        htefM7hI9T/fQk8VC+Dg6AZQhpE+PXlOoDNhmKQ2pKkqwZQMoWk1UoWRDaKt/ZxB
        8wAMc3aEgJlSvX4lTYw5Ij845MAtuuOZbUaKBp5uk2jedcgpwYMyPTDkQHegbUAC
        ekqb3aDuFGEBx1B/g9BN9U+o11E6Mc7D5ZrvImJLBipTI17ryGKBdBZJ3U4nM2/2
        AXgJi+fl3GrE5wvyE8Ht0PjLwESQJQhlN0Rv/lbTNyJ2YUmT/rZHJWh1DacAb69Q
        ==
X-ME-Sender: <xms:VCifXn0aDL--FfhAG2NWnaf-ygDDmi28zToE-o6LJfepoZ6EjQgQjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeehne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VCifXlfsY8qkCa6tNZdUSF_pYYA1Q5TDlYf9pj0wsYvriRWK_m3gNw>
    <xmx:VCifXqc37waKhyzIMWQrCS28hBX8UphlEZwR2hN3fXtVfZWUWrHrzA>
    <xmx:VCifXuCALixKl0dEtJwz9gOSp8ZlfqYm4YsD2typWTAKrL6bxLeaGg>
    <xmx:VCifXhUVT-dYWlmNmq-affxlflbR3QJTNq6GnyK7rKSAkuEkJagdVw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBFB93065C90;
        Tue, 21 Apr 2020 13:07:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rbd: call rbd_dev_unprobe() after unwatching and flushing" failed to apply to 4.19-stable tree
To:     idryomov@gmail.com, dillaman@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:07:22 +0200
Message-ID: <158748884256214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 952c48b0ed18919bff7528501e9a3fff8a24f8cd Mon Sep 17 00:00:00 2001
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 16 Mar 2020 15:52:54 +0100
Subject: [PATCH] rbd: call rbd_dev_unprobe() after unwatching and flushing
 notifies

rbd_dev_unprobe() is supposed to undo most of rbd_dev_image_probe(),
including rbd_dev_header_info(), which means that rbd_dev_header_info()
isn't supposed to be called after rbd_dev_unprobe().

However, rbd_dev_image_release() calls rbd_dev_unprobe() before
rbd_unregister_watch().  This is racy because a header update notify
can sneak in:

  "rbd unmap" thread                   ceph-watch-notify worker

  rbd_dev_image_release()
    rbd_dev_unprobe()
      free and zero out header
                                       rbd_watch_cb()
                                         rbd_dev_refresh()
                                           rbd_dev_header_info()
                                             read in header

The same goes for "rbd map" because rbd_dev_image_probe() calls
rbd_dev_unprobe() on errors.  In both cases this results in a memory
leak.

Fixes: fd22aef8b47c ("rbd: move rbd_unregister_watch() call into rbd_dev_image_release()")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jason Dillaman <dillaman@redhat.com>

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index ff2377e6d12c..7aec8bc5df6e 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6898,9 +6898,10 @@ static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
 
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
-	rbd_dev_unprobe(rbd_dev);
 	if (rbd_dev->opts)
 		rbd_unregister_watch(rbd_dev);
+
+	rbd_dev_unprobe(rbd_dev);
 	rbd_dev->image_format = 0;
 	kfree(rbd_dev->spec->image_id);
 	rbd_dev->spec->image_id = NULL;
@@ -6950,7 +6951,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
 			rbd_print_dne(rbd_dev, false);
-		goto err_out_watch;
+		goto err_out_probe;
 	}
 
 	/*
@@ -6995,12 +6996,11 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	return 0;
 
 err_out_probe:
-	rbd_dev_unprobe(rbd_dev);
-err_out_watch:
 	if (!depth)
 		up_write(&rbd_dev->header_rwsem);
 	if (need_watch)
 		rbd_unregister_watch(rbd_dev);
+	rbd_dev_unprobe(rbd_dev);
 err_out_format:
 	rbd_dev->image_format = 0;
 	kfree(rbd_dev->spec->image_id);

