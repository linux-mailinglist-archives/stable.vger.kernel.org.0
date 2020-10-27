Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8E829B2AE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750372AbgJ0OoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762705AbgJ0OoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:44:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19EC3206E5;
        Tue, 27 Oct 2020 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809847;
        bh=jTrFZs9DIx+gxbsNBqwlk6WWIe4DLgg7bsS91k+8FkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgXMAKiDrwmCzzq8Mp4uAh7eEyuSmE0YBWVD5Zfxbn5pHYsfXwB8aNRcaNjf9/fkd
         wGDllNswAU7urv3lTcssKiGSnF+PubNwAiI4eVpC6cHGSBkpYHwA+TEC5H3Bpk4aOK
         BFxy77SeolCKlr+LfQwaFys54NlJ9EiKvPBRo1c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 340/408] media: media/pci: prevent memory leak in bttv_probe
Date:   Tue, 27 Oct 2020 14:54:38 +0100
Message-Id: <20201027135510.803288539@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

[ Upstream commit 7b817585b730665126b45df5508dd69526448bc8 ]

In bttv_probe if some functions such as pci_enable_device,
pci_set_dma_mask and request_mem_region fails the allocated
 memory for btv should be released.

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a359da7773a90..ff2962cea6164 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4013,11 +4013,13 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btv->id  = dev->device;
 	if (pci_enable_device(dev)) {
 		pr_warn("%d: Can't enable device\n", btv->c.nr);
-		return -EIO;
+		result = -EIO;
+		goto free_mem;
 	}
 	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
 		pr_warn("%d: No suitable DMA available\n", btv->c.nr);
-		return -EIO;
+		result = -EIO;
+		goto free_mem;
 	}
 	if (!request_mem_region(pci_resource_start(dev,0),
 				pci_resource_len(dev,0),
@@ -4025,7 +4027,8 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 		pr_warn("%d: can't request iomem (0x%llx)\n",
 			btv->c.nr,
 			(unsigned long long)pci_resource_start(dev, 0));
-		return -EBUSY;
+		result = -EBUSY;
+		goto free_mem;
 	}
 	pci_set_master(dev);
 	pci_set_command(dev);
@@ -4211,6 +4214,10 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	release_mem_region(pci_resource_start(btv->c.pci,0),
 			   pci_resource_len(btv->c.pci,0));
 	pci_disable_device(btv->c.pci);
+
+free_mem:
+	bttvs[btv->c.nr] = NULL;
+	kfree(btv);
 	return result;
 }
 
-- 
2.25.1



