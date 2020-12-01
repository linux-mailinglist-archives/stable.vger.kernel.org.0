Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4422C9BD3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389960AbgLAJMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388872AbgLAJMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB9E21D46;
        Tue,  1 Dec 2020 09:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813931;
        bh=RWpL22H5WCyXuPHlHQxEotOnaHqYtQ8SB457ykaaaM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZY8PfEBguItKWmW3WdeeFniPRZqr3NRaebMJPc29d4kAawF/7iIJs6ko2iHkz7FP
         LAnkHgQzdc8kZhBa2GxOfugAb/PxkaQFysurdPSLvdGaAf0NXT2By+m76xdu2RTDQc
         EXb5tTCN6pcXNxOpIoSxV6U47TuiufLXjYs1KM4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clark Wang <xiaoning.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 107/152] spi: imx: fix the unbalanced spi runtime pm management
Date:   Tue,  1 Dec 2020 09:53:42 +0100
Message-Id: <20201201084725.854163718@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 7cd71202961090d8f2d2b863ec66b25ae43e1d39 ]

If set active without increase the usage count of pm, the dont use
autosuspend function will call the suspend callback to close the two
clocks of spi because the usage count is reduced to -1.
This will cause the warning dump below when the defer-probe occurs.

[  129.379701] ecspi2_root_clk already disabled
[  129.384005] WARNING: CPU: 1 PID: 33 at drivers/clk/clk.c:952 clk_core_disable+0xa4/0xb0

So add the get noresume function before set active.

Fixes: 43b6bf406cd0 spi: imx: fix runtime pm support for !CONFIG_PM
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Link: https://lore.kernel.org/r/20201124085247.18025-1-xiaoning.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 9aac515b718c8..91578103a3ca9 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1684,6 +1684,7 @@ static int spi_imx_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(spi_imx->dev, MXC_RPM_TIMEOUT);
 	pm_runtime_use_autosuspend(spi_imx->dev);
+	pm_runtime_get_noresume(spi_imx->dev);
 	pm_runtime_set_active(spi_imx->dev);
 	pm_runtime_enable(spi_imx->dev);
 
-- 
2.27.0



