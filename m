Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59243272F54
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgIUQoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729655AbgIUQoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9432D2399A;
        Mon, 21 Sep 2020 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706651;
        bh=QVOwEp/ilvmsvcYp+pcYqh2Ijh/X4nvBuPUUyBevBuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWkDPzyrS3GOb8LEwtws/Lks1GIABzAK6fJwqY17w4cn8PeVCztXn6m1GmJxrZshW
         2+X3a8iwoDziIphUFaju3865kW/lp1Mk2To3u2KGGdk9Ipup4FIPsreB2H8Pu5LC0I
         U+qTQ86vYgDVaTqdlQ3weK8T/XYk3Yy34LyPcfH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 039/118] ASoC: qcom: Set card->owner to avoid warnings
Date:   Mon, 21 Sep 2020 18:27:31 +0200
Message-Id: <20200921162038.118584776@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
index 2ef090f4af9e9..8abc1a95184b2 100644
--- a/sound/soc/qcom/apq8016_sbc.c
+++ b/sound/soc/qcom/apq8016_sbc.c
@@ -234,6 +234,7 @@ static int apq8016_sbc_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	card->dapm_widgets = apq8016_sbc_dapm_widgets;
 	card->num_dapm_widgets = ARRAY_SIZE(apq8016_sbc_dapm_widgets);
 	data = apq8016_sbc_parse_of(card);
diff --git a/sound/soc/qcom/apq8096.c b/sound/soc/qcom/apq8096.c
index 287ad2aa27f37..d47bedc259c59 100644
--- a/sound/soc/qcom/apq8096.c
+++ b/sound/soc/qcom/apq8096.c
@@ -114,6 +114,7 @@ static int apq8096_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	dev_set_drvdata(dev, card);
 	ret = qcom_snd_parse_of(card);
 	if (ret)
diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index 68e9388ff46f1..b5b8465caf56f 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -557,6 +557,7 @@ static int sdm845_snd_platform_probe(struct platform_device *pdev)
 	card->dapm_widgets = sdm845_snd_widgets;
 	card->num_dapm_widgets = ARRAY_SIZE(sdm845_snd_widgets);
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 	dev_set_drvdata(dev, card);
 	ret = qcom_snd_parse_of(card);
 	if (ret)
diff --git a/sound/soc/qcom/storm.c b/sound/soc/qcom/storm.c
index 3a6e18709b9e2..4ba111c841375 100644
--- a/sound/soc/qcom/storm.c
+++ b/sound/soc/qcom/storm.c
@@ -96,6 +96,7 @@ static int storm_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	card->dev = &pdev->dev;
+	card->owner = THIS_MODULE;
 
 	ret = snd_soc_of_parse_card_name(card, "qcom,model");
 	if (ret) {
-- 
2.25.1



