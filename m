Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480B549967F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbiAXVE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52752 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443929AbiAXU7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A80776131F;
        Mon, 24 Jan 2022 20:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAA1C340E5;
        Mon, 24 Jan 2022 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057975;
        bh=fvSo4k2DvJm5t6/jjMZlDtic3DNw8fsnPxhjZI0j8sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGhRZg4HifZEzRNNdokwj7TVtnkmiltIyfk4hRqMNOgS89CRi9x86+dKsjSiqYHM0
         a4kak+wCK5wt+gHUxpdS5RAlcPjFAtCbYiwUR68da1MlxcJyVrngZJpGB+9UphcM/X
         0AQu9UDf13vj29V8Ef3L3iYkdas97ewGfeGIBjRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0140/1039] Bluetooth: fix uninitialized variables notify_evt
Date:   Mon, 24 Jan 2022 19:32:09 +0100
Message-Id: <20220124184129.882767912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit a27c519a816437ec92f0ffa3adbc168c2c08725b ]

Coverity Scan report:

[...]
*** CID 1493985:  Uninitialized variables  (UNINIT)
/net/bluetooth/hci_event.c: 4535 in hci_sync_conn_complete_evt()
4529
4530     	/* Notify only in case of SCO over HCI transport data path which
4531     	 * is zero and non-zero value shall be non-HCI transport data path
4532     	 */
4533     	if (conn->codec.data_path == 0) {
4534     		if (hdev->notify)
>>>     CID 1493985:  Uninitialized variables  (UNINIT)
>>>     Using uninitialized value "notify_evt" when calling "*hdev->notify".
4535     			hdev->notify(hdev, notify_evt);
4536     	}
4537
4538     	hci_connect_cfm(conn, ev->status);
4539     	if (ev->status)
4540     		hci_conn_del(conn);
[...]

Although only btusb uses air_mode, and he only handles HCI_NOTIFY_ENABLE_SCO_CVSD
and HCI_NOTIFY_ENABLE_SCO_TRANSP, there is still a very small chance that
ev->air_mode is not equal to 0x2 and 0x3, but notify_evt is initialized to
HCI_NOTIFY_ENABLE_SCO_CVSD or HCI_NOTIFY_ENABLE_SCO_TRANSP. the context is
maybe not correct.

Let us directly use the required function instead of re-initializing it,
so as to restore the original logic and make the code more correct.

Addresses-Coverity: ("Uninitialized variables")
Fixes: f4f9fa0c07bb ("Bluetooth: Allow usb to auto-suspend when SCO use	non-HCI transport")
Suggested-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 59f0691d907f6..6eba439487749 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4445,7 +4445,6 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 {
 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
 	struct hci_conn *conn;
-	unsigned int notify_evt;
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
@@ -4517,22 +4516,18 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 	}
 
 	bt_dev_dbg(hdev, "SCO connected with air mode: %02x", ev->air_mode);
-
-	switch (ev->air_mode) {
-	case 0x02:
-		notify_evt = HCI_NOTIFY_ENABLE_SCO_CVSD;
-		break;
-	case 0x03:
-		notify_evt = HCI_NOTIFY_ENABLE_SCO_TRANSP;
-		break;
-	}
-
 	/* Notify only in case of SCO over HCI transport data path which
 	 * is zero and non-zero value shall be non-HCI transport data path
 	 */
-	if (conn->codec.data_path == 0) {
-		if (hdev->notify)
-			hdev->notify(hdev, notify_evt);
+	if (conn->codec.data_path == 0 && hdev->notify) {
+		switch (ev->air_mode) {
+		case 0x02:
+			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_CVSD);
+			break;
+		case 0x03:
+			hdev->notify(hdev, HCI_NOTIFY_ENABLE_SCO_TRANSP);
+			break;
+		}
 	}
 
 	hci_connect_cfm(conn, ev->status);
-- 
2.34.1



