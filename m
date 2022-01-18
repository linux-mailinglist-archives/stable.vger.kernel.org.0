Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE0491E39
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349565AbiARDsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:48:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49202 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347022AbiARCka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:40:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F131B81229;
        Tue, 18 Jan 2022 02:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D6FC36AE3;
        Tue, 18 Jan 2022 02:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473627;
        bh=lIX2r7eSQ/EpCjwtdMC7rJeKPE+cTnyydeIsvHazwQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7COKM5phOPBEphW3+oaaEPg21M7gYJsPYjY4DKBGKXY4lpPYir8BzWDX9vU479f/
         +mMc0felU952tM7RHNeaRF3hcbCEIftuJTC9+Zmk4x+G7H9uv7RZGfPbP0YC1fR9ep
         ZMaaNuXZI08jNa646P9Owm2SEHvaVHuWCqkU/yYcRHeLtWthHfn3M3RnHSpj2WU79A
         vx9LAhZiOj9Pqk2aGSw6lVdafdGVJEBa6Dv9mzBuvaJAbZk1fzPMREV5x2jeSt59wX
         aOOC8SKzWhKTAITuxpmH6DyrRApAFGkxZ2QF0T9JGmQbxIx9H7TRYehexxebHVr4X/
         Fcz1RUzBe/orQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, andrzej.hajda@intel.com,
        robert.foss@linaro.org, airlied@linux.ie, daniel@ffwll.ch,
        laurent.pinchart+renesas@ideasonboard.com, maxime@cerno.tech,
        harry.wentland@amd.com, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 007/116] drm/bridge: dw-hdmi: handle ELD when DRM_BRIDGE_ATTACH_NO_CONNECTOR
Date:   Mon, 17 Jan 2022 21:38:18 -0500
Message-Id: <20220118024007.1950576-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9fef6413741dc..9682416056ed6 100644
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
index 0c79a9ba48bb6..29c0eb4bd7546 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -756,6 +756,14 @@ static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi, bool enable)
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
@@ -3395,7 +3403,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 		audio.base = hdmi->regs;
 		audio.irq = irq;
 		audio.hdmi = hdmi;
-		audio.eld = hdmi->connector.eld;
+		audio.get_eld = hdmi_audio_get_eld;
 		hdmi->enable_audio = dw_hdmi_ahb_audio_enable;
 		hdmi->disable_audio = dw_hdmi_ahb_audio_disable;
 
@@ -3408,7 +3416,7 @@ struct dw_hdmi *dw_hdmi_probe(struct platform_device *pdev,
 		struct dw_hdmi_i2s_audio_data audio;
 
 		audio.hdmi	= hdmi;
-		audio.eld	= hdmi->connector.eld;
+		audio.get_eld	= hdmi_audio_get_eld;
 		audio.write	= hdmi_writeb;
 		audio.read	= hdmi_readb;
 		hdmi->enable_audio = dw_hdmi_i2s_audio_enable;
-- 
2.34.1

