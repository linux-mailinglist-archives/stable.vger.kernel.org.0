Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D4632E837
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCEMZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhCEMZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 287F46503A;
        Fri,  5 Mar 2021 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947116;
        bh=n/akUd8TOycWpX5RAtF+9av1q0LlX0wBc+2D9jZdWvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdxEKJHTyLd6nQv3FC2kk9F6CvHfAD9wkwRA11uerasX8ab0uoeecNKud00rSmPlM
         is/pKnCtsxS6srlVFZFjOiojlE14sxhYDgwfcxsYchLpsTgFNghU3NjO5Vh/YJAac2
         CZaJ17y4tCRZP1i5WRZlWDlNfulPkxnEj7YCRwQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 052/104] Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk
Date:   Fri,  5 Mar 2021 13:20:57 +0100
Message-Id: <20210305120905.721858200@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
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
index c1504aa3d9cf..ba2f439bc04d 100644
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
index ed3380db0217..6ea2e16c57bd 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3830,10 +3830,12 @@ int hci_register_dev(struct hci_dev *hdev)
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
 
@@ -3868,9 +3870,11 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
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



