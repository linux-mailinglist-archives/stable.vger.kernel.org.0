Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D6245C3F3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351198AbhKXNoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353535AbhKXNn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C5363287;
        Wed, 24 Nov 2021 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758718;
        bh=SDGLMV+MLgbMexAeVVZkYtNMnG+usCvtNMqhaH/JzSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO9YabjT5WGBH913+TGSUsnF3Hq7UpJ/Bl9lhiht3f65iQwgJ66UENsKh9AJWzgNs
         vMNisWWkF9nYM/lFgOups9AHR2f/2hSNhxAviseM0JWt8/LooVuABq/vpSfoOEFeOr
         oGN3QetvDfNrAk6fS1mdQC8FVRvJAkMurJR8euqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu-Hsuan Hsu <yuhsuan@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 149/154] ASoC: DAPM: Cover regression by kctl change notification fix
Date:   Wed, 24 Nov 2021 12:59:05 +0100
Message-Id: <20211124115707.297098480@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 827b0913a9d9d07a0c3e559dbb20ca4d6d285a54 upstream.

The recent fix for DAPM to correct the kctl change notification by the
commit 5af82c81b2c4 ("ASoC: DAPM: Fix missing kctl change
notifications") caused other regressions since it changed the behavior
of snd_soc_dapm_set_pin() that is called from several API functions.
Formerly it returned always 0 for success, but now it returns 0 or 1.

This patch addresses it, restoring the old behavior of
snd_soc_dapm_set_pin() while keeping the fix in
snd_soc_dapm_put_pin_switch().

Fixes: 5af82c81b2c4 ("ASoC: DAPM: Fix missing kctl change notifications")
Reported-by: Yu-Hsuan Hsu <yuhsuan@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211105090925.20575-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2555,8 +2555,13 @@ static struct snd_soc_dapm_widget *dapm_
 	return NULL;
 }
 
-static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
-				const char *pin, int status)
+/*
+ * set the DAPM pin status:
+ * returns 1 when the value has been updated, 0 when unchanged, or a negative
+ * error code; called from kcontrol put callback
+ */
+static int __snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
+				  const char *pin, int status)
 {
 	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
 	int ret = 0;
@@ -2582,6 +2587,18 @@ static int snd_soc_dapm_set_pin(struct s
 	return ret;
 }
 
+/*
+ * similar as __snd_soc_dapm_set_pin(), but returns 0 when successful;
+ * called from several API functions below
+ */
+static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
+				const char *pin, int status)
+{
+	int ret = __snd_soc_dapm_set_pin(dapm, pin, status);
+
+	return ret < 0 ? ret : 0;
+}
+
 /**
  * snd_soc_dapm_sync_unlocked - scan and power dapm paths
  * @dapm: DAPM context
@@ -3586,10 +3603,10 @@ int snd_soc_dapm_put_pin_switch(struct s
 	const char *pin = (const char *)kcontrol->private_value;
 	int ret;
 
-	if (ucontrol->value.integer.value[0])
-		ret = snd_soc_dapm_enable_pin(&card->dapm, pin);
-	else
-		ret = snd_soc_dapm_disable_pin(&card->dapm, pin);
+	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+	ret = __snd_soc_dapm_set_pin(&card->dapm, pin,
+				     !!ucontrol->value.integer.value[0]);
+	mutex_unlock(&card->dapm_mutex);
 
 	snd_soc_dapm_sync(&card->dapm);
 	return ret;


