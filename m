Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98EA406C1C
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhIJMg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbhIJMfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F314D61206;
        Fri, 10 Sep 2021 12:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277278;
        bh=WSnMHjzypwQ7Fjbes+Eoz5ZjFsK+4pYENgGUMoTuVxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8w7uOGw9fakfG/ZwQ3UZD01dGQB6I6fsk3xr37vfc4+q03vBT5YxurVKjuu84msC
         Mtj1OWk7fuqMSBVr+EeGMz8jUTYEKUgRthNCf9jKM7zSGv3LDOIzAgCd3F71D79k0b
         Er9bjuyQcN+fjkbhJgPo5tWA5kR1Rgr8h5Wsox/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 18/37] ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17
Date:   Fri, 10 Sep 2021 14:30:21 +0200
Message-Id: <20210910122917.767802823@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 13d9c6b998aaa76fd098133277a28a21f2cc2264 upstream.

ASUS ROG Strix G17 has the very same PCI and codec SSID (1043:103f) as
ASUS TX300, and unfortunately, the existing quirk for TX300 is broken
on ASUS ROG.  Actually the device works without the quirk, so we'll
need to clear the quirk before applying for this device.
Since ASUS ROG has a different codec (ALC294 - while TX300 has
ALC282), this patch adds a workaround for the device, just clearing
the codec->fixup_id by checking the codec vendor_id.

It's a bit ugly to add such a workaround there, but it seems to be the
simplest way.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214101
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210820143214.3654-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9160,6 +9160,16 @@ static int patch_alc269(struct hda_codec
 
 	snd_hda_pick_fixup(codec, alc269_fixup_models,
 		       alc269_fixup_tbl, alc269_fixups);
+	/* FIXME: both TX300 and ROG Strix G17 have the same SSID, and
+	 * the quirk breaks the latter (bko#214101).
+	 * Clear the wrong entry.
+	 */
+	if (codec->fixup_id == ALC282_FIXUP_ASUS_TX300 &&
+	    codec->core.vendor_id == 0x10ec0294) {
+		codec_dbg(codec, "Clear wrong fixup for ASUS ROG Strix G17\n");
+		codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
+	}
+
 	snd_hda_pick_pin_fixup(codec, alc269_pin_fixup_tbl, alc269_fixups, true);
 	snd_hda_pick_pin_fixup(codec, alc269_fallback_pin_fixup_tbl, alc269_fixups, false);
 	snd_hda_pick_fixup(codec, NULL,	alc269_fixup_vendor_tbl,


