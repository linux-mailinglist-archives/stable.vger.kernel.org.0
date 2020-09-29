Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20427C863
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbgI2MBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729235AbgI2LkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4790A2083B;
        Tue, 29 Sep 2020 11:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379608;
        bh=UTORA0vFhKrSQVJFeXxzWe2A2a4craZybvPVO4CRqC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyM6DsPzm8f6TnFbx85DM9F/jLCd3Qug4LKQtHGyz6SnGxPMowZktwJIVC8XSVi6V
         //o3I6MykkyPIZ//+wFstSNUTaAwvuoPgbShOH9ki08Pp0Dkrt9IjdqKAqx2V7TCgc
         HREqRGiNbR47b9pXshCmNUqY1GtngfimuR+N7Yjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/388] scsi: aacraid: Fix error handling paths in aac_probe_one()
Date:   Tue, 29 Sep 2020 12:59:30 +0200
Message-Id: <20200929110022.050208032@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7854c382240c1686900b2f098b36430c6f5047e ]

If 'scsi_host_alloc()' or 'kcalloc()' fail, 'error' is known to be 0. Set
it explicitly to -ENOMEM before branching to the error handling path.

While at it, remove 2 useless assignments to 'error'. These values are
overwridden a few lines later.

Link: https://lore.kernel.org/r/20200412094039.8822-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/linit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 514aed38b5afe..1035f947f1bcf 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1607,7 +1607,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost;
 	struct aac_dev *aac;
 	struct list_head *insert = &aac_devices;
-	int error = -ENODEV;
+	int error;
 	int unique_id = 0;
 	u64 dmamask;
 	int mask_bits = 0;
@@ -1632,7 +1632,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1664,8 +1663,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
-	if (!shost)
+	if (!shost) {
+		error = -ENOMEM;
 		goto out_disable_pdev;
+	}
 
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
@@ -1690,8 +1691,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->fibs = kcalloc(shost->can_queue + AAC_NUM_MGT_FIB,
 			    sizeof(struct fib),
 			    GFP_KERNEL);
-	if (!aac->fibs)
+	if (!aac->fibs) {
+		error = -ENOMEM;
 		goto out_free_host;
+	}
+
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
-- 
2.25.1



