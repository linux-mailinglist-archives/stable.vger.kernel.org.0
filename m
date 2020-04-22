Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5361B4067
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgDVKRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729822AbgDVKRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8362076B;
        Wed, 22 Apr 2020 10:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550642;
        bh=9pA80RXAeQaWY+lyLFsKyR/D7ioBH6TG8ZHD81mhMwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOHO3IqnH7F585Y+5mjTi+Zy/S6OIldge+sTD96eHmRkBaMML2dngZ7TmvR5dVaFm
         Am2ExXtESgcaUIR6zNflCdm2URzu2BsZQ0JcPn53ysTtmUKXdM2YgyKuvN6LX3Juyw
         olLPmPuXe7P89HJU3aTgHM+SJ90up48yvP6xFg9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jason Dillaman <dillaman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/118] rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
Date:   Wed, 22 Apr 2020 11:56:34 +0200
Message-Id: <20200422095037.317196101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 952c48b0ed18919bff7528501e9a3fff8a24f8cd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index bab9c546ba334..274beda31c356 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6933,9 +6933,10 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
 
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
@@ -6986,7 +6987,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 
 	ret = rbd_dev_header_info(rbd_dev);
 	if (ret)
-		goto err_out_watch;
+		goto err_out_probe;
 
 	/*
 	 * If this image is the one being mapped, we have pool name and
@@ -7035,12 +7036,11 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	return 0;
 
 err_out_probe:
-	rbd_dev_unprobe(rbd_dev);
-err_out_watch:
 	if (!depth)
 		up_write(&rbd_dev->header_rwsem);
 	if (!depth)
 		rbd_unregister_watch(rbd_dev);
+	rbd_dev_unprobe(rbd_dev);
 err_out_format:
 	rbd_dev->image_format = 0;
 	kfree(rbd_dev->spec->image_id);
-- 
2.20.1



