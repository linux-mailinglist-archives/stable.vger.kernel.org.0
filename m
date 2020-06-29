Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1551B20DE20
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgF2UWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732578AbgF2TZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F4B52548D;
        Mon, 29 Jun 2020 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445450;
        bh=68vB2YRlflfM6eEWY7FVvsbIyR/+gueoV8EbSaIbw6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wV/P3X5yG/WdAL2qYnxy6+l5DglLyFfrK5BqjrAbgSLslpkfp/637JyFPZIOPVPIP
         dXpZ0O8mYMwn6faUgCsxc6eMDo3zjbkyUtMH8MvflHkt04LkHHr5GUJ+UoCmxi8AfV
         e1CvOAYwf79Qx9ELFPnrTzDT5b1U5pR2ukPSiJ5E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 189/191] ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()
Date:   Mon, 29 Jun 2020 11:40:05 -0400
Message-Id: <20200629154007.2495120-190-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
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
index 198515f86fcc2..9646513f4b4ad 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1168,17 +1168,17 @@ void snd_emuusb_set_samplerate(struct snd_usb_audio *chip,
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

