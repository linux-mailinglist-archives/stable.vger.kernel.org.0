Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5314996B7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442656AbiAXVGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54516 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443916AbiAXU7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C27AB810BD;
        Mon, 24 Jan 2022 20:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC4C340E5;
        Mon, 24 Jan 2022 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057972;
        bh=0IGBf5tEYiMjH+4RXC5rOqHobWxotPtGXGTcCVuL41w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0aKrhXncadlwPsS0Xqz8olRSRZ0a0jT5TxNhDjj+ALwQ34p1cD+JKj3iCF2nxuId
         IzgnzyLDyHV7YTqU83/VspTZbVE0RXl8X2bNUOqGbEOJ8dgWJXXdNSV3nqMChzO/4M
         othgkgOPKm6Q7pTOg/LaynHzI5D6DUW5+qKGXPoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
Subject: [PATCH 5.16 0139/1039] Bluetooth: stop proccessing malicious adv data
Date:   Mon, 24 Jan 2022 19:32:08 +0100
Message-Id: <20220124184129.852295486@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 3a56ef719f0b9682afb8a86d64b2399e36faa4e6 ]

Syzbot reported slab-out-of-bounds read in hci_le_adv_report_evt(). The
problem was in missing validaion check.

We should check if data is not malicious and we can read next data block.
If we won't check ptr validness, code can read a way beyond skb->end and
it can cause problems, of course.

Fixes: e95beb414168 ("Bluetooth: hci_le_adv_report_evt code refactoring")
Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7d0db1ca12482..59f0691d907f6 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5825,7 +5825,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
-		if (ev->length <= HCI_MAX_AD_LENGTH) {
+		if (ev->length <= HCI_MAX_AD_LENGTH &&
+		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
 			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, rssi,
@@ -5835,6 +5836,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
+
+		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
+			break;
+		}
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.34.1



