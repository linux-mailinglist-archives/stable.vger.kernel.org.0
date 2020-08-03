Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABCD23A5C2
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgHCMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgHCMck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:32:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058022054F;
        Mon,  3 Aug 2020 12:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457957;
        bh=VeedW/TdBWMBwomzzS5MbUD45mopZmtJobYBsMLixqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOn8lb1q/36FFdv88tecdPe6XIrQPn9e5gkyLNKA0fNeyftZKoseqDipNLDV0/3vM
         qtfHK83L3NXm5BQOrPIdYzYVHfx/J5j9IuwM7yrZqrnzo0LWQ8W7vCgQqMN3riP+na
         XLOBI3y56WnUdV2pRe7uDhccdm8WEugybp/07X9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Alain Michaud <alainm@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/56] Bluetooth: fix kernel oops in store_pending_adv_report
Date:   Mon,  3 Aug 2020 14:19:58 +0200
Message-Id: <20200803121852.419620562@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit a2ec905d1e160a33b2e210e45ad30445ef26ce0e ]

Fix kernel oops observed when an ext adv data is larger than 31 bytes.

This can be reproduced by setting up an advertiser with advertisement
larger than 31 bytes.  The issue is not sensitive to the advertisement
content.  In particular, this was reproduced with an advertisement of
229 bytes filled with 'A'.  See stack trace below.

This is fixed by not catching ext_adv as legacy adv are only cached to
be able to concatenate a scanable adv with its scan response before
sending it up through mgmt.

With ext_adv, this is no longer necessary.

  general protection fault: 0000 [#1] SMP PTI
  CPU: 6 PID: 205 Comm: kworker/u17:0 Not tainted 5.4.0-37-generic #41-Ubuntu
  Hardware name: Dell Inc. XPS 15 7590/0CF6RR, BIOS 1.7.0 05/11/2020
  Workqueue: hci0 hci_rx_work [bluetooth]
  RIP: 0010:hci_bdaddr_list_lookup+0x1e/0x40 [bluetooth]
  Code: ff ff e9 26 ff ff ff 0f 1f 44 00 00 0f 1f 44 00 00 55 48 8b 07 48 89 e5 48 39 c7 75 0a eb 24 48 8b 00 48 39 f8 74 1c 44 8b 06 <44> 39 40 10 75 ef 44 0f b7 4e 04 66 44 39 48 14 75 e3 38 50 16 75
  RSP: 0018:ffffbc6a40493c70 EFLAGS: 00010286
  RAX: 4141414141414141 RBX: 000000000000001b RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffff9903e76c100f RDI: ffff9904289d4b28
  RBP: ffffbc6a40493c70 R08: 0000000093570362 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff9904344eae38 R12: ffff9904289d4000
  R13: 0000000000000000 R14: 00000000ffffffa3 R15: ffff9903e76c100f
  FS: 0000000000000000(0000) GS:ffff990434580000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007feed125a000 CR3: 00000001b860a003 CR4: 00000000003606e0
  Call Trace:
    process_adv_report+0x12e/0x560 [bluetooth]
    hci_le_meta_evt+0x7b2/0xba0 [bluetooth]
    hci_event_packet+0x1c29/0x2a90 [bluetooth]
    hci_rx_work+0x19b/0x360 [bluetooth]
    process_one_work+0x1eb/0x3b0
    worker_thread+0x4d/0x400
    kthread+0x104/0x140

Fixes: c215e9397b00 ("Bluetooth: Process extended ADV report event")
Reported-by: Andy Nguyen <theflow@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Signed-off-by: Alain Michaud <alainm@chromium.org>
Tested-by: Sonny Sasaka <sonnysasaka@chromium.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a044e6bb12b84..cdb92b129906f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1229,6 +1229,9 @@ static void store_pending_adv_report(struct hci_dev *hdev, bdaddr_t *bdaddr,
 {
 	struct discovery_state *d = &hdev->discovery;
 
+	if (len > HCI_MAX_AD_LENGTH)
+		return;
+
 	bacpy(&d->last_adv_addr, bdaddr);
 	d->last_adv_addr_type = bdaddr_type;
 	d->last_adv_rssi = rssi;
@@ -5116,7 +5119,8 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 
 static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 			       u8 bdaddr_type, bdaddr_t *direct_addr,
-			       u8 direct_addr_type, s8 rssi, u8 *data, u8 len)
+			       u8 direct_addr_type, s8 rssi, u8 *data, u8 len,
+			       bool ext_adv)
 {
 	struct discovery_state *d = &hdev->discovery;
 	struct smp_irk *irk;
@@ -5138,6 +5142,11 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 		return;
 	}
 
+	if (!ext_adv && len > HCI_MAX_AD_LENGTH) {
+		bt_dev_err_ratelimited(hdev, "legacy adv larger than 31 bytes");
+		return;
+	}
+
 	/* Find the end of the data in case the report contains padded zero
 	 * bytes at the end causing an invalid length value.
 	 *
@@ -5197,7 +5206,7 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	 */
 	conn = check_pending_le_conn(hdev, bdaddr, bdaddr_type, type,
 								direct_addr);
-	if (conn && type == LE_ADV_IND) {
+	if (!ext_adv && conn && type == LE_ADV_IND && len <= HCI_MAX_AD_LENGTH) {
 		/* Store report for later inclusion by
 		 * mgmt_device_connected
 		 */
@@ -5251,7 +5260,7 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	 * event or send an immediate device found event if the data
 	 * should not be stored for later.
 	 */
-	if (!has_pending_adv_report(hdev)) {
+	if (!ext_adv &&	!has_pending_adv_report(hdev)) {
 		/* If the report will trigger a SCAN_REQ store it for
 		 * later merging.
 		 */
@@ -5286,7 +5295,8 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 		/* If the new report will trigger a SCAN_REQ store it for
 		 * later merging.
 		 */
-		if (type == LE_ADV_IND || type == LE_ADV_SCAN_IND) {
+		if (!ext_adv && (type == LE_ADV_IND ||
+				 type == LE_ADV_SCAN_IND)) {
 			store_pending_adv_report(hdev, bdaddr, bdaddr_type,
 						 rssi, flags, data, len);
 			return;
@@ -5326,7 +5336,7 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			rssi = ev->data[ev->length];
 			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, rssi,
-					   ev->data, ev->length);
+					   ev->data, ev->length, false);
 		} else {
 			bt_dev_err(hdev, "Dropping invalid advertising data");
 		}
@@ -5400,7 +5410,8 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, ev->rssi,
-					   ev->data, ev->length);
+					   ev->data, ev->length,
+					   !(evt_type & LE_EXT_ADV_LEGACY_PDU));
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
@@ -5598,7 +5609,8 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 
 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 				   ev->bdaddr_type, &ev->direct_addr,
-				   ev->direct_addr_type, ev->rssi, NULL, 0);
+				   ev->direct_addr_type, ev->rssi, NULL, 0,
+				   false);
 
 		ptr += sizeof(*ev);
 	}
-- 
2.25.1



