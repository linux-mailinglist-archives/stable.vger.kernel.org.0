Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4266E63D7
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjDRMnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjDRMnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D671118D1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3758663363
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45413C433D2;
        Tue, 18 Apr 2023 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821820;
        bh=lpMZDMt2ao635UMlLATj4ifpFqIiLAuCX/em97Ah2z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBWRSgYljAP+Te72alckdLQnok1DErX8asOLV32zOaNl13oiM4+HHw6GFEVZqgGN0
         4R9mMW/1WSEv5gkwn3z+euO3mxxBrPKBA5JsvbK+ApP/ulIUitN0Tm4fYUkBGMqH1H
         hvBpZwC541LYd5CQNSwrDLpM7xB/TFG79dJw+d+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/134] Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure
Date:   Tue, 18 Apr 2023 14:21:50 +0200
Message-Id: <20230418120314.825408460@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 19cf60bf63cbaf5262eac400c707966e19999b83 ]

hci_connect_le_scan_cleanup shall always be invoked to cleanup the
states and re-enable passive scanning if necessary, otherwise it may
cause the pending action to stay active causing multiple attempts to
connect.

Fixes: 9b3628d79b46 ("Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 52 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6265614c748f8..1b80d94d639cc 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -68,7 +68,7 @@ static const struct sco_param esco_param_msbc[] = {
 };
 
 /* This function requires the caller holds hdev->lock */
-static void hci_connect_le_scan_cleanup(struct hci_conn *conn)
+static void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
 {
 	struct hci_conn_params *params;
 	struct hci_dev *hdev = conn->hdev;
@@ -88,9 +88,28 @@ static void hci_connect_le_scan_cleanup(struct hci_conn *conn)
 
 	params = hci_pend_le_action_lookup(&hdev->pend_le_conns, bdaddr,
 					   bdaddr_type);
-	if (!params || !params->explicit_connect)
+	if (!params)
 		return;
 
+	if (params->conn) {
+		hci_conn_drop(params->conn);
+		hci_conn_put(params->conn);
+		params->conn = NULL;
+	}
+
+	if (!params->explicit_connect)
+		return;
+
+	/* If the status indicates successful cancellation of
+	 * the attempt (i.e. Unknown Connection Id) there's no point of
+	 * notifying failure since we'll go back to keep trying to
+	 * connect. The only exception is explicit connect requests
+	 * where a timeout + cancel does indicate an actual failure.
+	 */
+	if (status && status != HCI_ERROR_UNKNOWN_CONN_ID)
+		mgmt_connect_failed(hdev, &conn->dst, conn->type,
+				    conn->dst_type, status);
+
 	/* The connection attempt was doing scan for new RPA, and is
 	 * in scan phase. If params are not associated with any other
 	 * autoconnect action, remove them completely. If they are, just unmark
@@ -178,7 +197,7 @@ static void le_scan_cleanup(struct work_struct *work)
 	rcu_read_unlock();
 
 	if (c == conn) {
-		hci_connect_le_scan_cleanup(conn);
+		hci_connect_le_scan_cleanup(conn, 0x00);
 		hci_conn_cleanup(conn);
 	}
 
@@ -1193,31 +1212,8 @@ EXPORT_SYMBOL(hci_get_route);
 static void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 {
 	struct hci_dev *hdev = conn->hdev;
-	struct hci_conn_params *params;
 
-	params = hci_pend_le_action_lookup(&hdev->pend_le_conns, &conn->dst,
-					   conn->dst_type);
-	if (params && params->conn) {
-		hci_conn_drop(params->conn);
-		hci_conn_put(params->conn);
-		params->conn = NULL;
-	}
-
-	/* If the status indicates successful cancellation of
-	 * the attempt (i.e. Unknown Connection Id) there's no point of
-	 * notifying failure since we'll go back to keep trying to
-	 * connect. The only exception is explicit connect requests
-	 * where a timeout + cancel does indicate an actual failure.
-	 */
-	if (status != HCI_ERROR_UNKNOWN_CONN_ID ||
-	    (params && params->explicit_connect))
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
-
-	/* Since we may have temporarily stopped the background scanning in
-	 * favor of connection establishment, we should restart it.
-	 */
-	hci_update_passive_scan(hdev);
+	hci_connect_le_scan_cleanup(conn, status);
 
 	/* Enable advertising in case this was a failed connection
 	 * attempt as a peripheral.
@@ -1254,7 +1250,7 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 	hci_dev_lock(hdev);
 
 	if (!err) {
-		hci_connect_le_scan_cleanup(conn);
+		hci_connect_le_scan_cleanup(conn, 0x00);
 		goto done;
 	}
 
-- 
2.39.2



