Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29DB1D8690
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387900AbgERSY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbgERRrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC03120671;
        Mon, 18 May 2020 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824038;
        bh=tpIiauc4YrWcZQXGN3wFm0cMXUDzbiRA6w5dDO/ReSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXySE3nGOcHdmDgekjaz+AJcDyWbhYL9QBraCWiES8pgIVxRBURaagBkweJLcFNA2
         qkuVlULLIqQJoZbJZebBLSSbML3a8z/zOTyIJx0SkOwac56kevVeA6EXl/qs5zD15O
         IhCEcA7LxK8OdSibtJ1X51T+ah9MxROGwZyQyKfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 039/114] blktrace: fix unlocked access to init/start-stop/teardown
Date:   Mon, 18 May 2020 19:36:11 +0200
Message-Id: <20200518173510.623937854@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 1f2cac107c591c24b60b115d6050adc213d10fc0 upstream.

sg.c calls into the blktrace functions without holding the proper queue
mutex for doing setup, start/stop, or teardown.

Add internal unlocked variants, and export the ones that do the proper
locking.

Fixes: 6da127ad0918 ("blktrace: Add blktrace ioctls to SCSI generic devices")
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/blktrace.c |   58 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 10 deletions(-)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -352,7 +352,7 @@ static void blk_trace_cleanup(struct blk
 	put_probe_ref();
 }
 
-int blk_trace_remove(struct request_queue *q)
+static int __blk_trace_remove(struct request_queue *q)
 {
 	struct blk_trace *bt;
 
@@ -365,6 +365,17 @@ int blk_trace_remove(struct request_queu
 
 	return 0;
 }
+
+int blk_trace_remove(struct request_queue *q)
+{
+	int ret;
+
+	mutex_lock(&q->blk_trace_mutex);
+	ret = __blk_trace_remove(q);
+	mutex_unlock(&q->blk_trace_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(blk_trace_remove);
 
 static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
@@ -565,9 +576,8 @@ err:
 	return ret;
 }
 
-int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
-		    struct block_device *bdev,
-		    char __user *arg)
+static int __blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+			     struct block_device *bdev, char __user *arg)
 {
 	struct blk_user_trace_setup buts;
 	int ret;
@@ -586,6 +596,19 @@ int blk_trace_setup(struct request_queue
 	}
 	return 0;
 }
+
+int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+		    struct block_device *bdev,
+		    char __user *arg)
+{
+	int ret;
+
+	mutex_lock(&q->blk_trace_mutex);
+	ret = __blk_trace_setup(q, name, dev, bdev, arg);
+	mutex_unlock(&q->blk_trace_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(blk_trace_setup);
 
 #if defined(CONFIG_COMPAT) && defined(CONFIG_X86_64)
@@ -622,7 +645,7 @@ static int compat_blk_trace_setup(struct
 }
 #endif
 
-int blk_trace_startstop(struct request_queue *q, int start)
+static int __blk_trace_startstop(struct request_queue *q, int start)
 {
 	int ret;
 	struct blk_trace *bt = q->blk_trace;
@@ -661,6 +684,17 @@ int blk_trace_startstop(struct request_q
 
 	return ret;
 }
+
+int blk_trace_startstop(struct request_queue *q, int start)
+{
+	int ret;
+
+	mutex_lock(&q->blk_trace_mutex);
+	ret = __blk_trace_startstop(q, start);
+	mutex_unlock(&q->blk_trace_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(blk_trace_startstop);
 
 /*
@@ -691,7 +725,7 @@ int blk_trace_ioctl(struct block_device
 	switch (cmd) {
 	case BLKTRACESETUP:
 		bdevname(bdev, b);
-		ret = blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
+		ret = __blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
 		break;
 #if defined(CONFIG_COMPAT) && defined(CONFIG_X86_64)
 	case BLKTRACESETUP32:
@@ -702,10 +736,10 @@ int blk_trace_ioctl(struct block_device
 	case BLKTRACESTART:
 		start = 1;
 	case BLKTRACESTOP:
-		ret = blk_trace_startstop(q, start);
+		ret = __blk_trace_startstop(q, start);
 		break;
 	case BLKTRACETEARDOWN:
-		ret = blk_trace_remove(q);
+		ret = __blk_trace_remove(q);
 		break;
 	default:
 		ret = -ENOTTY;
@@ -723,10 +757,14 @@ int blk_trace_ioctl(struct block_device
  **/
 void blk_trace_shutdown(struct request_queue *q)
 {
+	mutex_lock(&q->blk_trace_mutex);
+
 	if (q->blk_trace) {
-		blk_trace_startstop(q, 0);
-		blk_trace_remove(q);
+		__blk_trace_startstop(q, 0);
+		__blk_trace_remove(q);
 	}
+
+	mutex_unlock(&q->blk_trace_mutex);
 }
 
 #ifdef CONFIG_BLK_CGROUP


