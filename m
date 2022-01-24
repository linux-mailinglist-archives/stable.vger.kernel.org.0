Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B2499C37
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578814AbiAXWDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576173AbiAXVxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1225EC07E286;
        Mon, 24 Jan 2022 12:34:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3CC461530;
        Mon, 24 Jan 2022 20:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81743C340E5;
        Mon, 24 Jan 2022 20:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056477;
        bh=9ThM2tKjcmelkSf3NnzxN7fdj2TU5ZXZctFcGUmZTsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtGsxLD9G3StYZ/yJcx8Q4Kh2wRBG3IbSESbx8XHkO2iI4JSxyjIK2nB2kqxpmymw
         53ddL/UyB0ApOz2u018oOtLQ4dmoiUlKGNhF9KcZKkd96o694to7MPa6sUJ2O0X6B0
         Ht+jmqABkMa8XSt8BlHuXeMHE6Fl7zULNQpUXiSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/846] drm/bridge: dw-hdmi: handle ELD when DRM_BRIDGE_ATTACH_NO_CONNECTOR
Date:   Mon, 24 Jan 2022 19:39:47 +0100
Message-Id: <20220124184117.217663032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 3f2532d65a571ca02258b547b5b68ab2e9406fdb ]

The current ELD handling takes the internal connector ELD buffer and
shares it to the I2S and AHB sub-driver.

But with DRM_BRIDGE_ATTACH_NO_CONNECTOR, the connector is created
elsewhere (or not), and an eventual connector is known only
if the bridge chain up to a connector is enabled.

The current dw-hdmi code gets the current connector from
atomic_enable() so use the already stored connector pointer and
replace the buffer pointer with a callback returning the current
connector ELD buffer.

Since a connector is not always available, either pass an empty
ELD to the alsa HDMI driver or don't call snd_pcm_hw_constraint_eld()
in AHB driver.

Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: fixed typo in commit log]
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211029135947.3022875-1-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c | 10 +++++++---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h     |  4 ++--
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c |  9 ++++++++-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c           | 12 ++++++++++--
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
index d0db1acf11d73..7d2ed0ed2fe26 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
@@ -320,13 +320,17 @@ static int dw_hdmi_open(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_dw_hdmi *dw = substream->private_data;
 	void __iomem *base = dw->data.base;
+	u8 *eld;
 	int ret;
 
 	runtime->hw = dw_hdmi_hw;
 
-	ret = snd_pcm_hw_constraint_eld(runtime, dw->data.eld);
-	if (ret < 0)
-		return ret;
+	eld = dw->data.get_eld(dw->data.hdmi);
+	if (eld) {
+		ret = snd_pcm_hw_constraint_eld(runtime, eld);
+		if (ret < 0)
+			return ret;
+	}
 
 	ret = snd_pcm_limit_hw_rates(runtime);
 	if (ret < 0)
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h
index cb07dc0da5a70..f72d27208ebef 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-audio.h
@@ -9,15 +9,15 @@ struct dw_hdmi_audio_data {
 	void __iomem *base;
 	int irq;
 	struct dw_hdmi *hdmi;
-	u8 *eld;
+	u8 *(*get_eld)(struct dw_hdmi *hdmi);
 };
 
 struct dw_hdmi_i2s_audio_data {
 	struct dw_hdmi *hdmi;
-	u8 *eld;
 
 	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
 	u8 (*read)(struct dw_hdmi *hdmi, int offset);
+	u8 *(*get_eld)(struct dw_hdmi *hdmi);
 };
 
 #endif
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c
index feb04f127b550..f50b47ac11a82 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c
@@ -135,8 +135,15 @@ static int dw_hdmi_i2s_get_eld(struct device *dev, void *data, uint8_t *buf,
 			       size_t len)
 {
 	struct dw_hdmi_i2s_audio_data *audio = data;
+	u8 *eld;
+
+	eld = audio->get_eld(audio->hdmi);
+	if (eld)
+		memcpy(buf, eld, min_t(size_t, MAX_ELD_BYTES, len));
+	else
+		/* Pass en empty ELD if connector not available */
+		memset(buf, 0, len);
 
-	memcpy(buf, audio->eld, min_t(size_t, MAX_ELD_BYTES, len));
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index f08d0fded61f7..e1211a5b334ba 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -757,6 +757,14 @@ static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi, bool enable)
 	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 }
 
+static u8 *hdmi_audio_get_eld(struct dw_hdmi *hdmi)
+{
+	if (!hdmi->curr_conn)
+		return NULL;
+
+	return hdmi->curr_conn->eld;
+}
+
 static void dw_hdmi_ahb_audio_enable(struct dw_hdmi *hdmi)
 {
 	hdmi_set_cts_n(hdmi, hdmi->audio_cts, hdmi->audio_n);
@@ -3431,7 +3439,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 		audio.base = hdmi->regs;
 		audio.irq = irq;
 		audio.hdmi = hdmi;
-		audio.eld = hdmi->connector.eld;
+		audio.get_eld = hdmi_audio_get_eld;
 		hdmi->enable_audio = dw_hdmi_ahb_audio_enable;
 		hdmi->disable_audio = dw_hdmi_ahb_audio_disable;
 
@@ -3444,7 +3452,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 		struct dw_hdmi_i2s_audio_data audio;
 
 		audio.hdmi	= hdmi;
-		audio.eld	= hdmi->connector.eld;
+		audio.get_eld	= hdmi_audio_get_eld;
 		audio.write	= hdmi_writeb;
 		audio.read	= hdmi_readb;
 		hdmi->enable_audio = dw_hdmi_i2s_audio_enable;
-- 
2.34.1



