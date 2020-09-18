Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53926F0F0
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIRCr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgIRCJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52282399C;
        Fri, 18 Sep 2020 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394980;
        bh=3DMF38mldNUYA7yCL5j6zamAk3sB0jOQDvUCBZLfLl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7gx+7BYnC04ED1FWpWz+eFOz0lE1lREsuqAW534Q+kYJ7kUqaqN4QdFO9YfxR0zE
         MZ0Ug8LrmQIt5leSevPchrLffSmSvpiW5PNhu2we+2qsPgh5yahDVFVsEVFFBbhSos
         Y0aVj2AUzzLWl/nFY+bQkpCu2UnFOo4DtFOGlhy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 080/206] ALSA: usb-audio: Don't create a mixer element with bogus volume range
Date:   Thu, 17 Sep 2020 22:05:56 -0400
Message-Id: <20200918020802.2065198-80-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

