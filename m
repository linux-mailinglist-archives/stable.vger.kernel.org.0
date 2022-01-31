Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDB4A415C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348725AbiAaLDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359152AbiAaLDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B2C0612FC;
        Mon, 31 Jan 2022 03:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CCDEB82A5E;
        Mon, 31 Jan 2022 11:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45954C340E8;
        Mon, 31 Jan 2022 11:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626892;
        bh=xLeK2P+nBHoZ3TW+XG9S74ef1zCqYwfGpC4fgjP9Lmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqKRx4nO43K4aK3IFjsgJrMgpI0lrXCeYXhYdZ3o1knDclabwHJGeyDEAbHOY0xu7
         uHp/5t3QfkMqspEQXmY9KQ+IOzD5r1f3+bxLvfQ/f9eEFKJP59JByodE/WCXvUTYMI
         6oV74FuaRmK1Nr1KohwEDcejPddfqRdl8lhDB8AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Gix <brian.gix@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syphyr <syphyr@gmail.com>
Subject: [PATCH 5.10 001/100] Bluetooth: refactor malicious adv data check
Date:   Mon, 31 Jan 2022 11:55:22 +0100
Message-Id: <20220131105220.474074744@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -5661,6 +5661,11 @@ static void hci_le_adv_report_evt(struct
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
@@ -5672,11 +5677,6 @@ static void hci_le_adv_report_evt(struct
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);


