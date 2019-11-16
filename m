Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC6FF055
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbfKPQEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730787AbfKPPve (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:34 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51E62186D;
        Sat, 16 Nov 2019 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919494;
        bh=Jq7yV1cMB4AnFU+bp4wsDh/McG2TBw5lyeKLoiGpng0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7whCTcT6dPaxj3zFK5K1+vYvqgY7SEKMdoAm9BT6927kpm+iy6pCAkSQlr2XHVMA
         +binbkRs5H95g/tm4/A3iC4a0G2r75JSnOv7lE3NiSK9w2xEQzmkuaxwjO6mEqC0Md
         M8jZrVtq7BiPUUBfmJTqIzpCz3UMqumNzl6vnrF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 22/99] ASoC: tegra_sgtl5000: fix device_node refcounting
Date:   Sat, 16 Nov 2019 10:49:45 -0500
Message-Id: <20191116155103.10971-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit a85227da2dcc291b762c8482a505bc7d0d2d4b07 ]

Similar to the following:

commit 4321723648b0 ("ASoC: tegra_alc5632: fix device_node refcounting")

commit 7c5dfd549617 ("ASoC: tegra: fix device_node refcounting")

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra_sgtl5000.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra_sgtl5000.c b/sound/soc/tegra/tegra_sgtl5000.c
index 1e76869dd4880..863e04809a6b8 100644
--- a/sound/soc/tegra/tegra_sgtl5000.c
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -152,14 +152,14 @@ static int tegra_sgtl5000_driver_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing/invalid\n");
 		ret = -EINVAL;
-		goto err;
+		goto err_put_codec_of_node;
 	}
 
 	tegra_sgtl5000_dai.platform_of_node = tegra_sgtl5000_dai.cpu_of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		goto err_put_cpu_of_node;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
@@ -172,6 +172,13 @@ static int tegra_sgtl5000_driver_probe(struct platform_device *pdev)
 
 err_fini_utils:
 	tegra_asoc_utils_fini(&machine->util_data);
+err_put_cpu_of_node:
+	of_node_put(tegra_sgtl5000_dai.cpu_of_node);
+	tegra_sgtl5000_dai.cpu_of_node = NULL;
+	tegra_sgtl5000_dai.platform_of_node = NULL;
+err_put_codec_of_node:
+	of_node_put(tegra_sgtl5000_dai.codec_of_node);
+	tegra_sgtl5000_dai.codec_of_node = NULL;
 err:
 	return ret;
 }
@@ -186,6 +193,12 @@ static int tegra_sgtl5000_driver_remove(struct platform_device *pdev)
 
 	tegra_asoc_utils_fini(&machine->util_data);
 
+	of_node_put(tegra_sgtl5000_dai.cpu_of_node);
+	tegra_sgtl5000_dai.cpu_of_node = NULL;
+	tegra_sgtl5000_dai.platform_of_node = NULL;
+	of_node_put(tegra_sgtl5000_dai.codec_of_node);
+	tegra_sgtl5000_dai.codec_of_node = NULL;
+
 	return ret;
 }
 
-- 
2.20.1

