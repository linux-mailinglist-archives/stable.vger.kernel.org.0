Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F747272DF2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgIUQof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbgIUQoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BDF23998;
        Mon, 21 Sep 2020 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706648;
        bh=4v8q9J/9fwWug1dfX+6rl1pBaG1KGfGEq1QFjK0EsXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHNRx92Pj+wwo2+ajxcKL5s83ihAEyoImXqpQzgHfItUXcfRuVA74OeyerwiXJMI0
         nTmB2ZVp7BCwuacD6TPE9onitYvtHRemTPtypO3M7aZ2dsk/eKeIso2KWGxWp9cZf8
         1GNBGzx36jgJ++VJJRa54ivMHYlnOYDZ2ZTKSWvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 038/118] ASoC: Intel: skl_hda_dsp_generic: Fix NULLptr dereference in autosuspend delay
Date:   Mon, 21 Sep 2020 18:27:30 +0200
Message-Id: <20200921162038.067119767@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Gorski <mateusz.gorski@linux.intel.com>

[ Upstream commit 5610921a4435ef45c33702073e64f835f3dca7f1 ]

Different modules for HDMI codec are used depending on the
"hda_codec_use_common_hdmi" option being enabled or not. Driver private
context for both of them is different.
This leads to null-pointer dereference error when driver tries to set
autosuspend delay for HDMI codec while the option is off (hdac_hdmi
module is used for HDMI).

Change the string in conditional statement to "ehdaudio0D0" to ensure
that only the HDAudio codec is handled by this function.

Fixes: 5bf73b1b1dec ("ASoC: intel/skl/hda - fix oops on systems without i915 audio codec")
Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200722173524.30161-1-mateusz.gorski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/skl_hda_dsp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index ca4900036ead9..bc50eda297ab7 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -181,7 +181,7 @@ static void skl_set_hda_codec_autosuspend_delay(struct snd_soc_card *card)
 	struct snd_soc_dai *dai;
 
 	for_each_card_rtds(card, rtd) {
-		if (!strstr(rtd->dai_link->codecs->name, "ehdaudio"))
+		if (!strstr(rtd->dai_link->codecs->name, "ehdaudio0D0"))
 			continue;
 		dai = asoc_rtd_to_codec(rtd, 0);
 		hda_pvt = snd_soc_component_get_drvdata(dai->component);
-- 
2.25.1



