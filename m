Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210FB2C031A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgKWKSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgKWKSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 05:18:32 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCB1C061A4D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 02:18:32 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id q25so14215697qkm.17
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 02:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=GcoK8qMUEnSHSoEFmuVB5/ee/Q6gnGTRAARyiXTD6tI=;
        b=Y2WSGSmKWTFuCwZhuqKamV56JvCiFkSsxzG93yVes9093uv8zSLlS0dLZukooaKrtE
         JZCR+4fRPl934bAFi362BH+N5WT48tWWKCi0ay0kIzl7sWoLtDcVO/iYPluEQQ2zr4SL
         O974e8MIJ7fGvBIL3ubSCGGccfXQsKp9cutcdIodRUK7CeVQ5XPGb8gZ4cy0iL0Oxst1
         iGbP9UfV3uTD7HqBqDjUuI2Enj/j2rjFB1fAwgDFQlfJBB/ZgxDAOmmyIKKKIXIBAnSw
         d/+qJFTQW13K0meXuA+GL5E44Ho5Ukn4U09oAcnRpB3xX7bej1D9Cp26ysg7qITGB0hm
         1BpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=GcoK8qMUEnSHSoEFmuVB5/ee/Q6gnGTRAARyiXTD6tI=;
        b=Hh42c/FXwupN8skElq9Fa/CRK965vp9heAIwjhjqw+EggDhn0KDcjqKAWZG3MVtzJk
         jAwfjVdwGj3CX8Fm9MtPY4S7Ky3lfexKQab1oluuGTcW+6RoNM/CVfKr34L30gAg9MOP
         4TQqirBO9OLw/X5BlCnycvL5pLRGgCp3SiLYnfwnG7xVBNfNUuHw2K5LfJXV7czsIwMl
         e0WbPzyL51tCdjFGs0L7Gi0ec2sZkHSvhQe83r1rk5BerqyxIMObk5qq44HxF2g6gvJ8
         7VV6//AiguGMqRsoRONeP7FAoW5vlpa1YsWM2YtYh2jQ2CIjY9OVoF6ANJhI218QxIZp
         PiiQ==
X-Gm-Message-State: AOAM530A8wc4v+T+9O1fAWm+cVExmyavX34qRT9cnx0FXjKg8nDvJqRY
        OOz4clHKFrwGzW+itTqg9r7Y4YrRhrpdRoa3388hbUDzxMrNSJALMRpHpZVNzdkbBmsGc44/uqQ
        XlszOTUkRMG5cSIenT91x+p/XUMzpUx7jSgf6xGwzSv3MkQL9h9YKsIclhHanMQom
X-Google-Smtp-Source: ABdhPJx0vjckV+KAnRUFHC+odUrCif66jUn0bm1E5yfYglf15c9GHKgO6trAQu9hBrkIRayxcFJtpXchvYdF
Sender: "qperret via sendgmr" <qperret@luke.lon.corp.google.com>
X-Received: from luke.lon.corp.google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:ad4:5621:: with SMTP id
 cb1mr2041817qvb.12.1606126711573; Mon, 23 Nov 2020 02:18:31 -0800 (PST)
Date:   Mon, 23 Nov 2020 10:18:27 +0000
Message-Id: <20201123101827.451304-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH 5.4] sched/fair: Fix overutilized update in enqueue_task_fair()
From:   Quentin Perret <qperret@google.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Cc:     Quentin Perret <qperret@google.com>, Rick Yiu <rickyiu@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8e1ac4299a6e8726de42310d9c1379f188140c71 ]

enqueue_task_fair() attempts to skip the overutilized update for new
tasks as their util_avg is not accurate yet. However, the flag we check
to do so is overwritten earlier on in the function, which makes the
condition pretty much a nop.

Fix this by saving the flag early on.

Fixes: 2802bf3cd936 ("sched/fair: Add over-utilization/tipping point indicator")
Reported-by: Rick Yiu <rickyiu@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20201112111201.2081902-1-qperret@google.com
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dddaf61378f6..200e12110109 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5228,6 +5228,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 	int idle_h_nr_running = task_has_idle_policy(p);
+	int task_new = !(flags & ENQUEUE_WAKEUP);
 
 	/*
 	 * The code below (indirectly) updates schedutil which looks at
@@ -5299,7 +5300,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		 * into account, but that is not straightforward to implement,
 		 * and the following generally works well enough in practice.
 		 */
-		if (flags & ENQUEUE_WAKEUP)
+		if (!task_new)
 			update_overutilized_status(rq);
 
 	}
-- 
2.29.2.454.gaff20da3a2-goog

