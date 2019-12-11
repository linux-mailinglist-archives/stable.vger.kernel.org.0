Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E25D11B76E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbfLKQHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbfLKPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2384208C3;
        Wed, 11 Dec 2019 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077144;
        bh=HY3j7n3byT9QT0It2CXSCU9ZX3FuttIs9KmwYNh5x4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGZbdKlJmVMuw6yi5NztOCK9kWDqeZL/t4xFOgJtWey4UdT5y3GOw3B90h2kOguv9
         6rJFhSFRqvqPK18XxlIdbY8bpMAaLNxgvDIWKUzZj1C+ajfhJxya2tW40QBZXtcW5M
         /nVIA4hKeaqhChpJc04tmUlgQsRltdPwejFM1RBo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 031/134] dmaengine: fsl-qdma: Handle invalid qdma-queue0 IRQ
Date:   Wed, 11 Dec 2019 10:10:07 -0500
Message-Id: <20191211151150.19073-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 06664fbd2d911..89792083d62c5 100644
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

