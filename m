Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9577498D6B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347665AbiAXTcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351779AbiAXT2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:28:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E502B81239;
        Mon, 24 Jan 2022 19:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F506C340E5;
        Mon, 24 Jan 2022 19:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052518;
        bh=9o48Je1F87lDwxkuT1N6YQqhnrPGRVS42N5wlSw4AZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8kPBItzBgej0Jpg9RLPOAy6bcKRv+gTFkm4E8NkOec3Kymjw4bg5ZFEislTvRB/i
         KkJJ5kbVYFWNHE5YA1FX4T7QhOhlzF/Ql/Bm2z8jGKcQznMnCsU5y3id+DsnWqGRAv
         ba6CCESFmpH+nr26kFX1CbkQqKBtsIuQNkJXGDoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/320] media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes
Date:   Mon, 24 Jan 2022 19:41:09 +0100
Message-Id: <20220124183956.637433565@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 43f0633f89947df57fe0b5025bdd741768007708 ]

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Link: https://lore.kernel.org/linux-media/20211206022201.1639460-1-jiasheng@iscas.ac.cn
Fixes: b0444f18e0b1 ("[media] coda: add i.MX6 VDOA driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/imx-vdoa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 8bc0d83718193..dd6e2e320264e 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -287,7 +287,11 @@ static int vdoa_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "DMA enable failed\n");
+		return ret;
+	}
 
 	vdoa = devm_kzalloc(&pdev->dev, sizeof(*vdoa), GFP_KERNEL);
 	if (!vdoa)
-- 
2.34.1



