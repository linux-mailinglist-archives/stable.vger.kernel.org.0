Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6BF6584B6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiL1RBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiL1RAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:00:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696B421242
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09608B8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC1BC433F0;
        Wed, 28 Dec 2022 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246532;
        bh=k65Lw1dlEMgyIO5u6EUCxQ76RJ6rWVglKWFnCFjG2Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcspWakCP2XCjpGV3LPJZLh4OxkYq0b5sVDA3g0Kgvb/Vib5hONHeksM3yOOsHcG0
         UigZHd6CavyBlSOj4tKkZL3USP/LSVZlfanC1pMaRSmh68NZ9TxT8aLieYRJ1XS9Qn
         97rxfKBRWzaWH6NZq+EowRWiMVHhXO8nfa8NwXdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1072/1146] ALSA: hda/hdmi: fix i915 silent stream programming flow
Date:   Wed, 28 Dec 2022 15:43:31 +0100
Message-Id: <20221228144359.360726577@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit ada261b690ecd5c2f55f0c51bdf11d852a4561a6 ]

The i915 display codec may not successfully transition to
normal audio streaming mode, if the stream id is programmed
while codec is actively transmitting data. This can happen
when silent stream is enabled in KAE mode.

Fix the issue by implementing a i915 specific programming
flow, where the silent streaming is temporarily stopped,
a small delay is applied to ensure display codec becomes
idle, and then proceed with reprogramming the stream ID.

Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/7353
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20221209101822.3893675-2-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 21edf7a619f0..35bef8fcd240 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2878,9 +2878,33 @@ static int i915_hsw_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
 				 hda_nid_t pin_nid, int dev_id, u32 stream_tag,
 				 int format)
 {
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx = pin_id_to_pin_index(codec, pin_nid, dev_id);
+	struct hdmi_spec_per_pin *per_pin;
+	int res;
+
+	if (pin_idx < 0)
+		per_pin = NULL;
+	else
+		per_pin = get_pin(spec, pin_idx);
+
 	haswell_verify_D0(codec, cvt_nid, pin_nid);
-	return hdmi_setup_stream(codec, cvt_nid, pin_nid, dev_id,
-				 stream_tag, format);
+
+	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin && per_pin->silent_stream) {
+		silent_stream_set_kae(codec, per_pin, false);
+		/* wait for pending transfers in codec to clear */
+		usleep_range(100, 200);
+	}
+
+	res = hdmi_setup_stream(codec, cvt_nid, pin_nid, dev_id,
+				stream_tag, format);
+
+	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin && per_pin->silent_stream) {
+		usleep_range(100, 200);
+		silent_stream_set_kae(codec, per_pin, true);
+	}
+
+	return res;
 }
 
 /* pin_cvt_fixup ops override for HSW+ and VLV+ */
-- 
2.35.1



