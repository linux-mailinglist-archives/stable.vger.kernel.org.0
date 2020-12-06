Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7909C2D04C0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgLFMWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgLFMWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:22:18 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3117C0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 04:21:31 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id k10so9131041wmi.3
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 04:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXqpQgM+Nyx8O9A/awq9HVzugH5keRXaiuNsM55m6Tc=;
        b=O6EFBFeKbWi01Befn9rwrlo0nr2O0uDlVlSe7YpdojRS16fpelVr/Uzq1oV8nMuf+k
         B6+UG0fAzkhSKWDsj/Poe4HWUPkDB0eSK8ROtWSnLgZR9yvuzAuHgmg7OagGEdKoLqSD
         3wdKfZ5PFjccMyygxIYhI08yHl/OxTL39GeF10dPDD2G43du/2IKeD8cfYlY+0vf2xlr
         MfGKZ4DRJbpam50qmabiaxbToukeWpGIwsiro0Df9GfcEOi2BTKNpHopCFqVYJ5yT4sj
         Fe1kQaYfZYui8zzA0Fs6mXd1wb5ZY0H+J4nuLFYauIeShNnhcGgKiQ2/rdthoJi1Jbhw
         8PiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXqpQgM+Nyx8O9A/awq9HVzugH5keRXaiuNsM55m6Tc=;
        b=BsrTfl+at12lIaSztdKb0un9m5PNYIkI/eiCGDak28gtFvLkMo42kn5WlcC/6tkkpj
         67FPNOBYKQtvIS0ZnkqyUXaUDK1z+r2D8GWyS3HhdmCHBxkjIYNhoHqhrjDPp428upp8
         2ccZt60uajA7JsG4o4mA1GLYj59Nb0l7bzfrd6FCTCdjZI856r8ab/1gTIoYuXRKVOAx
         OBsF3KnTXY8oKCpQCiHXPJL4WVUkSAOT9LCEKIKARMJa5dX8E3dTVFmXkQqKO8C//Ahd
         PazKoN25EVsBpuhPzKH3FEiv6azHR9YiSfCsTFDNAsgoZ69k6IOI4AFGCh6fpp+skJk6
         b19w==
X-Gm-Message-State: AOAM5332RiS8BDDS40WoGHUWZRBHc87YpYn6OOtpZT4gN5DmzYEuSk5D
        ecjbUvmMTyPfPNOzZJrDEj+b5u7UYttVrg==
X-Google-Smtp-Source: ABdhPJxiva3u9BlyRVoCFqQUffJy5fnHNxqmZrttS4UvwvLKleDa5k9FLdTBtTJVU3ryzzHOVE7dZQ==
X-Received: by 2002:a1c:6002:: with SMTP id u2mr13677717wmb.29.1607257289768;
        Sun, 06 Dec 2020 04:21:29 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:f:6020:a5f1:3ae9:bf50:62a8])
        by smtp.gmail.com with ESMTPSA id j13sm9971534wmi.36.2020.12.06.04.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 04:21:28 -0800 (PST)
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     bsegall@google.com, pauld@redhat.com, peterz@infradead.org,
        zohooouoto@zoho.com.cn, sashal@kernel.org, gpiccoli@canonical.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v5.4] sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list
Date:   Sun,  6 Dec 2020 13:21:24 +0100
Message-Id: <20201206122124.9718-1-vincent.guittot@linaro.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]

Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
are quite close and follow the same sequence for enqueuing an entity in the
cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
enqueue_task_fair(). This fixes a problem already faced with the latter and
add an optimization in the last for_each_sched_entity loop.

Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org
---

This is the rebase on v5.4.y / v5.4.81 of commit:
  b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")

 kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 200e12110109..3dd7c10d6a58 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4580,7 +4580,6 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	int enqueue = 1;
 	long task_delta, idle_task_delta;
 
 	se = cfs_rq->tg->se[cpu_of(rq)];
@@ -4604,21 +4603,41 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	for_each_sched_entity(se) {
 		if (se->on_rq)
-			enqueue = 0;
+			break;
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+
+		cfs_rq->h_nr_running += task_delta;
+		cfs_rq->idle_h_nr_running += idle_task_delta;
 
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto unthrottle_throttle;
+	}
+
+	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		if (enqueue)
-			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+
 		cfs_rq->h_nr_running += task_delta;
 		cfs_rq->idle_h_nr_running += idle_task_delta;
 
+
+		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto unthrottle_throttle;
+
+		/*
+		 * One parent has been throttled and cfs_rq removed from the
+		 * list. Add it back to not break the leaf list.
+		 */
+		if (throttled_hierarchy(cfs_rq))
+			list_add_leaf_cfs_rq(cfs_rq);
 	}
 
-	if (!se)
-		add_nr_running(rq, task_delta);
+	/* At this point se is NULL and we are at root level*/
+	add_nr_running(rq, task_delta);
 
+unthrottle_throttle:
 	/*
 	 * The cfs_rq_throttled() breaks in the above iteration can result in
 	 * incomplete leaf list maintenance, resulting in triggering the
@@ -4627,7 +4646,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		list_add_leaf_cfs_rq(cfs_rq);
+		if (list_add_leaf_cfs_rq(cfs_rq))
+			break;
 	}
 
 	assert_list_leaf_cfs_rq(rq);
-- 
2.17.1

