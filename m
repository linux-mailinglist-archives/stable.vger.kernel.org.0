Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6FD290091
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405375AbgJPJHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405360AbgJPJHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:07:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BA2E20848;
        Fri, 16 Oct 2020 09:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839224;
        bh=He7kd/IWKk9HXeLmeyxEBnZSNgvB3+Usi8G4fnEe6Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ye6FswX490LZqD/8VQJo5YZkQzu/ybEzcIJ4EUb2sOt422g1LieBuJPfHfcK+MXst
         dWZols0KVnFkYw1IJykthsRkHykrUgWRGrGtVMhh1bSdbniqVEb7cxUdAh2idDYkrN
         vPCFeKlKxyFmWudBdnKH9cSlGuAC0jAoEvtElfs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Alain Michaud <alainm@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 03/16] Bluetooth: fix kernel oops in store_pending_adv_report
Date:   Fri, 16 Oct 2020 11:06:56 +0200
Message-Id: <20201016090435.598270778@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

commit a2ec905d1e160a33b2e210e45ad30445ef26ce0e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1133,6 +1133,9 @@ static void store_pending_adv_report(str
 {
 	struct discovery_state *d = &hdev->discovery;
 
+	if (len > HCI_MAX_AD_LENGTH)
+		return;
+
 	bacpy(&d->last_adv_addr, bdaddr);
 	d->last_adv_addr_type = bdaddr_type;
 	d->last_adv_rssi = rssi;
@@ -4752,6 +4755,11 @@ static void process_adv_report(struct hc
 	u32 flags;
 	u8 *ptr, real_len;
 
+	if (len > HCI_MAX_AD_LENGTH) {
+		pr_err_ratelimited("legacy adv larger than 31 bytes");
+		return;
+	}
+
 	/* Find the end of the data in case the report contains padded zero
 	 * bytes at the end causing an invalid length value.
 	 *
@@ -4812,7 +4820,7 @@ static void process_adv_report(struct hc
 	 */
 	conn = check_pending_le_conn(hdev, bdaddr, bdaddr_type, type,
 								direct_addr);
-	if (conn && type == LE_ADV_IND) {
+	if (conn && type == LE_ADV_IND && len <= HCI_MAX_AD_LENGTH) {
 		/* Store report for later inclusion by
 		 * mgmt_device_connected
 		 */
@@ -4937,10 +4945,14 @@ static void hci_le_adv_report_evt(struct
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
-		rssi = ev->data[ev->length];
-		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
-				   ev->bdaddr_type, NULL, 0, rssi,
-				   ev->data, ev->length);
+		if (ev->length <= HCI_MAX_AD_LENGTH) {
+			rssi = ev->data[ev->length];
+			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
+					   ev->bdaddr_type, NULL, 0, rssi,
+					   ev->data, ev->length);
+		} else {
+			bt_dev_err(hdev, "Dropping invalid advertising data");
+		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
 	}


