Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7019929C09F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818071AbgJ0RRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782301AbgJ0O5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B9422264;
        Tue, 27 Oct 2020 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810621;
        bh=fy9N58wjZup82r/EkguW3PAFikuqfdGSsjTn1IAuGoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDqngAsiated7EzsQJ/TW8h1CPq6wWBAIz1Tvr2Apg1wt0YJPw7/86RI3tP1tnXca
         v0vZVUfOSjTqWLEbbDENkEzCgYQFnjfBkBWy/Uhgk8IgGo5tI5tIcqsN3QV/p1U72n
         Cu2OHbI/OcdXEdNPRaaGMZaUvntJTh9LNaVTrLVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 204/633] ASoC: fsl: imx-es8328: add missing put_device() call in imx_es8328_probe()
Date:   Tue, 27 Oct 2020 14:49:07 +0100
Message-Id: <20201027135532.257051173@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e525db7e4b44c5b2b5aac0dad24e23cb58c54d22 ]

if of_find_device_by_node() succeed, imx_es8328_probe() doesn't have
a corresponding put_device(). Thus add a jump target to fix the exception
handling for this function implementation.

Fixes: 7e7292dba215 ("ASoC: fsl: add imx-es8328 machine driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200825130224.1488694-1-yukuai3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-es8328.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/imx-es8328.c b/sound/soc/fsl/imx-es8328.c
index 15a27a2cd0cae..fad1eb6253d53 100644
--- a/sound/soc/fsl/imx-es8328.c
+++ b/sound/soc/fsl/imx-es8328.c
@@ -145,13 +145,13 @@ static int imx_es8328_probe(struct platform_device *pdev)
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		ret = -ENOMEM;
-		goto fail;
+		goto put_device;
 	}
 
 	comp = devm_kzalloc(dev, 3 * sizeof(*comp), GFP_KERNEL);
 	if (!comp) {
 		ret = -ENOMEM;
-		goto fail;
+		goto put_device;
 	}
 
 	data->dev = dev;
@@ -182,12 +182,12 @@ static int imx_es8328_probe(struct platform_device *pdev)
 	ret = snd_soc_of_parse_card_name(&data->card, "model");
 	if (ret) {
 		dev_err(dev, "Unable to parse card name\n");
-		goto fail;
+		goto put_device;
 	}
 	ret = snd_soc_of_parse_audio_routing(&data->card, "audio-routing");
 	if (ret) {
 		dev_err(dev, "Unable to parse routing: %d\n", ret);
-		goto fail;
+		goto put_device;
 	}
 	data->card.num_links = 1;
 	data->card.owner = THIS_MODULE;
@@ -196,10 +196,12 @@ static int imx_es8328_probe(struct platform_device *pdev)
 	ret = snd_soc_register_card(&data->card);
 	if (ret) {
 		dev_err(dev, "Unable to register: %d\n", ret);
-		goto fail;
+		goto put_device;
 	}
 
 	platform_set_drvdata(pdev, data);
+put_device:
+	put_device(&ssi_pdev->dev);
 fail:
 	of_node_put(ssi_np);
 	of_node_put(codec_np);
-- 
2.25.1



