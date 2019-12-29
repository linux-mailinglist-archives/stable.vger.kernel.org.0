Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2417B12C58E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfL2Rgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfL2Rgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDD7206CB;
        Sun, 29 Dec 2019 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640999;
        bh=QnVmgWYf3XP6d13kHluYYJy18H9hA7bB6ACGz6kfiSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDOajttRJfonNxUC2JmuFtxH0ub++M7J9lGz3esL+bCnKhQwykMGXdyKDcTK61QA8
         oiciJ4CGeOfQA7M3NkqoD2OmM+DOb76vYe+aaza0JzTFxlr2iNQ7jHecLVBUcO0qLP
         R5a7Dc68i23xrvi2XFPmjcC9qJh48/d9zoBIbE60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 219/219] nbd: fix shutdown and recv work deadlock v2
Date:   Sun, 29 Dec 2019 18:20:21 +0100
Message-Id: <20191229162543.385065589@linuxfoundation.org>
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

From: Mike Christie <mchristi@redhat.com>

commit 1c05839aa973cfae8c3db964a21f9c0eef8fcc21 upstream.

This fixes a regression added with:

commit e9e006f5fcf2bab59149cb38a48a4817c1b538b4
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Aug 4 14:10:06 2019 -0500

    nbd: fix max number of supported devs

where we can deadlock during device shutdown. The problem occurs if
the recv_work's nbd_config_put occurs after nbd_start_device_ioctl has
returned and the userspace app has droppped its reference via closing
the device and running nbd_release. The recv_work nbd_config_put call
would then drop the refcount to zero and try to destroy the config which
would try to do destroy_workqueue from the recv work.

This patch just has nbd_start_device_ioctl do a flush_workqueue when it
wakes so we know after the ioctl returns running works have exited. This
also fixes a possible race where we could try to reuse the device while
old recv_works are still running.

Cc: stable@vger.kernel.org
Fixes: e9e006f5fcf2 ("nbd: fix max number of supported devs")
Signed-off-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nbd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1247,10 +1247,10 @@ static int nbd_start_device_ioctl(struct
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret) {
+	if (ret)
 		sock_shutdown(nbd);
-		flush_workqueue(nbd->recv_workq);
-	}
+	flush_workqueue(nbd->recv_workq);
+
 	mutex_lock(&nbd->config_lock);
 	nbd_bdev_reset(bdev);
 	/* user requested, ignore socket errors */


