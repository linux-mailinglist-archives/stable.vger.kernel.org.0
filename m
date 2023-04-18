Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805B76E6485
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjDRMt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjDRMt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA24E15A20
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B74263401
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513F7C433D2;
        Tue, 18 Apr 2023 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822190;
        bh=rpIu45qBzPZdf7AeMeZ1VRAqIeATZBw+5EFE9WnFHdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqE5UDFEw5YIhvzt/UlMjB5fq7g2yEF4eGFBm2kQmv0Fd5XlGJN0XKn3YWAZ1n7ri
         vy+ofP9CDdUgq3xxAeKHQhlqs85xXe4JcxHC8yHfOaMhuFUpiEM3k1FpQcgDq1z5x0
         NyU+9Q69CsRck0UVbVhWvWfsj3Hr9EHeU5RpJoYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 056/139] Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure
Date:   Tue, 18 Apr 2023 14:22:01 +0200
Message-Id: <20230418120315.857275498@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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
index 17baea2bc1924..6fbc1fe7b1dcb 100644
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
 
@@ -1191,31 +1210,8 @@ EXPORT_SYMBOL(hci_get_route);
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
@@ -1252,7 +1248,7 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 	hci_dev_lock(hdev);
 
 	if (!err) {
-		hci_connect_le_scan_cleanup(conn);
+		hci_connect_le_scan_cleanup(conn, 0x00);
 		goto done;
 	}
 
-- 
2.39.2



