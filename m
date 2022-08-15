Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A806D59383B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbiHOTJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245709AbiHOTID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:08:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F55713F59;
        Mon, 15 Aug 2022 11:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D4D8B8105D;
        Mon, 15 Aug 2022 18:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB27C433D6;
        Mon, 15 Aug 2022 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588538;
        bh=pbYCv6RDEGne8eUViBB7ET6jX4ALDR2TU5wIWds9bLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgawMHvQfACAUno4lXbX7krSyeDpm/V9dbtS8kxk5EWkVTR2nX07Y/jrAPdzVyf3t
         QeqQCw2vi+ssSyPcalggOr/WKzs9s/W37lBhsFOjsD1J502wPP5QnLSEKCzibhfIN/
         O61fcsYYERL/OpdmPX+KuO5PRQ0u57qesBD2wdQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/779] scsi: iscsi: Add helper to remove a session from the kernel
Date:   Mon, 15 Aug 2022 20:01:20 +0200
Message-Id: <20220815180355.926740196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit bb42856bfd54fda1cbc7c470fcf5db1596938f4f ]

During qedi shutdown we need to stop the iSCSI layer from sending new nops
as pings and from responding to target ones and make sure there is no
running connection cleanups. Commit d1f2ce77638d ("scsi: qedi: Fix host
removal with running sessions") converted the driver to use the libicsi
helper to drive session removal, so the above issues could be handled. The
problem is that during system shutdown iscsid will not be running so when
we try to remove the root session we will hang waiting for userspace to
reply.

Add a helper that will drive the destruction of sessions like these during
system shutdown.

Link: https://lore.kernel.org/r/20220616222738.5722-5-michael.christie@oracle.com
Tested-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 49 +++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 671a03b80c30..f46ae5391758 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2360,6 +2360,55 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
 }
 
+static int iscsi_iter_force_destroy_conn_fn(struct device *dev, void *data)
+{
+	struct iscsi_transport *transport;
+	struct iscsi_cls_conn *conn;
+
+	if (!iscsi_is_conn_dev(dev))
+		return 0;
+
+	conn = iscsi_dev_to_conn(dev);
+	transport = conn->transport;
+
+	if (READ_ONCE(conn->state) != ISCSI_CONN_DOWN)
+		iscsi_if_stop_conn(conn, STOP_CONN_TERM);
+
+	transport->destroy_conn(conn);
+	return 0;
+}
+
+/**
+ * iscsi_force_destroy_session - destroy a session from the kernel
+ * @session: session to destroy
+ *
+ * Force the destruction of a session from the kernel. This should only be
+ * used when userspace is no longer running during system shutdown.
+ */
+void iscsi_force_destroy_session(struct iscsi_cls_session *session)
+{
+	struct iscsi_transport *transport = session->transport;
+	unsigned long flags;
+
+	WARN_ON_ONCE(system_state == SYSTEM_RUNNING);
+
+	spin_lock_irqsave(&sesslock, flags);
+	if (list_empty(&session->sess_list)) {
+		spin_unlock_irqrestore(&sesslock, flags);
+		/*
+		 * Conn/ep is already freed. Session is being torn down via
+		 * async path. For shutdown we don't care about it so return.
+		 */
+		return;
+	}
+	spin_unlock_irqrestore(&sesslock, flags);
+
+	device_for_each_child(&session->dev, NULL,
+			      iscsi_iter_force_destroy_conn_fn);
+	transport->destroy_session(session);
+}
+EXPORT_SYMBOL_GPL(iscsi_force_destroy_session);
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3ecf9702287b..0f2f149ad916 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -441,6 +441,7 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
 						int dd_size,
 						unsigned int target_id);
+extern void iscsi_force_destroy_session(struct iscsi_cls_session *session);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
-- 
2.35.1



