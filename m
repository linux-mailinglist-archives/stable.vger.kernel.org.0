Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DD073815
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfGXTZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbfGXTZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0362622387;
        Wed, 24 Jul 2019 19:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996350;
        bh=m33R6dhHb2VmmyzYBxUc5e1BtHoU4ndX6Brej0xYZtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSyzWraMCquUJUifG44TtAVrQT82SWW7ma8bo9tKyl86eERFuY+Oc4n+s69zU8VPO
         JKSSdhjG0UYRlZIy2gDEuVvUmhHNxzBoJJFeYyzk2w0WOavFnOXZensjvklOANX+yg
         o54uvpvy6O/K58PzSII4XOLWwJbnv6kJrSsGdPRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 065/413] media: imx7-mipi-csis: Propagate the error if clock enabling fails
Date:   Wed, 24 Jul 2019 21:15:56 +0200
Message-Id: <20190724191739.849499604@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
index 19455f425416..7d7bdfdd852a 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -456,13 +456,9 @@ static void mipi_csis_set_params(struct csi_state *state)
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
@@ -973,7 +969,11 @@ static int mipi_csis_probe(struct platform_device *pdev)
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



