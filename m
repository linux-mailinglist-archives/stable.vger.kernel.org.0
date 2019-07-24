Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8673DE4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390615AbfGXTpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390611AbfGXTpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A6C22BE8;
        Wed, 24 Jul 2019 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997551;
        bh=OgRx/pHz+ryvb/eVxoFbkiGVp79nL9fr7SzT47ZFZJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aVZP2EFgZOI2WHA2FMWNsstBRxn/Hr9OCaLhTl0loFG9XSVkMFi1OtF9nCvgGKLy
         Lbjl77/keeXS28+/LICBUCfM2hIR4BbwpL1ULHOztfHSpgYBK1IskxHi6ykb8Mc3cJ
         Z4yC9zV+Ff/ChMYnf8gD+mUkKT0lYAM466v85b0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 061/371] media: imx7-mipi-csis: Propagate the error if clock enabling fails
Date:   Wed, 24 Jul 2019 21:16:53 +0200
Message-Id: <20190724191729.472632315@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2b393f91c651c16d5c09f5c7aa689e58a79df34e ]

Currently the return value from clk_bulk_prepare_enable() is checked,
but it is not propagate it in the case of failure.

Fix it and also move the error message to the caller of
mipi_csis_clk_enable().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 2ddcc42ab8ff..e9d621e19d6d 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -455,13 +455,9 @@ static void mipi_csis_set_params(struct csi_state *state)
 			MIPI_CSIS_CMN_CTRL_UPDATE_SHADOW_CTRL);
 }
 
-static void mipi_csis_clk_enable(struct csi_state *state)
+static int mipi_csis_clk_enable(struct csi_state *state)
 {
-	int ret;
-
-	ret = clk_bulk_prepare_enable(state->num_clks, state->clks);
-	if (ret < 0)
-		dev_err(state->dev, "failed to enable clocks\n");
+	return clk_bulk_prepare_enable(state->num_clks, state->clks);
 }
 
 static void mipi_csis_clk_disable(struct csi_state *state)
@@ -985,7 +981,11 @@ static int mipi_csis_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	mipi_csis_clk_enable(state);
+	ret = mipi_csis_clk_enable(state);
+	if (ret < 0) {
+		dev_err(state->dev, "failed to enable clocks: %d\n", ret);
+		return ret;
+	}
 
 	ret = devm_request_irq(dev, state->irq, mipi_csis_irq_handler,
 			       0, dev_name(dev), state);
-- 
2.20.1



