Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FB825EBF0
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 03:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgIFBW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 21:22:29 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54151 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFBW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Sep 2020 21:22:29 -0400
Received: by mail-pj1-f66.google.com with SMTP id t7so1784160pjd.3;
        Sat, 05 Sep 2020 18:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHGPS1eQkp3Nq4k5T2mBcncvv3X8+Xgal2LBLA7ET2I=;
        b=YhTkWqCM8aXvGTeKJgeQIXLUEwTOfGVSP9t5pduO9lPrsZ7WVYs6/BGFNI+vb0tT1r
         h+z700DVSd+ymgUhpeAcaEzFfiCMwnHm1CLkj+mOjD0JrX9NwvNe+YJnJFP6XQiWE3BS
         o7vhZ5vD2GC+YI/yQ1KzUHLV0G8vq/U7FMkMTwDheb9cy2anqWKBUjSLo6tAB+BRBJ32
         961w31Lkm8Je6HYvDc+Kl9bueoHctXwAM+VqbXWO3FMe5Xc2D1zlG6+/ELYX557IqFDa
         8HoOnEtppjAbnd8OPyaaCM4nmaD7BLbeyGzcy25vwLV7Ic6DuJyx512+1nz2yIpqIJq+
         ZNcw==
X-Gm-Message-State: AOAM530kAHzspkpPhRdP6AJ4iWMQl7TtygzzYtpgDzWgBR5/z2CxqTdh
        mLVV21wjts9mhSL5j2jVoAc=
X-Google-Smtp-Source: ABdhPJzjvw9TknM5zPRwJIdxrM7mVMvvZTx8q9fgC3nxHqY4Qnsp3jtGIxUparC9qXfKEIECKi0fFg==
X-Received: by 2002:a17:90b:80f:: with SMTP id bk15mr14559521pjb.36.1599355348468;
        Sat, 05 Sep 2020 18:22:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH 1/9] block: Fix a race in the runtime power management code
Date:   Sat,  5 Sep 2020 18:22:11 -0700
Message-Id: <20200906012219.17893-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the current implementation the following race can happen:
* blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
  blk_mq_unfreeze_queue().
* blk_queue_enter() calls blk_queue_pm_only() and that function returns
  true.
* blk_queue_enter() calls blk_pm_request_resume() and that function does
  not call pm_request_resume() because the queue runtime status is
  RPM_ACTIVE.
* blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.

Fix this race by changing the queue runtime status into RPM_SUSPENDING
before switching q_usage_counter to atomic mode.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-pm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-pm.c b/block/blk-pm.c
index b85234d758f7..17bd020268d4 100644
--- a/block/blk-pm.c
+++ b/block/blk-pm.c
@@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 
 	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
 
+	spin_lock_irq(&q->queue_lock);
+	q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(&q->queue_lock);
+
 	/*
 	 * Increase the pm_only counter before checking whether any
 	 * non-PM blk_queue_enter() calls are in progress to avoid that any
@@ -89,15 +93,14 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 	/* Switch q_usage_counter back to per-cpu mode. */
 	blk_mq_unfreeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
-	if (ret < 0)
+	if (ret < 0) {
+		spin_lock_irq(&q->queue_lock);
+		q->rpm_status = RPM_ACTIVE;
 		pm_runtime_mark_last_busy(q->dev);
-	else
-		q->rpm_status = RPM_SUSPENDING;
-	spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&q->queue_lock);
 
-	if (ret)
 		blk_clear_pm_only(q);
+	}
 
 	return ret;
 }
