Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1512C4A5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfL2Rbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfL2Rbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BC6207FD;
        Sun, 29 Dec 2019 17:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640696;
        bh=kf5GFZb2jr/iYcT1559dfHi72Y59J6biQZV9IkhsRyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLR9sN51Hr0aEFNiUiFcMjAwLmZJS3mGUMcAYhKrhWir8lHQrD0JguUU4F0++I+lp
         rUYdCLwqK4OU55wSTVFkdZ7XbfIdoUA9YwTMj2GAay2AZwy5rI0HD6UQFM5cr8Kcc0
         32IlOXuRjR4mDDhthYovJ6i73agIE7xlfiFiIRx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/219] ALSA: hda/hdmi - implement mst_no_extra_pcms flag
Date:   Sun, 29 Dec 2019 18:18:24 +0100
Message-Id: <20191229162523.844585380@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
 sound/pci/hda/hda_codec.h  |  1 +
 sound/pci/hda/patch_hdmi.c | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 2003403ce1c8..199927694aef 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -262,6 +262,7 @@ struct hda_codec {
 	unsigned int force_pin_prefix:1; /* Add location prefix */
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
+	unsigned int mst_no_extra_pcms:1; /* no backup PCMs for DP-MST */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c827a2a89cc3..9d5e3c8d62b9 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2063,15 +2063,24 @@ static bool is_hdmi_pcm_attached(struct hdac_device *hdac, int pcm_idx)
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



