Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0941E32E942
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhCEMbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhCEMb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1118165037;
        Fri,  5 Mar 2021 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947483;
        bh=7uwTKHEL8JkD0rm5wRmW3YlVYJuG/FlrtnHMdD9VSpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1owl1/e/rYLnbr6jA/D7pDcIMGm0l+rNMlBhsTsSt/MCffiKxh1nHKRbL9wOzUUg
         fH+vVoewkNXsv3JBQucOgpLhUGN74RSsGb9kesZnc90TlkL6ySWX8fA0fGcsAf4HWC
         nvRzUveRQWFr/w+H97AkOXQU3IeTQv/u0RAOwEg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/102] Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk
Date:   Fri,  5 Mar 2021 13:21:10 +0100
Message-Id: <20210305120905.803451961@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 219991e6be7f4a31d471611e265b72f75b2d0538 ]

Some devices, e.g. the RTL8723BS bluetooth part, some USB attached devices,
completely drop from the bus on a system-suspend. These devices will
have their driver unbound and rebound on resume (when the dropping of
the bus gets detected) and will show up as a new HCI after resume.

These devices do not benefit from the suspend / resume handling work done
by the hci_suspend_notifier. At best this unnecessarily adds some time to
the suspend/resume time. But this may also actually cause problems, if the
code doing the driver unbinding runs after the pm-notifier then the
hci_suspend_notifier code will try to talk to a device which is now in
an uninitialized state.

This commit adds a new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk which allows
drivers to opt-out of the hci_suspend_notifier when they know beforehand
that their device will be fully re-initialized / reprobed on resume.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  8 ++++++++
 net/bluetooth/hci_core.c    | 18 +++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c8e67042a3b1..6da4b3c5dd55 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -238,6 +238,14 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
+
+	/*
+	 * When this quirk is set, then the hci_suspend_notifier is not
+	 * registered. This is intended for devices which drop completely
+	 * from the bus on system-suspend and which will show up as a new
+	 * HCI after resume.
+	 */
+	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7a2f9559e99a..0152bc6b6796 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3785,10 +3785,12 @@ int hci_register_dev(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
 
-	hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
-	error = register_pm_notifier(&hdev->suspend_notifier);
-	if (error)
-		goto err_wqueue;
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
+		error = register_pm_notifier(&hdev->suspend_notifier);
+		if (error)
+			goto err_wqueue;
+	}
 
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
@@ -3823,9 +3825,11 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	cancel_work_sync(&hdev->power_on);
 
-	hci_suspend_clear_tasks(hdev);
-	unregister_pm_notifier(&hdev->suspend_notifier);
-	cancel_work_sync(&hdev->suspend_prepare);
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+		hci_suspend_clear_tasks(hdev);
+		unregister_pm_notifier(&hdev->suspend_notifier);
+		cancel_work_sync(&hdev->suspend_prepare);
+	}
 
 	hci_dev_do_close(hdev);
 
-- 
2.30.1



