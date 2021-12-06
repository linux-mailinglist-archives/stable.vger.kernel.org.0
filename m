Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297AB469E72
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379483AbhLFPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379167AbhLFPgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C572AC08EAD4;
        Mon,  6 Dec 2021 07:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6363861309;
        Mon,  6 Dec 2021 15:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D267C341C1;
        Mon,  6 Dec 2021 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804180;
        bh=kh7end/w1tCl7Yy936OmQbJ35EV+hbrWHksj12yD4ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozq1xDo9ZSwBiyWwfw7IhedvKg0VblGm6uco/cN112w5itL7TLT3FVX1XvQB5gLv/
         T7ZuvrLqxeIhjzSydtkiu8Y0sYhvqbwFzmv+FkCcgrlot9rabGlAG5/QJnOEXZW46k
         sVOZ2+SqqhZa1WGpst48bZs5CvtE6vXo3s/mXL1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Binding <sbinding@opensource.cirrus.com>,
        Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 055/207] ALSA: hda/cs8409: Set PMSG_ON earlier inside cs8409 driver
Date:   Mon,  6 Dec 2021 15:55:09 +0100
Message-Id: <20211206145612.144741389@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Binding <sbinding@opensource.cirrus.com>

commit 65cc4ad62a9ed47c0b4fcd7af667d97d7c29f19d upstream.

For cs8409, it is required to run Jack Detect on resume.
Jack Detect on cs8409+cs42l42 requires an interrupt from
cs42l42 to be sent to cs8409 which is propogated to the driver
via an unsolicited event.
However, the hda_codec drops unsolicited events if the power_state
is not set to PMSG_ON. Which is set at the end of the resume call.
This means there is a race condition between setting power_state
to PMSG_ON and receiving the interrupt.
To solve this, we can add an API to set the power_state earlier
and call that before we start Jack Detect.
This does not cause issues, since we know inside our driver that
we are already initialized, and ready to handle the unsolicited
events.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Cc: <stable@vger.kernel.org> # v5.15+
Link: https://lore.kernel.org/r/20211128115558.71683-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_local.h    |    9 +++++++++
 sound/pci/hda/patch_cs8409.c |    5 +++++
 2 files changed, 14 insertions(+)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -438,6 +438,15 @@ int snd_hda_codec_set_pin_target(struct
 #define for_each_hda_codec_node(nid, codec) \
 	for ((nid) = (codec)->core.start_nid; (nid) < (codec)->core.end_nid; (nid)++)
 
+/* Set the codec power_state flag to indicate to allow unsol event handling;
+ * see hda_codec_unsol_event() in hda_bind.c.  Calling this might confuse the
+ * state tracking, so use with care.
+ */
+static inline void snd_hda_codec_allow_unsol_events(struct hda_codec *codec)
+{
+	codec->core.dev.power.power_state = PMSG_ON;
+}
+
 /*
  * get widget capabilities
  */
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -750,6 +750,11 @@ static void cs42l42_resume(struct sub_co
 	if (cs42l42->full_scale_vol)
 		cs8409_i2c_write(cs42l42, 0x2001, 0x01);
 
+	/* we have to explicitly allow unsol event handling even during the
+	 * resume phase so that the jack event is processed properly
+	 */
+	snd_hda_codec_allow_unsol_events(cs42l42->codec);
+
 	cs42l42_enable_jack_detect(cs42l42);
 }
 


