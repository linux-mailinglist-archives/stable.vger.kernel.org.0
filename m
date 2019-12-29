Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A812C780
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfL2RnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfL2RnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA838206A4;
        Sun, 29 Dec 2019 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641382;
        bh=KG70q5BwuIoJXG7In5KYx+zi2s79625jSMuz5g1m7e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yebkzLdNa6oZ2yfhh3tF2PKqK5BrmqLw8S3HC3jlC/9p3rv6lbK+wH4OLPfUJRc0r
         rpppOLkCns2iwhytvrOZOCg14vj0PE6QmQgSd2MXwC9TCeb2i+pAXbEWUgvMlUmr/Y
         uK4hVraDHYytDwkwDxhVyYaPv9XtuZsNLerBGtg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 042/434] ALSA: hda/ca0132 - Fix work handling in delayed HP detection
Date:   Sun, 29 Dec 2019 18:21:35 +0100
Message-Id: <20191229172704.827422730@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 42fb6b1d41eb5905d77c06cad2e87b70289bdb76 upstream.

CA0132 has the delayed HP jack detection code that is invoked from the
unsol handler, but it does a few weird things: it contains the cancel
of a work inside the work handler, and yet it misses the cancel-sync
call at (runtime-)suspend.  This patch addresses those issues.

Fixes: 15c2b3cc09a3 ("ALSA: hda/ca0132 - Fix possible workqueue stall")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213085111.22855-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -7607,11 +7607,10 @@ static void hp_callback(struct hda_codec
 	/* Delay enabling the HP amp, to let the mic-detection
 	 * state machine run.
 	 */
-	cancel_delayed_work(&spec->unsol_hp_work);
-	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 	tbl = snd_hda_jack_tbl_get(codec, cb->nid);
 	if (tbl)
 		tbl->block_report = 1;
+	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 }
 
 static void amic_callback(struct hda_codec *codec, struct hda_jack_callback *cb)
@@ -8457,12 +8456,25 @@ static void ca0132_reboot_notify(struct
 	codec->patch_ops.free(codec);
 }
 
+#ifdef CONFIG_PM
+static int ca0132_suspend(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+
+	cancel_delayed_work_sync(&spec->unsol_hp_work);
+	return 0;
+}
+#endif
+
 static const struct hda_codec_ops ca0132_patch_ops = {
 	.build_controls = ca0132_build_controls,
 	.build_pcms = ca0132_build_pcms,
 	.init = ca0132_init,
 	.free = ca0132_free,
 	.unsol_event = snd_hda_jack_unsol_event,
+#ifdef CONFIG_PM
+	.suspend = ca0132_suspend,
+#endif
 	.reboot_notify = ca0132_reboot_notify,
 };
 


