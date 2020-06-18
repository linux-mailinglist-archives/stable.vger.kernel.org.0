Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2131FE829
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgFRBKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726966AbgFRBKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC462214DB;
        Thu, 18 Jun 2020 01:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442630;
        bh=P0+2fHaETgW6NNS4KKLoREqjNyFC9AlfVEZ+UAGUoTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHESbSgnlfk1+h8Ucy7wFADdGfJDZp5eOJzdP31WjzUfLpZe+l1ep7LLgBptYPBLg
         u+k7ed7DCPu3HB7HyCKMlCVa5rQvAmHMCzkcBfZmi6UB1Et+loFBAFfWaKt8k5B2bN
         330Z07vLB/r7eKMu8j9R7CC7aib4lsjLp4uLnvoo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 108/388] media: s5p-mfc: Properly handle dma_parms for the allocated devices
Date:   Wed, 17 Jun 2020 21:03:25 -0400
Message-Id: <20200618010805.600873-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5c2a23b953a4..eba2b9f040df 100644
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

