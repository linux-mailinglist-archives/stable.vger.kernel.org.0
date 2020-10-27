Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E0829AE6C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgJ0OAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408417AbgJ0N7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:59:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B1E821D42;
        Tue, 27 Oct 2020 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807184;
        bh=jjS6gpwBsMOgk9XdqvV8I2tubcL3s4WxOtrB5dDK+3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2Oh9Q+9EfGvWoT9cfO0x61WRV8nAKpOOPj+lvOUj9re49Mt1LOu+IMTL0B5ncnCR
         gKugnaKk2/5VStOrVb86WnHnxXfm35w5OvMsJ733lbxR3NZf2OFMwgjo/GRCFJ7Mpg
         VkcAIgGz8Y7vD8CALmA9ZLNQZPWhnOVMoQr37fT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 074/112] memory: fsl-corenet-cf: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:49:44 +0100
Message-Id: <20201027134904.055083893@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit dd85345abca60a8916617e8d75c0f9ce334336dd ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: 54afbec0d57f ("memory: Freescale CoreNet Coherency Fabric error reporting driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200827073315.29351-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/fsl-corenet-cf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/fsl-corenet-cf.c b/drivers/memory/fsl-corenet-cf.c
index 662d050243bec..2fbf8d09af36b 100644
--- a/drivers/memory/fsl-corenet-cf.c
+++ b/drivers/memory/fsl-corenet-cf.c
@@ -215,10 +215,8 @@ static int ccf_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, ccf);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "%s: no irq\n", __func__);
-		return -ENXIO;
-	}
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_irq(&pdev->dev, irq, ccf_irq, 0, pdev->name, ccf);
 	if (ret) {
-- 
2.25.1



