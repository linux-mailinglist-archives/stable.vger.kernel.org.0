Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C4F6583F1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiL1Qxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiL1Qwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71631DDF8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 541AD60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677F2C433D2;
        Wed, 28 Dec 2022 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246051;
        bh=+fHx5xwYWoNrQ8o+aNkjZ5N9nvTSb0xbIriaqQ8NvX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZ1HzVu285xvkWePP8Z74EqBL7l2JDoUR0I73Gahu/u9DW8TXnSt907oqHyre1Fyg
         7jNn7fEsQOFNl6p3O7JL0WDDpTRwqYi5+0/iuD9aZVsBRSj2OWzFwKF4rUdhEm9pK9
         v4DczNKhKxU1QKGXovxUHndOz02FO9i4R/lavfqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1004/1073] ALSA: hda/hdmi: fix i915 silent stream programming flow
Date:   Wed, 28 Dec 2022 15:43:12 +0100
Message-Id: <20221228144355.416002332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 287f4f78e7b1..3655584fc37b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2963,9 +2963,33 @@ static int i915_hsw_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
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



