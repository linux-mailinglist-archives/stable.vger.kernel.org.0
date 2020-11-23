Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B012BFE95
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 04:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKWDSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 22:18:00 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44560 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgKWDSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 22:18:00 -0500
Received: by mail-pf1-f193.google.com with SMTP id y7so13570163pfq.11;
        Sun, 22 Nov 2020 19:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NS2/LWJgfKnaWgsdnGvEKSQ6HreXoy5m6pflViridOg=;
        b=mPLpC1/5vBOjn4dQmMC00QMR9G5ANFc9SvPtKAMRxq4vabnmIT0Bg50aCHxsm6cFGz
         1F7Jya1T0zDAhYizm5mOwx2C1fTHpfqMf6YG91L+dq3JeXwTaijWuix2tQACyBpjFKiq
         YfFWyubTVa/A2ODv7Z6OdgK9Vc13CMxC5L5gjbDoLCovvNMfzGNQpHWRBzPe0QyogtKQ
         rZkFITJPJVPlmZGaD0dHtoOJcu/VnzFE9nrMivUEl5E3EOJCKw+jYShkrQ4uJB+Hruzk
         +isW2RRT+lEzKFvvmajJnT3ORAtHVsdO/GIe3C8hr5fJ8eYJF3sPKDSynL+SNLfmiDmc
         Sfbg==
X-Gm-Message-State: AOAM531pB12p49HqzRZvdRIEx1jT6cr/75WzIGF5lZZ3mKbiMwht+G8o
        Ja0l5eppQ7DMoznHvkrWneE=
X-Google-Smtp-Source: ABdhPJzrjluYfs7/aZf3abR/AZ1d+Cy6V5LXlpx5SjvPdL7rra3+1TiI3+YBdyWDqYgU0bC9zGkMkw==
X-Received: by 2002:a65:679a:: with SMTP id e26mr6737241pgr.394.1606101478901;
        Sun, 22 Nov 2020 19:17:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:17:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH v3 1/9] block: Fix a race in the runtime power management code
Date:   Sun, 22 Nov 2020 19:17:41 -0800
Message-Id: <20201123031749.14912-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
