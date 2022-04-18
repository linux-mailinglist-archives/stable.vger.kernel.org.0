Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93D505092
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiDRM0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiDRMZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CFB65DA;
        Mon, 18 Apr 2022 05:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8225460F0C;
        Mon, 18 Apr 2022 12:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B34C385A1;
        Mon, 18 Apr 2022 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284390;
        bh=X7qBUUgV1LaOs2vD6Ys+38lRH+s//Ob0CYGiP9aS3nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UarzniptMGxljpM24c7syi3qq68HoojlR4B8kdSsAIFQVizA68fXbMUsYoMqd56T8
         aoM0IwSUpA3ZmKLxTcp6eJJR20SIOXhdREaAlEXRB2ig/bLTVkFmsVWnaWkrUxLTJx
         fBDqbSs+zZgDr2gD1iliYZavP4zGWN3njivvDUA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 099/219] scsi: iscsi: Fix offload conn cleanup when iscsid restarts
Date:   Mon, 18 Apr 2022 14:11:08 +0200
Message-Id: <20220418121209.590264608@linuxfoundation.org>
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

[ Upstream commit cbd2283aaf47fef4ded4b29124b1ef3beb515f3a ]

When userspace restarts during boot or upgrades it won't know about the
offload driver's endpoint and connection mappings. iscsid will start by
cleaning up the old session by doing a stop_conn call. Later, if we are
able to create a new connection, we clean up the old endpoint during the
binding stage. The problem is that if we do stop_conn before doing the
ep_disconnect call offload, drivers can still be executing I/O. We then
might free tasks from the under the card/driver.

This moves the ep_disconnect call to before we do the stop_conn call for
this case. It will then work and look like a normal recovery/cleanup
procedure from the driver's point of view.

Link: https://lore.kernel.org/r/20220408001314.5014-3-michael.christie@oracle.com
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 48 +++++++++++++++++------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 126f6f23bffa..03cda2da80ef 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2255,6 +2255,23 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
 	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
 }
 
+static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
+					 struct iscsi_endpoint *ep,
+					 bool is_active)
+{
+	/* Check if this was a conn error and the kernel took ownership */
+	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		iscsi_ep_disconnect(conn, is_active);
+	} else {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
+		mutex_unlock(&conn->ep_mutex);
+
+		flush_work(&conn->cleanup_work);
+
+		mutex_lock(&conn->ep_mutex);
+	}
+}
+
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2275,6 +2292,16 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		cancel_work_sync(&conn->cleanup_work);
 		iscsi_stop_conn(conn, flag);
 	} else {
+		/*
+		 * For offload, when iscsid is restarted it won't know about
+		 * existing endpoints so it can't do a ep_disconnect. We clean
+		 * it up here for userspace.
+		 */
+		mutex_lock(&conn->ep_mutex);
+		if (conn->ep)
+			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
+		mutex_unlock(&conn->ep_mutex);
+
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
@@ -3003,16 +3030,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	mutex_lock(&conn->ep_mutex);
-	/* Check if this was a conn error and the kernel took ownership */
-	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
-		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
-		mutex_unlock(&conn->ep_mutex);
-
-		flush_work(&conn->cleanup_work);
-		goto put_ep;
-	}
-
-	iscsi_ep_disconnect(conn, false);
+	iscsi_if_disconnect_bound_ep(conn, ep, false);
 	mutex_unlock(&conn->ep_mutex);
 put_ep:
 	iscsi_put_endpoint(ep);
@@ -3723,16 +3741,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
-		if (conn->ep) {
-			/*
-			 * For offload boot support where iscsid is restarted
-			 * during the pivot root stage, the ep will be intact
-			 * here when the new iscsid instance starts up and
-			 * reconnects.
-			 */
-			iscsi_ep_disconnect(conn, true);
-		}
-
 		session = iscsi_session_lookup(ev->u.b_conn.sid);
 		if (!session) {
 			err = -EINVAL;
-- 
2.35.1



