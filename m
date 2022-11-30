Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3527E63DE40
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiK3SfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiK3SfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5A326545
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0578B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26252C433C1;
        Wed, 30 Nov 2022 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833303;
        bh=+OjShQvoVO2sfoGe1cW8c5l7565D24ROvEYNQhALPtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaRH9eiexM5WzC471VuU4GflCTQipLi1e9n235+pCY+/yrwWGcJvp8R3yIi4yfkHi
         cdse36b1ROI4gLzuCvJUI4uMJCL6iMhEuFEdc7vRS/AS3rvvSoIUkzIKtuT0Cnlqsk
         bfuKsBY1o9aTMuX1evlutvrq5LbYwQeZyXo3U8J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Junxiao Chang <junxiao.chang@intel.com>,
        Furong Zhou <furong.zhou@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/206] ASoC: hdac_hda: fix hda pcm buffer overflow issue
Date:   Wed, 30 Nov 2022 19:21:51 +0100
Message-Id: <20221130180534.504440880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit 37882100cd0629d830db430a8cee0b724fe1fea3 ]

When KASAN is enabled, below log might be dumped with Intel EHL hardware:
[   48.583597] ==================================================================
[   48.585921] BUG: KASAN: slab-out-of-bounds in hdac_hda_dai_hw_params+0x20a/0x22b [snd_soc_hdac_hda]
[   48.587995] Write of size 4 at addr ffff888103489708 by task pulseaudio/759

[   48.589237] CPU: 2 PID: 759 Comm: pulseaudio Tainted: G     U      E     5.15.71-intel-ese-standard-lts #9
[   48.591272] Hardware name: Intel Corporation Elkhart Lake Embedded Platform/ElkhartLake LPDDR4x T3 CRB, BIOS EHLSFWI1.R00.4251.A01.2206130432 06/13/2022
[   48.593010] Call Trace:
[   48.593648]  <TASK>
[   48.593852]  dump_stack_lvl+0x34/0x48
[   48.594404]  print_address_description.constprop.0+0x1f/0x140
[   48.595174]  ? hdac_hda_dai_hw_params+0x20a/0x22b [snd_soc_hdac_hda]
[   48.595868]  ? hdac_hda_dai_hw_params+0x20a/0x22b [snd_soc_hdac_hda]
[   48.596519]  kasan_report.cold+0x7f/0x11b
[   48.597003]  ? hdac_hda_dai_hw_params+0x20a/0x22b [snd_soc_hdac_hda]
[   48.597885]  hdac_hda_dai_hw_params+0x20a/0x22b [snd_soc_hdac_hda]

HDAC_LAST_DAI_ID is last index id, pcm buffer array size should
be +1 to avoid out of bound access.

Fixes: 608b8c36c371 ("ASoC: hdac_hda: add support for HDMI/DP as a HDA codec")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Signed-off-by: Furong Zhou <furong.zhou@intel.com>
Link: https://lore.kernel.org/r/20221109234023.3111035-1-junxiao.chang@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.h b/sound/soc/codecs/hdac_hda.h
index d0efc5e254ae..da0ed74758b0 100644
--- a/sound/soc/codecs/hdac_hda.h
+++ b/sound/soc/codecs/hdac_hda.h
@@ -14,7 +14,7 @@ enum {
 	HDAC_HDMI_1_DAI_ID,
 	HDAC_HDMI_2_DAI_ID,
 	HDAC_HDMI_3_DAI_ID,
-	HDAC_LAST_DAI_ID = HDAC_HDMI_3_DAI_ID,
+	HDAC_DAI_ID_NUM
 };
 
 struct hdac_hda_pcm {
@@ -24,7 +24,7 @@ struct hdac_hda_pcm {
 
 struct hdac_hda_priv {
 	struct hda_codec codec;
-	struct hdac_hda_pcm pcm[HDAC_LAST_DAI_ID];
+	struct hdac_hda_pcm pcm[HDAC_DAI_ID_NUM];
 	bool need_display_power;
 };
 
-- 
2.35.1



