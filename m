Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218174A4097
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiAaK6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:58:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59472 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiAaK6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:58:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D058860AF6;
        Mon, 31 Jan 2022 10:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8623BC340E8;
        Mon, 31 Jan 2022 10:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626692;
        bh=Am7HN6bjhbVZ5pfZErRSqrJI5VgqHDagnnGL38sPjRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TV2y1TpsF8Tqlvhrj+5HqsOMrni3XIqfRgE+tQfagdyeW/fe0oAt7tjkdtKyfxqBX
         Ey+lIuqo/5V4SR0vTllDAAhsIgF3+oq3t7iwP+f4OJT1pn5PJPPL/fLEdm5SdyA5NJ
         ryDUEEv720mmDYxmn+NyiF9zX2EF0eWtLh4pXStI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Gix <brian.gix@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syphyr <syphyr@gmail.com>
Subject: [PATCH 5.4 01/64] Bluetooth: refactor malicious adv data check
Date:   Mon, 31 Jan 2022 11:55:46 +0100
Message-Id: <20220131105215.695316553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -5506,6 +5506,11 @@ static void hci_le_adv_report_evt(struct
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
@@ -5517,11 +5522,6 @@ static void hci_le_adv_report_evt(struct
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);


