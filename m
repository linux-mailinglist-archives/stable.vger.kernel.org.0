Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D76440A9
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbfFMQIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbfFMIpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1232721744;
        Thu, 13 Jun 2019 08:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415504;
        bh=m3BzlRZEygZgm78MvScGVsCzwOIr2NZmwREFleJBVqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvUzhbozWNFKEIF0aGsEzOjz6o4zfvopUfBM4HSo+CPTRXEEsJv2L30IbAT/LN8wN
         WuE7IaKp/C4qsmreuyQTHnZpZZ7Z0S5BT44bwTLXFIpypnWrUWLXl36FyBP0C7l2Xf
         5W/ILQLMrRj5QC59LRvxMZlmbIQAlksDLPSxwXbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 025/155] thermal: rcar_gen3_thermal: disable interrupt in .remove
Date:   Thu, 13 Jun 2019 10:32:17 +0200
Message-Id: <20190613075654.218229639@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 63f55fcea50c25ae5ad45af92d08dae3b84534c2 ]

Currently IRQ remains enabled after .remove, later if device is probed,
IRQ is requested before .thermal_init, this may cause IRQ function be
called before device is initialized.

this patch disables interrupt in .remove, to ensure irq function
only be called after device is fully initialized.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 88fa41cf16e8..0c9e7a5bacdf 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -331,6 +331,9 @@ MODULE_DEVICE_TABLE(of, rcar_gen3_thermal_dt_ids);
 static int rcar_gen3_thermal_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct rcar_gen3_thermal_priv *priv = dev_get_drvdata(dev);
+
+	rcar_thermal_irq_set(priv, false);
 
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
-- 
2.20.1



