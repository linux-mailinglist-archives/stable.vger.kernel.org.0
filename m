Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047E82B3B9B
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 04:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgKPDFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 22:05:10 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33742 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKPDFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 22:05:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id t18so7684102plo.0;
        Sun, 15 Nov 2020 19:05:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHGPS1eQkp3Nq4k5T2mBcncvv3X8+Xgal2LBLA7ET2I=;
        b=OUFutdUdjWWUHfaRNTIOyUZOoPPYaETJL/2K8IOEGEsHPvT5xyDz4dWfO5I3BCGQYl
         ViQCtzOwH0oCYMT1jueNrehAcdMvgZeN/sjyw8XmndDFoNVfkt5uYxCwtNB8yC/Q93kX
         +QW9Myg2hFuLzfSPWR5mQkseZVTQM+hPIM3Dt7M/d66tuwxWBE79TKuBYWOfd+s0be5e
         6XcmwlTnkYrR5o1lEidUa1YkuLxrtd7CFQdXbB6BX2NZgmvuo0MCm1AAj2zWiwRDDFCY
         a8qWBrlNiVfZkNkRH7wdWxBReKNmZ8R59+CWC5gDj85o25wWJkdZpVWvgAsGqxdC0l1+
         7Yng==
X-Gm-Message-State: AOAM5339UPbw6J96uAKfPN4VwGuYP6N+nsTUasmsqKsSMcqC4pd77P1I
        OAARBBNn00tZ95rYQCY0NM8=
X-Google-Smtp-Source: ABdhPJzOLCDKJ+CbpDL0fJAYBoftHzHtLBAAUaaX/Jmgav1hUF3aUDU8xcVFsumB8VI0k4A8t1H2UA==
X-Received: by 2002:a17:902:bb94:b029:d6:edb2:4f41 with SMTP id m20-20020a170902bb94b02900d6edb24f41mr11173761pls.3.1605495909614;
        Sun, 15 Nov 2020 19:05:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH v2 1/9] block: Fix a race in the runtime power management code
Date:   Sun, 15 Nov 2020 19:04:51 -0800
Message-Id: <20201116030459.13963-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116030459.13963-1-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
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
