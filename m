Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF850779C
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356431AbiDSSQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356446AbiDSSPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962633D1E8;
        Tue, 19 Apr 2022 11:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A70D60DF3;
        Tue, 19 Apr 2022 18:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D51FC385A7;
        Tue, 19 Apr 2022 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391933;
        bh=M6RhXLMmz2S6qMvA0PcSqI2yybCtTdtl2N6YoFyDWec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKjYJcU9s9fWEEe7kLWyM4A+mzxMnezeTZz2NB4hm+OhFrDi72YtjvlpQTc9zmUkl
         afagoMfqBbNePVDwyGiva9futEXJaI9RLPZsEUMdDcvg2g27TDkZN70etdhy8cOAMu
         M4U0AdTcx2uV6YgSt5Pf7bmYyuDM0CjJ1qdS2bAsNo6X2rLF2wSkUAawwZYgo1+oqP
         Qmt9SJ5lSZRdeu4k9723SEu24P/fJIcaTj4YQQD0h5UtH6T1q89xl0yfO0IvMbkUDz
         X9/euS64jty1gUqykwE1m9aapARTpKQd1VOmLGZW75VwA8foebtVtQdYf+ha/FwjzL
         MTFEVgBk2GewQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 22/34] scsi: iscsi: Move iscsi_ep_disconnect()
Date:   Tue, 19 Apr 2022 14:10:49 -0400
Message-Id: <20220419181104.484667-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit c34f95e98d8fb750eefd4f3fe58b4f8b5e89253b ]

This patch moves iscsi_ep_disconnect() so it can be called earlier in the
next patch.

Link: https://lore.kernel.org/r/20220408001314.5014-2-michael.christie@oracle.com
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 554b6f784223..126f6f23bffa 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2236,6 +2236,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
 }
 
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	conn->state = ISCSI_CONN_FAILED;
+
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2276,25 +2295,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 	return 0;
 }
 
-static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
-{
-	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
-	struct iscsi_endpoint *ep;
-
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
-
-	if (!conn->ep || !session->transport->ep_disconnect)
-		return;
-
-	ep = conn->ep;
-	conn->ep = NULL;
-
-	session->transport->unbind_conn(conn, is_active);
-	session->transport->ep_disconnect(ep);
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
-}
-
 static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 {
 	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
-- 
2.35.1

