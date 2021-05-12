Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2E237D303
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352303AbhELSP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353350AbhELSLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50AA661454;
        Wed, 12 May 2021 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842773;
        bh=jRKlhqwjmPf3x/hXRdH1taxBiqw3u6f7H+MQnP5qJaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSkDRYBAAzNNQ7auhY0FxtL7bIGa7bqDXFXiNw4BDDcfxvidDKxsSfuRGZX3wQdU1
         KlOdn4B4bFr9zy6pocOvIqKTc/m/WPJpmoAApD932YbFhGv/rYBQnykMDTvwnUHd77
         /YOzBUDWmkucRBu5lK8Qqr2JCkvzOFBJZlXZ/dKT6EROqGODnFxaQuN3+Hcj8OBBEE
         r5wzp4diYk6i4s/PqxF5ZNIWaEbkV5B8L4ZbLi4ZBTQrllthHbKY/1vaVhco9owYZi
         IZEU92NJhZJnogWxZ9qtPbRDqmO4e+TtcjmkjjEsPNtZZl5UPkFhzePIaH5wTugY3k
         qXuAtUn7gnLLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 4/4] ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP
Date:   Wed, 12 May 2021 14:06:03 -0400
Message-Id: <20210512180604.666144-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180604.666144-1-sashal@kernel.org>
References: <20210512180604.666144-1-sashal@kernel.org>
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
index dcefb12557f1..7fed8d1bb79c 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1182,11 +1182,17 @@ static const char *get_line_out_pfx(struct hda_codec *codec, int ch,
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

