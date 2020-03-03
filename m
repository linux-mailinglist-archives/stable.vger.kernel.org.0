Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71739178104
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgCCSAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387724AbgCCSAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A394720870;
        Tue,  3 Mar 2020 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258404;
        bh=1BLt8yG0Ib8eC2ZyKs4srI96G0OIxxlYaqLtkkZ1u7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16jB1eGI0RI6EZ/VjsBRSMI3gvYsXUc/R++H5jeQ/Lt7192BTujU+fvlx/1HB/Vvj
         xtfsdZR2OgyU6zz4V/z4Km6bioT7kwG/0EdM3GriRR6+J7K7mWk2SV0bW6rBHHlULU
         94qLP36T2IR/WXtdu30W6O/COpxn6ulQa9JYIyKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 37/87] qede: Fix race between rdma destroy workqueue and link change event
Date:   Tue,  3 Mar 2020 18:43:28 +0100
Message-Id: <20200303174353.848357265@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit af6565adb02d3129d3fae4d9d5da945abaf4417a ]

If an event is added while the rdma workqueue is being destroyed
it could lead to several races, list corruption, null pointer
dereference during queue_work or init_queue.
This fixes the race between the two flows which can occur during
shutdown.

A kref object and a completion object are added to the rdma_dev
structure, these are initialized before the workqueue is created.
The refcnt is used to indicate work is being added to the
workqueue and ensures the cleanup flow won't start while we're in
the middle of adding the event.
Once the work is added, the refcnt is decreased and the cleanup flow
is safe to run.

Fixes: cee9fbd8e2e ("qede: Add qedr framework")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |    2 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c |   29 ++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -162,6 +162,8 @@ struct qede_rdma_dev {
 	struct list_head entry;
 	struct list_head rdma_event_list;
 	struct workqueue_struct *rdma_wq;
+	struct kref refcnt;
+	struct completion event_comp;
 };
 
 struct qede_ptp;
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -57,6 +57,9 @@ static void _qede_rdma_dev_add(struct qe
 static int qede_rdma_create_wq(struct qede_dev *edev)
 {
 	INIT_LIST_HEAD(&edev->rdma_info.rdma_event_list);
+	kref_init(&edev->rdma_info.refcnt);
+	init_completion(&edev->rdma_info.event_comp);
+
 	edev->rdma_info.rdma_wq = create_singlethread_workqueue("rdma_wq");
 	if (!edev->rdma_info.rdma_wq) {
 		DP_NOTICE(edev, "qedr: Could not create workqueue\n");
@@ -81,8 +84,23 @@ static void qede_rdma_cleanup_event(stru
 	}
 }
 
+static void qede_rdma_complete_event(struct kref *ref)
+{
+	struct qede_rdma_dev *rdma_dev =
+		container_of(ref, struct qede_rdma_dev, refcnt);
+
+	/* no more events will be added after this */
+	complete(&rdma_dev->event_comp);
+}
+
 static void qede_rdma_destroy_wq(struct qede_dev *edev)
 {
+	/* Avoid race with add_event flow, make sure it finishes before
+	 * we start accessing the list and cleaning up the work
+	 */
+	kref_put(&edev->rdma_info.refcnt, qede_rdma_complete_event);
+	wait_for_completion(&edev->rdma_info.event_comp);
+
 	qede_rdma_cleanup_event(edev);
 	destroy_workqueue(edev->rdma_info.rdma_wq);
 }
@@ -287,15 +305,24 @@ static void qede_rdma_add_event(struct q
 	if (!edev->rdma_info.qedr_dev)
 		return;
 
+	/* We don't want the cleanup flow to start while we're allocating and
+	 * scheduling the work
+	 */
+	if (!kref_get_unless_zero(&edev->rdma_info.refcnt))
+		return; /* already being destroyed */
+
 	event_node = qede_rdma_get_free_event_node(edev);
 	if (!event_node)
-		return;
+		goto out;
 
 	event_node->event = event;
 	event_node->ptr = edev;
 
 	INIT_WORK(&event_node->work, qede_rdma_handle_event);
 	queue_work(edev->rdma_info.rdma_wq, &event_node->work);
+
+out:
+	kref_put(&edev->rdma_info.refcnt, qede_rdma_complete_event);
 }
 
 void qede_rdma_dev_event_open(struct qede_dev *edev)


