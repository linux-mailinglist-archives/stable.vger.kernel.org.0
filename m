Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3181D24DDC7
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHURWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgHUQPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54CC208DB;
        Fri, 21 Aug 2020 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026547;
        bh=n6zWkgSvLTHWulO+um9xLaxuATIDNiiE2Uuh9AwmZx8=;
        h=From:To:Cc:Subject:Date:From;
        b=DiUWSuKIP23y5m93wbWRE4mAHiHphAU4UfDeU0TfJu0eUyqAcU0SYR60xrxRJpgTt
         G6M2geezz1F4YrWbHsiSulBt6ZPnVePOw1XnzHi9SlWxb5h3yd5OkaamxJvMvQtRb7
         A+g5u7wiROzuM2ccPFjpwxlwZL6QdD4yfh0HBMYk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 01/61] ALSA: hda/hdmi: Add quirk to force connectivity
Date:   Fri, 21 Aug 2020 12:14:45 -0400
Message-Id: <20200821161545.347622-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit cd72c317a0a11f64225b9a3f1fe503bb8c7327b5 ]

HDMI on some platforms doesn't enable audio support because its Port
Connectivity [31:30] is set to AC_JACK_PORT_NONE:
Node 0x05 [Pin Complex] wcaps 0x40778d: 8-Channels Digital Amp-Out CP
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0b000094: OUT Detect HBR HDMI DP
  Pin Default 0x58560010: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
  Devices: 0
  Connection: 3
     0x02 0x03* 0x04

For now, use a quirk to force connectivity based on SSID. If there are
more platforms affected by the same issue, we can eye for a more generic
solution.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200804155836.16252-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 37391c3d2f47c..de9570032e07c 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -160,6 +160,7 @@ struct hdmi_spec {
 
 	bool use_acomp_notifier; /* use eld_notify callback for hotplug */
 	bool acomp_registered; /* audio component registered in this driver */
+	bool force_connect; /* force connectivity */
 	struct drm_audio_component_audio_ops drm_audio_ops;
 	int (*port2pin)(struct hda_codec *, int); /* reverse port/pin mapping */
 
@@ -1700,7 +1701,8 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 	 * all device entries on the same pin
 	 */
 	config = snd_hda_codec_get_pincfg(codec, pin_nid);
-	if (get_defcfg_connect(config) == AC_JACK_PORT_NONE)
+	if (get_defcfg_connect(config) == AC_JACK_PORT_NONE &&
+	    !spec->force_connect)
 		return 0;
 
 	/*
@@ -1802,11 +1804,18 @@ static int hdmi_add_cvt(struct hda_codec *codec, hda_nid_t cvt_nid)
 	return 0;
 }
 
+static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	{}
+};
+
 static int hdmi_parse_codec(struct hda_codec *codec)
 {
+	struct hdmi_spec *spec = codec->spec;
 	hda_nid_t start_nid;
 	unsigned int caps;
 	int i, nodes;
+	const struct snd_pci_quirk *q;
 
 	nodes = snd_hda_get_sub_nodes(codec, codec->core.afg, &start_nid);
 	if (!start_nid || nodes < 0) {
@@ -1814,6 +1823,11 @@ static int hdmi_parse_codec(struct hda_codec *codec)
 		return -EINVAL;
 	}
 
+	q = snd_pci_quirk_lookup(codec->bus->pci, force_connect_list);
+
+	if (q && q->value)
+		spec->force_connect = true;
+
 	/*
 	 * hdmi_add_pin() assumes total amount of converters to
 	 * be known, so first discover all converters
-- 
2.25.1

