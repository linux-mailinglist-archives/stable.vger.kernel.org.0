Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DFB1E2DC6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391097AbgEZTIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391102AbgEZTIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 829B220776;
        Tue, 26 May 2020 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520079;
        bh=HGUPNIe73QIjL27PZuX7tKHL8j52LyP2cHr0uS7yZtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3WEI8DskkaH5DCuP78rGPIV9HGJHDdUgKNQhuE9sBRT0+HmHtbCIhZt9v6ccDBGK
         5/OZtniYDiOfS7LxHsxWiR5nr7UWJOrVz8IPvGGDveaQ0E7MASEJNI1P7o0KxOpaxo
         mcvbhJDp3yCnT/rjcJrsrN1XKa1kpdUixWmmoYAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/111] ALSA: hda: Manage concurrent reg access more properly
Date:   Tue, 26 May 2020 20:53:08 +0200
Message-Id: <20200526183937.615609255@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1a462be52f4505a2719631fb5aa7bfdbd37bfd8d ]

In the commit 8e85def5723e ("ALSA: hda: enable regmap internal
locking"), we re-enabled the regmap lock due to the reported
regression that showed the possible concurrent accesses.  It was a
temporary workaround, and there are still a few opened races even
after the revert.  In this patch, we cover those still opened windows
with a proper mutex lock and disable the regmap internal lock again.

First off, the patch introduces a new snd_hdac_device.regmap_lock
mutex that is applied for each snd_hdac_regmap_*() call, including
read, write and update helpers.  The mutex is applied carefully so
that it won't block the self-power-up procedure in the helper
function.  Also, this assures the protection for the accesses without
regmap, too.

The snd_hdac_regmap_update_raw() is refactored to use the standard
regmap_update_bits_check() function instead of the open-code.  The
non-regmap case is still open-coded but it's an easy part.  The all
read and write operations are in the single mutex protection, so it's
now race-free.

In addition, a couple of new helper functions are added:
snd_hdac_regmap_update_raw_once() and snd_hdac_regmap_sync().  Both
are called from HD-audio legacy driver.  The former is to initialize
the given verb bits but only once when it's not initialized yet.  Due
to this condition, the function invokes regcache_cache_only(), and
it's now performed inside the regmap_lock (formerly it was racy) too.
The latter function is for simply invoking regcache_sync() inside the
regmap_lock, which is called from the codec resume call path.
Along with that, the HD-audio codec driver code is slightly modified /
simplified to adapt those new functions.

And finally, snd_hdac_regmap_read_raw(), *_write_raw(), etc are
rewritten with the helper macro.  It's just for simplification because
the code logic is identical among all those functions.

Tested-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200109090104.26073-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_regmap.h    |   3 +
 include/sound/hdaudio.h       |   1 +
 sound/hda/hdac_device.c       |   1 +
 sound/hda/hdac_regmap.c       | 142 +++++++++++++++++++++++++---------
 sound/pci/hda/hda_codec.c     |  30 +++----
 sound/pci/hda/hda_generic.c   |   2 +-
 sound/pci/hda/hda_local.h     |   2 +
 sound/pci/hda/patch_hdmi.c    |   2 +-
 sound/pci/hda/patch_realtek.c |   4 +-
 sound/pci/hda/patch_via.c     |   2 +-
 10 files changed, 135 insertions(+), 54 deletions(-)

diff --git a/include/sound/hda_regmap.h b/include/sound/hda_regmap.h
index 5141f8ffbb12..4c1b9bebbd60 100644
--- a/include/sound/hda_regmap.h
+++ b/include/sound/hda_regmap.h
@@ -24,6 +24,9 @@ int snd_hdac_regmap_write_raw(struct hdac_device *codec, unsigned int reg,
 			      unsigned int val);
 int snd_hdac_regmap_update_raw(struct hdac_device *codec, unsigned int reg,
 			       unsigned int mask, unsigned int val);
+int snd_hdac_regmap_update_raw_once(struct hdac_device *codec, unsigned int reg,
+				    unsigned int mask, unsigned int val);
+void snd_hdac_regmap_sync(struct hdac_device *codec);
 
 /**
  * snd_hdac_regmap_encode_verb - encode the verb to a pseudo register
diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index fb9dce4c6928..44e57bcc4a57 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -87,6 +87,7 @@ struct hdac_device {
 
 	/* regmap */
 	struct regmap *regmap;
+	struct mutex regmap_lock;
 	struct snd_array vendor_verbs;
 	bool lazy_cache:1;	/* don't wake up for writes */
 	bool caps_overwriting:1; /* caps overwrite being in process */
diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 9f3e37511408..c946fd8beebc 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -57,6 +57,7 @@ int snd_hdac_device_init(struct hdac_device *codec, struct hdac_bus *bus,
 	codec->addr = addr;
 	codec->type = HDA_DEV_CORE;
 	mutex_init(&codec->widget_lock);
+	mutex_init(&codec->regmap_lock);
 	pm_runtime_set_active(&codec->dev);
 	pm_runtime_get_noresume(&codec->dev);
 	atomic_set(&codec->in_pm, 0);
diff --git a/sound/hda/hdac_regmap.c b/sound/hda/hdac_regmap.c
index 286361ecd640..2596a881186f 100644
--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -363,6 +363,7 @@ static const struct regmap_config hda_regmap_cfg = {
 	.reg_write = hda_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
+	.disable_locking = true,
 };
 
 /**
@@ -425,12 +426,29 @@ EXPORT_SYMBOL_GPL(snd_hdac_regmap_add_vendor_verb);
 static int reg_raw_write(struct hdac_device *codec, unsigned int reg,
 			 unsigned int val)
 {
+	int err;
+
+	mutex_lock(&codec->regmap_lock);
 	if (!codec->regmap)
-		return hda_reg_write(codec, reg, val);
+		err = hda_reg_write(codec, reg, val);
 	else
-		return regmap_write(codec->regmap, reg, val);
+		err = regmap_write(codec->regmap, reg, val);
+	mutex_unlock(&codec->regmap_lock);
+	return err;
 }
 
+/* a helper macro to call @func_call; retry with power-up if failed */
+#define CALL_RAW_FUNC(codec, func_call)				\
+	({							\
+		int _err = func_call;				\
+		if (_err == -EAGAIN) {				\
+			_err = snd_hdac_power_up_pm(codec);	\
+			if (_err >= 0)				\
+				_err = func_call;		\
+			snd_hdac_power_down_pm(codec);		\
+		}						\
+		_err;})
+
 /**
  * snd_hdac_regmap_write_raw - write a pseudo register with power mgmt
  * @codec: the codec object
@@ -442,42 +460,29 @@ static int reg_raw_write(struct hdac_device *codec, unsigned int reg,
 int snd_hdac_regmap_write_raw(struct hdac_device *codec, unsigned int reg,
 			      unsigned int val)
 {
-	int err;
-
-	err = reg_raw_write(codec, reg, val);
-	if (err == -EAGAIN) {
-		err = snd_hdac_power_up_pm(codec);
-		if (err >= 0)
-			err = reg_raw_write(codec, reg, val);
-		snd_hdac_power_down_pm(codec);
-	}
-	return err;
+	return CALL_RAW_FUNC(codec, reg_raw_write(codec, reg, val));
 }
 EXPORT_SYMBOL_GPL(snd_hdac_regmap_write_raw);
 
 static int reg_raw_read(struct hdac_device *codec, unsigned int reg,
 			unsigned int *val, bool uncached)
 {
+	int err;
+
+	mutex_lock(&codec->regmap_lock);
 	if (uncached || !codec->regmap)
-		return hda_reg_read(codec, reg, val);
+		err = hda_reg_read(codec, reg, val);
 	else
-		return regmap_read(codec->regmap, reg, val);
+		err = regmap_read(codec->regmap, reg, val);
+	mutex_unlock(&codec->regmap_lock);
+	return err;
 }
 
 static int __snd_hdac_regmap_read_raw(struct hdac_device *codec,
 				      unsigned int reg, unsigned int *val,
 				      bool uncached)
 {
-	int err;
-
-	err = reg_raw_read(codec, reg, val, uncached);
-	if (err == -EAGAIN) {
-		err = snd_hdac_power_up_pm(codec);
-		if (err >= 0)
-			err = reg_raw_read(codec, reg, val, uncached);
-		snd_hdac_power_down_pm(codec);
-	}
-	return err;
+	return CALL_RAW_FUNC(codec, reg_raw_read(codec, reg, val, uncached));
 }
 
 /**
@@ -504,6 +509,35 @@ int snd_hdac_regmap_read_raw_uncached(struct hdac_device *codec,
 	return __snd_hdac_regmap_read_raw(codec, reg, val, true);
 }
 
+static int reg_raw_update(struct hdac_device *codec, unsigned int reg,
+			  unsigned int mask, unsigned int val)
+{
+	unsigned int orig;
+	bool change;
+	int err;
+
+	mutex_lock(&codec->regmap_lock);
+	if (codec->regmap) {
+		err = regmap_update_bits_check(codec->regmap, reg, mask, val,
+					       &change);
+		if (!err)
+			err = change ? 1 : 0;
+	} else {
+		err = hda_reg_read(codec, reg, &orig);
+		if (!err) {
+			val &= mask;
+			val |= orig & ~mask;
+			if (val != orig) {
+				err = hda_reg_write(codec, reg, val);
+				if (!err)
+					err = 1;
+			}
+		}
+	}
+	mutex_unlock(&codec->regmap_lock);
+	return err;
+}
+
 /**
  * snd_hdac_regmap_update_raw - update a pseudo register with power mgmt
  * @codec: the codec object
@@ -515,20 +549,58 @@ int snd_hdac_regmap_read_raw_uncached(struct hdac_device *codec,
  */
 int snd_hdac_regmap_update_raw(struct hdac_device *codec, unsigned int reg,
 			       unsigned int mask, unsigned int val)
+{
+	return CALL_RAW_FUNC(codec, reg_raw_update(codec, reg, mask, val));
+}
+EXPORT_SYMBOL_GPL(snd_hdac_regmap_update_raw);
+
+static int reg_raw_update_once(struct hdac_device *codec, unsigned int reg,
+			       unsigned int mask, unsigned int val)
 {
 	unsigned int orig;
 	int err;
 
-	val &= mask;
-	err = snd_hdac_regmap_read_raw(codec, reg, &orig);
-	if (err < 0)
-		return err;
-	val |= orig & ~mask;
-	if (val == orig)
-		return 0;
-	err = snd_hdac_regmap_write_raw(codec, reg, val);
+	if (!codec->regmap)
+		return reg_raw_update(codec, reg, mask, val);
+
+	mutex_lock(&codec->regmap_lock);
+	regcache_cache_only(codec->regmap, true);
+	err = regmap_read(codec->regmap, reg, &orig);
+	regcache_cache_only(codec->regmap, false);
 	if (err < 0)
-		return err;
-	return 1;
+		err = regmap_update_bits(codec->regmap, reg, mask, val);
+	mutex_unlock(&codec->regmap_lock);
+	return err;
 }
-EXPORT_SYMBOL_GPL(snd_hdac_regmap_update_raw);
+
+/**
+ * snd_hdac_regmap_update_raw_once - initialize the register value only once
+ * @codec: the codec object
+ * @reg: pseudo register
+ * @mask: bit mask to update
+ * @val: value to update
+ *
+ * Performs the update of the register bits only once when the register
+ * hasn't been initialized yet.  Used in HD-audio legacy driver.
+ * Returns zero if successful or a negative error code
+ */
+int snd_hdac_regmap_update_raw_once(struct hdac_device *codec, unsigned int reg,
+				    unsigned int mask, unsigned int val)
+{
+	return CALL_RAW_FUNC(codec, reg_raw_update_once(codec, reg, mask, val));
+}
+EXPORT_SYMBOL_GPL(snd_hdac_regmap_update_raw_once);
+
+/**
+ * snd_hdac_regmap_sync - sync out the cached values for PM resume
+ * @codec: the codec object
+ */
+void snd_hdac_regmap_sync(struct hdac_device *codec)
+{
+	if (codec->regmap) {
+		mutex_lock(&codec->regmap_lock);
+		regcache_sync(codec->regmap);
+		mutex_unlock(&codec->regmap_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(snd_hdac_regmap_sync);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 6cb72336433a..07c03c32715a 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1267,6 +1267,18 @@ int snd_hda_override_amp_caps(struct hda_codec *codec, hda_nid_t nid, int dir,
 }
 EXPORT_SYMBOL_GPL(snd_hda_override_amp_caps);
 
+static unsigned int encode_amp(struct hda_codec *codec, hda_nid_t nid,
+			       int ch, int dir, int idx)
+{
+	unsigned int cmd = snd_hdac_regmap_encode_amp(nid, ch, dir, idx);
+
+	/* enable fake mute if no h/w mute but min=mute */
+	if ((query_amp_caps(codec, nid, dir) &
+	     (AC_AMPCAP_MUTE | AC_AMPCAP_MIN_MUTE)) == AC_AMPCAP_MIN_MUTE)
+		cmd |= AC_AMP_FAKE_MUTE;
+	return cmd;
+}
+
 /**
  * snd_hda_codec_amp_update - update the AMP mono value
  * @codec: HD-audio codec
@@ -1282,12 +1294,8 @@ EXPORT_SYMBOL_GPL(snd_hda_override_amp_caps);
 int snd_hda_codec_amp_update(struct hda_codec *codec, hda_nid_t nid,
 			     int ch, int dir, int idx, int mask, int val)
 {
-	unsigned int cmd = snd_hdac_regmap_encode_amp(nid, ch, dir, idx);
+	unsigned int cmd = encode_amp(codec, nid, ch, dir, idx);
 
-	/* enable fake mute if no h/w mute but min=mute */
-	if ((query_amp_caps(codec, nid, dir) &
-	     (AC_AMPCAP_MUTE | AC_AMPCAP_MIN_MUTE)) == AC_AMPCAP_MIN_MUTE)
-		cmd |= AC_AMP_FAKE_MUTE;
 	return snd_hdac_regmap_update_raw(&codec->core, cmd, mask, val);
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_amp_update);
@@ -1335,16 +1343,11 @@ EXPORT_SYMBOL_GPL(snd_hda_codec_amp_stereo);
 int snd_hda_codec_amp_init(struct hda_codec *codec, hda_nid_t nid, int ch,
 			   int dir, int idx, int mask, int val)
 {
-	int orig;
+	unsigned int cmd = encode_amp(codec, nid, ch, dir, idx);
 
 	if (!codec->core.regmap)
 		return -EINVAL;
-	regcache_cache_only(codec->core.regmap, true);
-	orig = snd_hda_codec_amp_read(codec, nid, ch, dir, idx);
-	regcache_cache_only(codec->core.regmap, false);
-	if (orig >= 0)
-		return 0;
-	return snd_hda_codec_amp_update(codec, nid, ch, dir, idx, mask, val);
+	return snd_hdac_regmap_update_raw_once(&codec->core, cmd, mask, val);
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_amp_init);
 
@@ -2905,8 +2908,7 @@ static void hda_call_codec_resume(struct hda_codec *codec)
 	else {
 		if (codec->patch_ops.init)
 			codec->patch_ops.init(codec);
-		if (codec->core.regmap)
-			regcache_sync(codec->core.regmap);
+		snd_hda_regmap_sync(codec);
 	}
 
 	if (codec->jackpoll_interval)
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index fc001c64ef20..6815f9dc8545 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -6027,7 +6027,7 @@ int snd_hda_gen_init(struct hda_codec *codec)
 	/* call init functions of standard auto-mute helpers */
 	update_automute_all(codec);
 
-	regcache_sync(codec->core.regmap);
+	snd_hda_regmap_sync(codec);
 
 	if (spec->vmaster_mute.sw_kctl && spec->vmaster_mute.hook)
 		snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 3942e1b528d8..3dca65d79b02 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -138,6 +138,8 @@ int snd_hda_codec_reset(struct hda_codec *codec);
 void snd_hda_codec_register(struct hda_codec *codec);
 void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec);
 
+#define snd_hda_regmap_sync(codec)	snd_hdac_regmap_sync(&(codec)->core)
+
 enum {
 	HDA_VMUTE_OFF,
 	HDA_VMUTE_ON,
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d48263d1f6a2..d41c91468ab3 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2359,7 +2359,7 @@ static int generic_hdmi_resume(struct hda_codec *codec)
 	int pin_idx;
 
 	codec->patch_ops.init(codec);
-	regcache_sync(codec->core.regmap);
+	snd_hda_regmap_sync(codec);
 
 	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
 		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a0e7d711cbb5..499c8150ebb8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -908,7 +908,7 @@ static int alc_resume(struct hda_codec *codec)
 	if (!spec->no_depop_delay)
 		msleep(150); /* to avoid pop noise */
 	codec->patch_ops.init(codec);
-	regcache_sync(codec->core.regmap);
+	snd_hda_regmap_sync(codec);
 	hda_call_check_power_status(codec, 0x01);
 	return 0;
 }
@@ -3756,7 +3756,7 @@ static int alc269_resume(struct hda_codec *codec)
 		msleep(200);
 	}
 
-	regcache_sync(codec->core.regmap);
+	snd_hda_regmap_sync(codec);
 	hda_call_check_power_status(codec, 0x01);
 
 	/* on some machine, the BIOS will clear the codec gpio data when enter
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index b40d01e01832..7ef8f3105cdb 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -396,7 +396,7 @@ static int via_resume(struct hda_codec *codec)
 	/* some delay here to make jack detection working (bko#98921) */
 	msleep(10);
 	codec->patch_ops.init(codec);
-	regcache_sync(codec->core.regmap);
+	snd_hda_regmap_sync(codec);
 	return 0;
 }
 #endif
-- 
2.25.1



