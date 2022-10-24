Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DB660AD75
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiJXOZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiJXOXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C75981CA;
        Mon, 24 Oct 2022 05:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB07612FF;
        Mon, 24 Oct 2022 12:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1297C433D7;
        Mon, 24 Oct 2022 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615481;
        bh=uLP/v4pPCuxso/vuU6PoxkZFMFw+IoE4hCq+BrnMAP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6FpNxWbktKFS2+cxhvK167Lhv/CERBMwYMzCVAY+8iU7p3nZ2NMU2+fY66eHtcDa
         MHTK9ERF2xHF7SETY9lC4g+79zahAfuxlM0yO1gWka7LTSZdHRPJJzPQe28HDk2N4s
         NQdCXt4WcWxAU/S7v4WWgyYw1X0+AFMqj01+xtgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/530] ALSA: hda: beep: Simplify keep-power-at-enable behavior
Date:   Mon, 24 Oct 2022 13:29:32 +0200
Message-Id: <20221024113055.406268982@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4c8d695cb9bc5f6fd298a586602947b2fc099a64 ]

The recent fix for IDT codecs to keep the power up while the beep is
enabled can be better integrated into the beep helper code.
This patch cleans up the code with refactoring.

Fixes: 414d38ba8710 ("ALSA: hda/sigmatel: Keep power up while beep is enabled")
Link: https://lore.kernel.org/r/20220906092306.26183-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_beep.c       | 15 +++++++++++++--
 sound/pci/hda/hda_beep.h       |  1 +
 sound/pci/hda/patch_sigmatel.c | 25 ++-----------------------
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/sound/pci/hda/hda_beep.c b/sound/pci/hda/hda_beep.c
index 53a2b89f8983..e63621bcb214 100644
--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -118,6 +118,12 @@ static int snd_hda_beep_event(struct input_dev *dev, unsigned int type,
 	return 0;
 }
 
+static void turn_on_beep(struct hda_beep *beep)
+{
+	if (beep->keep_power_at_enable)
+		snd_hda_power_up_pm(beep->codec);
+}
+
 static void turn_off_beep(struct hda_beep *beep)
 {
 	cancel_work_sync(&beep->beep_work);
@@ -125,6 +131,8 @@ static void turn_off_beep(struct hda_beep *beep)
 		/* turn off beep */
 		generate_tone(beep, 0);
 	}
+	if (beep->keep_power_at_enable)
+		snd_hda_power_down_pm(beep->codec);
 }
 
 /**
@@ -140,7 +148,9 @@ int snd_hda_enable_beep_device(struct hda_codec *codec, int enable)
 	enable = !!enable;
 	if (beep->enabled != enable) {
 		beep->enabled = enable;
-		if (!enable)
+		if (enable)
+			turn_on_beep(beep);
+		else
 			turn_off_beep(beep);
 		return 1;
 	}
@@ -167,7 +177,8 @@ static int beep_dev_disconnect(struct snd_device *device)
 		input_unregister_device(beep->dev);
 	else
 		input_free_device(beep->dev);
-	turn_off_beep(beep);
+	if (beep->enabled)
+		turn_off_beep(beep);
 	return 0;
 }
 
diff --git a/sound/pci/hda/hda_beep.h b/sound/pci/hda/hda_beep.h
index a25358a4807a..db76e3ddba65 100644
--- a/sound/pci/hda/hda_beep.h
+++ b/sound/pci/hda/hda_beep.h
@@ -25,6 +25,7 @@ struct hda_beep {
 	unsigned int enabled:1;
 	unsigned int linear_tone:1;	/* linear tone for IDT/STAC codec */
 	unsigned int playing:1;
+	unsigned int keep_power_at_enable:1;	/* set by driver */
 	struct work_struct beep_work; /* scheduled task for beep event */
 	struct mutex mutex;
 	void (*power_hook)(struct hda_beep *beep, bool on);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 7f340f18599c..a794a01a68ca 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4311,6 +4311,8 @@ static int stac_parse_auto_config(struct hda_codec *codec)
 		if (codec->beep) {
 			/* IDT/STAC codecs have linear beep tone parameter */
 			codec->beep->linear_tone = spec->linear_tone_beep;
+			/* keep power up while beep is enabled */
+			codec->beep->keep_power_at_enable = 1;
 			/* if no beep switch is available, make its own one */
 			caps = query_amp_caps(codec, nid, HDA_OUTPUT);
 			if (!(caps & AC_AMPCAP_MUTE)) {
@@ -4444,28 +4446,6 @@ static int stac_suspend(struct hda_codec *codec)
 
 	return 0;
 }
-
-static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
-{
-#ifdef CONFIG_SND_HDA_INPUT_BEEP
-	struct sigmatel_spec *spec = codec->spec;
-#endif
-	int ret = snd_hda_gen_check_power_status(codec, nid);
-
-#ifdef CONFIG_SND_HDA_INPUT_BEEP
-	if (nid == spec->gen.beep_nid && codec->beep) {
-		if (codec->beep->enabled != spec->beep_power_on) {
-			spec->beep_power_on = codec->beep->enabled;
-			if (spec->beep_power_on)
-				snd_hda_power_up_pm(codec);
-			else
-				snd_hda_power_down_pm(codec);
-		}
-		ret |= spec->beep_power_on;
-	}
-#endif
-	return ret;
-}
 #else
 #define stac_suspend		NULL
 #endif /* CONFIG_PM */
@@ -4478,7 +4458,6 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
-	.check_power_status = stac_check_power_status,
 #endif
 };
 
-- 
2.35.1



