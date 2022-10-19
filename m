Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D13604150
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiJSKm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiJSKli (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:41:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D05C38B3;
        Wed, 19 Oct 2022 03:19:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F5DB8241E;
        Wed, 19 Oct 2022 08:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A2CC433D6;
        Wed, 19 Oct 2022 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169755;
        bh=GT2VMBbT8oyd3xN+8SDhxONqhXZD0SajvrZKEinfg3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzlX3Vgs2AIzYlRP0bHRzexNFlv3pYnPo1kU1T8HMzbLIytE6PZTOnFkNpZRymiSO
         f4o+JOqjJimK8s3f2iYTlS/UF41PMNNtcD0Fgpe9kmevgt7ecg+4yUZj4cROcU39iY
         CuB+Vg0aLBvFQ3GfioWCa9uRN2ngULt1dY1xCmsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 396/862] ALSA: hda/hdmi: Fix the converter allocation for the silent stream
Date:   Wed, 19 Oct 2022 10:28:03 +0200
Message-Id: <20221019083307.428832707@linuxfoundation.org>
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

[ Upstream commit fc6f923ecfa2fafd0600f1b7e2de09baf29865e2 ]

Track the converters handling the silent stream using a new
variable to avoid mixing of the open/close and silent stream
use. This change ensures the proper allocation of the converters.

Fixes: 5f80d6bd2b01 ("ALSA: hda/hdmi: Fix the converter reuse for the silent stream")

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20220919135444.3554982-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 69afea67bf3e..d463c968b3a4 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(enable_all_pins, "Forcibly enable all pins");
 struct hdmi_spec_per_cvt {
 	hda_nid_t cvt_nid;
 	bool assigned;		/* the stream has been assigned */
+	bool silent_stream;	/* silent stream activated */
 	unsigned int channels_min;
 	unsigned int channels_max;
 	u32 rates;
@@ -988,7 +989,8 @@ static int hdmi_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
  * of the pin.
  */
 static int hdmi_choose_cvt(struct hda_codec *codec,
-			   int pin_idx, int *cvt_id)
+			   int pin_idx, int *cvt_id,
+			   bool silent)
 {
 	struct hdmi_spec *spec = codec->spec;
 	struct hdmi_spec_per_pin *per_pin;
@@ -1003,6 +1005,9 @@ static int hdmi_choose_cvt(struct hda_codec *codec,
 
 	if (per_pin && per_pin->silent_stream) {
 		cvt_idx = cvt_nid_to_cvt_index(codec, per_pin->cvt_nid);
+		per_cvt = get_cvt(spec, cvt_idx);
+		if (per_cvt->assigned && !silent)
+			return -EBUSY;
 		if (cvt_id)
 			*cvt_id = cvt_idx;
 		return 0;
@@ -1013,7 +1018,7 @@ static int hdmi_choose_cvt(struct hda_codec *codec,
 		per_cvt = get_cvt(spec, cvt_idx);
 
 		/* Must not already be assigned */
-		if (per_cvt->assigned)
+		if (per_cvt->assigned || per_cvt->silent_stream)
 			continue;
 		if (per_pin == NULL)
 			break;
@@ -1199,7 +1204,7 @@ static int hdmi_pcm_open_no_pin(struct hda_pcm_stream *hinfo,
 	if (pcm_idx < 0)
 		return -EINVAL;
 
-	err = hdmi_choose_cvt(codec, -1, &cvt_idx);
+	err = hdmi_choose_cvt(codec, -1, &cvt_idx, false);
 	if (err)
 		return err;
 
@@ -1267,7 +1272,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 		}
 	}
 
-	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx);
+	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx, false);
 	if (err < 0)
 		goto unlock;
 
@@ -1278,7 +1283,6 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	set_bit(pcm_idx, &spec->pcm_in_use);
 	per_pin = get_pin(spec, pin_idx);
 	per_pin->cvt_nid = per_cvt->cvt_nid;
-	per_pin->silent_stream = false;
 	hinfo->nid = per_cvt->cvt_nid;
 
 	/* flip stripe flag for the assigned stream if supported */
@@ -1760,14 +1764,14 @@ static void silent_stream_enable(struct hda_codec *codec,
 	}
 
 	pin_idx = pin_id_to_pin_index(codec, per_pin->pin_nid, per_pin->dev_id);
-	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx);
+	err = hdmi_choose_cvt(codec, pin_idx, &cvt_idx, true);
 	if (err) {
 		codec_err(codec, "hdmi: no free converter to enable silent mode\n");
 		goto unlock_out;
 	}
 
 	per_cvt = get_cvt(spec, cvt_idx);
-	per_cvt->assigned = true;
+	per_cvt->silent_stream = true;
 	per_pin->cvt_nid = per_cvt->cvt_nid;
 	per_pin->silent_stream = true;
 
@@ -1827,7 +1831,7 @@ static void silent_stream_disable(struct hda_codec *codec,
 	cvt_idx = cvt_nid_to_cvt_index(codec, per_pin->cvt_nid);
 	if (cvt_idx >= 0 && cvt_idx < spec->num_cvts) {
 		per_cvt = get_cvt(spec, cvt_idx);
-		per_cvt->assigned = false;
+		per_cvt->silent_stream = false;
 	}
 
 	if (spec->silent_stream_type == SILENT_STREAM_I915) {
-- 
2.35.1



