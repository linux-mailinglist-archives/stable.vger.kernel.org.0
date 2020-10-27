Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A700029B3E1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752804AbgJ0O4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752425AbgJ0O4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB472071A;
        Tue, 27 Oct 2020 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810580;
        bh=CKdbozfGAMdtZknlqdY5bp2Fb5rFcplqU5HrpLApcOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ui+POp0CSsYTD5aV+Ld3N3vtoJun5lk7K4KqWgxjbi98k7TpBroDx7Qa1qr1qcYLY
         ELykVYdYIqViLt8uFJniRcqQ2tLR0pt1BD9tBJiKhKkEypg/R2Yz/74fSvVK0prZc7
         pz++ktv6AI4bVuhOP5IJRbP+wFnHkQJzNNnwk5mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 190/633] Bluetooth: Clear suspend tasks on unregister
Date:   Tue, 27 Oct 2020 14:48:53 +0100
Message-Id: <20201027135531.595012103@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 0e9952804ec9c8ba60f131225eab80634339f042 ]

While unregistering, make sure to clear the suspend tasks before
cancelling the work. If the unregister is called during resume from
suspend, this will unnecessarily add 2s to the resume time otherwise.

Fixes: 4e8c36c3b0d73d (Bluetooth: Fix suspend notifier race)
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fc28dc201b936..0f4e5a31f983c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3280,6 +3280,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	}
 }
 
+static void hci_suspend_clear_tasks(struct hci_dev *hdev)
+{
+	int i;
+
+	for (i = 0; i < __SUSPEND_NUM_TASKS; i++)
+		clear_bit(i, hdev->suspend_tasks);
+
+	wake_up(&hdev->suspend_wait_q);
+}
+
 static int hci_suspend_wait_event(struct hci_dev *hdev)
 {
 #define WAKE_COND                                                              \
@@ -3609,6 +3619,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->power_on);
 
 	unregister_pm_notifier(&hdev->suspend_notifier);
+	hci_suspend_clear_tasks(hdev);
 	cancel_work_sync(&hdev->suspend_prepare);
 
 	hci_dev_do_close(hdev);
-- 
2.25.1



