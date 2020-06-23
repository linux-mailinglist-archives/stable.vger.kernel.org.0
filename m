Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6E920665F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbgFWVkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388488AbgFWUGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED6820EDD;
        Tue, 23 Jun 2020 20:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942793;
        bh=qQV8XaSV3qftiuUV2eui7l31ooADsetal0aMx7Owrbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRxz3GjGEn821Lb+VlzLHHwD1mkQfoR0LDFtOkTxfe0fH1RcD4fjJ4OKGR2IV99Si
         svWtdCdYsIZYY89hY6fR3TB/eZxbwrw9a6PCGqeJjWSy0sNTws3TRk2lJ6dFN1d8Df
         J24/FNwF9p26Q6Mkry951Fk/+1fq48VDgG3F3UWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 107/477] media: s5p-mfc: Properly handle dma_parms for the allocated devices
Date:   Tue, 23 Jun 2020 21:51:44 +0200
Message-Id: <20200623195412.652180204@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit cc8c0363ddce6308168d8223378ca884c213f280 ]

Commit 9495b7e92f71 ("driver core: platform: Initialize dma_parms for
platform devices") in v5.7-rc5 added allocation of dma_parms structure to
all platform devices. Then vb2_dma_contig_set_max_seg_size() have been
changed not to allocate dma_parms structure and rely on the one allocated
by the device core. Lets allocate the needed structure also for the
devices created for the 2 MFC device memory ports.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Fixes: 9495b7e92f71 ("driver core: platform: Initialize dma_parms for platform devices")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 5c2a23b953a41..eba2b9f040df0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1089,6 +1089,10 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 	child->coherent_dma_mask = dev->coherent_dma_mask;
 	child->dma_mask = dev->dma_mask;
 	child->release = s5p_mfc_memdev_release;
+	child->dma_parms = devm_kzalloc(dev, sizeof(*child->dma_parms),
+					GFP_KERNEL);
+	if (!child->dma_parms)
+		goto err;
 
 	/*
 	 * The memdevs are not proper OF platform devices, so in order for them
@@ -1104,7 +1108,7 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 			return child;
 		device_del(child);
 	}
-
+err:
 	put_device(child);
 	return NULL;
 }
-- 
2.25.1



