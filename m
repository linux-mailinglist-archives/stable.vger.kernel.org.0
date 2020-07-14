Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55C21F46A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgGNOja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgGNOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6951A2253A;
        Tue, 14 Jul 2020 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737568;
        bh=CDgSlUqKPGmQBQWGQKwaip8LlKp+TzgJr12FOTDVWuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMoDk3RQoGh4ouP4/Jsz+yG9Y+X5UXITWkyI7B3Ag/3JrxWpQQGAbclTOufuX8im3
         mgd4LyU1ccc+EeiHYea5jfTpKcPWOkoioai+cnDoCH7TZ4h4H8m37aX0TQgEjRUd4n
         GyU4srXa7BxGdL+RR0IVULBes+VmidV32DqptOBA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 11/18] ALSA: hda/hdmi: fix failures at PCM open on Intel ICL and later
Date:   Tue, 14 Jul 2020 10:39:07 -0400
Message-Id: <20200714143914.4035489-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143914.4035489-1-sashal@kernel.org>
References: <20200714143914.4035489-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 56275036d8185f92eceac7479d48b858ee3dab84 ]

When HDMI PCM devices are opened in a specific order, with at least one
HDMI/DP receiver connected, ALSA PCM open fails to -EBUSY on the
connected monitor, on recent Intel platforms (ICL/JSL and newer). While
this is not a typical sequence, at least Pulseaudio does this every time
when it is started, to discover the available PCMs.

The rootcause is an invalid assumption in hdmi_add_pin(), where the
total number of converters is assumed to be known at the time the
function is called. On older Intel platforms this held true, but after
ICL/JSL, the order how pins and converters are in the subnode list as
returned by snd_hda_get_sub_nodes(), was changed. As a result,
information for some converters was not stored to per_pin->mux_nids.
And this means some pins cannot be connected to all converters, and
application instead gets -EBUSY instead at open.

The assumption that converters are always before pins in the subnode
list, is not really a valid one. Fix the problem in hdmi_parse_codec()
by introducing separate loops for discovering converters and pins.

BugLink: https://github.com/thesofproject/linux/issues/1978
BugLink: https://github.com/thesofproject/linux/issues/2216
BugLink: https://github.com/thesofproject/linux/issues/2217
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200703153818.2808592-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index e78c4367b6c86..820f534a67b1c 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1817,33 +1817,43 @@ static int hdmi_add_cvt(struct hda_codec *codec, hda_nid_t cvt_nid)
 
 static int hdmi_parse_codec(struct hda_codec *codec)
 {
-	hda_nid_t nid;
+	hda_nid_t start_nid;
+	unsigned int caps;
 	int i, nodes;
 
-	nodes = snd_hda_get_sub_nodes(codec, codec->core.afg, &nid);
-	if (!nid || nodes < 0) {
+	nodes = snd_hda_get_sub_nodes(codec, codec->core.afg, &start_nid);
+	if (!start_nid || nodes < 0) {
 		codec_warn(codec, "HDMI: failed to get afg sub nodes\n");
 		return -EINVAL;
 	}
 
-	for (i = 0; i < nodes; i++, nid++) {
-		unsigned int caps;
-		unsigned int type;
+	/*
+	 * hdmi_add_pin() assumes total amount of converters to
+	 * be known, so first discover all converters
+	 */
+	for (i = 0; i < nodes; i++) {
+		hda_nid_t nid = start_nid + i;
 
 		caps = get_wcaps(codec, nid);
-		type = get_wcaps_type(caps);
 
 		if (!(caps & AC_WCAP_DIGITAL))
 			continue;
 
-		switch (type) {
-		case AC_WID_AUD_OUT:
+		if (get_wcaps_type(caps) == AC_WID_AUD_OUT)
 			hdmi_add_cvt(codec, nid);
-			break;
-		case AC_WID_PIN:
+	}
+
+	/* discover audio pins */
+	for (i = 0; i < nodes; i++) {
+		hda_nid_t nid = start_nid + i;
+
+		caps = get_wcaps(codec, nid);
+
+		if (!(caps & AC_WCAP_DIGITAL))
+			continue;
+
+		if (get_wcaps_type(caps) == AC_WID_PIN)
 			hdmi_add_pin(codec, nid);
-			break;
-		}
 	}
 
 	return 0;
-- 
2.25.1

