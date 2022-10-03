Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519935F2A48
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiJCHew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiJCHeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502FA52DD1;
        Mon,  3 Oct 2022 00:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF5AB80E97;
        Mon,  3 Oct 2022 07:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8ECC433D6;
        Mon,  3 Oct 2022 07:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781694;
        bh=SnZkNAAap/Esf6QKxUhI0fy+mo0YZ4Nsu80pdvM0q08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3GF7RD3E4B2iz3eidxve0jvY7nt5N7YEA2wyyXAKo8K9cPSKYSSyumTFkAQ9ToyH
         nk7wmsXuPxojwAouzU4ZAr2g8Op5AWZVlO8RCAH54rtkuW55eDGL4lWuhlEY5cn6cp
         8nF4YEs6PzfyS7nse+B/QnhLCIa4SaeXNh4/oO1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>
Subject: [PATCH 5.10 05/52] ALSA: hda/hdmi: let new platforms assign the pcm slot dynamically
Date:   Mon,  3 Oct 2022 09:11:12 +0200
Message-Id: <20221003070718.869196074@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 13046370c4d143b629adc1a51659a8a6497fbbe6 ]

If the platform set the dyn_pcm_assign to true, it will call
hdmi_find_pcm_slot() to find a pcm slot when hdmi/dp monitor is
connected and need to create a pcm.

So far only intel_hsw_common_init() and patch_nvhdmi() set the
dyn_pcm_assign to true, here we let tgl platforms assign the pcm slot
dynamically first, if the driver runs for a period of time and there
is no regression reported, we could set no_fixed_assgin to true in
the intel_hsw_common_init(), and then set it to true in the
patch_nvhdmi().

This change comes from the discussion between Takashi and
Kai Vehmanen. Please refer to:
https://github.com/alsa-project/alsa-lib/pull/118

Suggested-and-reviewed-by: Takashi Iwai <tiwai@suse.de>
Suggested-and-reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210301111202.2684-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: f89e409402e2 ("ALSA: hda: Fix Nvidia dp infoframe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 7551cdf3b452..6110370f874d 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -157,6 +157,7 @@ struct hdmi_spec {
 
 	bool dyn_pin_out;
 	bool dyn_pcm_assign;
+	bool dyn_pcm_no_legacy;
 	bool intel_hsw_fixup;	/* apply Intel platform-specific fixups */
 	/*
 	 * Non-generic VIA/NVIDIA specific
@@ -1348,6 +1349,12 @@ static int hdmi_find_pcm_slot(struct hdmi_spec *spec,
 {
 	int i;
 
+	/* on the new machines, try to assign the pcm slot dynamically,
+	 * not use the preferred fixed map (legacy way) anymore.
+	 */
+	if (spec->dyn_pcm_no_legacy)
+		goto last_try;
+
 	/*
 	 * generic_hdmi_build_pcms() may allocate extra PCMs on some
 	 * platforms (with maximum of 'num_nids + dev_num - 1')
@@ -1377,6 +1384,7 @@ static int hdmi_find_pcm_slot(struct hdmi_spec *spec,
 			return i;
 	}
 
+ last_try:
 	/* the last try; check the empty slots in pins */
 	for (i = 0; i < spec->num_nids; i++) {
 		if (!test_bit(i, &spec->pcm_bitmap))
@@ -3010,8 +3018,16 @@ static int patch_i915_tgl_hdmi(struct hda_codec *codec)
 	 * the index indicate the port number.
 	 */
 	static const int map[] = {0x4, 0x6, 0x8, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf};
+	int ret;
 
-	return intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map));
+	ret = intel_hsw_common_init(codec, 0x02, map, ARRAY_SIZE(map));
+	if (!ret) {
+		struct hdmi_spec *spec = codec->spec;
+
+		spec->dyn_pcm_no_legacy = true;
+	}
+
+	return ret;
 }
 
 /* Intel Baytrail and Braswell; with eld notifier */
-- 
2.35.1



