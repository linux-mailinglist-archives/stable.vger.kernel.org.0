Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA31215E1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfLPSSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731753AbfLPSSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95FB206EC;
        Mon, 16 Dec 2019 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520286;
        bh=BzwtY2xumsPIyEzfR5YwTpRvEUUAxhPUzDn13z8ARIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6HM2ZYSpkJhiisEkQs+wQuphpS+nAWY/xENwICncjkOojpMl3yJ024Cs49pcXE8L
         5hQJsAA0kV1x1KVUMo57R/3AhXahogeFojS7pnSTye9E8BQ02q6t7yzzw0XIDLo1K2
         1SxvtruXW5ZTbZiql24BoiwDKkP7ukpGrYnAPIqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Marcin Pawlowski <mpawlowski@fb.com>,
        "Williams, Gerald S" <gerald.s.williams@intel.com>
Subject: [PATCH 5.4 085/177] workqueue: Fix spurious sanity check failures in destroy_workqueue()
Date:   Mon, 16 Dec 2019 18:49:01 +0100
Message-Id: <20191216174838.079405048@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4325,9 +4325,28 @@ void destroy_workqueue(struct workqueue_
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
+	}
+
 	/* sanity checks */
 	mutex_lock(&wq->mutex);
 	for_each_pwq(pwq, wq) {
@@ -4359,11 +4378,6 @@ void destroy_workqueue(struct workqueue_
 	list_del_rcu(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
-	workqueue_sysfs_unregister(wq);
-
-	if (wq->rescuer)
-		kthread_stop(wq->rescuer->task);
-
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq_unregister_lockdep(wq);
 		/*


