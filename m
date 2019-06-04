Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAC13542A
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfFDXbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfFDXW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 635AD208E3;
        Tue,  4 Jun 2019 23:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690578;
        bh=qqAkKaDS4lL6uII4veNn02iHkQ8Wsm4Bb8JZWisIFWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pmrcFendHX3htXDFA1yQHlTbIQBjBqmek0B22g3D8hxHH/ubZGqrtNL29wdEYhsL
         NON3mqlIplypbSlEkVzyv/MRZcH/Yl1160+NeiY5i/cbsdDFJIDx6dWBlrvbiF+QuI
         awS1GS65XbRpmMMnSbkuWdfndw/4Ck9KjqXbz38Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <keith.busch@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 28/60] nvme-pci: Fix controller freeze wait disabling
Date:   Tue,  4 Jun 2019 19:21:38 -0400
Message-Id: <20190604232212.6753-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

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
index a90cf5d63aac..4e064aad2b1a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2397,7 +2397,7 @@ static void nvme_pci_disable(struct nvme_dev *dev)
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 {
-	bool dead = true;
+	bool dead = true, freeze = false;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 
 	mutex_lock(&dev->shutdown_lock);
@@ -2405,8 +2405,10 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
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
@@ -2415,10 +2417,8 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
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

