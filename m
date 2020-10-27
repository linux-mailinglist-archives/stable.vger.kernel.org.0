Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979229B927
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802231AbgJ0PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798439AbgJ0P15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7432064B;
        Tue, 27 Oct 2020 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812477;
        bh=AOgugOgpvuDOvnuM09xgHtiENMreYx07QU28IOHzlOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSZN4D1Z2nWGfVQDL8u6LH7/QuumPUbrrvwC1ISsm9R2sWAMK5F8mtTY6Fcky3Df8
         DUJBCumI3fR2qGPjrZgYQyixs93erVXzfFk+aHnHPejlzmcIX4qshhKkMGV4v6CTSt
         X+0wju2RydM1YMcTJYEtOtVwvDT3YBToopOiNmoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 224/757] Bluetooth: Clear suspend tasks on unregister
Date:   Tue, 27 Oct 2020 14:47:54 +0100
Message-Id: <20201027135501.117405092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 68bfe57b66250..efc0fe2b47dac 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
@@ -3785,6 +3795,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->power_on);
 
 	unregister_pm_notifier(&hdev->suspend_notifier);
+	hci_suspend_clear_tasks(hdev);
 	cancel_work_sync(&hdev->suspend_prepare);
 
 	hci_dev_do_close(hdev);
-- 
2.25.1



