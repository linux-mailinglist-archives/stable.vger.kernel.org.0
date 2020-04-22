Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C11B3DEA
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgDVKWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgDVKVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0471D2084D;
        Wed, 22 Apr 2020 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550891;
        bh=bPwKDTKpL2Y+JZMMa3GJB3P5LJcrgEhmvE86xCxhotQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3Wg9uN99Vnttf1PmjqG9EaNa8hYorZy60IUj85apuccv5CEMONq+xpJ+9QPOUr9F
         YWnAFNfWlqCpJAdLxHiMjgKafYkqyWkAKQJyIt+j+xtV6vTvu5EL5npKxY0u5cjqhL
         W6sRsVvEwbu71I1BqIhmAxQjk4vy4iL+Nd1y0uZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jason Dillaman <dillaman@redhat.com>
Subject: [PATCH 5.6 017/166] rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
Date:   Wed, 22 Apr 2020 11:55:44 +0200
Message-Id: <20200422095050.245586777@linuxfoundation.org>
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

commit 952c48b0ed18919bff7528501e9a3fff8a24f8cd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6955,9 +6955,10 @@ static void rbd_print_dne(struct rbd_dev
 
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
@@ -7007,7 +7008,7 @@ static int rbd_dev_image_probe(struct rb
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
 			rbd_print_dne(rbd_dev, false);
-		goto err_out_watch;
+		goto err_out_probe;
 	}
 
 	/*
@@ -7052,12 +7053,11 @@ static int rbd_dev_image_probe(struct rb
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


