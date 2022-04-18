Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8CD5052A2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiDRMuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiDRMrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8386C2A26F;
        Mon, 18 Apr 2022 05:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED7961170;
        Mon, 18 Apr 2022 12:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7880C385A1;
        Mon, 18 Apr 2022 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285198;
        bh=P0PpmTVT7Y/0AiX7WMNDTCG8Gq3all5OStnnOrkDWLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG4ELV+qtHUJImO9isC0uvFFPgWBybcQ5swbxw6eMlk0bCvv7PPB54pO8KJTqMZ9A
         +f71Qk8DI3+cT8pUfaXMhctMvRZIGTMlzt9uXwjlpcLUTEJLUbtnyn337qasW42TDn
         Rl/X2HN36y+o+WrVKJEFbDpcAZDDB8J5IhwbxNvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/189] scsi: iscsi: Fix unbound endpoint error handling
Date:   Mon, 18 Apr 2022 14:11:45 +0200
Message-Id: <20220418121202.920066676@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 03690d81974535f228e892a14f0d2d44404fe555 ]

If a driver raises a connection error before the connection is bound, we
can leave a cleanup_work queued that can later run and disconnect/stop a
connection that is logged in. The problem is that drivers can call
iscsi_conn_error_event for endpoints that are connected but not yet bound
when something like the network port they are using is brought down.
iscsi_cleanup_conn_work_fn will check for this and exit early, but if the
cleanup_work is stuck behind other works, it might not get run until after
userspace has done ep_disconnect. Because the endpoint is not yet bound
there was no way for ep_disconnect to flush the work.

The bug of leaving stop_conns queued was added in:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

and:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

was supposed to fix it, but left this case.

This patch moves the conn state check to before we even queue the work so
we can avoid queueing.

Link: https://lore.kernel.org/r/20220408001314.5014-7-michael.christie@oracle.com
Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in kernel space")
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 65 ++++++++++++++++-------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ed289e1242c9..c7b1b2e8bb02 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2221,10 +2221,10 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 
 	switch (flag) {
 	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
+		WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
 		break;
 	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
+		WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 		break;
 	default:
 		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
@@ -2242,7 +2242,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
 	struct iscsi_endpoint *ep;
 
 	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
+	WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
 
 	if (!conn->ep || !session->transport->ep_disconnect)
 		return;
@@ -2341,21 +2341,6 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
 
 	mutex_lock(&conn->ep_mutex);
-	/*
-	 * If we are not at least bound there is nothing for us to do. Userspace
-	 * will do a ep_disconnect call if offload is used, but will not be
-	 * doing a stop since there is nothing to clean up, so we have to clear
-	 * the cleanup bit here.
-	 */
-	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
-		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
-		spin_lock_irq(&conn->lock);
-		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
-		spin_unlock_irq(&conn->lock);
-		mutex_unlock(&conn->ep_mutex);
-		return;
-	}
-
 	/*
 	 * Get a ref to the ep, so we don't release its ID until after
 	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
@@ -2422,7 +2407,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
-	conn->state = ISCSI_CONN_DOWN;
+	WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
@@ -2610,10 +2595,30 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
 	unsigned long flags;
+	int state;
 
 	spin_lock_irqsave(&conn->lock, flags);
-	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
-		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
+	/*
+	 * Userspace will only do a stop call if we are at least bound. And, we
+	 * only need to do the in kernel cleanup if in the UP state so cmds can
+	 * be released to upper layers. If in other states just wait for
+	 * userspace to avoid races that can leave the cleanup_work queued.
+	 */
+	state = READ_ONCE(conn->state);
+	switch (state) {
+	case ISCSI_CONN_BOUND:
+	case ISCSI_CONN_UP:
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
+				      &conn->flags)) {
+			queue_work(iscsi_conn_cleanup_workq,
+				   &conn->cleanup_work);
+		}
+		break;
+	default:
+		ISCSI_DBG_TRANS_CONN(conn, "Got conn error in state %d\n",
+				     state);
+		break;
+	}
 	spin_unlock_irqrestore(&conn->lock, flags);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
@@ -2964,7 +2969,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
-	int err = 0, value = 0;
+	int err = 0, value = 0, state;
 
 	if (ev->u.set_param.len > PAGE_SIZE)
 		return -EINVAL;
@@ -2981,8 +2986,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		if ((conn->state == ISCSI_CONN_BOUND) ||
-			(conn->state == ISCSI_CONN_UP)) {
+		state = READ_ONCE(conn->state);
+		if (state == ISCSI_CONN_BOUND || state == ISCSI_CONN_UP) {
 			err = transport->set_param(conn, ev->u.set_param.param,
 					data, ev->u.set_param.len);
 		} else {
@@ -3778,7 +3783,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
+			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
 
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
@@ -3797,7 +3802,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_START_CONN:
 		ev->r.retcode = transport->start_conn(conn);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_UP;
+			WRITE_ONCE(conn->state, ISCSI_CONN_UP);
+
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
 		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
@@ -4105,10 +4111,11 @@ static ssize_t show_conn_state(struct device *dev,
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
 	const char *state = "unknown";
+	int conn_state = READ_ONCE(conn->state);
 
-	if (conn->state >= 0 &&
-	    conn->state < ARRAY_SIZE(connection_state_names))
-		state = connection_state_names[conn->state];
+	if (conn_state >= 0 &&
+	    conn_state < ARRAY_SIZE(connection_state_names))
+		state = connection_state_names[conn_state];
 
 	return sysfs_emit(buf, "%s\n", state);
 }
-- 
2.35.1



