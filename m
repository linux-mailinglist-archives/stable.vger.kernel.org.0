Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB529B8E6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802086AbgJ0Ppd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799324AbgJ0Pay (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9180B22264;
        Tue, 27 Oct 2020 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812654;
        bh=wuIaM2CmiHRjiOtfYcKoTk+UZHm/HJtytqCMTs4z1YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDld+HvqCD0XjZjkwYj8GPhdM6AiW4QpNPD/6LQ2Vn8raqE2AcJy2sdwKtF5I9uch
         gJgxcwdjg1f+JTV4/2BdBYEENkDHODPOy2raK7kW5zzv9S3VCfvqivu3EVJUZCEIhl
         DqvIMHKxLQR+//9BBxfpzxGAauD+g8OytxrbU4ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sonny Sasaka <sonnysasaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 285/757] Bluetooth: Fix auto-creation of hci_conn at Conn Complete event
Date:   Tue, 27 Oct 2020 14:48:55 +0100
Message-Id: <20201027135503.940820980@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sonny Sasaka <sonnysasaka@chromium.org>

[ Upstream commit a46b7ed4d52d09bd6c7ab53b2217d04fc2f02c65 ]

Currently the code auto-creates hci_conn only if the remote address has
been discovered before. This may not be the case. For example, the
remote device may trigger connection after reboot at already-paired
state so there is no inquiry result found, but it is still correct to
create the hci_conn when Connection Complete event is received.

A better guard is to check against bredr allowlist. Devices in the
allowlist have been given permission to auto-connect.

Fixes: 4f40afc6c764 ("Bluetooth: Handle BR/EDR devices during suspend")
Signed-off-by: Sonny Sasaka <sonnysasaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793cf..7cf42b9d3dfc8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2569,7 +2569,6 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_ev_conn_complete *ev = (void *) skb->data;
-	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 
 	BT_DBG("%s", hdev->name);
@@ -2578,13 +2577,19 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
 	if (!conn) {
-		/* Connection may not exist if auto-connected. Check the inquiry
-		 * cache to see if we've already discovered this bdaddr before.
-		 * If found and link is an ACL type, create a connection class
+		/* Connection may not exist if auto-connected. Check the bredr
+		 * allowlist to see if this device is allowed to auto connect.
+		 * If link is an ACL type, create a connection class
 		 * automatically.
+		 *
+		 * Auto-connect will only occur if the event filter is
+		 * programmed with a given address. Right now, event filter is
+		 * only used during suspend.
 		 */
-		ie = hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
-		if (ie && ev->link_type == ACL_LINK) {
+		if (ev->link_type == ACL_LINK &&
+		    hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+						      &ev->bdaddr,
+						      BDADDR_BREDR)) {
 			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
 					    HCI_ROLE_SLAVE);
 			if (!conn) {
-- 
2.25.1



