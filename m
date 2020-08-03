Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1261E23A63D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgHCM07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgHCM06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EFD207DF;
        Mon,  3 Aug 2020 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457616;
        bh=Rh62DhGdoKHPCSs+kPs8e/tz6sIMTBBS7JOf5oDuEXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+SQ0XrLSB+jrAXhsUpyTUtkMLPXyTuVWwv2GsIdtPCfZJS2BqCNkRE6WOug+x3cT
         2Oo2wd4Es5kfbWIEiVplRL1W0crRRxeDk4ghW9cObsca2GddehpF5XG/i9wlsXof9y
         NHnRiUoL0Eyy1Lp4q74Mc7aKNKrp5U8FZH2HW6NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 12/90] ALSA: hda/hdmi: Fix keep_power assignment for non-component devices
Date:   Mon,  3 Aug 2020 14:18:34 +0200
Message-Id: <20200803121858.140976208@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c2c3657f0aedb8736a0fb7b2b1985adfb86e7802 upstream.

It's been reported that, when neither nouveau nor Nvidia graphics
driver is used, the screen starts flickering.  And, after comparing
between the working case (stable 4.4.x) and the broken case, it turned
out that the problem comes from the audio component binding.  The
Nvidia and AMD audio binding code clears the bus->keep_power flag
whenever snd_hdac_acomp_init() succeeds.  But this doesn't mean that
the component is actually bound, but it merely indicates that it's
ready for binding.  So, when both nouveau and Nvidia are blacklisted
or not ready, the driver keeps running without the audio component but
also with bus->keep_power = false.  This made the driver runtime PM
kicked in and powering down when unused, which results in flickering
in the graphics side, as it seems.

For fixing the bug, this patch moves the bus->keep_power flag change
into generic_acomp_notifier_set() that is the function called from the
master_bind callback of component ops; i.e. it's guaranteed that the
binding succeeded.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208609
Fixes: 5a858e79c911 ("ALSA: hda - Disable audio component for legacy Nvidia HDMI codecs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200728082033.23933-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2483,6 +2483,7 @@ static void generic_acomp_notifier_set(s
 	mutex_lock(&spec->bind_lock);
 	spec->use_acomp_notifier = use_acomp;
 	spec->codec->relaxed_resume = use_acomp;
+	spec->codec->bus->keep_power = 0;
 	/* reprogram each jack detection logic depending on the notifier */
 	if (spec->use_jack_detect) {
 		for (i = 0; i < spec->num_pins; i++)
@@ -2578,7 +2579,6 @@ static void generic_acomp_init(struct hd
 	if (!snd_hdac_acomp_init(&codec->bus->core, &spec->drm_audio_ops,
 				 match_bound_vga, 0)) {
 		spec->acomp_registered = true;
-		codec->bus->keep_power = 0;
 	}
 }
 


