Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F6F505090
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbiDRM0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238714AbiDRM0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3FE65E5;
        Mon, 18 Apr 2022 05:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B19CB80EC4;
        Mon, 18 Apr 2022 12:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6527C385A1;
        Mon, 18 Apr 2022 12:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284396;
        bh=Wx4NCEWlH2dKwa1cDmSNLQyZi3kQ6S5UPpNLcHYn7bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2eJLMrzSBQbNNZO6fHf5Fj+s8Zca0mlYsXuIVSDju07dAzvKTRtvmJfHhxeuSyPB
         wTl0HSgrjGYfolQPzNW5chh4w+M6ezAu/8GcvlvrXpXUGEOY0dlDr8WWmFYAFXYZSp
         VeyJR6ejeXVjFj9gL5a2vLzKSrjoawD52O5KAjFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 101/219] scsi: iscsi: Fix conn cleanup and stop race during iscsid restart
Date:   Mon, 18 Apr 2022 14:11:10 +0200
Message-Id: <20220418121209.680843067@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 7c6e99c18167ed89729bf167ccb4a7e3ab3115ba ]

If iscsid is doing a stop_conn at the same time the kernel is starting
error recovery we can hit a race that allows the cleanup work to run on a
valid connection. In the race, iscsi_if_stop_conn sees the cleanup bit set,
but it calls flush_work on the clean_work before iscsi_conn_error_event has
queued it. The flush then returns before the queueing and so the
cleanup_work can run later and disconnect/stop a conn while it's in a
connected state.

The patch:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

added the late stop_conn call bug originally, and the patch:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

attempted to fix it but only fixed the normal EH case and left the above
race for the iscsid restart case. For the normal EH case we don't hit the
race because we only signal userspace to start recovery after we have done
the queueing, so the flush will always catch the queued work or see it
completed.

For iscsid restart cases like boot, we can hit the race because iscsid will
call down to the kernel before the kernel has signaled any error, so both
code paths can be running at the same time. This adds a lock around the
setting of the cleanup bit and queueing so they happen together.

Link: https://lore.kernel.org/r/20220408001314.5014-6-michael.christie@oracle.com
Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in kernel space")
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 17 +++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4fa2fd7f4c72..ed289e1242c9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2260,9 +2260,12 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 					 bool is_active)
 {
 	/* Check if this was a conn error and the kernel took ownership */
+	spin_lock_irq(&conn->lock);
 	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
 		iscsi_ep_disconnect(conn, is_active);
 	} else {
+		spin_unlock_irq(&conn->lock);
 		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
 
@@ -2309,9 +2312,12 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
+		spin_lock_irq(&conn->lock);
 		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			spin_unlock_irq(&conn->lock);
 			iscsi_stop_conn(conn, flag);
 		} else {
+			spin_unlock_irq(&conn->lock);
 			ISCSI_DBG_TRANS_CONN(conn,
 					     "flush kernel conn cleanup.\n");
 			flush_work(&conn->cleanup_work);
@@ -2320,7 +2326,9 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		 * Only clear for recovery to avoid extra cleanup runs during
 		 * termination.
 		 */
+		spin_lock_irq(&conn->lock);
 		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		spin_unlock_irq(&conn->lock);
 	}
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
 	return 0;
@@ -2341,7 +2349,9 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	 */
 	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
 		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
+		spin_lock_irq(&conn->lock);
 		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		spin_unlock_irq(&conn->lock);
 		mutex_unlock(&conn->ep_mutex);
 		return;
 	}
@@ -2407,6 +2417,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 		conn->dd_data = &conn[1];
 
 	mutex_init(&conn->ep_mutex);
+	spin_lock_init(&conn->lock);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
@@ -2598,9 +2609,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
+	unsigned long flags;
 
+	spin_lock_irqsave(&conn->lock, flags);
 	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
 		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
+	spin_unlock_irqrestore(&conn->lock, flags);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -3743,11 +3757,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	mutex_lock(&conn->ep_mutex);
+	spin_lock_irq(&conn->lock);
 	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
 		mutex_unlock(&conn->ep_mutex);
 		ev->r.retcode = -ENOTCONN;
 		return 0;
 	}
+	spin_unlock_irq(&conn->lock);
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c5d7810fd792..037c77fb5dc5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -211,6 +211,8 @@ struct iscsi_cls_conn {
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	/* Used when accessing flags and queueing work. */
+	spinlock_t lock;
 	unsigned long flags;
 	struct work_struct cleanup_work;
 
-- 
2.35.1



