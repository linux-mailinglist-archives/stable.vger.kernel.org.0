Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976211198E6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfLJVk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730027AbfLJVeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A09C22464;
        Tue, 10 Dec 2019 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013665;
        bh=BaOJLlsaJCuwyylSLKMNeU454E8WKcHKVG/Ej1RBeow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=et2Ys//IG+GzwStFn7P/tad0zhDqBmKUZjpwfveO4NTs8Lzp/Cx0WCHbWY5ATWNF+
         5LrxVnJG4eli+LX4lkSRHp1M/NYptX0Fmu8qNtdnTousvlYkkpVM1MO5cOj5qPq9Nn
         SM3N1ZPGXi2tWtPt3untK0DW8yWCJpMW2Q6HVBYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 102/177] nvmem: imx-ocotp: reset error status on probe
Date:   Tue, 10 Dec 2019 16:31:06 -0500
Message-Id: <20191210213221.11921-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index afb429a417fe0..926d9cc080cf4 100644
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

