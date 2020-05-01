Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E464F1C1510
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbgEANpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgEANpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DC2A20757;
        Fri,  1 May 2020 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340735;
        bh=0VFc2qRc5hjTtbBiwOHfPCBNfs1qHbsn1ia/UKcpAtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1ZIaJrEOoxiUnW6+w0Tw1MmaOWZTvn2GZJ7Z00xLVCuRyUjJUYqi0MgkOFU1YZzg
         bpraRPw4Y7Nbqjt/7IgjMYwaLOUInqit22J34E7Le0Z3/lLz4WjAYIhepK2WW2qtaV
         6e9Hssdu7ikfICO/ZABNGClo7t5Qq4HJZldeB/ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Yuval Basson <ybason@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 099/106] qed: Fix race condition between scheduling and destroying the slowpath workqueue
Date:   Fri,  1 May 2020 15:24:12 +0200
Message-Id: <20200501131555.143209497@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>

commit 3b85720d3fd72e6ef4de252cd2f67548eb645eb4 upstream.

Calling queue_delayed_work concurrently with
destroy_workqueue might race to an unexpected outcome -
scheduled task after wq is destroyed or other resources
(like ptt_pool) are freed (yields NULL pointer dereference).
cancel_delayed_work prevents the race by cancelling
the timer triggered for scheduling a new task.

Fixes: 59ccf86fe ("qed: Add driver infrastucture for handling mfw requests")
Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/qed/qed_main.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1087,9 +1087,6 @@ static void qed_update_pf_params(struct
 #define QED_PERIODIC_DB_REC_INTERVAL_MS		100
 #define QED_PERIODIC_DB_REC_INTERVAL \
 	msecs_to_jiffies(QED_PERIODIC_DB_REC_INTERVAL_MS)
-#define QED_PERIODIC_DB_REC_WAIT_COUNT		10
-#define QED_PERIODIC_DB_REC_WAIT_INTERVAL \
-	(QED_PERIODIC_DB_REC_INTERVAL_MS / QED_PERIODIC_DB_REC_WAIT_COUNT)
 
 static int qed_slowpath_delayed_work(struct qed_hwfn *hwfn,
 				     enum qed_slowpath_wq_flag wq_flag,
@@ -1123,7 +1120,7 @@ void qed_periodic_db_rec_start(struct qe
 
 static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 {
-	int i, sleep_count = QED_PERIODIC_DB_REC_WAIT_COUNT;
+	int i;
 
 	if (IS_VF(cdev))
 		return;
@@ -1135,13 +1132,7 @@ static void qed_slowpath_wq_stop(struct
 		/* Stop queuing new delayed works */
 		cdev->hwfns[i].slowpath_wq_active = false;
 
-		/* Wait until the last periodic doorbell recovery is executed */
-		while (test_bit(QED_SLOWPATH_PERIODIC_DB_REC,
-				&cdev->hwfns[i].slowpath_task_flags) &&
-		       sleep_count--)
-			msleep(QED_PERIODIC_DB_REC_WAIT_INTERVAL);
-
-		flush_workqueue(cdev->hwfns[i].slowpath_wq);
+		cancel_delayed_work(&cdev->hwfns[i].slowpath_task);
 		destroy_workqueue(cdev->hwfns[i].slowpath_wq);
 	}
 }


