Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FB42D3A8A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 06:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgLIFar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 00:30:47 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43385 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbgLIFan (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 00:30:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id y10so330784plr.10;
        Tue, 08 Dec 2020 21:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BHwoHOMvig80TKhMF0enCCYk2D2TdkshHI6fRWVwlZw=;
        b=XP9w+/VsEk0rJbKHKBkF+OBfrJgDjtmFEFJj3EnrPSN5q0XtHqSerB+Q+a5K6Qwrrt
         f14qjAHmfkrlovuNlhuz0AuXaY2oQcravYZeVWuhzSDzg12SeO/8PRywTxtLnNyQLU0O
         QGpCQRqNuTsDKJQTyqQqfowDuWE5aFYgSsMqDQSlO1mJNs1+7ISgKmcJoaufefMwOvOb
         AzIrXp8Yaum1U5O5keBDeauGHysms89Qzbp70FD5QW72OLr01Fh+r7gpRcpSlbj4XfKA
         HMSgXUWF8k5g+gW+LArz1GQrO8W0CH7JQexfRGosiW2UT8yKuLJTjzSLqFXRJOsYS9PI
         QfXw==
X-Gm-Message-State: AOAM531TVUrWi26HPlfGndLRhlBup3VZ/jSurf7dTmeM48kWVVhGVGyd
        Ywfkjwls2g9D9p8F8PjZfz79dXwz/LE=
X-Google-Smtp-Source: ABdhPJwdtRwo+u1GUyNNyDZw6TWPNo8HFr+jXCVil7K7eolcWEqiLd5J9E0DxTMgCUP321EJbuS0bg==
X-Received: by 2002:a17:902:24b:b029:d6:cd52:61e3 with SMTP id 69-20020a170902024bb02900d6cd5261e3mr619537plc.2.1607491802543;
        Tue, 08 Dec 2020 21:30:02 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:30:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH v5 1/8] block: Fix a race in the runtime power management code
Date:   Tue,  8 Dec 2020 21:29:44 -0800
Message-Id: <20201209052951.16136-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
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
Reviewed-by: Jens Axboe <axboe@kernel.dk>
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
