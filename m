Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD9C73BF5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392634AbfGXUFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392632AbfGXUFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:05:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB5B205C9;
        Wed, 24 Jul 2019 20:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998713;
        bh=iCwAtCff7HHcrnouW7cbb5SaFvdXO8vYxmqpN98uFJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKfBLzjhKJZhcnMgMPkYlDZWfSbu2yRmen0VwE+rMTaaFeewNtNuaSywmgZWuK+Wg
         ySaEjT1AZbtKQ6pGbzjmSKxTgxaqCV7s3JP6Bb+ppkgvKc4bEdSdS3BQfMzwGpYRKl
         d5BBhLGvfrRKt1bj8dS0PTCjVRTOB54EP9mIn7M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/271] nvme-pci: set the errno on ctrl state change error
Date:   Wed, 24 Jul 2019 21:19:18 +0200
Message-Id: <20190724191702.864048375@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e71afda49335620e3d9adf56015676db33a3bd86 ]

This patch removes the confusing assignment of the variable result at
the time of declaration and sets the value in error cases next to the
places where the actual error is happening.

Here we also set the result value to -ENODEV when we fail at the final
ctrl state transition in nvme_reset_work(). Without this assignment
result will hold 0 from nvme_setup_io_queue() and on failure 0 will be
passed to he nvme_remove_dead_ctrl() from final state transition.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 03e72e2f57f5..0a5d064f82ca 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2253,11 +2253,13 @@ static void nvme_reset_work(struct work_struct *work)
 	struct nvme_dev *dev =
 		container_of(work, struct nvme_dev, ctrl.reset_work);
 	bool was_suspend = !!(dev->ctrl.ctrl_config & NVME_CC_SHN_NORMAL);
-	int result = -ENODEV;
+	int result;
 	enum nvme_ctrl_state new_state = NVME_CTRL_LIVE;
 
-	if (WARN_ON(dev->ctrl.state != NVME_CTRL_RESETTING))
+	if (WARN_ON(dev->ctrl.state != NVME_CTRL_RESETTING)) {
+		result = -ENODEV;
 		goto out;
+	}
 
 	/*
 	 * If we're called to reset a live controller first shut it down before
@@ -2355,6 +2357,7 @@ static void nvme_reset_work(struct work_struct *work)
 	if (!nvme_change_ctrl_state(&dev->ctrl, new_state)) {
 		dev_warn(dev->ctrl.device,
 			"failed to mark controller state %d\n", new_state);
+		result = -ENODEV;
 		goto out;
 	}
 
-- 
2.20.1



