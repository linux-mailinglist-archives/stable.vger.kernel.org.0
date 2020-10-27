Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5200929B722
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798638AbgJ0P3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798630AbgJ0P3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25FB20728;
        Tue, 27 Oct 2020 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812560;
        bh=K14gWbDoq5k9JMBfm5S96X9KLsczL1rujmV0+6SwvYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUVcbrgOB7phLLe5AahjOsLFPJUBKFG44qJZbKHpsQhz2tf/J8LH08TFjrJazoquJ
         WID49O6mUsnZ7EuRwnaNV9oKWEcf/uw/O2ltLK+ko6jHhNKtdzaCQ3UH8Ofz++3yej
         4iqTdXAX89SKbp3x2iLLXOHTpGmoluSAbtreeEz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 253/757] Bluetooth: Re-order clearing suspend tasks
Date:   Tue, 27 Oct 2020 14:48:23 +0100
Message-Id: <20201027135502.437785144@linuxfoundation.org>
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

[ Upstream commit 3eec158d5eca7dd455118d9e00568aad2371219f ]

Unregister_pm_notifier is a blocking call so suspend tasks should be
cleared beforehand. Otherwise, the notifier will wait for completion
before returning (and we encounter a 2s timeout on resume).

Fixes: 0e9952804ec9c8 (Bluetooth: Clear suspend tasks on unregister)
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index efc0fe2b47dac..be9cdf5dabe5d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3794,8 +3794,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	cancel_work_sync(&hdev->power_on);
 
-	unregister_pm_notifier(&hdev->suspend_notifier);
 	hci_suspend_clear_tasks(hdev);
+	unregister_pm_notifier(&hdev->suspend_notifier);
 	cancel_work_sync(&hdev->suspend_prepare);
 
 	hci_dev_do_close(hdev);
-- 
2.25.1



