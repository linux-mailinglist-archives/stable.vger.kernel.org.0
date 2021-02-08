Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B5C31362F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhBHPHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhBHPFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:05:11 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9175AC06178C
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c6so18527704ede.0
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfO/909mdUaRpv6ekeQ5pLoyeo6G7O5g5UYJLsEOL80=;
        b=MmGtK51mZ/nb4m6J+tegtGj9dEOWyEsw4IM6ibVo9nz/IxSChfLMDRAudfCxGzPbym
         z/m21H2HxzTt7EV42jQnB0JS0Xz9D2a2frYh6lxYb0R8nEo1G8eEtGdslD0PFWNx4ilS
         MgqnnxC+/zuUgv5U2iI63iPTzW1la1s5KyqWuAB63nQIJ3gA94SKgR7zmOSAQvmXJfqx
         3N9vYqQlXqschblGlUvYIlJIpL4HFOxB1Eh2pyxuw7imB2rrC86UAOFeS/UZFhmrFPMd
         cEbYPMY28VwyIjikW9mCuDCB8EdLScD/XVzRP1P8G19218/lqOxbYfzms1TuOOQmVc2D
         i2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfO/909mdUaRpv6ekeQ5pLoyeo6G7O5g5UYJLsEOL80=;
        b=NJI1UB5Rwzjwo41RQNthmeZ5MkVCQF2j0H4CTEJS8alfQL09Hlh4IznIxjBIOmSDnd
         3kHfjfbDb6Hpw+UR+l01O79pfWL+FUC2VJQ2vA/OhzNMwoku3Zgibw9qJKZwcaYnUMLZ
         xhGKxzaP0ILvC/Ld1R/EJsGBMO2gGUfux4yHH6aCf/ZCc1tYLhJC7IIju1xRxErBVzym
         NCyC4m8nlXJcVdoA5vp/SaGLSfMrwwCRPCwiPnCon/1B/5cy2NzPovRVlH2IqYR6dXkJ
         WPHv0OAtqaHeqxZOGBrxnuRt5jjpshcbMYT5XGeLUgXHOGtKNY0H5iiMhcqUzxbcp5vM
         xSxg==
X-Gm-Message-State: AOAM531KuFnUxHi54r+WIXPqPUoke6myJ0PCIWW4Uj/hVPX4rREDKflk
        iyAPLwLWewcCVBKh/vLPJzMTAw==
X-Google-Smtp-Source: ABdhPJySqwps4jJIuSEUwGbgLGSxUHSe/fFXecOuSpzJWz5pxtiUcs15gqWQxwl4+QnF1eLfkHcEWw==
X-Received: by 2002:a05:6402:2690:: with SMTP id w16mr17703671edd.304.1612796669170;
        Mon, 08 Feb 2021 07:04:29 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:28 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [stable-4.19 Resend 2/7] block: don't hold q->sysfs_lock in elevator_init_mq
Date:   Mon,  8 Feb 2021 16:04:21 +0100
Message-Id: <20210208150426.62755-3-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

The original comment says:

	q->sysfs_lock must be held to provide mutual exclusion between
	elevator_switch() and here.

Which is simply wrong. elevator_init_mq() is only called from
blk_mq_init_allocated_queue, which is always called before the request
queue is registered via blk_register_queue(), for dm-rq or normal rq
based driver. However, queue's kobject is only exposed and added to sysfs
in blk_register_queue(). So there isn't such race between elevator_switch()
and elevator_init_mq().

So avoid to hold q->sysfs_lock in elevator_init_mq().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit c48dac137a62a5d6fa1ef3fa445cbd9c43655a76)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/elevator.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index fae58b2f906f..ddbcd36616a8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -980,23 +980,19 @@ int elevator_init_mq(struct request_queue *q)
 	if (q->nr_hw_queues != 1)
 		return 0;
 
-	/*
-	 * q->sysfs_lock must be held to provide mutual exclusion between
-	 * elevator_switch() and here.
-	 */
-	mutex_lock(&q->sysfs_lock);
+	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
+
 	if (unlikely(q->elevator))
-		goto out_unlock;
+		goto out;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out_unlock;
+		goto out;
 
 	err = blk_mq_init_sched(q, e);
 	if (err)
 		elevator_put(e);
-out_unlock:
-	mutex_unlock(&q->sysfs_lock);
+out:
 	return err;
 }
 
-- 
2.25.1

