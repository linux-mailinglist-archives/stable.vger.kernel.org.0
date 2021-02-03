Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C286930DAFF
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBCNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhBCNVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:46 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BCDC06178B
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:30 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id y187so5204708wmd.3
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6IdRX02f71VtSCOgLB7umSVkmw3Wa3ffAZk4G0tZrdA=;
        b=dlNTm1aqGFC81Rn4kmr+1KJkS4hA6/aCVr1rPI/p9RywE+IfFVudr5pGMBnzxs8DFW
         Pk8Uk8UXYC+yE7ffRyXcT8McVFJIvG7rOzfW/oUW0tj2LxGOIuzwsxkz7umL/5RcdT4D
         2j32kmf6ryTLbOZ8Gy37QsOYAd21Ahil4JebHEjVsG2UaXH+LEWngyhgCCikdhg1KfDZ
         p8wmW5BT/HljPOJyZjr58OgHs/wm7sQk5TcS7P0K0wej45mF40XtAQSQNyruE0ePw+QX
         oT5Q5UFq6qemVJWVEqus4tuHSLB1VhqlisZWE8KI4UOamqBGu1G+i5fjGk8iX59Lb3BA
         daKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6IdRX02f71VtSCOgLB7umSVkmw3Wa3ffAZk4G0tZrdA=;
        b=AJdO5T+JiK1JzG9wJJz9EHAR6cAR3F5fI5iiPeSpTNAIfg61Dsp78TmG8jkCyE47nJ
         0eXm5qBmgqkDREZ16ealoflrCvWqNwfV9rJrmenaWeIanbI9W7KF9hsWPQYZf+S7EGVl
         9SvCfLG96oxav3RzGI/Gtwv0VNf9rasxCKdxiL4Fa8GWLEUJiBSL+70fuSb9cok41KzY
         MbcEWAxLvbX87Xffl5qCPnYnln3tkAAI1ubR1313mFPd0URFvhlHkkkclyVEVi3l5xnG
         yRCOyht3EMgEh4BA2vfSQO610crlcYxlYPYSUZkBL4TaiknKT6ZN1Afc6ot5skKjLVHl
         dWeA==
X-Gm-Message-State: AOAM530Ijrosw8+ZApkTvhJrBdx7e/MILybtlGvwrdhhSQaa0M01KOE/
        4g0q7v+7aAg90Vcs0S2qn7mK0w==
X-Google-Smtp-Source: ABdhPJwQu49P67ungbgd8YZkJy4L4TmjLDyJe5dNpVkywT4LPBFMefMunV/Cbn5V2uR8ttlw5P1bSg==
X-Received: by 2002:a1c:99d0:: with SMTP id b199mr1261715wme.147.1612358429504;
        Wed, 03 Feb 2021 05:20:29 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:29 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 6/8] block: fix race between switching elevator and removing queues
Date:   Wed,  3 Feb 2021 14:20:20 +0100
Message-Id: <20210203132022.92406-7-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

cecf5d87ff20 ("block: split .sysfs_lock into two locks") starts to
release & actuire sysfs_lock again during switching elevator. So it
isn't enough to prevent switching elevator from happening by simply
clearing QUEUE_FLAG_REGISTERED with holding sysfs_lock, because
in-progress switch still can move on after re-acquiring the lock,
meantime the flag of QUEUE_FLAG_REGISTERED won't get checked.

Fixes this issue by checking 'q->elevator' directly & locklessly after
q->kobj is removed in blk_unregister_queue(), this way is safe because
q->elevator can't be changed at that time.

Fixes: cecf5d87ff20 ("block: split .sysfs_lock into two locks")
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 0a67b5a926e63ff5492c3c675eab5900580d056d)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b2208b69f04a..899987152701 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -977,7 +977,6 @@ EXPORT_SYMBOL_GPL(blk_register_queue);
 void blk_unregister_queue(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	bool has_elevator;
 
 	if (WARN_ON(!q))
 		return;
@@ -993,7 +992,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	 */
 	mutex_lock(&q->sysfs_lock);
 	blk_queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
-	has_elevator = !!q->elevator;
 	mutex_unlock(&q->sysfs_lock);
 
 	mutex_lock(&q->sysfs_dir_lock);
@@ -1009,7 +1007,11 @@ void blk_unregister_queue(struct gendisk *disk)
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
 	mutex_lock(&q->sysfs_lock);
-	if (q->request_fn || has_elevator)
+	/*
+	 * q->kobj has been removed, so it is safe to check if elevator
+	 * exists without holding q->sysfs_lock.
+	 */
+	if (q->request_fn || q->elevator)
 		elv_unregister_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);
-- 
2.25.1

