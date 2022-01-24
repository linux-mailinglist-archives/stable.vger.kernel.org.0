Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643134988F1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiAXSvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:51:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49418 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiAXSuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F5F614C9;
        Mon, 24 Jan 2022 18:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC23EC340E5;
        Mon, 24 Jan 2022 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050239;
        bh=bXxs5pp4y2DzjUk7vXFOB+RzFrdzy657g1Ih/Gk3cYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2j4K1PD9kwkxTmCjxqQZ2UShuwWKIpRkNcYUmsQvg1PSM+EfjM+LEaPjz3w3z0yp8
         KTcBIrifsFqE0d48KTY9gZ7sIyFJjlfznws+rZ4JH3AbkJtQdzED8D9xaJv3dnzTd4
         /sUdoRg8jdBpWyBvUd4pszetauqzCNFuexsGerQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
Subject: [PATCH 4.4 021/114] Bluetooth: stop proccessing malicious adv data
Date:   Mon, 24 Jan 2022 19:41:56 +0100
Message-Id: <20220124183927.780532909@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index 6528ecc3a3bc5..05ccd2bcd9e46 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4940,7 +4940,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
-		if (ev->length <= HCI_MAX_AD_LENGTH) {
+		if (ev->length <= HCI_MAX_AD_LENGTH &&
+		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
 			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, rssi,
@@ -4950,6 +4951,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
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



