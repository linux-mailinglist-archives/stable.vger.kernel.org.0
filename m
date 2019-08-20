Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4D99614B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfHTNp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730607AbfHTNmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:23 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796DD233A1;
        Tue, 20 Aug 2019 13:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308543;
        bh=9rv6wPnr7yZgysjFyc9cuvlkBeG4pSWyhpy+lTy8SmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5UkXVUPfiwacK7CCtQCt0Jhi9//qIWRyhYhHTmc+Xi9vpnPbhbv9eNrJrSRrXu3b
         y8Z05mmKDnX5XVQTds8U8+uvVr7bn6JNmc6/oQ0vN/DcW6Bo6aNIerzSV2nieMQ4ND
         tMDz/kmpx9QAt14M0UmJbPc/RsAArSw4lSHE/Zd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Li Zhong <lizhongfs@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 10/27] nvme-pci: Fix async probe remove race
Date:   Tue, 20 Aug 2019 09:41:56 -0400
Message-Id: <20190820134213.11279-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit bd46a90634302bfe791e93ad5496f98f165f7ae0 ]

Ensure the controller is not in the NEW state when nvme_probe() exits.
This will always allow a subsequent nvme_remove() to set the state to
DELETING, fixing a potential race between the initial asynchronous probe
and device removal.

Reported-by: Li Zhong <lizhongfs@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0a5d064f82ca3..a64a8bca0d5b9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2468,7 +2468,7 @@ static void nvme_async_probe(void *data, async_cookie_t cookie)
 {
 	struct nvme_dev *dev = data;
 
-	nvme_reset_ctrl_sync(&dev->ctrl);
+	flush_work(&dev->ctrl.reset_work);
 	flush_work(&dev->ctrl.scan_work);
 	nvme_put_ctrl(&dev->ctrl);
 }
@@ -2535,6 +2535,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev_info(dev->ctrl.device, "pci function %s\n", dev_name(&pdev->dev));
 
+	nvme_reset_ctrl(&dev->ctrl);
 	nvme_get_ctrl(&dev->ctrl);
 	async_schedule(nvme_async_probe, dev);
 
-- 
2.20.1

