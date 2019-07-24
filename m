Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062B173F35
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbfGXUat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388479AbfGXTb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C9221951;
        Wed, 24 Jul 2019 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996686;
        bh=IwmdfIkC2MqFSmTk8Jj9ODAe/YIn4lBeiRKZeC1gaSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bj6MDSt+DP6fD3Op5WbKktvuWvDQRKUaXaatIShNZ4yQPgzSFeqth6EmbvefhOo/7
         TrCXG2AEX8eL8ini3txrnff4stg/lsh97xvrlyVN5YpSHjJZo4I4JWJ44L85kJgtD5
         SE+U9j2LRwmrwYjoE/Y0Pu1uDq8cr2YhTjMhjGac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 165/413] ASoC: Intel: hdac_hdmi: Set ops to NULL on remove
Date:   Wed, 24 Jul 2019 21:17:36 +0200
Message-Id: <20190724191746.841668644@linuxfoundation.org>
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

[ Upstream commit 0f6ff78540bd1b4df1e0f17806b0ce2e1dff0d78 ]

When we unload Skylake driver we may end up calling
hdac_component_master_unbind(), it uses acomp->audio_ops, which we set
in hdmi_codec_probe(), so we need to set it to NULL in hdmi_codec_remove(),
otherwise we will dereference no longer existing pointer.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 1f57126708e7..c9f9820968bb 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -1859,6 +1859,12 @@ static void hdmi_codec_remove(struct snd_soc_component *component)
 {
 	struct hdac_hdmi_priv *hdmi = snd_soc_component_get_drvdata(component);
 	struct hdac_device *hdev = hdmi->hdev;
+	int ret;
+
+	ret = snd_hdac_acomp_register_notifier(hdev->bus, NULL);
+	if (ret < 0)
+		dev_err(&hdev->dev, "notifier unregister failed: err: %d\n",
+				ret);
 
 	pm_runtime_disable(&hdev->dev);
 }
-- 
2.20.1



