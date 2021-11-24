Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3FA45BDD6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbhKXMlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345009AbhKXMjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:39:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF31B6120F;
        Wed, 24 Nov 2021 12:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756620;
        bh=MoAPyZQ8dBjT6Y4/5IiofA+Ju8ZfMzSAQNa7XYg6N+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDmPa19BhfESYl03JExJt0q2jyRMhzrlElCdm+IbiQ4TTaLCjwpXb0UYtTSv0JVfx
         8PB4LCP2FZtUfmi5mdXHrvkchvC9kQ2VHQxJEFMqW3E7JCDq43jP26KgkQfu09Prfd
         YEyGp4F10PV6VH/2du/iDBACDIXcSvvpNh5oyTiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/251] memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe
Date:   Wed, 24 Nov 2021 12:56:30 +0100
Message-Id: <20211124115715.404649264@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 38b945eb410f3..9c0e70b047c39 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -276,7 +276,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 
 	ret = fsl_ifc_ctrl_init(fsl_ifc_ctrl_dev);
 	if (ret < 0)
-		goto err;
+		goto err_unmap_nandirq;
 
 	init_waitqueue_head(&fsl_ifc_ctrl_dev->nand_wait);
 
@@ -285,7 +285,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	if (ret != 0) {
 		dev_err(&dev->dev, "failed to install irq (%d)\n",
 			fsl_ifc_ctrl_dev->irq);
-		goto err_irq;
+		goto err_unmap_nandirq;
 	}
 
 	if (fsl_ifc_ctrl_dev->nand_irq) {
@@ -294,17 +294,16 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
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
 	iounmap(fsl_ifc_ctrl_dev->gregs);
-- 
2.33.0



