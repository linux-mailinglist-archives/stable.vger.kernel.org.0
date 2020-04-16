Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DF21AC7BE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409063AbgDPNyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgDPNyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367C920732;
        Thu, 16 Apr 2020 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045290;
        bh=Ccx5IMb0hrnaC5537dtoCxBIqyonxRrmjubp0SWGv5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=em+kzqvSXmiRchnAoOWXBoycz+i39eiN7VfCS//D+D67n3oy0kf4bFMuc1FoGsqzD
         KIRX2+qlzJTCahiESF2p+miNvoCtXnNxLaRVoKjIWINyhwvex1krzjt24nXhLKbxsP
         aQaC1gryRCeb9iWVPtYhVKdUtt7tn9eJIdCoz6V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 074/254] ALSA: hda: Fix potential access overflow in beep helper
Date:   Thu, 16 Apr 2020 15:22:43 +0200
Message-Id: <20200416131335.141789732@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
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
@@ -290,8 +290,12 @@ int snd_hda_mixer_amp_switch_get_beep(st
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


