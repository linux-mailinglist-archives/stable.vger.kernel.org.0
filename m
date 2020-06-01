Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C22A1EAB41
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgFASPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729943AbgFASPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0F62065C;
        Mon,  1 Jun 2020 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035341;
        bh=K+MPREEvjCnKdthF5xOE8ZSc+QlaNUqvFSdezvXCyYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2af4+qBzSdGm6fjSlvRRG1a9K6PHQW+48NmSRjO/qChULFspej6/Y544zMr6PiJrD
         72Xo66ngKoHlRZiKR01/nIvwroOs3IrDT71L4AN8UA+fdPtzhIaLk7TpE/Kvz4uCqO
         whfZJMWg6dP45UREk31/C+rOSphGdOmcxukTQMOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 115/177] ALSA: hda/realtek - Add a model for Thinkpad T570 without DAC workaround
Date:   Mon,  1 Jun 2020 19:54:13 +0200
Message-Id: <20200601174058.219132950@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 399c01aa49e548c82d40f8161915a5941dd3c60e ]

We fixed the regression of the speaker volume for some Thinkpad models
(e.g. T570) by the commit 54947cd64c1b ("ALSA: hda/realtek - Fix
speaker output regression on Thinkpad T570").  Essentially it fixes
the DAC / pin pairing by a static table.  It was confirmed and merged
to stable kernel later.

Now, interestingly, we got another regression report for the very same
model (T570) about the similar problem, and the commit above was the
culprit.  That is, by some reason, there are devices that prefer the
DAC1, and another device DAC2!

Unfortunately those have the same ID and we have no idea what can
differentiate, in this patch, a new fixup model "tpt470-dock-fix" is
provided, so that users with such a machine can apply it manually.
When model=tpt470-dock-fix option is passed to snd-hda-intel module,
it avoids the fixed DAC pairing and the DAC1 is assigned to the
speaker like the earlier versions.

Fixes: 54947cd64c1b ("ALSA: hda/realtek - Fix speaker output regression on Thinkpad T570")
BugLink: https://apibugzilla.suse.com/show_bug.cgi?id=1172017
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526062406.9799-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 36 +++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 041d2a32059b..92c6e58c3862 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5484,18 +5484,9 @@ static void alc_fixup_tpt470_dock(struct hda_codec *codec,
 		{ 0x19, 0x21a11010 }, /* dock mic */
 		{ }
 	};
-	/* Assure the speaker pin to be coupled with DAC NID 0x03; otherwise
-	 * the speaker output becomes too low by some reason on Thinkpads with
-	 * ALC298 codec
-	 */
-	static const hda_nid_t preferred_pairs[] = {
-		0x14, 0x03, 0x17, 0x02, 0x21, 0x02,
-		0
-	};
 	struct alc_spec *spec = codec->spec;
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		spec->gen.preferred_dacs = preferred_pairs;
 		spec->parse_flags = HDA_PINCFG_NO_HP_FIXUP;
 		snd_hda_apply_pincfgs(codec, pincfgs);
 	} else if (action == HDA_FIXUP_ACT_INIT) {
@@ -5508,6 +5499,23 @@ static void alc_fixup_tpt470_dock(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_tpt470_dacs(struct hda_codec *codec,
+				  const struct hda_fixup *fix, int action)
+{
+	/* Assure the speaker pin to be coupled with DAC NID 0x03; otherwise
+	 * the speaker output becomes too low by some reason on Thinkpads with
+	 * ALC298 codec
+	 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x03, 0x17, 0x02, 0x21, 0x02,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->gen.preferred_dacs = preferred_pairs;
+}
+
 static void alc_shutup_dell_xps13(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -6063,6 +6071,7 @@ enum {
 	ALC700_FIXUP_INTEL_REFERENCE,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
+	ALC298_FIXUP_TPT470_DOCK_FIX,
 	ALC298_FIXUP_TPT470_DOCK,
 	ALC255_FIXUP_DUMMY_LINEOUT_VERB,
 	ALC255_FIXUP_DELL_HEADSET_MIC,
@@ -6994,12 +7003,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC274_FIXUP_DELL_BIND_DACS
 	},
-	[ALC298_FIXUP_TPT470_DOCK] = {
+	[ALC298_FIXUP_TPT470_DOCK_FIX] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_tpt470_dock,
 		.chained = true,
 		.chain_id = ALC293_FIXUP_LENOVO_SPK_NOISE
 	},
+	[ALC298_FIXUP_TPT470_DOCK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_tpt470_dacs,
+		.chained = true,
+		.chain_id = ALC298_FIXUP_TPT470_DOCK_FIX
+	},
 	[ALC255_FIXUP_DUMMY_LINEOUT_VERB] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7638,6 +7653,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC292_FIXUP_TPT440_DOCK, .name = "tpt440-dock"},
 	{.id = ALC292_FIXUP_TPT440, .name = "tpt440"},
 	{.id = ALC292_FIXUP_TPT460, .name = "tpt460"},
+	{.id = ALC298_FIXUP_TPT470_DOCK_FIX, .name = "tpt470-dock-fix"},
 	{.id = ALC298_FIXUP_TPT470_DOCK, .name = "tpt470-dock"},
 	{.id = ALC233_FIXUP_LENOVO_MULTI_CODECS, .name = "dual-codecs"},
 	{.id = ALC700_FIXUP_INTEL_REFERENCE, .name = "alc700-ref"},
-- 
2.25.1



