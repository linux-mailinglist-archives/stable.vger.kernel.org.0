Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9909C603DC4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiJSJG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiJSJFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB002A02C2;
        Wed, 19 Oct 2022 01:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C5461811;
        Wed, 19 Oct 2022 08:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C34C433D6;
        Wed, 19 Oct 2022 08:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169753;
        bh=z4eMTWqcnGs3mvdT0lsKNRiWvcTHVC0wRPyGnsThfYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuBtc6lJb19m61pheBKaire+LeNpxlZpYaqLw1bXbGpcjEJBpEwqm4p7W7zNoxuhf
         OntVfGAG92sLkKXMPznqCIscfNZEd0fCRkKPUrrsytra6qqptz1vmytgzyOQelY3fA
         NQygZDFSmfTkQzr+nuHDprbihcGe/CgRV3cBG/JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 395/862] ALSA: hda/hdmi: change type for the assigned variable
Date:   Wed, 19 Oct 2022 10:28:02 +0200
Message-Id: <20221019083307.392603524@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit 4053a41282f8aae290d3fe7b8daef4c8c53a4ab8 ]

This change converts the assigned value from int type to
the bool type to retain consistency with other structure
members like 'setup', 'non_pcm' etc.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220913070307.3234038-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: fc6f923ecfa2 ("ALSA: hda/hdmi: Fix the converter allocation for the silent stream")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c239d9dbbaef..69afea67bf3e 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(enable_all_pins, "Forcibly enable all pins");
 
 struct hdmi_spec_per_cvt {
 	hda_nid_t cvt_nid;
-	int assigned;
+	bool assigned;		/* the stream has been assigned */
 	unsigned int channels_min;
 	unsigned int channels_max;
 	u32 rates;
@@ -1204,7 +1204,7 @@ static int hdmi_pcm_open_no_pin(struct hda_pcm_stream *hinfo,
 		return err;
 
 	per_cvt = get_cvt(spec, cvt_idx);
-	per_cvt->assigned = 1;
+	per_cvt->assigned = true;
 	hinfo->nid = per_cvt->cvt_nid;
 
 	pin_cvt_fixup(codec, NULL, per_cvt->cvt_nid);
@@ -1273,7 +1273,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 
 	per_cvt = get_cvt(spec, cvt_idx);
 	/* Claim converter */
-	per_cvt->assigned = 1;
+	per_cvt->assigned = true;
 
 	set_bit(pcm_idx, &spec->pcm_in_use);
 	per_pin = get_pin(spec, pin_idx);
@@ -1308,7 +1308,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 		snd_hdmi_eld_update_pcm_info(&eld->info, hinfo);
 		if (hinfo->channels_min > hinfo->channels_max ||
 		    !hinfo->rates || !hinfo->formats) {
-			per_cvt->assigned = 0;
+			per_cvt->assigned = false;
 			hinfo->nid = 0;
 			snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 			err = -ENODEV;
@@ -1767,7 +1767,7 @@ static void silent_stream_enable(struct hda_codec *codec,
 	}
 
 	per_cvt = get_cvt(spec, cvt_idx);
-	per_cvt->assigned = 1;
+	per_cvt->assigned = true;
 	per_pin->cvt_nid = per_cvt->cvt_nid;
 	per_pin->silent_stream = true;
 
@@ -1827,7 +1827,7 @@ static void silent_stream_disable(struct hda_codec *codec,
 	cvt_idx = cvt_nid_to_cvt_index(codec, per_pin->cvt_nid);
 	if (cvt_idx >= 0 && cvt_idx < spec->num_cvts) {
 		per_cvt = get_cvt(spec, cvt_idx);
-		per_cvt->assigned = 0;
+		per_cvt->assigned = false;
 	}
 
 	if (spec->silent_stream_type == SILENT_STREAM_I915) {
@@ -2223,7 +2223,7 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 			goto unlock;
 		}
 		per_cvt = get_cvt(spec, cvt_idx);
-		per_cvt->assigned = 0;
+		per_cvt->assigned = false;
 		hinfo->nid = 0;
 
 		azx_stream(get_azx_dev(substream))->stripe = 0;
-- 
2.35.1



