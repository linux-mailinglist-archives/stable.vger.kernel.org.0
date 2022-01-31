Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59CA4A4306
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359056AbiAaLQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:16:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60584 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359073AbiAaLOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 452C0B82A71;
        Mon, 31 Jan 2022 11:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CE0C340E8;
        Mon, 31 Jan 2022 11:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627676;
        bh=ssY7kXE1Ief3LelNhBCJDUqtMCTqLfRPdkAXGYpBN34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZT5nqGfzD5mwKWTp4TI6QT55AM6PJvo6rL6ZZNKkDWcxXrKz98vAWOV2Y/pR3W0Yq
         yNh3FZUwQAr3rVOU6lvJwU0tWCHvT9wlAuSrmKjp/InFVf/TSp+rZxQzEfvnOngFaM
         TlBmvPN9aT67PkHzQG5Juh2IJ7hDIzkGe6lt9zPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Gix <brian.gix@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syphyr <syphyr@gmail.com>
Subject: [PATCH 5.15 161/171] Bluetooth: refactor malicious adv data check
Date:   Mon, 31 Jan 2022 11:57:06 +0100
Message-Id: <20220131105235.463268057@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Gix <brian.gix@intel.com>

commit 899663be5e75dc0174dc8bda0b5e6826edf0b29a upstream.

Check for out-of-bound read was being performed at the end of while
num_reports loop, and would fill journal with false positives. Added
check to beginning of loop processing so that it doesn't get checked
after ptr has been advanced.

Signed-off-by: Brian Gix <brian.gix@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: syphyr <syphyr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5782,6 +5782,11 @@ static void hci_le_adv_report_evt(struct
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
+		if (ptr > (void *)skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data.");
+			break;
+		}
+
 		if (ev->length <= HCI_MAX_AD_LENGTH &&
 		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
@@ -5793,11 +5798,6 @@ static void hci_le_adv_report_evt(struct
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);


