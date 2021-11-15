Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E2A452669
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbhKPCFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239955AbhKOSFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DC5D632F6;
        Mon, 15 Nov 2021 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998031;
        bh=QbymsJ380DTccmP3Hu4m1dPKrL/tg/oHfHWXNYeQZDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeRyJgorhsDbkA7GaX7TKIIYmLX9UBIlH/DR8HgAKNj5LoGLvAbffkr2C2zhDsgB/
         M/G2f3oP6RLCqJJo0ZgcBLPJy++U0kIaUH/95PzRmOIISiVCfuVzkjLHWSwM4RX6h9
         +9XBExwdsYve7hnBfhErgaDttVnLZZoTfxmRrfuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/575] mmc: mxs-mmc: disable regulator on error and in the remove function
Date:   Mon, 15 Nov 2021 18:00:54 +0100
Message-Id: <20211115165355.170079705@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ce5f6c2c9b0fcb4094f8e162cfd37fb4294204f7 ]

The 'reg_vmmc' regulator is enabled in the probe. It is never disabled.
Neither in the error handling path of the probe nor in the remove
function.

Register a devm_action to disable it when needed.

Fixes: 4dc5a79f1350 ("mmc: mxs-mmc: enable regulator for mmc slot")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/4aadb3c97835f7b80f00819c3d549e6130384e67.1634365151.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxs-mmc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 4fbbff03137c3..2ec3eb651d6b5 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -565,6 +565,11 @@ static const struct of_device_id mxs_mmc_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mxs_mmc_dt_ids);
 
+static void mxs_mmc_regulator_disable(void *regulator)
+{
+	regulator_disable(regulator);
+}
+
 static int mxs_mmc_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
@@ -606,6 +611,11 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 				"Failed to enable vmmc regulator: %d\n", ret);
 			goto out_mmc_free;
 		}
+
+		ret = devm_add_action_or_reset(&pdev->dev, mxs_mmc_regulator_disable,
+					       reg_vmmc);
+		if (ret)
+			goto out_mmc_free;
 	}
 
 	ssp->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.33.0



