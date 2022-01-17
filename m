Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DDE490DC1
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbiAQRFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbiAQRDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4957DB81162;
        Mon, 17 Jan 2022 17:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1592DC36AEF;
        Mon, 17 Jan 2022 17:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439009;
        bh=S5nPjdjCzKt885qz1sQlYghV0MtZBTbsg2HgpYi5+bs=;
        h=From:To:Cc:Subject:Date:From;
        b=fHRxkSzU3k/lBqgGb0gQvFohe60WegQYvjqURXxjusqqcTkx5D7jeRA0HvVjNSAfa
         7HjdvgRryOxoAaIGus3jhf6pyhsQJavJx7V4Ofstn9/HS7LEsFyIuXy0DpCD9MsFqE
         G5FJVY1yzth+WyLTSAi1odJDs4nB4wU3SDh95LcyLCORPDqUQnoAQVAWEbUOwjwEvd
         1fXmZXx2A/LC2v/LHtCTI0fztNSolMAWU1KRIMx+yr/M1g+5xjbxQnTRoXTpgkdmwh
         Z9BrcQouBXs+G86NlhgCmb6xZ2mmjJtHPTWvTZeayq2XvzNF4D2SU5NJSWXKS7F4Gh
         1OoaGAFmkG8AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, timo.gurr@gmail.com,
        andfagiani@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 01/34] ALSA: usb-audio: Fix dB level of Bose Revolve+ SoundLink
Date:   Mon, 17 Jan 2022 12:02:51 -0500
Message-Id: <20220117170326.1471712-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 02eb1d098e26f34c8f047b0b1cee6f4433a34bd1 ]

Bose Revolve+ SoundLink (0a57:40fa) advertises invalid dB level for
the speaker volume.  This patch provides the correction in the mixer
map quirk table entry.

Note that this requires the prerequisite change to add min_mute flag
to the dB map table.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1192375
Link: https://lore.kernel.org/r/20211116065415.11159-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 8f6823df944ff..01a30968e7e1f 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -337,6 +337,13 @@ static const struct usbmix_name_map bose_companion5_map[] = {
 	{ 0 }	/* terminator */
 };
 
+/* Bose Revolve+ SoundLink, correction of dB maps */
+static const struct usbmix_dB_map bose_soundlink_dB = {-8283, -0, true};
+static const struct usbmix_name_map bose_soundlink_map[] = {
+	{ 2, NULL, .dB = &bose_soundlink_dB },
+	{ 0 }	/* terminator */
+};
+
 /* Sennheiser Communications Headset [PC 8], the dB value is reported as -6 negative maximum  */
 static const struct usbmix_dB_map sennheiser_pc8_dB = {-9500, 0};
 static const struct usbmix_name_map sennheiser_pc8_map[] = {
@@ -551,6 +558,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x05a7, 0x1020),
 		.map = bose_companion5_map,
 	},
+	{
+		/* Bose Revolve+ SoundLink */
+		.id = USB_ID(0x05a7, 0x40fa),
+		.map = bose_soundlink_map,
+	},
 	{
 		/* Corsair Virtuoso SE (wired mode) */
 		.id = USB_ID(0x1b1c, 0x0a3d),
-- 
2.34.1

