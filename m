Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0E272FB5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgIUQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgIUQlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CA3239A1;
        Mon, 21 Sep 2020 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706494;
        bh=3fFjhSXkEdvGu2sCrP0+hIy37eBYx+itDtAIC9dTxFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eev3k/dLldLZffX5VCFJmo+WoxEi454U+2zYTUvrQm7FuJU+WKehVBZePJbOb+cGH
         UswBzgWpOEwkeZxtsvtvZwqPpeT7/+J7lxjiSg02ov5HEzfOzf97Iuw8OpdhppSalM
         qYdDR3fUg4aM48ZdW4v6ANC9x/P9lJPhlxAAemi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/49] ASoC: qcom: Set card->owner to avoid warnings
Date:   Mon, 21 Sep 2020 18:28:12 +0200
Message-Id: <20200921162035.897165856@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 3c27ea23ffb43262da6c64964163895951aaed4e ]

On Linux 5.9-rc1 I get the following warning with apq8016-sbc:

WARNING: CPU: 2 PID: 69 at sound/core/init.c:207 snd_card_new+0x36c/0x3b0 [snd]
CPU: 2 PID: 69 Comm: kworker/2:1 Not tainted 5.9.0-rc1 #1
Workqueue: events deferred_probe_work_func
pc : snd_card_new+0x36c/0x3b0 [snd]
lr : snd_card_new+0xf4/0x3b0 [snd]
Call trace:
 snd_card_new+0x36c/0x3b0 [snd]
 snd_soc_bind_card+0x340/0x9a0 [snd_soc_core]
 snd_soc_register_card+0xf4/0x110 [snd_soc_core]
 devm_snd_soc_register_card+0x44/0xa0 [snd_soc_core]
 apq8016_sbc_platform_probe+0x11c/0x140 [snd_soc_apq8016_sbc]

This warning was introduced in
commit 81033c6b584b ("ALSA: core: Warn on empty module").
It looks like we are supposed to set card->owner to THIS_MODULE.

Fix this for all the qcom ASoC drivers.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 79119c798649 ("ASoC: qcom: Add Storm machine driver")
Fixes: bdb052e81f62 ("ASoC: qcom: add apq8016 sound card support")
Fixes: a6f933f63f2f ("ASoC: qcom: apq8096: Add db820c machine driver")
Fixes: 6b1687bf76ef ("ASoC: qcom: add sdm845 sound card support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200820154511.203072-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/apq8016_sbc.c | 1 +
 sound/soc/qcom/apq8096.c     | 1 +
 sound/soc/qcom/sdm845.c      | 1 +
 sound/soc/qcom/storm.c       | 1 +
 4 files changed, 4 insertions(+)

diff --git a/sound/soc/qcom/apq8016_sbc.c b/sound/soc/qcom/apq8016_sbc.c
index 4b559932adc33..121460db8eacf 100644
--- a/sound/soc/qcom/apq8016_sbc.c
+++ b/sound/soc/qcom/apq8016_sbc.c
@@ -233,6 +233,7 @@ static int apq8016_sbc_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	card->dapm_widgets = apq8016_sbc_dapm_widgets;
 	card->num_dapm_widgets = ARRAY_SIZE(apq8016_sbc_dapm_widgets);
 	data = apq8016_sbc_parse_of(card);
diff --git a/sound/soc/qcom/apq8096.c b/sound/soc/qcom/apq8096.c
index 1543e85629f80..04f814a0a7d51 100644
--- a/sound/soc/qcom/apq8096.c
+++ b/sound/soc/qcom/apq8096.c
@@ -46,6 +46,7 @@ static int apq8096_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	dev_set_drvdata(dev, card);
 	ret = qcom_snd_parse_of(card);
 	if (ret) {
diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index 2a781d87ee65e..5fdbfa363ab16 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -226,6 +226,7 @@ static int sdm845_snd_platform_probe(struct platform_device *pdev)
 	}
 
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	dev_set_drvdata(dev, card);
 	ret = qcom_snd_parse_of(card);
 	if (ret) {
diff --git a/sound/soc/qcom/storm.c b/sound/soc/qcom/storm.c
index a9fa972466ad1..00a3f4c1b6fed 100644
--- a/sound/soc/qcom/storm.c
+++ b/sound/soc/qcom/storm.c
@@ -99,6 +99,7 @@ static int storm_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = &pdev->dev;
+	card->owner = THIS_MODULE;
 
 	ret = snd_soc_of_parse_card_name(card, "qcom,model");
 	if (ret) {
-- 
2.25.1



