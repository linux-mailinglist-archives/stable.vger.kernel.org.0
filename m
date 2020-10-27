Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9537129C3A4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754085AbgJ0Rqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902129AbgJ0Oak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:30:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A3F22202;
        Tue, 27 Oct 2020 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809040;
        bh=FORQzrbH0JNXbkiJPlvAsPZqJT8xPSN8LuDtji+XeT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5mp2zG7+wtb0KA9so+7nPtVWCfc9tnCxPIUneNboc1dkyyrJK0wXRCsG1ZAoNxDq
         sCRae+ElpRjiECaJaA4oMNSJ3f3nwYtWCzJSQXIM5X6532F5fxlF5Kd6CLiI8X3Bix
         Eb+Bxrz8DFWZ7xOiNhnM9DFiZvyE3k/9ZnlVCuMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 022/408] ALSA: hda: fix jack detection with Realtek codecs when in D3
Date:   Tue, 27 Oct 2020 14:49:20 +0100
Message-Id: <20201027135456.087078753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit a6e7d0a4bdb02a7a3ffe0b44aaa8842b7efdd056 upstream.

In case HDA controller becomes active, but codec is runtime suspended,
jack detection is not successful and no interrupt is raised. This has
been observed with multiple Realtek codecs and HDA controllers from
different vendors. Bug does not occur if both codec and controller are
active, or both are in suspend. Bug can be easily hit on desktop systems
with no built-in speaker.

The problem can be fixed by powering up the codec once after every
controller runtime resume. Even if codec goes back to suspend later, the
jack detection will continue to work. Add a flag to 'hda_codec' to
describe codecs that require this flow from the controller driver.
Modify __azx_runtime_resume() to use pm_request_resume() to make the
intent clearer.

Mark all Realtek codecs with the new forced_resume flag.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209379
Cc: Kailang Yang <kailang@realtek.com>
Co-developed-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201012102704.794423-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/hda_codec.h     |    1 +
 sound/pci/hda/hda_intel.c     |   14 ++++++++------
 sound/pci/hda/patch_realtek.c |    1 +
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -254,6 +254,7 @@ struct hda_codec {
 	unsigned int force_pin_prefix:1; /* Add location prefix */
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
+	unsigned int forced_resume:1; /* forced resume for jack */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1001,12 +1001,14 @@ static void __azx_runtime_resume(struct
 	azx_init_pci(chip);
 	hda_intel_init_chip(chip, true);
 
-	if (status && from_rt) {
-		list_for_each_codec(codec, &chip->bus)
-			if (!codec->relaxed_resume &&
-			    (status & (1 << codec->addr)))
-				schedule_delayed_work(&codec->jackpoll_work,
-						      codec->jackpoll_interval);
+	if (from_rt) {
+		list_for_each_codec(codec, &chip->bus) {
+			if (codec->relaxed_resume)
+				continue;
+
+			if (codec->forced_resume || (status & (1 << codec->addr)))
+				pm_request_resume(hda_codec_dev(codec));
+		}
 	}
 
 	/* power down again for link-controlled chips */
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1141,6 +1141,7 @@ static int alc_alloc_spec(struct hda_cod
 	codec->single_adc_amp = 1;
 	/* FIXME: do we need this for all Realtek codec models? */
 	codec->spdif_status_reset = 1;
+	codec->forced_resume = 1;
 	codec->patch_ops = alc_patch_ops;
 
 	err = alc_codec_rename_from_preset(codec);


