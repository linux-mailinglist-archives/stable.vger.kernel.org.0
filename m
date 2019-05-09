Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C6F1923B
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfEISrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbfEISrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65184217D7;
        Thu,  9 May 2019 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427651;
        bh=DRhEhGyYWBssR7wYLehVy2xwuilR7RyWyiKA0TLdZbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzC/R/PUG1UawOMEVYjYuxNdL8JoArROj/d2a56JUZ23dBzBKLfhG9gS8GFp3Ht3A
         yMaHlAx229cQG6f++fDY0ekJEirQQR+H8iFRlhhNQb+JTc7s8/sDY6UERXRO3luysW
         VIO10NN9BjSFV1O/dfGUCW9Y6z6SDmtO2MDwZUHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/66] ASoC: stm32: dfsdm: fix debugfs warnings on entry creation
Date:   Thu,  9 May 2019 20:41:55 +0200
Message-Id: <20190509181304.025650625@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c47255b61129857b74b0d86eaf59335348be05e0 ]

Register platform component with a prefix, to avoid warnings
on debugfs entries creation, due to component name
redundancy.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_adfsdm.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index 71d341b732a4d..24948b95eb19f 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -304,6 +304,7 @@ MODULE_DEVICE_TABLE(of, stm32_adfsdm_of_match);
 static int stm32_adfsdm_probe(struct platform_device *pdev)
 {
 	struct stm32_adfsdm_priv *priv;
+	struct snd_soc_component *component;
 	int ret;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -331,9 +332,15 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->iio_cb))
 		return PTR_ERR(priv->iio_cb);
 
-	ret = devm_snd_soc_register_component(&pdev->dev,
-					      &stm32_adfsdm_soc_platform,
-					      NULL, 0);
+	component = devm_kzalloc(&pdev->dev, sizeof(*component), GFP_KERNEL);
+	if (!component)
+		return -ENOMEM;
+#ifdef CONFIG_DEBUG_FS
+	component->debugfs_prefix = "pcm";
+#endif
+
+	ret = snd_soc_add_component(&pdev->dev, component,
+				    &stm32_adfsdm_soc_platform, NULL, 0);
 	if (ret < 0)
 		dev_err(&pdev->dev, "%s: Failed to register PCM platform\n",
 			__func__);
@@ -341,12 +348,20 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int stm32_adfsdm_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_component(&pdev->dev);
+
+	return 0;
+}
+
 static struct platform_driver stm32_adfsdm_driver = {
 	.driver = {
 		   .name = STM32_ADFSDM_DRV_NAME,
 		   .of_match_table = stm32_adfsdm_of_match,
 		   },
 	.probe = stm32_adfsdm_probe,
+	.remove = stm32_adfsdm_remove,
 };
 
 module_platform_driver(stm32_adfsdm_driver);
-- 
2.20.1



