Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F4540E3C9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbhIPQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344866AbhIPQtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6AFB615A2;
        Thu, 16 Sep 2021 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809670;
        bh=5Ig2ASFP7PQhU3grkOm7W7+VUDD0CcVerGaQ3MjpO8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG72mle0fJ+jXGW6xsNaJtqzMO0CTJfsp1wRVKYCB79ynG0elR05XeO0SO53EtMo5
         2HtQYv/7zgR4G2Mtsc9yjImQYbrTT+Z7ouSQbUA7przBwU/A0gIMu/FOEOiecRTBm6
         x/2ErwIXNFc87VXcK9yhO2VRoSx5iaNXxF90yg+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 212/380] Bluetooth: skip invalid hci_sync_conn_complete_evt
Date:   Thu, 16 Sep 2021 17:59:29 +0200
Message-Id: <20210916155811.291549995@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 92fe24a7db751b80925214ede43f8d2be792ea7b ]

Syzbot reported a corrupted list in kobject_add_internal [1]. This
happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
status 0 are sent for the same HCI connection. This causes us to
register the device more than once which corrupts the kset list.

As this is forbidden behavior, we add a check for whether we're
trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
times for one connection. If that's the case, the event is invalid, so
we report an error that the device is misbehaving, and ignore the
packet.

Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 62c99e015609..c5de24372971 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4373,6 +4373,21 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 
 	switch (ev->status) {
 	case 0x00:
+		/* The synchronous connection complete event should only be
+		 * sent once per new connection. Receiving a successful
+		 * complete event when the connection status is already
+		 * BT_CONNECTED means that the device is misbehaving and sent
+		 * multiple complete event packets for the same new connection.
+		 *
+		 * Registering the device more than once can corrupt kernel
+		 * memory, hence upon detecting this invalid event, we report
+		 * an error and ignore the packet.
+		 */
+		if (conn->state == BT_CONNECTED) {
+			bt_dev_err(hdev, "Ignoring connect complete event for existing connection");
+			goto unlock;
+		}
+
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
-- 
2.30.2



