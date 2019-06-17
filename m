Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C349432
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfFQVVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbfFQVVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0734B208E4;
        Mon, 17 Jun 2019 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806476;
        bh=ELvTOrk45EK+TWqLdnXanaRtbY3YzIW95jg6O2WUp2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eS51hMqH5UwkGZr8FHHnTBFrzeQnMV6H4eqMarcGrR4PxNyyeh4icuRrf8ljSxAt3
         5v6IZfXdggetWzSAZs9fGzu/azKbHses6ZOB3n5s+5kgsDkD2AUcWx7B6GThcn/rEs
         MsXu+UHkaEDg+hOVbYRoLovcjPsEMQCOoJ7/PaYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 065/115] nvme-pci: Fix controller freeze wait disabling
Date:   Mon, 17 Jun 2019 23:09:25 +0200
Message-Id: <20190617210803.490251928@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e43269e6e5c49d7fec599e6bba71963935b0e4ba ]

If a controller disabling didn't start a freeze, don't wait for the
operation to complete.

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 372d3f4a106a..f20da2e3da2c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2400,7 +2400,7 @@ static void nvme_pci_disable(struct nvme_dev *dev)
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 {
-	bool dead = true;
+	bool dead = true, freeze = false;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 
 	mutex_lock(&dev->shutdown_lock);
@@ -2408,8 +2408,10 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 		u32 csts = readl(dev->bar + NVME_REG_CSTS);
 
 		if (dev->ctrl.state == NVME_CTRL_LIVE ||
-		    dev->ctrl.state == NVME_CTRL_RESETTING)
+		    dev->ctrl.state == NVME_CTRL_RESETTING) {
+			freeze = true;
 			nvme_start_freeze(&dev->ctrl);
+		}
 		dead = !!((csts & NVME_CSTS_CFS) || !(csts & NVME_CSTS_RDY) ||
 			pdev->error_state  != pci_channel_io_normal);
 	}
@@ -2418,10 +2420,8 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	 * Give the controller a chance to complete all entered requests if
 	 * doing a safe shutdown.
 	 */
-	if (!dead) {
-		if (shutdown)
-			nvme_wait_freeze_timeout(&dev->ctrl, NVME_IO_TIMEOUT);
-	}
+	if (!dead && shutdown && freeze)
+		nvme_wait_freeze_timeout(&dev->ctrl, NVME_IO_TIMEOUT);
 
 	nvme_stop_queues(&dev->ctrl);
 
-- 
2.20.1



