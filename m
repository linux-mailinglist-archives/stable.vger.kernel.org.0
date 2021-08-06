Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7031C3E25C8
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbhHFIWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244337AbhHFIVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A6D86120F;
        Fri,  6 Aug 2021 08:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238054;
        bh=seXKnse4CKxRZfXGylSwDcGOoqWKeNbun1PVJBChxMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oz13EyqN+wvzS+ub689XJMDYow1lVgrRrhWjkwG6wOO+PxkN+fWLUObYh6pYiLpsX
         13g8Zcp3bz/bgmJMDBYyXdqFgzE/lsM0WvxLATALbNIUIuZPkLvc5oEaNectE29Her
         t8JaSSlXdgleHRmVY3E8aUlsm1SaIJ1xkL452XBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 33/35] Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
Date:   Fri,  6 Aug 2021 10:17:16 +0200
Message-Id: <20210806081114.810836917@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c19a2820df32b94d1d4fb65e96ae36f97dddda56 which is
commit 0ea9fd001a14ebc294f112b0361a4e601551d508 upstream.

It has been reported to have problems:
	https://lore.kernel.org/linux-bluetooth/8735ryk0o7.fsf@baylibre.com/

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1721,6 +1721,14 @@ int hci_dev_do_close(struct hci_dev *hde
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	cancel_delayed_work(&hdev->power_off);
 
 	hci_request_cancel_all(hdev);
@@ -1797,14 +1805,6 @@ int hci_dev_do_close(struct hci_dev *hde
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 


