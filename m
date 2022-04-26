Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5C50F6F5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbiDZJDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346741AbiDZJBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CA1793B2;
        Tue, 26 Apr 2022 01:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A7B9611A3;
        Tue, 26 Apr 2022 08:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80783C385A4;
        Tue, 26 Apr 2022 08:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962608;
        bh=1kzBCrS/4dNEaFZo2xGXwRPSegciKCrtTqSWBwzICZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+t67OceqFieOhbyOhJqpoUY9KJDOBG1ktfoMk7owRCdC2eU7fJZguMTkPaag+BUn
         I9nOJkgjub436IwdJwF7GifF6/KyOQRJUKcuK3zz884Pu4/dH+eb7c8OjsDydeb8+M
         vTuleF2BAV4ocN73GhCRTgLfoQ5Pme4bsFjVndBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 030/146] ALSA: hda/hdmi: fix warning about PCM count when used with SOF
Date:   Tue, 26 Apr 2022 10:20:25 +0200
Message-Id: <20220426081750.914813903@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit c74193787b2f683751a67603fb5f15c7584f355f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index cf4f277dccdd..26637a695979 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1387,7 +1387,7 @@ static int hdmi_find_pcm_slot(struct hdmi_spec *spec,
 
  last_try:
 	/* the last try; check the empty slots in pins */
-	for (i = 0; i < spec->num_nids; i++) {
+	for (i = 0; i < spec->pcm_used; i++) {
 		if (!test_bit(i, &spec->pcm_bitmap))
 			return i;
 	}
@@ -2263,7 +2263,9 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 	 * dev_num is the device entry number in a pin
 	 */
 
-	if (codec->mst_no_extra_pcms)
+	if (spec->dyn_pcm_no_legacy && codec->mst_no_extra_pcms)
+		pcm_num = spec->num_cvts;
+	else if (codec->mst_no_extra_pcms)
 		pcm_num = spec->num_nids;
 	else
 		pcm_num = spec->num_nids + spec->dev_num - 1;
-- 
2.35.1



