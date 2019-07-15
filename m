Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05E468D43
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbfGON5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732545AbfGON5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:57:05 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F9C7212F5;
        Mon, 15 Jul 2019 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199025;
        bh=ifm9BaJa8jPBE/MqI6oKR7zqVQZgvgLz4itICySiQdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH/Fnd18GqkSE3/y/jUg3vWdF3WJZr0GD76iMozhLKNUjexXd8HzCZo/HuovYei+L
         6mj+E15xv9NUb2fZp3mMQTpYUagHKgHKtzJTJI44fT+2Q1YEMhVSBXdftBLkihvs93
         Rgbel6wdwBnv3GgisPg4n8NRVG4kC214SICtBzbY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 168/249] ASoC: Intel: hdac_hdmi: Set ops to NULL on remove
Date:   Mon, 15 Jul 2019 09:45:33 -0400
Message-Id: <20190715134655.4076-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

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

