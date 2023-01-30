Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49B0681000
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbjA3N6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjA3N6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:58:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004FB1BADA
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38DE06102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F022C433D2;
        Mon, 30 Jan 2023 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087092;
        bh=go/GMPLJj0FYMB9tHn2SlAK73+0LYf+9GD3NCEnabgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtKfoPFuZicWBwdHGVryXWdZYGRi1GN4nXztbvrMFfqzLPCVkOfEAdW1veCMJae4l
         W0t7Jtnnt2V//QsM6FtuHKBVMPs0LvXRekvoJIAqfEl5GnOcQAIgcQsCSey4HK5+Kf
         uL8Nd+TmsqSPzoE+LU+WUhUlrxay2tdv+HbEMGV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Jack Pham <quic_jackp@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/313] usb: ucsi: Ensure connector delayed work items are flushed
Date:   Mon, 30 Jan 2023 14:48:49 +0100
Message-Id: <20230130134341.018424651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <quic_jackp@quicinc.com>

[ Upstream commit fac4b8633fd682ecc8e9cff61cb3e33374a1c7e5 ]

During ucsi_unregister() when destroying a connector's workqueue, there
may still be pending delayed work items that haven't been scheduled yet.
Because queue_delayed_work() uses a separate timer to schedule a work
item, the destroy_workqueue() call is not aware of any pending items.
Hence when a pending item's timer expires it would then try to queue on
a dangling workqueue pointer.

Fix this by keeping track of all work items in a list, so that prior to
destroying the workqueue any pending items can be flushed.  Do this by
calling mod_delayed_work() as that will cause pending items to get
queued immediately, which then allows the ensuing destroy_workqueue() to
implicitly drain all currently queued items to completion and free
themselves.

Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Co-developed-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230110071218.26261-1-quic_jackp@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 24 +++++++++++++++++++++---
 drivers/usb/typec/ucsi/ucsi.h |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index eabe519013e7..1292241d581a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -187,6 +187,7 @@ EXPORT_SYMBOL_GPL(ucsi_send_command);
 
 struct ucsi_work {
 	struct delayed_work work;
+	struct list_head node;
 	unsigned long delay;
 	unsigned int count;
 	struct ucsi_connector *con;
@@ -202,6 +203,7 @@ static void ucsi_poll_worker(struct work_struct *work)
 	mutex_lock(&con->lock);
 
 	if (!con->partner) {
+		list_del(&uwork->node);
 		mutex_unlock(&con->lock);
 		kfree(uwork);
 		return;
@@ -209,10 +211,12 @@ static void ucsi_poll_worker(struct work_struct *work)
 
 	ret = uwork->cb(con);
 
-	if (uwork->count-- && (ret == -EBUSY || ret == -ETIMEDOUT))
+	if (uwork->count-- && (ret == -EBUSY || ret == -ETIMEDOUT)) {
 		queue_delayed_work(con->wq, &uwork->work, uwork->delay);
-	else
+	} else {
+		list_del(&uwork->node);
 		kfree(uwork);
+	}
 
 	mutex_unlock(&con->lock);
 }
@@ -236,6 +240,7 @@ static int ucsi_partner_task(struct ucsi_connector *con,
 	uwork->con = con;
 	uwork->cb = cb;
 
+	list_add_tail(&uwork->node, &con->partner_tasks);
 	queue_delayed_work(con->wq, &uwork->work, delay);
 
 	return 0;
@@ -1056,6 +1061,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	INIT_WORK(&con->work, ucsi_handle_connector_change);
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
+	INIT_LIST_HEAD(&con->partner_tasks);
 	con->num = index + 1;
 	con->ucsi = ucsi;
 
@@ -1420,8 +1426,20 @@ void ucsi_unregister(struct ucsi *ucsi)
 		ucsi_unregister_altmodes(&ucsi->connector[i],
 					 UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(&ucsi->connector[i]);
-		if (ucsi->connector[i].wq)
+
+		if (ucsi->connector[i].wq) {
+			struct ucsi_work *uwork;
+
+			mutex_lock(&ucsi->connector[i].lock);
+			/*
+			 * queue delayed items immediately so they can execute
+			 * and free themselves before the wq is destroyed
+			 */
+			list_for_each_entry(uwork, &ucsi->connector[i].partner_tasks, node)
+				mod_delayed_work(ucsi->connector[i].wq, &uwork->work, 0);
+			mutex_unlock(&ucsi->connector[i].lock);
 			destroy_workqueue(ucsi->connector[i].wq);
+		}
 		typec_unregister_port(ucsi->connector[i].port);
 	}
 
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index c968474ee547..60ce9fb6e745 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -322,6 +322,7 @@ struct ucsi_connector {
 	struct work_struct work;
 	struct completion complete;
 	struct workqueue_struct *wq;
+	struct list_head partner_tasks;
 
 	struct typec_port *port;
 	struct typec_partner *partner;
-- 
2.39.0



