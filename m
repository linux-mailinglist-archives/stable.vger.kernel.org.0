Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8722C12C6B2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbfL2Rtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731665AbfL2Rte (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FF9208C4;
        Sun, 29 Dec 2019 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641773;
        bh=w6iSnY7I0kCH9waKfL1HKUjv26aKQS+yqBaDUpDii+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sq6plOo0igIVcSl4z5DgEXXGlRJAqjsqmqyGK1P81qiADmnc9hkJ6XTZvAbI3daCs
         7MoPqMm7W0FT2Oz/5NhFhBV6/EXfdZSNL8Ej9YdA4y0th+tvPmNNu8jEhmRhAK/K1K
         OH2hPNCM1qJIr93KZbt86PBIJigww4Ilzp7Zomkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/434] ALSA: hda/hdmi - implement mst_no_extra_pcms flag
Date:   Sun, 29 Dec 2019 18:24:19 +0100
Message-Id: <20191229172715.511452367@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 2a2edfbbfee47947dd05f5860c66c0e80ee5e09d ]

To support the DP-MST multiple streams via single connector feature,
the HDMI driver was extended with the concept of backup PCMs. See
commit 9152085defb6 ("ALSA: hda - add DP MST audio support").

This implementation works fine with snd_hda_intel.c as PCM topology
is fully managed within the single driver.

When the HDA codec driver is used from ASoC components, the concept
of backup PCMs no longer fits. For ASoC topologies, the physical
HDMI converters are presented as backend DAIs and these should match
with hardware capabilities. The ASoC topology may define arbitrary
PCMs (i.e. frontend DAIs) and have processing elements before eventual
routing to the HDMI BE DAIs. With backup PCMs, the link between
FE and BE DAIs would become dynamic and change when monitors are
(un)plugged. This would lead to modifying the topology every time
hotplug events happen, which is not currently possible in ASoC and
there does not seem to be any obvious benefits from this design.

To overcome above problems and enable the HDMI driver to be used
from ASoC, this patch adds a new mode (mst_no_extra_pcms flags) to
patch_hdmi.c. In this mode, the codec driver does not assume
the backup PCMs to be created.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191029134017.18901-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h  |  1 +
 sound/pci/hda/patch_hdmi.c | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 9a0393cf024c..ac18f428eda6 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -254,6 +254,7 @@ struct hda_codec {
 	unsigned int force_pin_prefix:1; /* Add location prefix */
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
+	unsigned int mst_no_extra_pcms:1; /* no backup PCMs for DP-MST */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 488c17c9f375..74f809b6fa31 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2082,15 +2082,24 @@ static bool is_hdmi_pcm_attached(struct hdac_device *hdac, int pcm_idx)
 static int generic_hdmi_build_pcms(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
-	int idx;
+	int idx, pcm_num;
 
 	/*
 	 * for non-mst mode, pcm number is the same as before
-	 * for DP MST mode, pcm number is (nid number + dev_num - 1)
-	 *  dev_num is the device entry number in a pin
-	 *
+	 * for DP MST mode without extra PCM, pcm number is same
+	 * for DP MST mode with extra PCMs, pcm number is
+	 *  (nid number + dev_num - 1)
+	 * dev_num is the device entry number in a pin
 	 */
-	for (idx = 0; idx < spec->num_nids + spec->dev_num - 1; idx++) {
+
+	if (codec->mst_no_extra_pcms)
+		pcm_num = spec->num_nids;
+	else
+		pcm_num = spec->num_nids + spec->dev_num - 1;
+
+	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
+
+	for (idx = 0; idx < pcm_num; idx++) {
 		struct hda_pcm *info;
 		struct hda_pcm_stream *pstr;
 
-- 
2.20.1



