Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501C327CB99
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgI2M3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgI2Lbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:31:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C11123B18;
        Tue, 29 Sep 2020 11:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378709;
        bh=3DMF38mldNUYA7yCL5j6zamAk3sB0jOQDvUCBZLfLl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1uA2YfCLmuBLjpGferotFod6bIppImEtGGbllbRD93EztrKpAzF8JtxNczxTEgIp
         Cw2DNkUjOR46RLiJjiAg3mhbG1jk7c7vTKN1tA2eU321YokwkR8zfLlXVZMApgUpR6
         ZxqvuEtAmme56ozphhKBImjqWnjTeBfAkGRfO1bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/245] ALSA: usb-audio: Dont create a mixer element with bogus volume range
Date:   Tue, 29 Sep 2020 12:58:52 +0200
Message-Id: <20200929105950.941922358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e9a0ef0b5ddcbc0d56c65aefc0f18d16e6f71207 ]

Some USB-audio descriptors provide a bogus volume range (e.g. volume
min and max are identical), which confuses user-space.
This patch makes the driver skipping such a control element.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206221
Link: https://lore.kernel.org/r/20200214144928.23628-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 45bd3d54be54b..451b8ea383c61 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1699,6 +1699,16 @@ static void __build_feature_ctl(struct usb_mixer_interface *mixer,
 	/* get min/max values */
 	get_min_max_with_quirks(cval, 0, kctl);
 
+	/* skip a bogus volume range */
+	if (cval->max <= cval->min) {
+		usb_audio_dbg(mixer->chip,
+			      "[%d] FU [%s] skipped due to invalid volume\n",
+			      cval->head.id, kctl->id.name);
+		snd_ctl_free_one(kctl);
+		return;
+	}
+
+
 	if (control == UAC_FU_VOLUME) {
 		check_mapped_dB(map, cval);
 		if (cval->dBmin < cval->dBmax || !cval->initialized) {
-- 
2.25.1



