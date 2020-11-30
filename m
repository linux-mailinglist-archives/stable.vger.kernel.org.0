Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF42C7CE7
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 03:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgK3CrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 21:47:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43647 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgK3CrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 21:47:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id w202so9466589pff.10;
        Sun, 29 Nov 2020 18:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uo+5W/VFPGcdmJas5S5VfCp+uberliRJhse/5+5MoEs=;
        b=qC61DSU/aPZp9pg6ENHHnPGjj6lw3YpEG30S34AQpfSjFzWTMX5vyvFbPQtShjD5VH
         d3EqRuYApoI5LmuvsOt4lNd/Sx5vb21lpTMfC3g4qyRxVj1jYoHXxlGn7hy6MgwxcqeE
         zbzYd2RYc9liI2/AzkjdgE5jCoLRvl38W7anitPhsaUD6khgjOfrDOaO5nb7higStKS6
         Wty77cnbi9Qo/GQ+L8hjBC2RTD762fYIynY0vr3FLWuTfc6kq88KkPHEGqd9gTArY03s
         XzyAY8+DHXFxHFHrDakC5EiQc6FfSrvFYQNcNmrcwNh1S37DHrSCVwvEc60RFRKbgmlJ
         s/4w==
X-Gm-Message-State: AOAM5335BwA45V38LNS2GJcvJqzlLelDe3iGlhroUmYSy4nbLFE4dKTV
        jqZF0cdtP/PWdi1cxybQ18M+5g5DX5Q=
X-Google-Smtp-Source: ABdhPJxUa/UG3UwhIngJplELaSW0y1y3pJsgxmzZ8dl+JDG+y+xzN7Oy+mlGhCRyxdCtwHLs6dP98A==
X-Received: by 2002:aa7:82c5:0:b029:19a:aaac:9b4c with SMTP id f5-20020aa782c50000b029019aaaac9b4cmr14034095pfn.75.1606704384660;
        Sun, 29 Nov 2020 18:46:24 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH v4 1/9] block: Fix a race in the runtime power management code
Date:   Sun, 29 Nov 2020 18:46:07 -0800
Message-Id: <20201130024615.29171-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
