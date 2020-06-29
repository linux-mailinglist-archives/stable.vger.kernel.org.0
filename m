Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC44520DE7B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbgF2U0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732529AbgF2TZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE3925346;
        Mon, 29 Jun 2020 15:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445186;
        bh=CrQXWLwoyy3ze5VrJOPM1I8/eyHw+ktTM3NKnFofK0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knw57tdsergGKt9nHVPDbQsN0UyeqMHiaGXFclmPlXiE6QAvqUbQ1a56YTGZdr8lz
         zgsV7/1MC8wYPcHGjfZFkkbRcJX/wqN9/TH+jc3faP7TiEnNtT1du0FNHdUZ7M4Cw1
         Ju8LOLaxefi4UOSJZswezjNMYtIFVUtgwmTq1BC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 76/78] ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()
Date:   Mon, 29 Jun 2020 11:38:04 -0400
Message-Id: <20200629153806.2494953-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6de3c9e3f6b3eaf66859e1379b3f35dda781416b upstream.

The quirk function snd_emuusb_set_samplerate() has a NULL check for
the mixer element, but this is useless in the current code.  It used
to be a check against mixer->id_elems[unitid] but it was changed later
to the value after mixer_eleme_list_to_info() which is always non-NULL
due to the container_of() usage.

This patch fixes the check before the conversion.

While we're at it, correct a typo in the comment in the function,
too.

Fixes: 8c558076c740 ("ALSA: usb-audio: Clean up mixer element list traverse")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 5604cce30a582..ac80fd188a3fb 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1169,17 +1169,17 @@ void snd_emuusb_set_samplerate(struct snd_usb_audio *chip,
 {
 	struct usb_mixer_interface *mixer;
 	struct usb_mixer_elem_info *cval;
-	int unitid = 12; /* SamleRate ExtensionUnit ID */
+	int unitid = 12; /* SampleRate ExtensionUnit ID */
 
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
-		cval = mixer_elem_list_to_info(mixer->id_elems[unitid]);
-		if (cval) {
+		if (mixer->id_elems[unitid]) {
+			cval = mixer_elem_list_to_info(mixer->id_elems[unitid]);
 			snd_usb_mixer_set_ctl_value(cval, UAC_SET_CUR,
 						    cval->control << 8,
 						    samplerate_id);
 			snd_usb_mixer_notify_id(mixer, unitid);
+			break;
 		}
-		break;
 	}
 }
 
-- 
2.25.1

