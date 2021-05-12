Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA92E37D2F4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351459AbhELSPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353188AbhELSKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F03D6193F;
        Wed, 12 May 2021 18:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842740;
        bh=v+o9R/WRLaLDBMpf2DCdFw1HJwrUNglZKj5Rq94Tmf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibu2wIFX2G/lJSYR5r6bIljCfcD8/xuifRVQuq60Uk9G1Im+TXE9vJY7RyKMeHuQb
         uh5LOinQEH0kv/0reFI2VUOj6vzPY2+bPqmvjyWNKngvYt2OYzPSqhUzBkzTY7tJU3
         CPujUxxuFTCSUFalcGrxap73ufebslPrYr+4W6N3LboqUKW5V5PGb/o78dhldojyvL
         CIHlMLSjJ1gdNf7uXqIDzsVT8o6i8Zh1hqxlUl28JfezGLRplmuZYcoT1pWnjNoHqL
         MU+g/TukzmLfSSJVcKFLf7wvLnNkEmcnSQafM2xhvW+gyS5/sLpsgk0YPEbUBKE+ZL
         5VK9U6NDqk51Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 10/12] ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP
Date:   Wed, 12 May 2021 14:05:20 -0400
Message-Id: <20210512180522.665788-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180522.665788-1-sashal@kernel.org>
References: <20210512180522.665788-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit f48652bbe3ae62ba2835a396b7e01f063e51c4cd ]

Without this change, the DAC ctl's name could be changed only when
the machine has both Speaker and Headphone, but we met some machines
which only has Lineout and Headhpone, and the Lineout and Headphone
share the Audio Mixer0 and DAC0, the ctl's name is set to "Front".

On most of machines, the "Front" is used for Speaker only or Lineout
only, but on this machine it is shared by Lineout and Headphone,
This introduces an issue in the pipewire and pulseaudio, suppose users
want the Headphone to be on and the Speaker/Lineout to be off, they
could turn off the "Front", this works on most of the machines, but on
this machine, the "Front" couldn't be turned off otherwise the
headphone will be off too. Here we do some change to let the ctl's
name change to "Headphone+LO" on this machine, and pipewire and
pulseaudio already could handle "Headphone+LO" and "Speaker+LO".
(https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/747)

BugLink: http://bugs.launchpad.net/bugs/804178
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210504073917.22406-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_generic.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 14881fe80a21..1833deefe1af 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1212,11 +1212,17 @@ static const char *get_line_out_pfx(struct hda_codec *codec, int ch,
 		*index = ch;
 		return "Headphone";
 	case AUTO_PIN_LINE_OUT:
-		/* This deals with the case where we have two DACs and
-		 * one LO, one HP and one Speaker */
-		if (!ch && cfg->speaker_outs && cfg->hp_outs) {
-			bool hp_lo_shared = !path_has_mixer(codec, spec->hp_paths[0], ctl_type);
-			bool spk_lo_shared = !path_has_mixer(codec, spec->speaker_paths[0], ctl_type);
+		/* This deals with the case where one HP or one Speaker or
+		 * one HP + one Speaker need to share the DAC with LO
+		 */
+		if (!ch) {
+			bool hp_lo_shared = false, spk_lo_shared = false;
+
+			if (cfg->speaker_outs)
+				spk_lo_shared = !path_has_mixer(codec,
+								spec->speaker_paths[0],	ctl_type);
+			if (cfg->hp_outs)
+				hp_lo_shared = !path_has_mixer(codec, spec->hp_paths[0], ctl_type);
 			if (hp_lo_shared && spk_lo_shared)
 				return spec->vmaster_mute.hook ? "PCM" : "Master";
 			if (hp_lo_shared)
-- 
2.30.2

