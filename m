Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D46612C5AE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfL2Rj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbfL2RcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:32:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B85207FF;
        Sun, 29 Dec 2019 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640738;
        bh=GtEqOnwyIEsSAXZSYt0Y94oiVIavuM0u3h1Nu09IQHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAf6PNjIXBY7IGrEgjvvS9rYhuDvqgKKntQKoAb5Jh0bGd7UhDqndRAbtAqr+4cZ3
         vx3F2QABXNYPIdfCzGG3CaSOEo1l5nFptqVLN6a9yvrFuLc5SaZUAxqGVSoH2w5kEs
         0pxrHiHGfdtzeBsiVM2KKjkfEHuT+xCHhICr/hLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/219] nvmem: imx-ocotp: reset error status on probe
Date:   Sun, 29 Dec 2019 18:18:39 +0100
Message-Id: <20191229162526.298007347@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit c33c585f1b3a99d53920bdac614aca461d8db06f ]

If software running before the OCOTP driver is loaded left the
controller with the error status pending, the driver will never
be able to complete the read timing setup. Reset the error status
on probe to make sure the controller is in usable state.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20191029114240.14905-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/imx-ocotp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
index afb429a417fe..926d9cc080cf 100644
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -466,6 +466,10 @@ static int imx_ocotp_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
+	clk_prepare_enable(priv->clk);
+	imx_ocotp_clr_err_if_set(priv->base);
+	clk_disable_unprepare(priv->clk);
+
 	priv->params = of_device_get_match_data(&pdev->dev);
 	imx_ocotp_nvmem_config.size = 4 * priv->params->nregs;
 	imx_ocotp_nvmem_config.dev = dev;
-- 
2.20.1



