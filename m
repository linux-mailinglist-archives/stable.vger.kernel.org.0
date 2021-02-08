Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ACE313656
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhBHPJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhBHPGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:06:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF90C061794
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id df22so18529403edb.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gw7klKD2RMcDufoZq/xD79IYKU/w+UW1t1ZRskK2cSw=;
        b=REtoqEvdi1bEY/DgIZ/t7Ft5fXF2dQ8pGquUWPDJ83Jli5NTr6uGQvnfQn2PsyZMlZ
         t3PmS2JIg2R6/BoMWbhu1IiwGjSst5kZ3huEB2GA0Jvoh2Z0vNOerhhT1Y1lyiqi3/x6
         dXNa2vBjUUrIH8MgIIE2oBSKSnn/PwpSuU84jsE6dgW2/vBQRqLZ6s6RYvFRUuydNf78
         TvI+rriQlQaUF7HETt/zr4VOedYeQy+FHTwoYRdV7z4AIWo6RYQ1f+HqsM460iTNgCFG
         6eSZkOJJFCqrqOX+U71EEjZZ/vg53P2lGWChjM3Sd6blO80zapRJunfz0th1Low4yIky
         zN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gw7klKD2RMcDufoZq/xD79IYKU/w+UW1t1ZRskK2cSw=;
        b=jdK67rb2NMZebf+CRZ/3zeXNhmjUPDdWpZFFy6pJFA9fM4MVMiSxIZ+ZXKJgCLBh0z
         E5BD+gZyZeQ4NUhZGQC51xKSeqU08cM3V1ER4LpkhPr+kY95cG5qjGwSIXFGr2lHJjLU
         k/i7qc5iF3iWRPdUn8tacozf7/iCXp3+04jz3kKGTspJrM8D2Ot+pzpx5EhxaroZ0xFx
         fHSqnEUhoHvGQDPCyUeOXEBGX7vNlngnRPHglosWovtwzoFoBySAhWSJaWNFGrdhDxKb
         D0OUxfMb66X3jMFZSyg6tLpy8TWsdwarkrTUQkRVWuXa32bEm+ARCAqNfv/E75DClHHL
         mOow==
X-Gm-Message-State: AOAM531H9EDkw18McDyFVaxd1icc4nbXP1YCz7yTopCi5pew/nzczTuo
        1iRfN/aNpn9Ua9q2BxIaGJaHQg==
X-Google-Smtp-Source: ABdhPJwEbsjDMNFV1BWZKNm4r5qnl1xCf2S9u+Hf9Sl2SRJa3dx12ccM6ws47GtebxeJ8F1hzwIKxw==
X-Received: by 2002:aa7:cac6:: with SMTP id l6mr18005573edt.357.1612796671557;
        Mon, 08 Feb 2021 07:04:31 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:31 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [stable-4.19 Resend 4/7] block: add helper for checking if queue is registered
Date:   Mon,  8 Feb 2021 16:04:23 +0100
Message-Id: <20210208150426.62755-5-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

There are 4 users which check if queue is registered, so add one helper
to check it.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 58c898ba370e68d39470cd0d932b524682c1f9be)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-sysfs.c      | 4 ++--
 block/blk-wbt.c        | 2 +-
 block/elevator.c       | 2 +-
 include/linux/blkdev.h | 1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8286640d4d66..0a7636d24563 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -896,7 +896,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
-	WARN_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags),
+	WARN_ONCE(blk_queue_registered(q),
 		  "%s is registering an already registered queue\n",
 		  kobject_name(&dev->kobj));
 	queue_flag_set_unlocked(QUEUE_FLAG_REGISTERED, q);
@@ -973,7 +973,7 @@ void blk_unregister_queue(struct gendisk *disk)
 		return;
 
 	/* Return early if disk->queue was never registered. */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return;
 
 	/*
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index f1de8ba483a9..50f2abfa1a60 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -708,7 +708,7 @@ void wbt_enable_default(struct request_queue *q)
 		return;
 
 	/* Queue not registered? Maybe shutting down... */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return;
 
 	if ((q->mq_ops && IS_ENABLED(CONFIG_BLK_WBT_MQ)) ||
diff --git a/block/elevator.c b/block/elevator.c
index ddbcd36616a8..9bffe4558929 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1083,7 +1083,7 @@ static int __elevator_change(struct request_queue *q, const char *name)
 	struct elevator_type *e;
 
 	/* Make sure queue is not in the middle of being removed */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return -ENOENT;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 745b2d0dcf78..3a2b34c2c82b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -743,6 +743,7 @@ bool blk_queue_flag_test_and_clear(unsigned int flag, struct request_queue *q);
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
+#define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.25.1

