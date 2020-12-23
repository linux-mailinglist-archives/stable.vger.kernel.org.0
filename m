Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B637B2E1232
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgLWCTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgLWCTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61BC822AAF;
        Wed, 23 Dec 2020 02:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689967;
        bh=mK6F1eNbCDeh/+Jdo2XeFy0nr6p5hB+HBpXQR9qJtFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmRhVjf9GlWmohL3byKflPWUS90gw+rLPA3gkdMSYAUKRVHoQaqe6FiRhjRDX3CLI
         52OfPa8jf8aNpQPF9hW6TuP7DZz8hhnX1gl5WlvNrYQTTvU+92yoiZ2/V/Lrq/zevb
         f1WLglTAUYyCmTPWnT+I3Macou/vfghIQXIhfq47zyEbz2x+aRcpbtx1H87CO7kICI
         /XxYAmWO3+1do6Ok5iWDrtalL4Ddr7Hoy1l+lK7UYgReDceECiEsZmB72iq6d2XNv9
         RVcsh30IdOubsGCr6tv3AWtoxePCWsSR0vSe3NB1ByOiBZObhm9Ig1UAmKA46QO2ma
         Do7HyGNLslBzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Dylan Robinson <dylan_robinson@motu.com>,
        Keith Milner <kamilner@superlative.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 057/130] ALSA: usb-audio: Check valid altsetting at parsing rates for UAC2/3
Date:   Tue, 22 Dec 2020 21:17:00 -0500
Message-Id: <20201223021813.2791612-57-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 93db51d06b32227319dae2ac289029ccf1b33181 ]

The current driver code assumes blindly that all found sample rates for
the same endpoint from the UAC2 and UAC3 descriptors can be used no
matter which altsetting, but actually this was wrong: some devices
accept only limited sample rates in each altsetting.  For determining
which altsetting supports which rate, we need to verify each sample rate
and check the validity via UAC2_AS_VAL_ALT_SETTINGS.  This control
reports back the available altsettings as a bitmap.

This patch implements the missing piece above, the verification and
reconstructs the sample rate tables based on the result.

An open question is how to deal with the altsettings that ended up
with no valid sample rates after verification.  At least, there is a
device that showed this problem although the sample rates did work in
the later usage (see bug link).  For now, we accept such an altset as
is, assuming that it's a firmware bug.

Reported-by: Dylan Robinson <dylan_robinson@motu.com>
Tested-by: Keith Milner <kamilner@superlative.org>
Tested-by: Dylan Robinson <dylan_robinson@motu.com>
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1178203
Link: https://lore.kernel.org/r/20201123085347.19667-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c  | 106 ++++++++++++++++++++++++++-------------------
 sound/usb/clock.h  |   4 ++
 sound/usb/format.c |  93 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+), 45 deletions(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index b118cf97607f3..960174485a531 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -560,16 +560,60 @@ static int get_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 	return le32_to_cpu(data);
 }
 
+/*
+ * Try to set the given sample rate:
+ *
+ * Return 0 if the clock source is read-only, the actual rate on success,
+ * or a negative error code.
+ *
+ * This function gets called from format.c to validate each sample rate, too.
+ * Hence no message is shown upon error
+ */
+int snd_usb_set_sample_rate_v2v3(struct snd_usb_audio *chip,
+				 const struct audioformat *fmt,
+				 int clock, int rate)
+{
+	bool writeable;
+	u32 bmControls;
+	__le32 data;
+	int err;
+
+	if (fmt->protocol == UAC_VERSION_3) {
+		struct uac3_clock_source_descriptor *cs_desc;
+
+		cs_desc = snd_usb_find_clock_source_v3(chip->ctrl_intf, clock);
+		bmControls = le32_to_cpu(cs_desc->bmControls);
+	} else {
+		struct uac_clock_source_descriptor *cs_desc;
+
+		cs_desc = snd_usb_find_clock_source(chip->ctrl_intf, clock);
+		bmControls = cs_desc->bmControls;
+	}
+
+	writeable = uac_v2v3_control_is_writeable(bmControls,
+						  UAC2_CS_CONTROL_SAM_FREQ);
+	if (!writeable)
+		return 0;
+
+	data = cpu_to_le32(rate);
+	err = snd_usb_ctl_msg(chip->dev, usb_sndctrlpipe(chip->dev, 0), UAC2_CS_CUR,
+			      USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			      UAC2_CS_CONTROL_SAM_FREQ << 8,
+			      snd_usb_ctrl_intf(chip) | (clock << 8),
+			      &data, sizeof(data));
+	if (err < 0)
+		return err;
+
+	return get_sample_rate_v2v3(chip, fmt->iface, fmt->altsetting, clock);
+}
+
 static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
-			      struct usb_host_interface *alts,
-			      struct audioformat *fmt, int rate)
+				struct usb_host_interface *alts,
+				struct audioformat *fmt, int rate)
 {
 	struct usb_device *dev = chip->dev;
-	__le32 data;
-	int err, cur_rate, prev_rate;
+	int cur_rate, prev_rate;
 	int clock;
-	bool writeable;
-	u32 bmControls;
 
 	/* First, try to find a valid clock. This may trigger
 	 * automatic clock selection if the current clock is not
@@ -592,50 +636,22 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip, int iface,
 	if (prev_rate == rate)
 		goto validation;
 
-	if (fmt->protocol == UAC_VERSION_3) {
-		struct uac3_clock_source_descriptor *cs_desc;
-
-		cs_desc = snd_usb_find_clock_source_v3(chip->ctrl_intf, clock);
-		bmControls = le32_to_cpu(cs_desc->bmControls);
-	} else {
-		struct uac_clock_source_descriptor *cs_desc;
-
-		cs_desc = snd_usb_find_clock_source(chip->ctrl_intf, clock);
-		bmControls = cs_desc->bmControls;
+	cur_rate = snd_usb_set_sample_rate_v2v3(chip, fmt, clock, rate);
+	if (cur_rate < 0) {
+		usb_audio_err(chip,
+			      "%d:%d: cannot set freq %d (v2/v3): err %d\n",
+			      iface, fmt->altsetting, rate, cur_rate);
+		return cur_rate;
 	}
 
-	writeable = uac_v2v3_control_is_writeable(bmControls,
-						  UAC2_CS_CONTROL_SAM_FREQ);
-	if (writeable) {
-		data = cpu_to_le32(rate);
-		err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC2_CS_CUR,
-				      USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-				      UAC2_CS_CONTROL_SAM_FREQ << 8,
-				      snd_usb_ctrl_intf(chip) | (clock << 8),
-				      &data, sizeof(data));
-		if (err < 0) {
-			usb_audio_err(chip,
-				"%d:%d: cannot set freq %d (v2/v3): err %d\n",
-				iface, fmt->altsetting, rate, err);
-			return err;
-		}
-
-		cur_rate = get_sample_rate_v2v3(chip, iface,
-						fmt->altsetting, clock);
-	} else {
+	if (!cur_rate)
 		cur_rate = prev_rate;
-	}
 
 	if (cur_rate != rate) {
-		if (!writeable) {
-			usb_audio_warn(chip,
-				 "%d:%d: freq mismatch (RO clock): req %d, clock runs @%d\n",
-				 iface, fmt->altsetting, rate, cur_rate);
-			return -ENXIO;
-		}
-		usb_audio_dbg(chip,
-			"current rate %d is different from the runtime rate %d\n",
-			cur_rate, rate);
+		usb_audio_warn(chip,
+			       "%d:%d: freq mismatch (RO clock): req %d, clock runs @%d\n",
+			       fmt->iface, fmt->altsetting, rate, cur_rate);
+		return -ENXIO;
 	}
 
 	/* Some devices doesn't respond to sample rate changes while the
diff --git a/sound/usb/clock.h b/sound/usb/clock.h
index 68df0fbe09d00..97597f5a3c18a 100644
--- a/sound/usb/clock.h
+++ b/sound/usb/clock.h
@@ -9,4 +9,8 @@ int snd_usb_init_sample_rate(struct snd_usb_audio *chip, int iface,
 int snd_usb_clock_find_source(struct snd_usb_audio *chip,
 			      struct audioformat *fmt, bool validate);
 
+int snd_usb_set_sample_rate_v2v3(struct snd_usb_audio *chip,
+				 const struct audioformat *fmt,
+				 int clock, int rate);
+
 #endif /* __USBAUDIO_CLOCK_H */
diff --git a/sound/usb/format.c b/sound/usb/format.c
index 1f9ea513230a6..442df4578182d 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -367,6 +367,97 @@ static int line6_parse_audio_format_rates_quirk(struct snd_usb_audio *chip,
 	return -ENODEV;
 }
 
+/* check whether the given altsetting is supported for the already set rate */
+static bool check_valid_altsetting_v2v3(struct snd_usb_audio *chip, int iface,
+					int altsetting)
+{
+	struct usb_device *dev = chip->dev;
+	__le64 raw_data = 0;
+	u64 data;
+	int err;
+
+	/* we assume 64bit is enough for any altsettings */
+	if (snd_BUG_ON(altsetting >= 64 - 8))
+		return false;
+
+	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC2_CS_CUR,
+			      USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			      UAC2_AS_VAL_ALT_SETTINGS << 8,
+			      iface, &raw_data, sizeof(raw_data));
+	if (err < 0)
+		return false;
+
+	data = le64_to_cpu(raw_data);
+	/* first byte contains the bitmap size */
+	if ((data & 0xff) * 8 < altsetting)
+		return false;
+	if (data & (1ULL << (altsetting + 8)))
+		return true;
+
+	return false;
+}
+
+/*
+ * Validate each sample rate with the altsetting
+ * Rebuild the rate table if only partial values are valid
+ */
+static int validate_sample_rate_table_v2v3(struct snd_usb_audio *chip,
+					   struct audioformat *fp,
+					   int clock)
+{
+	struct usb_device *dev = chip->dev;
+	unsigned int *table;
+	unsigned int nr_rates;
+	unsigned int rate_min = 0x7fffffff;
+	unsigned int rate_max = 0;
+	unsigned int rates = 0;
+	int i, err;
+
+	table = kcalloc(fp->nr_rates, sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	/* clear the interface altsetting at first */
+	usb_set_interface(dev, fp->iface, 0);
+
+	nr_rates = 0;
+	for (i = 0; i < fp->nr_rates; i++) {
+		err = snd_usb_set_sample_rate_v2v3(chip, fp, clock,
+						   fp->rate_table[i]);
+		if (err < 0)
+			continue;
+
+		if (check_valid_altsetting_v2v3(chip, fp->iface, fp->altsetting)) {
+			table[nr_rates++] = fp->rate_table[i];
+			if (rate_min > fp->rate_table[i])
+				rate_min = fp->rate_table[i];
+			if (rate_max < fp->rate_table[i])
+				rate_max = fp->rate_table[i];
+			rates |= snd_pcm_rate_to_rate_bit(fp->rate_table[i]);
+		}
+	}
+
+	if (!nr_rates) {
+		usb_audio_dbg(chip,
+			      "No valid sample rate available for %d:%d, assuming a firmware bug\n",
+			      fp->iface, fp->altsetting);
+		nr_rates = fp->nr_rates; /* continue as is */
+	}
+
+	if (fp->nr_rates == nr_rates) {
+		kfree(table);
+		return 0;
+	}
+
+	kfree(fp->rate_table);
+	fp->rate_table = table;
+	fp->nr_rates = nr_rates;
+	fp->rate_min = rate_min;
+	fp->rate_max = rate_max;
+	fp->rates = rates;
+	return 0;
+}
+
 /*
  * parse the format descriptor and stores the possible sample rates
  * on the audioformat table (audio class v2 and v3).
@@ -459,6 +550,8 @@ static int parse_audio_format_rates_v2v3(struct snd_usb_audio *chip,
 	 * allocated, so the rates will be stored */
 	parse_uac2_sample_rate_range(chip, fp, nr_triplets, data);
 
+	ret = validate_sample_rate_table_v2v3(chip, fp, clock);
+
 err_free:
 	kfree(data);
 err:
-- 
2.27.0

