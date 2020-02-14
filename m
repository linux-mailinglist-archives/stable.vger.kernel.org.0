Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5124515F09D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbgBNRzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387883AbgBNP5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8D922314;
        Fri, 14 Feb 2020 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695857;
        bh=TreOZo7LIfFEOx2Eary8QjXSr38gn5Y71VR/D+FQBwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMoAMTiMdweWsCmqQPNYH3YVhHN+9ko70fo0gDj9dpY4fYsiHinO1U00ZSeHEu5bL
         6/afuXc1ik87EAtL7sNC7YOW5XF2+HJV6xD9yeO6LYRlpL4OKunpFsWPbv7RzeSU5H
         7Kt6MxVyqPaXi9/UWEJa4YTyHJgRwLtqz+siSoY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 405/542] ASoC: wm_adsp: Correct cache handling of new kernel control API
Date:   Fri, 14 Feb 2020 10:46:37 -0500
Message-Id: <20200214154854.6746-405-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 73ecf1a673d3502dff1445f06675aba65ff20ce7 ]

The recently added API that exposes firmware mixer controls to the
kernel is missing cache handling and all writes bypass the cache, this
obviously causes the cache to get out of sync with the hardware. Factor
out the cache handling into two new helper functions and call those from
both the normal ALSA control handlers and the new kernel API.

Fixes: eb65ccdb0836 ("ASoC: wm_adsp: Expose mixer control API")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200114161841.451-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 98 ++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 2a9b610f6d435..d3d32b501acae 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1030,8 +1030,8 @@ static int wm_coeff_write_acked_control(struct wm_coeff_ctl *ctl,
 	return -ETIMEDOUT;
 }
 
-static int wm_coeff_write_control(struct wm_coeff_ctl *ctl,
-				  const void *buf, size_t len)
+static int wm_coeff_write_ctrl_raw(struct wm_coeff_ctl *ctl,
+				   const void *buf, size_t len)
 {
 	struct wm_adsp *dsp = ctl->dsp;
 	void *scratch;
@@ -1061,6 +1061,23 @@ static int wm_coeff_write_control(struct wm_coeff_ctl *ctl,
 	return 0;
 }
 
+static int wm_coeff_write_ctrl(struct wm_coeff_ctl *ctl,
+			       const void *buf, size_t len)
+{
+	int ret = 0;
+
+	if (ctl->flags & WMFW_CTL_FLAG_VOLATILE)
+		ret = -EPERM;
+	else if (buf != ctl->cache)
+		memcpy(ctl->cache, buf, len);
+
+	ctl->set = 1;
+	if (ctl->enabled && ctl->dsp->running)
+		ret = wm_coeff_write_ctrl_raw(ctl, buf, len);
+
+	return ret;
+}
+
 static int wm_coeff_put(struct snd_kcontrol *kctl,
 			struct snd_ctl_elem_value *ucontrol)
 {
@@ -1071,16 +1088,7 @@ static int wm_coeff_put(struct snd_kcontrol *kctl,
 	int ret = 0;
 
 	mutex_lock(&ctl->dsp->pwr_lock);
-
-	if (ctl->flags & WMFW_CTL_FLAG_VOLATILE)
-		ret = -EPERM;
-	else
-		memcpy(ctl->cache, p, ctl->len);
-
-	ctl->set = 1;
-	if (ctl->enabled && ctl->dsp->running)
-		ret = wm_coeff_write_control(ctl, p, ctl->len);
-
+	ret = wm_coeff_write_ctrl(ctl, p, ctl->len);
 	mutex_unlock(&ctl->dsp->pwr_lock);
 
 	return ret;
@@ -1096,15 +1104,10 @@ static int wm_coeff_tlv_put(struct snd_kcontrol *kctl,
 
 	mutex_lock(&ctl->dsp->pwr_lock);
 
-	if (copy_from_user(ctl->cache, bytes, size)) {
+	if (copy_from_user(ctl->cache, bytes, size))
 		ret = -EFAULT;
-	} else {
-		ctl->set = 1;
-		if (ctl->enabled && ctl->dsp->running)
-			ret = wm_coeff_write_control(ctl, ctl->cache, size);
-		else if (ctl->flags & WMFW_CTL_FLAG_VOLATILE)
-			ret = -EPERM;
-	}
+	else
+		ret = wm_coeff_write_ctrl(ctl, ctl->cache, size);
 
 	mutex_unlock(&ctl->dsp->pwr_lock);
 
@@ -1135,8 +1138,8 @@ static int wm_coeff_put_acked(struct snd_kcontrol *kctl,
 	return ret;
 }
 
-static int wm_coeff_read_control(struct wm_coeff_ctl *ctl,
-				 void *buf, size_t len)
+static int wm_coeff_read_ctrl_raw(struct wm_coeff_ctl *ctl,
+				  void *buf, size_t len)
 {
 	struct wm_adsp *dsp = ctl->dsp;
 	void *scratch;
@@ -1166,29 +1169,37 @@ static int wm_coeff_read_control(struct wm_coeff_ctl *ctl,
 	return 0;
 }
 
-static int wm_coeff_get(struct snd_kcontrol *kctl,
-			struct snd_ctl_elem_value *ucontrol)
+static int wm_coeff_read_ctrl(struct wm_coeff_ctl *ctl, void *buf, size_t len)
 {
-	struct soc_bytes_ext *bytes_ext =
-		(struct soc_bytes_ext *)kctl->private_value;
-	struct wm_coeff_ctl *ctl = bytes_ext_to_ctl(bytes_ext);
-	char *p = ucontrol->value.bytes.data;
 	int ret = 0;
 
-	mutex_lock(&ctl->dsp->pwr_lock);
-
 	if (ctl->flags & WMFW_CTL_FLAG_VOLATILE) {
 		if (ctl->enabled && ctl->dsp->running)
-			ret = wm_coeff_read_control(ctl, p, ctl->len);
+			return wm_coeff_read_ctrl_raw(ctl, buf, len);
 		else
-			ret = -EPERM;
+			return -EPERM;
 	} else {
 		if (!ctl->flags && ctl->enabled && ctl->dsp->running)
-			ret = wm_coeff_read_control(ctl, ctl->cache, ctl->len);
+			ret = wm_coeff_read_ctrl_raw(ctl, ctl->cache, ctl->len);
 
-		memcpy(p, ctl->cache, ctl->len);
+		if (buf != ctl->cache)
+			memcpy(buf, ctl->cache, len);
 	}
 
+	return ret;
+}
+
+static int wm_coeff_get(struct snd_kcontrol *kctl,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct soc_bytes_ext *bytes_ext =
+		(struct soc_bytes_ext *)kctl->private_value;
+	struct wm_coeff_ctl *ctl = bytes_ext_to_ctl(bytes_ext);
+	char *p = ucontrol->value.bytes.data;
+	int ret;
+
+	mutex_lock(&ctl->dsp->pwr_lock);
+	ret = wm_coeff_read_ctrl(ctl, p, ctl->len);
 	mutex_unlock(&ctl->dsp->pwr_lock);
 
 	return ret;
@@ -1204,15 +1215,7 @@ static int wm_coeff_tlv_get(struct snd_kcontrol *kctl,
 
 	mutex_lock(&ctl->dsp->pwr_lock);
 
-	if (ctl->flags & WMFW_CTL_FLAG_VOLATILE) {
-		if (ctl->enabled && ctl->dsp->running)
-			ret = wm_coeff_read_control(ctl, ctl->cache, size);
-		else
-			ret = -EPERM;
-	} else {
-		if (!ctl->flags && ctl->enabled && ctl->dsp->running)
-			ret = wm_coeff_read_control(ctl, ctl->cache, size);
-	}
+	ret = wm_coeff_read_ctrl_raw(ctl, ctl->cache, size);
 
 	if (!ret && copy_to_user(bytes, ctl->cache, size))
 		ret = -EFAULT;
@@ -1340,7 +1343,7 @@ static int wm_coeff_init_control_caches(struct wm_adsp *dsp)
 		 * created so we don't need to do anything.
 		 */
 		if (!ctl->flags || (ctl->flags & WMFW_CTL_FLAG_READABLE)) {
-			ret = wm_coeff_read_control(ctl, ctl->cache, ctl->len);
+			ret = wm_coeff_read_ctrl_raw(ctl, ctl->cache, ctl->len);
 			if (ret < 0)
 				return ret;
 		}
@@ -1358,7 +1361,8 @@ static int wm_coeff_sync_controls(struct wm_adsp *dsp)
 		if (!ctl->enabled)
 			continue;
 		if (ctl->set && !(ctl->flags & WMFW_CTL_FLAG_VOLATILE)) {
-			ret = wm_coeff_write_control(ctl, ctl->cache, ctl->len);
+			ret = wm_coeff_write_ctrl_raw(ctl, ctl->cache,
+						      ctl->len);
 			if (ret < 0)
 				return ret;
 		}
@@ -2048,7 +2052,7 @@ int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 	if (len > ctl->len)
 		return -EINVAL;
 
-	ret = wm_coeff_write_control(ctl, buf, len);
+	ret = wm_coeff_write_ctrl(ctl, buf, len);
 
 	kcontrol = snd_soc_card_get_kcontrol(dsp->component->card, ctl->name);
 	snd_ctl_notify(dsp->component->card->snd_card,
@@ -2070,7 +2074,7 @@ int wm_adsp_read_ctl(struct wm_adsp *dsp, const char *name, int type,
 	if (len > ctl->len)
 		return -EINVAL;
 
-	return wm_coeff_read_control(ctl, buf, len);
+	return wm_coeff_read_ctrl(ctl, buf, len);
 }
 EXPORT_SYMBOL_GPL(wm_adsp_read_ctl);
 
-- 
2.20.1

