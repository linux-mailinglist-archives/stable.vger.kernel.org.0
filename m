Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0A12F164
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgABWNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbgABWNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58532222C3;
        Thu,  2 Jan 2020 22:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003191;
        bh=MzetPlcMtO42x1sKQ4+xlUjnOHVzATAf85E4X9kGBpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiTqHsJNFp94oQq+H7MrzWU9XwOlfCiqcPrLJI7LogKVJ8HQV1fZq8rtzqUJWMJT1
         k/SfcVR7WwgTIGHlbbT33PLY+eBBmEDLeAbIGcBiQGSjRyBPCONo/cAzB5K0HB93AV
         w19fvmrGifsBzbKBvQ909RTVhAPcYUSKT9wrUR7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Peng Ma <peng.ma@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/191] dmaengine: fsl-qdma: Handle invalid qdma-queue0 IRQ
Date:   Thu,  2 Jan 2020 23:05:14 +0100
Message-Id: <20200102215833.437983302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 41814c4eadf8a791b6d07114f96e7e120e59555c ]

platform_get_irq_byname() might return -errno which later would be cast
to an unsigned int and used in IRQ handling code leading to usage of
wrong ID and errors about wrong irq_base.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Peng Ma <peng.ma@nxp.com>
Tested-by: Peng Ma <peng.ma@nxp.com>
Link: https://lore.kernel.org/r/20191004150826.6656-1-krzk@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index 06664fbd2d91..89792083d62c 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -1155,6 +1155,9 @@ static int fsl_qdma_probe(struct platform_device *pdev)
 		return ret;
 
 	fsl_qdma->irq_base = platform_get_irq_byname(pdev, "qdma-queue0");
+	if (fsl_qdma->irq_base < 0)
+		return fsl_qdma->irq_base;
+
 	fsl_qdma->feature = of_property_read_bool(np, "big-endian");
 	INIT_LIST_HEAD(&fsl_qdma->dma_dev.channels);
 
-- 
2.20.1



