Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788265F2A8B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiJCHhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiJCHgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B23953D07;
        Mon,  3 Oct 2022 00:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B3A5B80E6B;
        Mon,  3 Oct 2022 07:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9EBC433C1;
        Mon,  3 Oct 2022 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781757;
        bh=QubCXVO1eZHduPQuQf/ZUdZM76o2tK99OXXVagDZDhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMfhG1kfCGUaV3eadt7moQvKOLKvCCaD2e8gTdfL2fglCq3EsvabqLlWgO+uq2iqu
         d5LHtmCP+y898k/CypcEl0hA9YC1p11BzdczAxFhlUfTjbpfHF0Fqb3bIbVJQRmXuE
         Lpyw3bVsauAnVqdHhfiMFz94ZovFQ6tP1DKM0NoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 52/52] ALSA: hda/hdmi: fix warning about PCM count when used with SOF
Date:   Mon,  3 Oct 2022 09:11:59 +0200
Message-Id: <20221003070720.265653019@linuxfoundation.org>
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

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit c74193787b2f683751a67603fb5f15c7584f355f upstream.

With commit 13046370c4d1 ("ALSA: hda/hdmi: let new platforms assign the
pcm slot dynamically"), old behaviour to consider the HDA pin number,
when choosing PCM to assign, was dropped.

Build on this change and limit the number of PCMs created to number of
converters (= maximum number of concurrent display/receivers) when
"mst_no_extra_pcms" and "dyn_pcm_no_legacy" quirks are both set.

Fix the check in hdmi_find_pcm_slot() to ensure only spec->pcm_used
entries are considered in the search. Elsewhere in the driver
spec->pcm_used is already checked properly.

Doing this avoids following warning at SOF driver probe for multiple
machine drivers:

[  112.425297] sof_sdw sof_sdw: hda_dsp_hdmi_build_controls: no
PCM in topology for HDMI converter 4
[  112.425298] sof_sdw sof_sdw: hda_dsp_hdmi_build_controls: no
PCM in topology for HDMI converter 5
[  112.425299] sof_sdw sof_sdw: hda_dsp_hdmi_build_controls: no
PCM in topology for HDMI converter 6

Fixes: 13046370c4d1 ("ALSA: hda/hdmi: let new platforms assign the pcm slot dynamically")
BugLink: https://github.com/thesofproject/linux/issues/2573
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20220414150516.3638283-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1397,7 +1397,7 @@ static int hdmi_find_pcm_slot(struct hdm
 
  last_try:
 	/* the last try; check the empty slots in pins */
-	for (i = 0; i < spec->num_nids; i++) {
+	for (i = 0; i < spec->pcm_used; i++) {
 		if (!test_bit(i, &spec->pcm_bitmap))
 			return i;
 	}
@@ -2273,7 +2273,9 @@ static int generic_hdmi_build_pcms(struc
 	 * dev_num is the device entry number in a pin
 	 */
 
-	if (codec->mst_no_extra_pcms)
+	if (spec->dyn_pcm_no_legacy && codec->mst_no_extra_pcms)
+		pcm_num = spec->num_cvts;
+	else if (codec->mst_no_extra_pcms)
 		pcm_num = spec->num_nids;
 	else
 		pcm_num = spec->num_nids + spec->dev_num - 1;


