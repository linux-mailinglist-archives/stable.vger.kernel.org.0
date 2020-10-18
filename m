Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314A291984
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgJRTSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbgJRTSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBB81222EA;
        Sun, 18 Oct 2020 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048710;
        bh=flb3bwQ1gDVKXGaaMS3Pa/biqu4CqGQ82jZk66Pid8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZcWfki2wwCbAlUKjUNeuwFTVc4YPwke1sogNsz0nTrPaI0QEXBB9Ac2b7/jGLa6m
         H/H9Hn72CvHseZjKGTtyn/0TinuEI9wqaMYUKAB/tmtD83CwTZ1u3KokxT+RX0ESCY
         wd7FsjRZCBQgpsYZHfmRnd77rsgS4zkYmVjs2LC4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 018/111] media: media/pci: prevent memory leak in bttv_probe
Date:   Sun, 18 Oct 2020 15:16:34 -0400
Message-Id: <20201018191807.4052726-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9144f795fb933..b721720f9845a 100644
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

