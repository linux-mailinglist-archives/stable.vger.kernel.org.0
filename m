Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CCD45BA6D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbhKXMKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhKXMJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FB4610A5;
        Wed, 24 Nov 2021 12:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755514;
        bh=crpv9u2e6q3KcKn9wQkOXzOTzU5z+Zxi9Sl7oPGV/9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6PRzXotEBScAkWx/ac2Glr6MdnhEgtf29MEmSlppmi+pu/627e4gV9A85Ze6ATSY
         Q5vP2eLNU2HNQgPz8yRmRqcFW/IkMV/Nuk7RyblDcGX25bR2AtOc2JnWSnRg5/mZdw
         Dc39FokAvxQjUV1r6XW8tuLVUAWBHWGrktuoCPic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 091/162] memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe
Date:   Wed, 24 Nov 2021 12:56:34 +0100
Message-Id: <20211124115701.264666913@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 4ed2f3545c2e5acfbccd7f85fea5b1a82e9862d7 ]

The error handling code of fsl_ifc_ctrl_probe is problematic. When
fsl_ifc_ctrl_init fails or request_irq of fsl_ifc_ctrl_dev->irq fails,
it forgets to free the irq and nand_irq. Meanwhile, if request_irq of
fsl_ifc_ctrl_dev->nand_irq fails, it will still free nand_irq even if
the request_irq is not successful.

Fix this by refactoring the error handling code.

Fixes: d2ae2e20fbdd ("driver/memory:Move Freescale IFC driver to a common driver")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20210925151434.8170-1-mudongliangabcd@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/fsl_ifc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/memory/fsl_ifc.c b/drivers/memory/fsl_ifc.c
index 26b37ba4feda6..258d95b9c0adc 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -275,7 +275,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 
 	ret = fsl_ifc_ctrl_init(fsl_ifc_ctrl_dev);
 	if (ret < 0)
-		goto err;
+		goto err_unmap_nandirq;
 
 	init_waitqueue_head(&fsl_ifc_ctrl_dev->nand_wait);
 
@@ -284,7 +284,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	if (ret != 0) {
 		dev_err(&dev->dev, "failed to install irq (%d)\n",
 			fsl_ifc_ctrl_dev->irq);
-		goto err_irq;
+		goto err_unmap_nandirq;
 	}
 
 	if (fsl_ifc_ctrl_dev->nand_irq) {
@@ -293,17 +293,16 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 		if (ret != 0) {
 			dev_err(&dev->dev, "failed to install irq (%d)\n",
 				fsl_ifc_ctrl_dev->nand_irq);
-			goto err_nandirq;
+			goto err_free_irq;
 		}
 	}
 
 	return 0;
 
-err_nandirq:
-	free_irq(fsl_ifc_ctrl_dev->nand_irq, fsl_ifc_ctrl_dev);
-	irq_dispose_mapping(fsl_ifc_ctrl_dev->nand_irq);
-err_irq:
+err_free_irq:
 	free_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_dev);
+err_unmap_nandirq:
+	irq_dispose_mapping(fsl_ifc_ctrl_dev->nand_irq);
 	irq_dispose_mapping(fsl_ifc_ctrl_dev->irq);
 err:
 	return ret;
-- 
2.33.0



