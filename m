Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C462D3C4A55
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhGLGwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236630AbhGLGsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BC860241;
        Mon, 12 Jul 2021 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072248;
        bh=fJO6K/xonleVd18X5pk4q2CWZ6W+rfCbbIpWMG4HWSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCxZK+QtYqUg2V2cUYteOTDC624Fv6eqWtaJ+rL3qRg3646WOL8elqvJjgBRpgfyA
         ux71ZnMQmn8Kd306boIVrfGbIHNUW7PLSbtCjtnJmKQthfPCFz6ucugsXnWUTX5mAl
         PPEZZP5OkVvOIzkeLHpKsjPdSkBAIPvbjOqHz4mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/593] Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event
Date:   Mon, 12 Jul 2021 08:09:36 +0200
Message-Id: <20210712060933.856111017@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 23837a6d7a1a61818ed94a6b8af552d6cf7d32d5 ]

Error status of this event means that it has ended due reasons other
than a connection:

 'If advertising has terminated as a result of the advertising duration
 elapsing, the Status parameter shall be set to the error code
 Advertising Timeout (0x3C).'

 'If advertising has terminated because the
 Max_Extended_Advertising_Events was reached, the Status parameter
 shall be set to the error code Limit Reached (0x43).'

Fixes: acf0aeae431a0 ("Bluetooth: Handle ADv set terminated event")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20f17d312596..d62ac4b73709 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5256,8 +5256,19 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
-	if (ev->status)
+	if (ev->status) {
+		struct adv_info *adv;
+
+		adv = hci_find_adv_instance(hdev, ev->handle);
+		if (!adv)
+			return;
+
+		/* Remove advertising as it has been terminated */
+		hci_remove_adv_instance(hdev, ev->handle);
+		mgmt_advertising_removed(NULL, hdev, ev->handle);
+
 		return;
+	}
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->conn_handle));
 	if (conn) {
-- 
2.30.2



