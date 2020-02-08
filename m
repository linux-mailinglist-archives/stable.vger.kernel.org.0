Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2D5156713
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBHSjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:39:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33492 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgBHS3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003Zy-CY; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CJ5-Hq; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tejun Heo" <tj@kernel.org>,
        "Williams, Gerald S" <gerald.s.williams@intel.com>,
        "Marcin Pawlowski" <mpawlowski@fb.com>
Date:   Sat, 08 Feb 2020 18:19:08 +0000
Message-ID: <lsq.1581185940.932320075@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 009/148] workqueue: Fix spurious sanity check
 failures in destroy_workqueue()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit def98c84b6cdf2eeea19ec5736e90e316df5206b upstream.

Before actually destrying a workqueue, destroy_workqueue() checks
whether it's actually idle.  If it isn't, it prints out a bunch of
warning messages and leaves the workqueue dangling.  It unfortunately
has a couple issues.

* Mayday list queueing increments pwq's refcnts which gets detected as
  busy and fails the sanity checks.  However, because mayday list
  queueing is asynchronous, this condition can happen without any
  actual work items left in the workqueue.

* Sanity check failure leaves the sysfs interface behind too which can
  lead to init failure of newer instances of the workqueue.

This patch fixes the above two by

* If a workqueue has a rescuer, disable and kill the rescuer before
  sanity checks.  Disabling and killing is guaranteed to flush the
  existing mayday list.

* Remove sysfs interface before sanity checks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Marcin Pawlowski <mpawlowski@fb.com>
Reported-by: "Williams, Gerald S" <gerald.s.williams@intel.com>
[bwh: Backported to 3.16: destroy_workqueue() also freed wq->rescuer itself]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4266,9 +4266,29 @@ void destroy_workqueue(struct workqueue_
 	struct pool_workqueue *pwq;
 	int node;
 
+	/*
+	 * Remove it from sysfs first so that sanity check failure doesn't
+	 * lead to sysfs name conflicts.
+	 */
+	workqueue_sysfs_unregister(wq);
+
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
 
+	/* kill rescuer, if sanity checks fail, leave it w/o rescuer */
+	if (wq->rescuer) {
+		struct worker *rescuer = wq->rescuer;
+
+		/* this prevents new queueing */
+		spin_lock_irq(&wq_mayday_lock);
+		wq->rescuer = NULL;
+		spin_unlock_irq(&wq_mayday_lock);
+
+		/* rescuer will empty maydays list before exiting */
+		kthread_stop(rescuer->task);
+		kfree(rescuer);
+	}
+
 	/* sanity checks */
 	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq) {
@@ -4298,14 +4318,6 @@ void destroy_workqueue(struct workqueue_
 	list_del_init(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
-	workqueue_sysfs_unregister(wq);
-
-	if (wq->rescuer) {
-		kthread_stop(wq->rescuer->task);
-		kfree(wq->rescuer);
-		wq->rescuer = NULL;
-	}
-
 	if (!(wq->flags & WQ_UNBOUND)) {
 		/*
 		 * The base ref is never dropped on per-cpu pwqs.  Directly

