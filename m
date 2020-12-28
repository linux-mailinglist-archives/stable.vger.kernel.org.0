Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCB42E386D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgL1NKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbgL1NKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC451207F7;
        Mon, 28 Dec 2020 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160994;
        bh=jWWecCvtWSloin1KklTI0i6RRAy8XgIXFUC1cw82+x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alK+BizeUsCiVk0H2fVrc/uFnADhO9Ed2UJnF2hRj3199ny7vpIGOu8p/4E9iqieg
         0eO8a1YaTuRv2NLW8tuIiWgjtkDjWccCshCzpQ1dLY5G4dnRea9JKWNtQw0TbZFggL
         fHgjw2ynWBDlEomwm64koFkRVsYs6xW87oXHYmf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
Subject: [PATCH 4.14 064/242] Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()
Date:   Mon, 28 Dec 2020 13:47:49 +0100
Message-Id: <20201228124907.836326064@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit f7e0e8b2f1b0a09b527885babda3e912ba820798 upstream.

`num_reports` is not being properly checked. A malformed event packet with
a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
of bounds. Fix it.

Cc: stable@vger.kernel.org
Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5141,20 +5141,18 @@ static void hci_le_direct_adv_report_evt
 					 struct sk_buff *skb)
 {
 	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
 
-	hci_dev_lock(hdev);
+	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
+		return;
 
-	while (num_reports--) {
-		struct hci_ev_le_direct_adv_info *ev = ptr;
+	hci_dev_lock(hdev);
 
+	for (; num_reports; num_reports--, ev++)
 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 				   ev->bdaddr_type, &ev->direct_addr,
 				   ev->direct_addr_type, ev->rssi, NULL, 0);
 
-		ptr += sizeof(*ev);
-	}
-
 	hci_dev_unlock(hdev);
 }
 


