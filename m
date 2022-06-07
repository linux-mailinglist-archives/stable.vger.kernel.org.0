Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F10541C62
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382530AbiFGV7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382887AbiFGVwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3B423F7C5;
        Tue,  7 Jun 2022 12:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6EC1B823B0;
        Tue,  7 Jun 2022 19:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19670C385A2;
        Tue,  7 Jun 2022 19:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628995;
        bh=5mxlH3iRHODs8jmDEHc8PYBWsNJAXK9pYlaZ/gdQ2qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psyuNZBFqgyPKua+oxTIWzGbiMo8Ht+MTjeUWsxfqxz+s46OAd4fs6viZxA640n7d
         4AxMBHTpre2M9fs4E/r6bRK5ne4rKv/99eDFaTUmulyTInliI1ZwC+uGJKayH0k/Dp
         jISEjtMuo0anH0NZq/pAo5kVN7PkeF8eMlj0wO1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 530/879] Bluetooth: hci_conn: Fix hci_connect_le_sync
Date:   Tue,  7 Jun 2022 19:00:48 +0200
Message-Id: <20220607165018.258567207@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c9f73a2178c12fb24d2807634209559d6a836e08 ]

The handling of connection failures shall be handled by the request
completion callback as already done by hci_cs_le_create_conn, also make
sure to use hci_conn_failed instead of hci_le_conn_failed as the later
don't actually call hci_conn_del to cleanup.

Link: https://github.com/bluez/bluez/issues/340
Fixes: 8e8b92ee60de5 ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c  | 5 +++--
 net/bluetooth/hci_event.c | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 882a7df13005..ac06c9724c7f 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -943,10 +943,11 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
 	bt_dev_err(hdev, "request failed to create LE connection: err %d", err);
 
-	if (!conn)
+	/* Check if connection is still pending */
+	if (conn != hci_lookup_le_connect(hdev))
 		goto done;
 
-	hci_le_conn_failed(conn, err);
+	hci_conn_failed(conn, err);
 
 done:
 	hci_dev_unlock(hdev);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0270e597c285..af17dfb20e01 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5632,10 +5632,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		status = HCI_ERROR_INVALID_PARAMETERS;
 	}
 
-	if (status) {
-		hci_conn_failed(conn, status);
+	/* All connection failure handling is taken care of by the
+	 * hci_conn_failed function which is triggered by the HCI
+	 * request completion callbacks used for connecting.
+	 */
+	if (status)
 		goto unlock;
-	}
 
 	if (conn->dst_type == ADDR_LE_DEV_PUBLIC)
 		addr_type = BDADDR_LE_PUBLIC;
-- 
2.35.1



