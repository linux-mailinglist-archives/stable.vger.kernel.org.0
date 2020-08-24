Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D815824F15B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 05:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgHXDGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 23:06:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43276 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgHXDGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 23:06:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id d19so3865815pgl.10;
        Sun, 23 Aug 2020 20:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XWtnYwfG7Oj1F5XxLqbDL44F7TecGCP0D4b991l1F+U=;
        b=Stu4C++hqk6zbMp45mwUR6U9Pt8Kd+e6zvby12Ikft/ii+DE8+m2HemF8QI2GbJrBx
         G1SohaTxgyCb9uQ0NxG0iT2LutXUbejnCicQglTtTtObGXMQECFSOCgptsJk4t6wqPWq
         RRyLcur8V+T2HmsiT4niRnCIATlHIFP75/y+YRZoFsSsjeXqd6Y09ft1QmF7t8V1+C+G
         VWiI/xAMvqG58t9DcYglJacZS8v4E7yY+p5D8x7QqCcWDiPP+jyxmMlvHmL09glI4GNO
         eg+TdYYmYPOcrYZSBXwE2VMab6xHwp8NmIkfD8HDZzb9e9gk+Kq5XxbQEbQFe4q95phd
         GR3A==
X-Gm-Message-State: AOAM530VTcW3kA3oYyRiDx8yekFyTY/lj64zeR1Ry8YIpgBensgiADeg
        6/urt38IolRJ5pVaWs2t0JM=
X-Google-Smtp-Source: ABdhPJyOeJ/dZD7fDjvJYiY/1Zoc4SOwMrUVgvQ05SeXn4tqhTGof91SCUzLgOmiZwuQUm3yJl5d2A==
X-Received: by 2002:aa7:9dd0:: with SMTP id g16mr2578609pfq.107.1598238379618;
        Sun, 23 Aug 2020 20:06:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id ha17sm4022500pjb.6.2020.08.23.20.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 20:06:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: [PATCH] block: Fix a race in the runtime power management code
Date:   Sun, 23 Aug 2020 20:06:07 -0700
Message-Id: <20200824030607.19357-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
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

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
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
