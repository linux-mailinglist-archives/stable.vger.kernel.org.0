Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7276DEE79
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjDLIly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjDLIlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20413524B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04BBE62FFE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D7DC4339C;
        Wed, 12 Apr 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288823;
        bh=LwYiKpVI7U1V7BfG1v/KuTbzsmNUe1U52wW6R+vDd+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybcEOUSK1liX0zVek693mmGE2sCxCsBT3jaXiCcFrtVPormNF+4TD5fPrI04dHR9S
         Oag8wCsui3+iybZ5bNFcswuopZvkOICpUVqZVAXtqe7klghF6W9+8QkbygEWNlRq02
         vqHJAnIVwKMrLvl9aJlO2y+7TpPuMrMrRntb79lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/164] ALSA: hda/hdmi: Preserve the previous PCM device upon re-enablement
Date:   Wed, 12 Apr 2023 10:32:33 +0200
Message-Id: <20230412082838.235812113@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f785f5ee968f7045268b8be6b0abc850c4a4277c ]

When a DRM driver turns on or off the screen with the audio
capability, it notifies the ELD to HD-audio HDMI codec driver via
component ops.  HDMI codec driver, in turn, attaches or detaches the
PCM stream for the given port on the fly.

The problem is that, since the recent code change, the HDMI driver
always treats the PCM stream assignment dynamically; this ended up the
confusion of the PCM device appearance.  e.g. when a screen goes once
off and on again, it may appear on a different PCM device before the
screen-off.  Although the application should treat such a change, it
doesn't seem working gracefully with the current pipewire (maybe
PulseAudio, too).

As a workaround, this patch changes the HDMI codec driver behavior
slightly to be more consistent.  Now it remembers the previous PCM
slot for the given port and try to assign to it.  That is, if a port
is re-enabled, the driver tries to use the same PCM slot that was
assigned to that port previously.  If it conflicts, a new slot is
searched and used like before, instead.

Note that multiple monitor connections are the only typical case where
the PCM slot preservation is effective.  As long as only a single
monitor is connected, the behavior isn't changed, and the first PCM
slot is still assigned always.

Fixes: ef6f5494faf6 ("ALSA: hda/hdmi: Use only dynamic PCM device allocation")
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217259
Link: https://lore.kernel.org/r/20230331142217.19791-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 9ea633fe93393..4ffa3a59f419f 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -81,6 +81,7 @@ struct hdmi_spec_per_pin {
 	struct delayed_work work;
 	struct hdmi_pcm *pcm; /* pointer to spec->pcm_rec[n] dynamically*/
 	int pcm_idx; /* which pcm is attached. -1 means no pcm is attached */
+	int prev_pcm_idx; /* previously assigned pcm index */
 	int repoll_count;
 	bool setup; /* the stream has been set up by prepare callback */
 	bool silent_stream;
@@ -1380,9 +1381,17 @@ static void hdmi_attach_hda_pcm(struct hdmi_spec *spec,
 	/* pcm already be attached to the pin */
 	if (per_pin->pcm)
 		return;
+	/* try the previously used slot at first */
+	idx = per_pin->prev_pcm_idx;
+	if (idx >= 0) {
+		if (!test_bit(idx, &spec->pcm_bitmap))
+			goto found;
+		per_pin->prev_pcm_idx = -1; /* no longer valid, clear it */
+	}
 	idx = hdmi_find_pcm_slot(spec, per_pin);
 	if (idx == -EBUSY)
 		return;
+ found:
 	per_pin->pcm_idx = idx;
 	per_pin->pcm = get_hdmi_pcm(spec, idx);
 	set_bit(idx, &spec->pcm_bitmap);
@@ -1398,6 +1407,7 @@ static void hdmi_detach_hda_pcm(struct hdmi_spec *spec,
 		return;
 	idx = per_pin->pcm_idx;
 	per_pin->pcm_idx = -1;
+	per_pin->prev_pcm_idx = idx; /* remember the previous index */
 	per_pin->pcm = NULL;
 	if (idx >= 0 && idx < spec->pcm_used)
 		clear_bit(idx, &spec->pcm_bitmap);
@@ -1924,6 +1934,7 @@ static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 
 		per_pin->pcm = NULL;
 		per_pin->pcm_idx = -1;
+		per_pin->prev_pcm_idx = -1;
 		per_pin->pin_nid = pin_nid;
 		per_pin->pin_nid_idx = spec->num_nids;
 		per_pin->dev_id = i;
-- 
2.39.2



