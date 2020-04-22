Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A01B426C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgDVLBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgDVKBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EB92076C;
        Wed, 22 Apr 2020 10:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549681;
        bh=/3LBLbFaskxzFJjgyhptmFt7VqVQH1RAEmwmXCB/9dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyULcM7umYbVo+UputciKW3darAvMwzr2tYvFfWRJeIKDUwdjj6rqSF7X2VgsYCKI
         2Yv12Hjm0uF4KyP1k27cZIPcs0ltCca/E3sWGneU6yvfQOddnGE1tvOk/5kl+Fq0JL
         HfEyDH3W07PEVmqqEiLVnMLMOsWjlkwOsCn8+PL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 022/100] ALSA: hda: Fix potential access overflow in beep helper
Date:   Wed, 22 Apr 2020 11:55:52 +0200
Message-Id: <20200422095026.825310678@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0ad3f0b384d58f3bd1f4fb87d0af5b8f6866f41a upstream.

The beep control helper function blindly stores the values in two
stereo channels no matter whether the actual control is mono or
stereo.  This is practically harmless, but it annoys the recently
introduced sanity check, resulting in an error when the checker is
enabled.

This patch corrects the behavior to store only on the defined array
member.

Fixes: 0401e8548eac ("ALSA: hda - Move beep helper functions to hda_beep.c")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207139
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200407084402.25589-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_beep.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -310,8 +310,12 @@ int snd_hda_mixer_amp_switch_get_beep(st
 {
 	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct hda_beep *beep = codec->beep;
+	int chs = get_amp_channels(kcontrol);
+
 	if (beep && (!beep->enabled || !ctl_has_mute(kcontrol))) {
-		ucontrol->value.integer.value[0] =
+		if (chs & 1)
+			ucontrol->value.integer.value[0] = beep->enabled;
+		if (chs & 2)
 			ucontrol->value.integer.value[1] = beep->enabled;
 		return 0;
 	}


